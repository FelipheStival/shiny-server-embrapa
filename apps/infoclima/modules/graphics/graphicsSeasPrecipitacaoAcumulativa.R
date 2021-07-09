#==============================================#
# Exibe realiza uma analise SEAS nos dados de precipitacao  ao longo dos anos
# tabela => data.frame com as colunas obrigatorias "data" 
# nomeEstacao => nome da estacao (titulo)
# colunaPrecipitacao => nome da coluna de precipitacao
# intervalo => intervalo de dias analisados
graphicsSeasPrecipitacaoAcumulativa = function(tabela, nomeEstacao, colunaPrecipitacao, intervalo){
     
     if(length(tabela) == 1)
          return(NULL)
     
     tabela[[colunaPrecipitacao]] = as.numeric(tabela[[colunaPrecipitacao]])
     
     tabela$data = as.Date(tabela$data)
     year.max = format(max(tabela$data), "%Y")
     year.min = format(min(tabela$data), "%Y")
     
     titulo = sprintf("Municipio '%s'\n %s - %s", nomeEstacao, year.min, year.max)
     
     indexData = which(names(tabela) %in% c("data", colunaPrecipitacao))
     names(tabela)[indexData] = c("date", "precip")
     
     tabela$rain = tabela$precip;
     tabela$snow = 0;
     
     s.s = seas.sum(tabela, width = intervalo)     
     s.n = precip.norm(s.s, fun = "mean")
     
     dat.dep = precip.dep(tabela, s.n)
     
     plot(dep ~ date, dat.dep, type="l",
          main = titulo, ylab = "Precipitacao cumulativa (mm)" )
}
#==============================================#