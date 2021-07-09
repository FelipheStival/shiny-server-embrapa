start.packages = function(){
     require(leaflet)
     require(RJDBC)
     require(seas)
}

create.map = function(bancoDados, usuario, inp){
     
     coordenadas = get.estacao.meta(bancoDados, usuario, inp)
     
     plantIcon = makeIcon(
          iconUrl = "src//pictures//leaves.svg",
          iconWidth = 38, iconHeight = 95,
          iconAnchorX = 22, iconAnchorY = 20
     )
     
     leaflet(coordenadas) %>%
          addTiles() %>%
          addProviderTiles("OpenTopoMap", group = "Topografia") %>%
          addProviderTiles("Esri.WorldImagery", group = "Satelite") %>%
          addMarkers(lng=~longitude, lat=~latitude, popup=~id_estacao, clusterOptions = markerClusterOptions(), icon = plantIcon) %>%
          addLayersControl(
               baseGroups = c("Topografia", "Satelite"),
               options = layersControlOptions(collapsed = FALSE)
          )
}

get.estados = function(bancoDados, usuario){
        
     # Criando uma conexao com o banco
     estados = executeQuery("select * from estado")
     estados = estados[complete.cases(estados),]
     
     estados.estacao = executeQuery("select distinct codigoEstado from estacao")
     estados = estados[estados$codigoEstado %in% estados.estacao$codigoEstado,]
     
     return(estados)
}

get.estacao.meta = function(bancoDados, usuario, codigo){
     # Criando uma conexao com o banco
     query = "select distinct latitude, longitude, id_estacao, codigoEstado from estacao"
     
     if(codigo != "Todos"){
          codigo = strsplit(codigo, split = ' ')[[1]][1]
          query = sprintf("%s where codigoEstado = '%s'", query, codigo)
     }
     
     coordenadas = executeQuery(query)
     coordenadas = coordenadas[complete.cases(coordenadas),]
     
     return(coordenadas)
}

get.estacao.By.latlong = function(bancoDados, usuario, lat, long){
     
     # Criando uma conexao com o banco
     query = sprintf("select distinct id_estacao from estacao where latitude = '%s' and longitude = '%s'",lat,long)
     
     coordenadas = executeQuery(query)
     coordenadas = coordenadas[complete.cases(coordenadas),]
     
     return(as.character(coordenadas))
}

get.estacao = function(bancoDados, usuario, estacao, intervalo){
     
     # Criando uma conexao com o banco
     query = "select id_estacao, data, tempMaxima, tempMinima, precipitacao, radiacao, tempMaximaFlag, tempMinimaFlag, precipitacaoFlag, radiacaoFlag from estacao"
     query = sprintf("%s where id_estacao = '%s' and data >= '%s' and data <= '%s'", query, estacao, as.character(intervalo[1]), as.character(intervalo[2]) )
     
     coordenadas = executeQuery(query)
     coordenadas = coordenadas[complete.cases(coordenadas),]
     
     return(coordenadas)
}

get.altitude = function(bancoDados, usuario, idEstacao){
     
     # Criando uma conexao com o banco
     query = sprintf("select distinct codigoMunicipio from estacao where id_estacao = '%s'", idEstacao)
     
     codigoMunicipio = executeQuery(query)
     codigoMunicipio = codigoMunicipio[complete.cases(codigoMunicipio),]
     
     query = sprintf("select altitude from municipio where codigoMunicipio = '%s'", codigoMunicipio)

     altitude = executeQuery(query)
     altitude = altitude[complete.cases(altitude),]
     
     return(altitude)
}

get.variaveis = function(){
     
     nomes.variavel = c("Temperatura Maxima", "Temperatura Minima", "Precipitacao", "Radiacao", "Graus Dias Acumulado")
     nomes.variavel = sort(nomes.variavel)
     
     return(nomes.variavel)
}

get.variaveis.reverse = function(name){
     
     nomes.variavel = switch(name,
                             "t_max" = "Temperatura Maxima",
                             "t_min" = "Temperatura Minima",
                             "precipitacao" = "Precipitacao",
                             "radiacao" = "Radiacao", 
                             "gdd10" = "Graus Dias Acumulado")
     
     return(nomes.variavel)
}

prepare.table = function(tabela, taxa){
     
     tabela$tempMedia = (tabela$tempMaxima + tabela$tempMinima)/2
     tabela = tabela[,c(1,2,3,4,11,5,6)]
     names(tabela) = c("id_estacao","date", "t_max", "t_min" ,"t_mean", "precipitacao", "radiacao")
     
     tabela$date = as.Date(tabela$date)
     tabela$gdd10 = tabela$t_mean - taxa
     tabela$gdd10[tabela$gdd10 < 0] = 0
     attr(tabela$gdd10,"long.name") <- "Graus Dias Acumulado"
     
     return(tabela)
}

getDssatFiles = function(data, bancoDados, usuario, estado){
     
     estacao.meta = get.estacao.meta(bancoDados, usuario, estado) 
     
     data$tempMaximaFlag = NULL
     data$tempMinimaFlag = NULL
     data$precipitacaoFlag = NULL
     data$radiacaoFlag = NULL
     
     anos = as.Date(data$data)
     anos = unique(year(anos))
     anos = as.character(anos)
     
     estacao = unique(data$id_estacao)
     estacao = as.character(estacao)
     
     altitude = get.altitude(bancoDados, usuario, estacao)
     
     arq.tmp = list.files(path = "tmp", full.names = T)
     
     lat = estacao.meta$latitude[estacao.meta$id_estacao == estacao]
     long = estacao.meta$longitude[estacao.meta$id_estacao == estacao]
     
     parametros = list()
     parametros$estacao = estacao
     parametros$bancoDados = bancoDados
     parametros$usuario = usuario
     parametros$lat = lat
     parametros$long = long
     parametros$altitude = altitude

     unlink("files")
     dir.create("files")
     
     arquivos = sapply(anos, function(ano,tabela,parametros){

          estacao = parametros$estacao
          bancoDados = parametros$bancoDados
          usuario = parametros$usuario
          lat = parametros$lat
          long = parametros$long
          altitude = parametros$altitude
          
          name.tmp = gsub("\\.","",estacao)
          name.tmp = substr(name.tmp,1,4)
          fileName.tmp = sprintf("%s%s01", name.tmp , substr(ano ,3 ,4))
          fileName.tmp = sprintf("files//%s.WTH", fileName.tmp)
          
          cat(sprintf("*WEATHER DATA %s\n\n", estacao), file = fileName.tmp, append = T)
          
          #=======================================#
          
          tav = 10
          amp = 12
          
          estacao = gsub("\\.","",estacao)
          
          cat(sprintf("@ INSI %8s %8s %5s %5s %5s REFHT WNDHT\n","LAT","LONG","ELEV","TAV","AMP"), file = fileName.tmp, append = T)
          cat(sprintf(" %4s %8s %8s %5s %5s %5s -99.0 -99.0\n",substr(estacao,1,4) ,lat, long, altitude, tav, amp), file = fileName.tmp, append = T)
          
          #=======================================#
          
          tabela = tabela[year(tabela$data) == ano,]
          data.convert = tabela$data
          data.convert = format(data.convert, "%j")
          data.convert = sprintf("%s%s", substr(ano,3,4),data.convert)
          
          cat(sprintf("@DATE  SRAD  TMAX  TMIN  RAIN  DEWP  WIND   PAR  EVAP  RHUM\n"), file = fileName.tmp, append = T)
          cat(sprintf("%s %5s %5s %5s %5s\n", data.convert, tabela$radiacao, tabela$tempMaxima, tabela$tempMinima, tabela$precipitacao), file = fileName.tmp, append = T, sep = "")
          
          return(fileName.tmp)
          
     },data,parametros)
}

# Metodo para obter a conexao com o banco de dados
getConnection = function(){
     driver = JDBC("com.mysql.jdbc.Driver",
                   "driver//mysql-connector-java-5.1.48-bin.jar")
     
     conn = dbConnect(driver,
                      sprintf("jdbc:mysql://%s:%s/%s",DB_HOST,DB_PORT,DB_DATABASE),
                      DB_USERNAME,
                      DB_PASSWORD)
}

# Metodo para executar Query no banco
executeQuery = function(query) {
     connection = getConnection()
     result = dbGetQuery(connection, query)
     result = set_utf8(result)
     dbDisconnect(connection)
     return(result)
}
