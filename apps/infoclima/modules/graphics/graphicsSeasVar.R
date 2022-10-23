#==============================================#
# Exibe realiza uma analise SEAS nos dados
# tabela => data.frame com as colunas obrigatorias "data" 
# nomeEstacao => nome da estacao (titulo)
# colunaVariavel => nome da coluna de variavel
# intervalo => intervalo de dias analisados
# color => cor do grafico
graphicsSeasVar = function(tabela, nomeEstacao, colunaVariavel, ylab, intervalo = 10, color = "tomato") {

     if(length(tabela) == 1)
          return(NULL)

     tabela[[colunaVariavel]] = as.numeric(tabela[[colunaVariavel]])
     tabela$data = as.Date(tabela$data)
     
     year.max = format(max(tabela$data), "%Y")
     year.min = format(min(tabela$data), "%Y")
     
     titulo = sprintf("Municipio '%s'\n %s - %s", nomeEstacao, year.min, year.max)
 
     indexData = which(names(tabela) == "data")
     names(tabela)[indexData] = "date"
     
     seas.var.plot(tabela, var = colunaVariavel, start = 1, col = color,
                   ylog = FALSE, width = intervalo, main = titulo, ylab = ylab) + geom_boxplot(outlier.shape = NA)
}
