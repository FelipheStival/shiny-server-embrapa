#==============================================#
# Exibe o periodo de precipitacao da estacao
# tabela => data.frame com as colunas obrigatorias "data" 
# nomeEstacao => nome da estacao (titulo)
# colunaPrecipitacao => nome da coluna de precipitacao
graphicsPeriodoPrecipitacao = function(tabela, nomeEstacao, colunaPrecipitacao){
     
     if(length(tabela) == 1)
          return(NULL)
     
     tabela$data = as.Date(tabela$data)
     tabela[[colunaPrecipitacao]] = as.numeric(tabela[[colunaPrecipitacao]])
     
     R.prec = mean(tabela[[colunaPrecipitacao]])
     tabela$R_diff = NA
     
     for(linha in 1:dim(tabela)[1]){
          
          if(linha == 1){
               tabela$R_diff[linha] = tabela[[colunaPrecipitacao]][linha] - R.prec
          }else{
               tabela$R_diff[linha] = (tabela[[colunaPrecipitacao]][linha] - R.prec) + tabela$R_diff[linha -1]
          }
     }
     
     tabela$ano = format(tabela$data, "%Y")
     tabela$mes = format(tabela$data, "%m")
     
     resumo = dcast(tabela, ano ~ mes, value.var = "R_diff", fun = mean)
     
     prec_media = apply(resumo[,-1], 2, mean)
     prec_media = data.frame(mes = names(prec_media), media = prec_media)
     
     inicioChuva = prec_media$mes[prec_media$media == min(prec_media$media)]
     fimChuva = prec_media$mes[prec_media$media == max(prec_media$media)]
     
     inicioChuva = as.numeric(as.character(inicioChuva))
     fimChuva = as.numeric(as.character(fimChuva))
     
     resumo = melt(resumo, id.vars = "ano", variable.name = "mes", value.name = "R_diff")
     resumo$status = resumo$mes %in% c(inicioChuva, fimChuva)
     resumo$mes = as.numeric(as.character(resumo$mes))
     
     resumo$periodo = !(resumo$mes %in% fimChuva:inicioChuva)
     resumo$periodo[resumo$mes == fimChuva] = "Inicio / Final das chuvas"
     resumo$periodo[resumo$mes == inicioChuva] = "Inicio / Final das chuvas"
     
     breaks = c("TRUE","FALSE", "Inicio / Final das chuvas")
     labels = c("Periodo chuvoso", "Periodo seco", "Inicio / Final das chuvas")
     titulo = sprintf("Periodos climaticos da estacao %s", nomeEstacao)
     col = c("#ff9999","gray", "#56B4E9")
     
     ggplot(resumo, aes(factor(mes), R_diff)) + geom_boxplot(aes(fill = periodo)) + 
          scale_fill_manual(breaks = breaks, labels = labels, values = col) +
          labs(title = titulo, x = "Mes", y = "Anomalia da precipitacao média acumulada por dia (mm)") + theme_bw()
}
