# Metodo para obter os estados
provider.obterEstados = function() {
  statement = "SELECT * FROM public.estados"
  estados = banco.provider.executeQuery(statement)
  return(estados)
}

# Metodo para obter as cidades de acordo com o estado
provider.obterCidades = function(estado) {
  statement = sprintf(
    "
  SELECT cidades.id,
  cidades.nome,
	cidades.id_estado
	FROM public.cidades
	JOIN estados ON cidades.id_estado = estados.id
	WHERE estados.nome = '%s'",
    estado
  )
  cidades = banco.provider.executeQuery(statement)
  return(cidades)
}

# Metodo para conseguir os dados climaticos
provider.obterClimaticos = function(cidade, periodo) {
  statement = sprintf(
    "SELECT
  clima.data,
	clima.Tmax,
	clima.Tmin,
	clima.Tmed,
	clima.Urmed,
	clima.Vento,
	clima.Vtmax,
	clima.Rad,
	clima.Precip,
	clima.Tsolo,
	estados.nome as nome_estado,
	cidades.nome as cidade_nome
	FROM public.clima
	JOIN cidades ON clima.id_cidade = cidades.id
	JOIN estados ON cidades.id_estado = estados.id
	WHERE cidades.nome = '%s'
	AND
	clima.data >= '%s'
	AND
	clima.data <= '%s'",
    cidade,
    periodo[1],
    periodo[2]
  )
  dados = banco.provider.executeQuery(statement)
  return(dados)
}

# Metodo para obter a cor do grafico
graficos.provider.grafico.cor = function(variavelSelect) {
  cor = NULL
  switch (
    variavelSelect,
    "tmin" = {
      cor = "tomato"
    },
    "tmax" = {
      cor = "OrangeRed"
    },
    "vtmax" = {
      cor = "blue"
    },
    "vento" = {
      cor = "DodgerBlue"
    },
    "urmed" = {
      cor = "DarkCyan"
    },
    "tsolo" = {
      cor = "DarkGray"
    },
    "rad" = {
      cor = "orange"
    },
    "precip" = {
      cor = "LightSteelBlue"
    },
    "tmed" = {
      cor = "SandyBrown"
    }
  )
  return(cor)
}

# Metodo para obter a legenda do grafico
graficos.provider.grafico.legenda = function(variavelSelect) {
  legenda = NULL
  switch (
    variavelSelect,
    "tmin" = {
      legenda = "Temperatura mínima do ar(*C)"
    },
    "tmax" = {
      legenda = "Temperatura máxima do ar(*C)"
    },
    "minimum_relative_air_humidity" = {
      legenda = "Umidade Relativa mínima do ar(%)"
    },
    "maximum_relative_air_humidity" = {
      legenda = "Umidade Relativa máxima do ar(%)"
    },
    "wind_speed" = {
      legenda =  "Velocidade do Vento(%)"
    },
    "rad" = {
      legenda = "Radiação solar global(MJ/m2)"
    },
    "precip" = {
      legenda = "Precipitação Pluvial(mm)"
    }
  )
  return(legenda)
}

grafico.provider.dadosPrec = function(dados, meses) {
  
  # Calculando meses
  dados$data = ymd(dados$data)
  dados$meses = format(dados$data,"%m")
  
  #Calculando precipitacao media
  dados$ta = (dados$tmax + dados$tmin) / 2
  
  #Convetendo coluna data
  dados$data = as.Date(dados$data, "%Y-%m-%d")
  
  #Selecionando colunas
  dados = dados[, c("data", "precip", "ta")]
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
  
  if(meses == "Safra"){
    
    #Gerando safra
    data = grafico.provider.safra(data)
    
    #removendo safras NA
    data = data[!is.na(data$safra), ]
    
    #sumarizando variaveis
    data_inv = data %>%
      group_by(safra) %>%
      dplyr::summarise(pr = sum(pr, na.rm = TRUE),
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
  } else {
    
    # Filtrando dados
    data = data[data$season %in% meses,]
    
    #sumarizando variaveis
    data_inv = data %>%
      group_by(winter_yr) %>%
      dplyr::summarise(pr = sum(pr, na.rm = TRUE),
                ta = mean(ta, na.rm = TRUE))
    
    #calculando anomalia variaveis
    data_inv =  mutate(
      data_inv,
      pr_mean = mean(pr),
      ta_mean = mean(ta),
      pr_anom = (pr * 100 / pr_mean) - 100,
      ta_anom = ta - ta_mean,
      labyr = case_when(
        pr_anom < -10 & ta_anom < -.5 ~ winter_yr,
        pr_anom < -10 &
          ta_anom > .5 ~ winter_yr,
        pr_anom > 10 &
          ta_anom < -.5 ~ winter_yr,
        pr_anom > 10 &
          ta_anom > .5 ~ winter_yr
      ),
      symb_point = ifelse(!is.na(labyr), "yes", "no"),
      lab_font = ifelse(labyr == 2020, "bold", "plain"))
      
      return(data_inv)
  }
  
  return(data_inv)
}

#======================================================================
# Metodo para obter os dados para gerar o grafico
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
#======================================================================
grafico.provider.safra = function(data) {
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
# Metodo para gerar o range de anos
#======================================================================
graficos.provider.rangeDate = function(minData, maxData) {
  pastePeriodo = NULL
  minData = format(as.Date(minData), "%Y")
  maxData = format(as.Date(maxData), "%Y")
  periodos = seq(minData, maxData, by = 1)
  for (i in 1:length(periodos)) {
    if (!is.na(periodos[i + 1])) {
      aux = paste(periodos[i], periodos[i + 1], sep = "-")
      pastePeriodo = c(pastePeriodo, aux)
    }
  }
  return(pastePeriodo)
}

#==================================================================
# Metodo para obter dados para desenhar o mapa
#==================================================================
mapa.provider.dadosMapa = function() {
  statement = "SELECT cidades.id,
  cidades.nome as municipio,
	cidades.latitude as latitude,
	cidades.longitude as longitude,
	cidades.id_estado
	FROM public.cidades
	JOIN estados ON cidades.id_estado = estados.id"
  dados = banco.provider.executeQuery(statement)
  return(dados)
}
#==================================================================
# Metodo para renomear as colunas
#==================================================================
provider.renomear.colunas = function(dados){
  names(dados) = c(
    "Data",
    "Temperatura máxima (ºC)",
    "Temperatura mínima (ºC)",
    "Temperatura média (ºC)",
    "Umidade relativa do ar média (%)",
    "Velocidade média do vento (m/s)",
    "Velocidade máxima do vento (m/s)",
    "Radiação solar global (MJ/m2.dia)",
    "Precipitação (mm)",
    "Temperatura do solo (ºC) ",
    "Estado",
    "Cidade"
  )
  return(dados)
}
#==================================================================
# Metodo para obter os meses do input anomalia
#==================================================================
provider.meses.analises = function(inputAnomalia){
  meses = NULL
  switch (
    inputAnomalia,
    "Safra" = {
      meses = c('10','11','12','01','02','03','05')
    },
    "Outono" = {
      meses = c('04','05','06','07')
    },
    "Inverno" = {
      meses = c('07','08','09')
    },
    "Primavera" = {
      meses = c('10','11','12')
    },
    "Verao" = {
      meses = c('01','02','03')
    }
  )
  return(meses)
}

#==================================================================
# Metodo para obter as legendas das analises
#==================================================================
provider.meses.analises.nomes = function(inputAnomalia){
  legenda = NULL
  switch (
    inputAnomalia,
    "Safra" = {
      legenda = 'Out a Mar'
    },
    "Outono" = {
      legenda = 'Abr a Jun'
    },
    "Inverno" = {
      legenda = 'Jul a Set'
    },
    "Primavera" = {
      legenda = 'Out a Dez'
    },
    "Verao" = {
      legenda = 'Jan a Mar'
    }
  )
  return(legenda)
}


