#==================================================================
# Metodo para obter o nome do municipio pelo ID da estacao
#
# @param IDestacao id da estacao
# @param data data.frame com os dados das estacoes
# @return string com o municipio selecionado
#==================================================================
dadosTabelaFiltrados = function(IDestacao,periodo,data){
  
  #filtrando dados
  dados = data[data$municipio %in% IDestacao &
               data$data >= periodo[1] &
               data$data <= periodo[2],]
  
  return(dados)
  
}