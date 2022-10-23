#======================================================================
# Metodo para criar o grafico basico
#
# @param dados data.frame com dados do grafico
# @param Municipio municipio selecionado
# @param Coluna coluna selecionada
# @param cor selecionada
# @param intervalo grupo de dias selecionado
# @param ylab legenda grafico
#======================================================================
graficos.GraficoBasico = function(dados,
                                  Municipio,
                                  Coluna,
                                  cor,
                                  intervalo,
                                  ylab)
  
{
  dados[[Coluna]] = as.numeric(dados[[Coluna]])
  dados$data = as.Date(dados$data)
  
  year.max = format(max(dados$data), "%Y")
  year.min = format(min(dados$data), "%Y")
  
  titulo = sprintf("Municipio '%s'\n %s - %s", Municipio, year.min, year.max)
  
  indexData = which(names(dados) == "data")
  names(dados)[indexData] = "date"
  
  
  seas.var.plot(
    dados,
    var = Coluna,
    start = 1,
    col = cor,
    ylog = FALSE,
    width = intervalo,
    main = titulo,
    ylab = ylab
  ) + geom_boxplot(outlier.shape = NA)
  
  
}

#======================================================================
# Metodo para criar o grafico basico
#
# @param dados data.frame com dados do grafico
# @param Municipio municipio selecionado
# @param Coluna coluna selecionada
# @param cor selecionada
# @param intervalo grupo de dias selecionado
#======================================================================
grafico.GraficoMatriz = function(dados, Municipio, Coluna, cor, intervalo)
{
  
  dados[[Coluna]] = as.numeric(dados[[Coluna]])
  
  dados$data = as.Date(dados$data)
  year.max = format(max(dados$data), "%Y")
  year.min = format(min(dados$data), "%Y")
  
  titulo = sprintf("Municipio '%s'\n %s - %s", Municipio, year.min, year.max)
  
  indexData = which(names(dados) == "data")
  names(dados)[indexData] = "date"
  
  dados = dados[, c("date", Coluna)]
  
  paleta = colorRampPalette(c("white", cor))(64)
  
  dados.sum = seas.sum(dados,
                       start = 1,
                       var = Coluna,
                       width = intervalo)
  image(
    dados.sum,
    Coluna,
    palette = paleta,
    main = titulo,
    ylab = "Precipitacao pluvial (mm)"
  )
  
  
}

#======================================================================
# Metodo para criar o grafico basico
#
# @param dados data.frame com dados do grafico
# @param Municipio municipio selecionado
# @param Coluna coluna selecionada
#======================================================================
grafico.precipitacaoAcumulada = function(dados, Municipio, Coluna)
{
  
  dados[[Coluna]] = as.numeric(dados[[Coluna]])
  
  dados$data = as.Date(dados$data)
  year.max = format(max(dados$data), "%Y")
  year.min = format(min(dados$data), "%Y")
  
  titulo = sprintf("Municipio '%s'\n %s - %s", Municipio, year.min, year.max)
  
  indexData = which(names(dados) %in% c("data", "precipitacao"))
  names(dados)[indexData] = c("date", "precip")
  
  dados$rain = dados$precip
  
  dados$snow = 0
  
  
  s.s = seas.sum(dados, width = 10)
  s.n = precip.norm(s.s, fun = "mean")
  
  dat.dep = precip.dep(dados, s.n)
  
  plot(dep ~ date,
       dat.dep,
       type = "l",
       main = titulo,
       ylab = "Precipitacao pluvial cumulativa (mm/dia)")
  
}
grafico.precipitacao = function(dados, Municipio, Grupodias, Coluna)
{
  
  dados[[Coluna]] = as.numeric(dados[[Coluna]])
  
  dados$data = as.Date(dados$data)
  year.max = format(max(dados$data), "%Y")
  year.min = format(min(dados$data), "%Y")
  
  titulo = sprintf("Municipio '%s'\n %s - %s", Municipio, year.min, year.max)
  
  indexData = which(names(dados) %in% c("data", "precipitacao"))
  names(dados)[indexData] = c("date", "precip")
  
  dados$rain = dados$precip
  
  dados$snow = 0
  
  
  s.s = seas.sum(dados, width = Grupodias)
  s.n = seas.norm(s.s, fun = "mean")
  
  
  plot(s.n,
       start = 1,
       main = titulo,
       ylab = "Precipitacao pluvial (mm/dia)")
  
}

#======================================================================
# Metodo para criar o grafico anomalia da precipitacao
#
# @param dados data.frame com dados do grafico
# @param Municipio municipio selecionado
# @param Coluna coluna selecionada
#======================================================================
grafico.anomalia.precipitacao = function(data_inv, municipio) {
  
  #criando grafico
  data_inv_p = mutate(data_inv, pr_anom = pr_anom * -1)
  bglab = data.frame(
    x = c(-Inf, Inf, -Inf, Inf),
    y = c(Inf, Inf, -Inf, -Inf),
    hjust = c(1, 1, 0, 0),
    vjust = c(1, 0, 1, 0),
    lab = c("?mido-Quente", "Seco-Quente",
            "?mido-Frio", "Seco-Frio")
  )
  g1 = ggplot(data_inv_p, aes(pr_anom, ta_anom)) +
    annotate(
      "rect",
      xmin = -Inf,
      xmax = 0,
      ymin = 0,
      ymax = Inf,
      fill = "#fc9272",
      alpha = .6
    ) + #Umido-Quente
    annotate(
      "rect",
      xmin = 0,
      xmax = Inf,
      ymin = 0,
      ymax = Inf,
      fill = "#cb181d",
      alpha = .6
    ) + #Seco-Quente
    annotate(
      "rect",
      xmin = -Inf,
      xmax = 0,
      ymin = -Inf,
      ymax = 0,
      fill = "#2171b5",
      alpha = .6
    ) + #mido-Frio
    annotate(
      "rect",
      xmin = 0,
      xmax = Inf,
      ymin = -Inf,
      ymax = 0,
      fill = "#c6dbef",
      alpha = .6
    ) + #Seco-Frio
    geom_hline(yintercept = 0, linetype = "dashed") +
    geom_vline(xintercept = 0, linetype = "dashed") +
    geom_text(
      data = bglab,
      aes(
        x,
        y,
        label = lab,
        hjust = hjust,
        vjust = vjust
      ),
      fontface = "italic",
      size = 5,
      angle = 90,
      colour = "white"
    )
  
  
  g1 = g1 + geom_point(
    aes(fill = symb_point, colour = symb_point),
    size = 2.8,
    shape = 21,
    show.legend = FALSE
  ) +
    geom_text_repel(aes(label = labyr, fontface = lab_font),
                    max.iter = 10000,
                    size = 3.5)
  
  
  g1 = g1 + scale_x_continuous(
    "Anomalia da precipitacao em %",
    breaks = seq(-100, 250, 10) * -1,
    labels = seq(-100, 250, 10),
    limits = c(min(data_inv_p$pr_anom), 100)
  ) +
    scale_y_continuous("Anomalia da temperatura media em ?C",
                       breaks = seq(-2, 2, 0.5)) +
    scale_fill_manual(values = c("black", "white")) +
    scale_colour_manual(values = rev(c("black", "white"))) +
    labs(
      title = sprintf("Anomalias Aguas (Outubro a Marco) em %s", municipio),
      caption = "Data: Embrapa\ periodo 1980-2020"
    ) +
    theme_bw()
  
  return(g1)
}

#======================================================================
# Metodo para criar o grafico do periodo climatico
#
# @param dados data.frame com dados do grafico
# @param Municipio municipio selecionado
# @param Coluna coluna selecionada
#======================================================================
grafico.periodoClimatico = function(dados, Municipio, Coluna) {
  
  dados$data = as.Date(dados$data)
  dados[[Coluna]] = as.numeric(dados[[Coluna]])
  
  R.prec = mean(dados[[Coluna]])
  dados$R_diff = NA
  
  for (linha in 1:dim(dados)[1]) {
    if (linha == 1) {
      dados$R_diff[linha] = dados[[Coluna]][linha] - R.prec
    } else{
      dados$R_diff[linha] = (dados[[Coluna]][linha] - R.prec) + dados$R_diff[linha -
                                                                               1]
    }
  }
  
  dados$ano = format(dados$data, "%Y")
  dados$mes = format(dados$data, "%m")
  
  resumo = dcast(dados, ano ~ mes, value.var = "R_diff", fun = mean)
  
  prec_media = apply(resumo[, -1], 2, mean)
  prec_media = data.frame(mes = names(prec_media), media = prec_media)
  
  inicioChuva = prec_media$mes[prec_media$media == min(prec_media$media)]
  fimChuva = prec_media$mes[prec_media$media == max(prec_media$media)]
  
  inicioChuva = as.numeric(as.character(inicioChuva))
  fimChuva = as.numeric(as.character(fimChuva))
  
  resumo = melt(
    resumo,
    id.vars = "ano",
    variable.name = "mes",
    value.name = "R_diff"
  )
  resumo$status = resumo$mes %in% c(inicioChuva, fimChuva)
  resumo$mes = as.numeric(as.character(resumo$mes))
  
  resumo$periodo = !(resumo$mes %in% fimChuva:inicioChuva)
  resumo$periodo[resumo$mes == fimChuva] = "Inicio / Final das chuvas"
  resumo$periodo[resumo$mes == inicioChuva] = "Inicio / Final das chuvas"
  
  breaks = c("TRUE", "FALSE", "Inicio / Final das chuvas")
  labels = c("Periodo chuvoso", "Periodo seco", "Inicio / Final das chuvas")
  titulo = sprintf("Periodos climaticos da estacao %s", Municipio)
  col = c("#ff9999", "gray", "#56B4E9")
  
  ggplot(resumo, aes(factor(mes), R_diff)) + geom_boxplot(aes(fill = periodo)) +
    scale_fill_manual(breaks = breaks,
                      labels = labels,
                      values = col) +
    labs(title = titulo, x = "Mes", y = "Anomalia da precipitacao pluvial media acumulada por dia (mm)") + theme_bw() +
    scale_x_discrete(
      labels = c(
        "Janeiro",
        "Feveiro",
        "Marco",
        "Abril",
        "Maio",
        "Junho",
        "Julho",
        "Agosto",
        "Setembro",
        "Outobro",
        "Novembro",
        'Dezembro'
      )
    )
}

#======================================================================
# Metodo para criar o grafico do periodo climatico
#
# @param dados data.frame com dados do grafico
# @param Municipio municipio selecionado
# @param Coluna coluna selecionada
#======================================================================
grafico.anomalia.temperatura = function(dados,Municipio,ano){
  
  dados = dados %>%
    select(data,municipio,precipitacao) %>% 
    filter(municipio == Municipio) %>% 
    mutate(DATE = ymd(data), RR = ifelse(precipitacao == -9999, NA, precipitacao/10)) %>% 
    select(DATE,RR) %>% 
    rename(date = DATE, pr = RR)
  
  dados <- mutate(dados, mo = month(date, label = TRUE), yr = year(date)) %>% 
    filter(date >= min(dados$date)) %>% 
    group_by(yr, mo) %>% 
    dplyr::summarise(prs = sum( pr, na.rm = TRUE))
  
  pr_ref <- filter(dados, yr > min(dados$yr), yr <= max(dados$yr)) %>% 
    group_by(mo) %>% 
    dplyr::summarise(pr_ref = mean(prs))
  
  dados <- left_join(dados, pr_ref, by = "mo")
  
  dados <- mutate(dados, anom = (prs*100/pr_ref)-100,  date = str_c(yr, as.numeric(mo), 1, sep = "-") %>% 
                    ymd(),sign= ifelse(anom > 0, "pos", "neg"))
  
  dados$mo <- str_to_lower(dados$mo)
  
  Meses = c('set','out','nov','dez','jan','fev','mar','mai')
  
  dados = dados %>% mutate(filtro = format(date,'%m')) %>%
    filter(mo %in% Meses)
  dados$mo = factor(dados$mo,levels = Meses)
  
  ano = str_split(ano,"-")[[1]]
  Filter_ano_um = dados %>%
    filter(yr == ano[1],
             mo == "set" |
             mo == "out" |
             mo == "nov" |
             mo == "dez"
    )
  
  Filter_ano_dois = dados %>%
    filter(yr == ano[2],
           mo == "jan" |
             mo == "fev" |
             mo == "mar" |
             mo == "mai"
    )
  
  Filter_rbind = rbind(Filter_ano_um,Filter_ano_dois)
  
  data_norm <-  group_by(dados, mo) %>% 
   dplyr::summarise(mx = max(anom),min = min(anom),q25 = quantile(anom, .25),q75 = quantile(anom, .75),iqr = q75-q25)
  
  g1 = ggplot(data_norm) + geom_crossbar(aes(x = mo, y = 0, ymin = min, ymax = mx),fatten = 0, fill = "grey90", colour = "NA") +
    geom_crossbar(aes(x = mo, y = 0, ymin = q25, ymax = q75),fatten = 0, fill = "grey70") + theme_hc()
  g1 =  g1 + geom_crossbar(data = Filter_rbind, aes(x = mo, y = 0, ymin = 0, ymax = anom, fill = sign),fatten = 0, width = 0.7, alpha = .7, colour = "NA",show.legend = FALSE)
  g1 = g1 + geom_hline(yintercept = 0)+scale_fill_manual(values=c("#99000d","#034e7b"))+scale_y_continuous(as.character("Anomalia da precipitacao pluvial em (%)"),breaks = seq(-100,1200,100),expand = c(0, 5))
  g1 = g1 + labs(x = "",title = as.character(sprintf("Anomalia precipitacao em %s",Municipio))) + theme(text = element_text(size=16))
  
  
  plot(g1)
}
