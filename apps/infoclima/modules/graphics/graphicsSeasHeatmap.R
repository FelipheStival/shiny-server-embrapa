#==============================================#
# Exibe realiza uma analise SEAS nos dados ao longo dos anos
# tabela => data.frame com as colunas obrigatorias "data" 
# nomeEstacao => nome da estacao (titulo)
# colunaVariavel => nome da coluna de variavel
# intervalo => intervalo de dias analisados
# color => cor do grafico
graphicsSeasHeatmap = function(tabela, nomeEstacao, colunaVariavel, intervalo = 10, color = "tomato"){
     
     if(length(tabela) == 1)
          return(NULL)
     
     tabela[[colunaVariavel]] = as.numeric(tabela[[colunaVariavel]])
     
     tabela$data = as.Date(tabela$data)
     year.max = format(max(tabela$data), "%Y")
     year.min = format(min(tabela$data), "%Y")
     
     titulo = sprintf("Municipio '%s'\n %s - %s", nomeEstacao, year.min, year.max)
     
     indexData = which(names(tabela) == "data")
     names(tabela)[indexData] = "date"
     
     paleta = colorRampPalette(c("white", color))(64)
     
     tabela.sum = seas.sum(tabela, start = 1, var = colunaVariavel, width = intervalo)
     image(tabela.sum, colunaVariavel, palette = paleta, main = titulo)
}
