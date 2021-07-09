#==============================================#
# Exibe realiza uma analise SEAS nos dados de precipitacao  ao longo dos anos
# tabela => data.frame com as colunas obrigatorias "data" 
# nomeEstacao => nome da estacao (titulo)
# colunaPrecipitacao => nome da coluna de precipitacao
# intervalo => intervalo de dias analisados
graphicsSeasPrecipitacaoGeral = function(tabela, nomeEstacao, colunaPrecipitacao, intervalo){
     
     if(length(tabela) == 1)
          return(NULL)
     
     tabela[[colunaPrecipitacao]] = as.numeric(tabela[[colunaPrecipitacao]])
     
     tabela$data = as.Date(tabela$data)
     year.max = format(max(tabela$data), "%Y")
     year.min = format(min(tabela$data), "%Y")
     
     titulo = sprintf("Municipio '%s'\n %s - %s", nomeEstacao, year.min, year.max)
     
     indexData = which(names(tabela) %in% c("data", colunaPrecipitacao))
     names(tabela)[indexData] = c("date", "precip")
     
     s.s = seas.sum(tabela, width = intervalo)     
     s.n = seas.norm(s.s, fun = "mean")

     plot(s.n, start = 1, main = titulo, ylab = "Precipitacao / dia (mm)")
}
#==============================================#