#==================================================================
# Metodo para gerar o grafico de dados perdidos
#
# @param conexao conexao com banco de dados
# @return data.frame com dados dos estados
#==================================================================
analise.chart.dadosPerdidos = function(dados) {
  grafico =  ggplot(data = dados, aes(x = Variavel, y = Estacao)) + geom_tile(aes(fill = Valor), colour = "white") +
    scale_fill_gradient(low = "#7cb342", high = "#e53935") + theme_minimal() +
    ylab("Estação") + xlab("Variável")
  return(grafico)
}
