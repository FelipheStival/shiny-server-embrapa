#==============================================#
# Retorna uma tabela contendo as coordenadas geograficas do grid.
# A tabela retornada devera possuir as colunas latitude e longitude.
serviceMapa = function(global) {
     
     query = "select latitude, longitude, municipio, estado from grid_meta"

     mapaCoords = executeQuery(query)
     mapaCoords$latitude = as.numeric(mapaCoords$latitude)
     mapaCoords$longitude = as.numeric(mapaCoords$longitude)
     mapaCoords = mapaCoords[complete.cases(mapaCoords),]
     
     return(mapaCoords)
}
