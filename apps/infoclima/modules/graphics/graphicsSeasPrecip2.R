#==============================================#
# Exibe realiza uma analise SEAS nos dados de precipitacao  ao longo dos anos
# tabela => data.frame com as colunas obrigatorias "data" 
# nomeEstacao => nome da estacao (titulo)
# colunaPrecipitacao => nome da coluna de precipitacao
# intervalo => intervalo de dias analisados
graphicsSeasPrecip2 = function(tabela, nomeEstacao, colunaPrecipitacao, intervalo){
     
     if(length(tabela) == 1)
          return(NULL)
     
     tabela[[colunaPrecipitacao]] = as.numeric(tabela[[colunaPrecipitacao]])
     
     tabela$data = as.Date(tabela$data)
     year.max = format(max(tabela$data), "%Y")
     year.min = format(min(tabela$data), "%Y")

     indexData = which(names(tabela) %in% c("data", colunaPrecipitacao))
     names(tabela)[indexData] = c("date", "precip")
     
     titulo = sprintf("Municipio '%s'\n %s - %s", nomeEstacao, year.min, year.max)
     
     d.w.table = interarrival(tabela, "precip")
     
     par(mfrow=c(1,2))
     plot(d.w.table, width = intervalo, start = 1, main = titulo)
}
#==============================================#