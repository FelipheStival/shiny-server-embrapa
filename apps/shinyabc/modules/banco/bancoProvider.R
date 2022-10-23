# Metodo para abrir a conexao com o banco de dados
banco.provider.openConnection = function(dbname) {
  
  # configurando driver
  driver = JDBC("org.postgresql.Driver",
                "driver//postgresql-42.2.22.jar")
  
  # criando conexao
  if(dbname == DB_DATABASE){
    conn = dbConnect(driver,
                     sprintf("jdbc:postgresql://%s:%s/%s",DB_HOST,DB_PORT,DB_DATABASE),
                     DB_USERNAME,
                     DB_PASSWORD)
    return(conn)
  } else {
    conn = dbConnect(driver,
                     sprintf("jdbc:postgresql://%s:%s/%s",DB_HOST,DB_PORT,DOENCA_DB_DATABASE),
                     DB_USERNAME,
                     DB_PASSWORD) 
  }
  
  return(conn)
}

# metodo para executar a query
banco.provider.executeQuery = function(statement, dbname = 'meteoro') {
  connection = banco.provider.openConnection(dbname)
  result = dbGetQuery(connection, statement)
  result = set_utf8(result)
  dbDisconnect(connection)
  return(result)
}

# Metodo para transformar os caracteres em utf-8
set_utf8 = function(x) {
  # Declare UTF-8 encoding on all character columns:
  chr <- sapply(x, is.character)
  x[, chr] <- lapply(x[, chr, drop = FALSE], `Encoding<-`, "UTF-8")
  # Same on column names:
  Encoding(names(x)) <- "UTF-8"
  x
}