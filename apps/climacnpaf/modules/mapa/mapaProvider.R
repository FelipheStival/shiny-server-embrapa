#======================================================================
# Metodo para obter as latitudes e longitudes de cadas estacoes
#
# @param dadosEstacoes objeto do tipo dataframe com dados das estacoes
# @return objeto do tipo data.frame com dados latitudes e longitudes
#======================================================================
estacoesCords = function(dadosEstacoes){
  
  #selecionando colunas municipio latitude e longitude
  filtrar = dadosEstacoes[,c("id_estacao","municipio","latitude","longitude")]
  
  #obtendo index unicos
  filtrar = filtrar[!duplicated(filtrar$municipio),]
  
  return(filtrar)
  
}