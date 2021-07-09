grafico.seas.basic = function(variavel, slice = 10, intervalo, tabela){
     
     tabela = prepare.table(tabela,slice)
     
     year.max = year(max(tabela$date))
     year.min = year(min(tabela$date))
     id = unique(tabela$id_estacao)
     
     titulo = sprintf("Estacao '%s'\n %s - %s", id, year.min, year.max)
     var = get.variaveis.reverse(variavel)
     
     color = ifelse(variavel == "precipitacao", "azure", "tomato")
     seas.var.plot(tabela, var = variavel, start=1, rep=6, col=color,
                   ylog = TRUE, width = intervalo, main = titulo, ylab = var)
}

grafico.seas.heatmap = function(variavel, slice = 10, intervalo, tabela){
     
     tabela = prepare.table(tabela,slice)
     
     cor = switch (variavel,
                   "t_max" = "red",
                   "t_min" = "blue",
                   "precipitacao" = "blue",
                   "radiacao" = "orange",
                   "gdd10" = "red"
     )
     
     year.max = year(max(tabela$date))
     year.min = year(min(tabela$date))
     id = unique(tabela$id_estacao)
     
     titulo = sprintf("Estacao '%s'\n %s - %s", id, year.min, year.max)
     var = get.variaveis.reverse(variavel)
     
     s.s = seas.sum(tabela, var = variavel, width = intervalo)
     paleta = colorRampPalette(c("white", cor))(64)
     image(s.s, variavel, palette = paleta, start=1, rep=6, main = titulo)
     
}

grafico.seas.precip1 = function(intervalo, variavel, slice = 10, tabela){
     
     tabela = prepare.table(tabela,slice)
     names(tabela)[6] = "rain"
     
     tabela$gdd10 = NULL
     tabela$snow = 0
     tabela$precip = tabela$snow + tabela$rain
     
     s.s = seas.sum(tabela, width = intervalo)     
     s.n = precip.norm(s.s, fun = "mean")
     
     dat.dep = precip.dep(tabela, s.n)
     
     year.max = year(max(tabela$date))
     year.min = year(min(tabela$date))
     id = unique(tabela$id_estacao)
     
     titulo = sprintf("Estacao '%s'\n %s - %s", id, year.min, year.max)
     var = get.variaveis.reverse(variavel)
     
     par(mfrow=c(1,2)) 
     plot(s.n, start=1, rep=6, main = titulo, ylab = var)
     plot(dep ~ date, dat.dep, type="l",
          main = titulo, ylab = var )
}

grafico.seas.precip2 = function(intervalo, slice = 10, tabela){
     
     tabela = prepare.table(tabela,slice)
     names(tabela)[6] = "rain"
     
     tabela$gdd10 = NULL
     tabela$snow = 0
     tabela$precip = tabela$snow + tabela$rain
     
     year.max = year(max(tabela$date))
     year.min = year(min(tabela$date))
     id = unique(tabela$id_estacao)
     
     titulo = sprintf("Estacao '%s'\n %s - %s", id, year.min, year.max)
     
     d.w.table = interarrival(tabela, "precip")
     plot(d.w.table, width = intervalo, start=1, rep=6, main = titulo)
}

