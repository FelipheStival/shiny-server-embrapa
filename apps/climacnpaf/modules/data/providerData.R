#==================================================================
# Metodo para obter o periodo de datas maximo e minino da estacao
#
# @param municipio nome do municipio
# @param data data.frame com os dados das estacoes
# @return vetor de string com minimo e maximo
#==================================================================
obterMinMax = function(municipio,data){
  
  #obtendo nome do municipio
  periodo = data[data$municipio %in% municipio,]
  
  #convertendo coluna para data
  retorno = c(
    min(periodo$data),
    max(periodo$data)
  )
  
  return(retorno)
  
}