# Metodo para abrir a conexao com o banco de dados
openConnection = function() {
     
     # configurando driver
     driver = JDBC("com.mysql.jdbc.Driver",
                   "driver//mysql-connector-java-5.1.48-bin.jar")
     
     # criando conexao
     conn = dbConnect(driver,
                      sprintf("jdbc:mysql://%s:%s/%s",DB_HOST,DB_PORT,DB_DATABASE),
                      DB_USERNAME,
                      DB_PASSWORD)
     return(conn)
}

# Metodo para executar uma query
executeQuery = function(statment) {
     connection = openConnection()
     result = dbGetQuery(connection,statment)
     result = set_utf8(result)
     dbDisconnect(connection)
     return(result)
}

# converter caracteres para UTF-8
set_utf8 = function(x) {
     # Declare UTF-8 encoding on all character columns:
     chr <- sapply(x, is.character)
     x[, chr] <- lapply(x[, chr, drop = FALSE], `Encoding<-`, "UTF-8")
     # Same on column names:
     Encoding(names(x)) <- "UTF-8"
     x
}