#==============================================#
# Retorna um vetor contendo o nome do estado e do municipio mais proximo dada as coordenadas.
# tabela => data.frame extraido do banco.
# lat => latitude do ponto
# long = longitude do ponto
providerMetadata.byCoords = function(tabela, lat, long) {

     nearLat = abs(tabela$latitude - lat)
     nearLatIndex = which(nearLat %in% min(nearLat))
     
     nearLong = abs(tabela$longitude - long)
     nearLongIndex = which(nearLong %in% min(nearLong))
     
     index = intersect(nearLatIndex, nearLongIndex)
     
     municipio.selected = as.character(tabela$municipio[index])
     estado.selected = as.character(tabela$estado[index])
     res = c(estado.selected[1], municipio.selected[1])
     
     return(res)
}
#==============================================#

#==============================================#
# 
# tabela => data.frame extraido do banco.
providerMetadata.getEstadoNorm = function(tabela, municipio) {
     
     estado = tabela$estado[tabela$municipio == municipio]
     estado = as.character(estado)
     estado = unique(estado)
     estado = gsub(" ", "_", estado)

     return(estado)
}
#==============================================#

#==============================================#
# 
# tabela => data.frame extraido do banco.
providerMetadata.order = function(tabela, colunaName) {
     
     nomes = as.character(tabela[[colunaName]])
     nomes = unique(nomes)
     nomes = sort(nomes)
     return(nomes)
}
#==============================================#

#==============================================#
# 
# tabela => data.frame extraido do banco.
providerMetadata.filterByEstados = function(tabela, estados) {
     
     index = which(tabela$estado %in% estados)
     if(length(index > 0))
          tabela = tabela[index,]
     
     return(tabela)
}
#==============================================#