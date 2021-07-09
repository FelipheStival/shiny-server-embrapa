#======================================================================
# Metodo para obter os graficos disponiveis para cada variavel
#
# @param variavelSelected variavel selecionada
# @return objeto do tipo string com opcoes de graficos
#======================================================================
provider.grafico.opcoes = function(variavelSelected) {
  op = NULL
  switch (
    variavelSelected,
    "precipitacao" = {
      op = c(
        "Grafico basico",
        "Precipitacao",
        "Recarga",
        "Periodo Climatico",
        "Mapa matriz",
        "Anomalia",
        "Anomalia Temperatura Precipitacao"
      )
    },
    "temp_max" = {
      op = c("Grafico basico",
             "Mapa matriz")
    },
    "temp_min" = {
      op = c("Grafico basico",
             "Mapa matriz")
    },
    "radiacao" = {
      op = c("Grafico basico",
             "Mapa matriz")
    }
  )
  
  return(op)
}

#======================================================================
# Metodo para obter as lengendas dos graficos
#
# @param variavelSelected variavel selecionada
# @return objeto do string com legenda do grafico
#======================================================================
provider.grafico.legenda = function(variavelSelect) {
  legenda = NULL
  switch (
    variavelSelect,
    "temp_max" = {
      legenda = "Temperatura Maxima do ar(*C)"
    },
    "temp_min" = {
      legenda = "Temperatura Minima do ar(*C)"
    },
    "precipitacao" = {
      legenda = "Precipitacao (mm/dia)"
    },
    "radiacao" = {
      legenda = "Radiacao solar global (MJ/m2) "
    },
  )
  return(legenda)
}

#======================================================================
# Metodo para obter as cores dos graficos
#
# @param variavelSelected variavel selecionada
# @return objeto do tipo string com a cor do grafico
#======================================================================
provider.grafico.cor = function(variavelSelect) {
  cor = NULL
  switch (
    variavelSelect,
    "temp_max" = {
      cor = "tomato"
    },
    "temp_min" = {
      cor = "cyan"
    },
    "precipitacao" = {
      cor = "blue"
    },
    "radiacao" = {
      cor = "orange"
    }
  )
  return(cor)
}

#======================================================================
# Metodo para obter os dados para gerar o grafico
#
# @param periodoSelect objeto data com periodo de datas a ser filtrado
# @param cidadeSelect input com cidade selecionada
# @param dadosCompletos objeto data.frame com dados completos
# @return objeto do tipo data.frame com dados filtrados
#======================================================================
provider.grafico.dados = function(periodoSelect,
                                  cidadeSelect,
                                  dadosCompletos) {
  minDate = as.Date(periodoSelect[1], "%Y-%m-%d")
  maxDate = as.Date(periodoSelect[2], "%Y-%m-%d")
  dadosFiltred = dadosCompletos[dadosCompletos$data >= minDate &
                                  dadosCompletos$data <= maxDate &
                                  dadosCompletos$municipio %in% cidadeSelect,]
  
  return(dadosFiltred)
}


#======================================================================
# Metodo para obter os dados para gerar o grafico da anomalia da temperatura
#
# @param dados objeto data.frame com dados completos
#======================================================================

provider.grafico.dadosPrec = function(periodoSelect,cidadeSelect,dadosCompletos) {
  
  dados = provider.grafico.dados(periodoSelect,cidadeSelect,dadosCompletos)
  
  #Calculando precipitacao media
  dados$ta = (dados$temp_max + dados$temp_min) / 2
  
  #Convetendo coluna data
  dados$data = as.Date(dados$data, "%Y-%m-%d")
  
  #Selecionando colunas
  dados = dados[, c("data", "precipitacao", "ta")]
  names(dados) = c("data", "pr", "ta")
  
  #criando coluna winter_yr month season
  data = mutate(
    dados,
    winter_yr = meteo_yr(data, 12),
    month = month(data),
    season = case_when(month %in% c(10, 11, 12, 1:3) ~ "Aguas",
                       month %in% 4:9 ~ "Seca")
  )
  
  data = mutate(
    dados,
    winter_yr = meteo_yr(data, 12),
    month = month(data),
    season = case_when(
      month %in% c(12, 1:2) ~ "Verao",
      month %in% 3:5 ~ "Outono",
      month %in% 6:8 ~ "Inverno",
      month %in% 9:11 ~ "Primavera"
    )
  )
  
  #Gerando coluna ano
  data$ano = format(data$data, "%Y")
  
  #Gerando safra
  data = provider.grafico.safra(data)
  
  #removendo safras NA
  data = data[!is.na(data$safra),]
  
  #sumarizando variaveis
  data_inv = data %>%
    group_by(safra) %>%
    summarise(pr = sum(pr, na.rm = TRUE),
              ta = mean(ta, na.rm = TRUE))
  
  #calculando anomalia variaveis
  data_inv =  mutate(
    data_inv,
    pr_mean = mean(pr),
    ta_mean = mean(ta),
    pr_anom = (pr * 100 / pr_mean) - 100,
    ta_anom = ta - ta_mean,
    labyr = case_when(
      pr_anom < -10 & ta_anom < -.5 ~ safra,
      pr_anom < -10 &
        ta_anom > .5 ~ safra,
      pr_anom > 10 &
        ta_anom < -.5 ~ safra,
      pr_anom > 10 &
        ta_anom > .5 ~ safra
    ),
    symb_point = ifelse(!is.na(labyr), "yes", "no"),
    lab_font = ifelse(labyr == 2020, "bold", "plain")
  )
  
  return(data_inv)
}
#======================================================================
# Metodo para obter os dados para gerar o grafico
#
# @param periodoSelect objeto data com periodo de datas a ser filtrado
# @param cidadeSelect input com cidade selecionada
# @param dadosCompletos objeto data.frame com dados completos
# @return objeto do tipo data.frame com dados filtrados
#======================================================================
meteo_yr =  function(dates, start_month = NULL) {
  # convert to POSIXlt
  dates.posix <- as.POSIXlt(dates)
  # year offset
  offset <- ifelse(dates.posix$mon >= start_month - 1, 1, 0)
  # new year
  adj.year = dates.posix$year + 1900 + offset
  return(adj.year)
}

#======================================================================
# Metodo para criar as safras para o grafico anomalia temperatura
#
# @param data objeto do tipo data.frame com safras
# @return data.frame com coluna safra
#======================================================================
provider.grafico.safra = function(data) {
  #criando coluna safra
  data$safra = NA
  
  #gerando safras
  anos = unique(data$ano)
  for (i in 1:length(anos)) {
    if (!is.na(anos[i + 1])) {
      #obtendo index dos meses 1,2,3
      indexUm = which(data$month %in% c(10, 11, 12) &
                        data$ano == anos[i])
      indexDois = which(data$month %in% c(1:3) &
                          data$ano == anos[i + 1])
      #juntando index
      indexUniao = union(indexUm, indexDois)
      
      #populando coluna safra
      safraGerada = paste(str_sub(anos[i], 3),
                          str_sub(anos[i + 1], 3),
                          sep = "/")
      
      data$safra[indexUniao] = safraGerada
      
    }
  }
  return(data)
}

#======================================================================
# Metodo para criar os periodos para o grafico da anomalia climatica
#
# @param data objeto do tipo data.frame com safras
# @return data.frame com coluna safra
#======================================================================
provider.grafico.anos = function(datas){
  
  #Obtendo anos
  datas = as.Date(datas,"%Y-%m-%d")
  anos = unique(format(datas,format = "%Y"))
  periodo = NULL
  
  #Contruindo periodos
  for(i in 1:length(anos)){
    if(!is.na(anos[i + 1])){
      periodo = c(
        periodo,
        paste(anos[i],anos[i + 1],sep = '-')
      )
    }
  }
  return(periodo)
}

#======================================================================
# Metodo para criar os periodos para o grafico da anomalia climatica
#
# @param data objeto do tipo data.frame com safras
# @return data.frame com coluna safra
#======================================================================
provider.grafico.anomalia.temperatura = function(data){
  
  dados = data %>%
    select(data,municipio,precipitacao) %>% 
    filter(municipio == Municipio) %>% 
    mutate(DATE = ymd(data), RR = ifelse(precipitacao == -9999, NA, precipitacao/10)) %>% 
    select(DATE,RR) %>% 
    rename(date = DATE, pr = RR)
  
  dados <- mutate(dados, mo = month(date, label = TRUE), yr = year(date)) %>% 
    filter(date >= min(dados$date)) %>% 
    group_by(yr, mo) %>% 
    summarise(prs = sum( pr, na.rm = TRUE))
  
  pr_ref <- filter(dados, yr > min(dados$yr), yr <= max(dados$yr)) %>% 
    group_by(mo) %>% 
    summarise(pr_ref = mean(prs))
  
  dados <- left_join(dados, pr_ref, by = "mo")
  
  dados <- mutate(dados, anom = (prs*100/pr_ref)-100,  date = str_c(yr, as.numeric(mo), 1, sep = "-") %>% 
                    ymd(),sign= ifelse(anom > 0, "pos", "neg"))
  
  Meses = c('Set','Out','Nov','Dez','Jan','Fev','Mar','Mai')
  
  dados = dados %>% mutate(filtro = format(date,'%m')) %>%
    filter(mo %in% Meses)
  dados$mo = factor(dados$mo,levels = Meses)
  
  return(data_norm)
}