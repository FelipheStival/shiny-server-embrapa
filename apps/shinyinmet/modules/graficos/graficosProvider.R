#==================================================================
# Metodo para obter dados para os graficos
#
# @param conexao conexao com banco de dados
# @return data.frame com dados dos estados
#==================================================================
graficos.provider.dados = function(municipio, startDate, endDate) {
  statement = sprintf(
    "SELECT inmet_daily_data.id,
     inmet_daily_data.station_id,
	   inmet_daily_data.measurement_date,
	   inmet_daily_data.minimum_temperature,
	   inmet_daily_data.maximum_temperature,
	   inmet_daily_data.minimum_precipitation,
	   inmet_daily_data.maximum_precipitation,
	   inmet_daily_data.minimum_relative_air_humidity,
	   inmet_daily_data.maximum_relative_air_humidity,
	   inmet_daily_data.wind_speed, wind_direction,
	   inmet_daily_data.global_radiation,
	   inmet_daily_data.minimum_dew_point,
	   inmet_daily_data.maximum_dew_point,
	   inmet_daily_data.rain,
	   city.name as municipio
	FROM inmet_daily_data
	JOIN station ON inmet_daily_data.station_id = station.id
	JOIN city ON station.city_id = city.id
	WHERE city.name = '%s'
	AND
	inmet_daily_data.measurement_date >= '%s'
	AND
	inmet_daily_data.measurement_date <= '%s'",
    municipio,
    startDate,
    endDate
  )
  
  dados = banco.provider.executeQuery(statement)
  
  # Corrigindo radiacao global
  dados$global_radiation = round(dados$global_radiation / 1000,2)
  
  # Renomeando coluna data
  colnames(dados)[3] = "data"
  return(dados)
}

#==================================================================
# Metodo para preparar os dados para o grafico de perdidos
#
# @param conexao conexao com banco de dados
# @return data.frame com dados dos estados
#==================================================================
graficos.provider.dadosPerdidos = function(estado, inicio, fim) {
  # Executando query
    statement = sprintf(
      "SELECT
    	   city.name as nome_cidade,
    	   inmet_daily_data.minimum_temperature,
    	   inmet_daily_data.maximum_temperature,
    	   inmet_daily_data.minimum_relative_air_humidity,
    	   inmet_daily_data.maximum_relative_air_humidity,
    	   inmet_daily_data.wind_speed, 
    	   inmet_daily_data.global_radiation,
    	   inmet_daily_data.rain
  	     FROM inmet_daily_data
  	     JOIN station ON inmet_daily_data.station_id = station.id
  	     JOIN city ON station.city_id = city.id
  	     JOIN state ON city.state_id = state.id
  	     WHERE state.name = '%s'
  	     AND
  	     inmet_daily_data.measurement_date >= '%s'
  	     AND
  	     inmet_daily_data.measurement_date <= '%s'",
         estado,
         inicio,
         fim
    ) 
  
  dados = banco.provider.executeQuery(statement)
  dados$nome_cidade = paste(dados$nome_cidade,estado,sep = "-")
  
  # Renomando colunas
  names(dados) = c(
    "nome_cidade",
    "Temperatura minima",
    "Temperatura maxima",
    "Umidade minima do ar",
    'Umidade maxima do ar',
    "Velocidade do vento",
    "Radiacao solar global",
    "Precipitacao"
  )
  
  # Preparando dados para gerar o grafico
  naTabela = melt(dados, id.vars = "nome_cidade")
  naTabela = dcast(naTabela,
                   nome_cidade ~ variable,
                   value.var = "value",
                   fun.aggregate = naCounter)
  naTabela = melt(naTabela, id.vars = "nome_cidade")
  names(naTabela) = c("Estacao", "Variavel", "Valor")
  return(naTabela)
}

#======================================================================
# Metodo para obter as cores dos graficos
#
# @param variavelSelected variavel selecionada
# @return objeto do tipo string com a cor do grafico
#======================================================================
graficos.provider.grafico.cor = function(variavelSelect) {
  cor = NULL
  switch (
    variavelSelect,
    "minimum_temperature" = {
      cor = "tomato"
    },
    "maximum_temperature" = {
      cor = "OrangeRed"
    },
    "minimum_precipitation" = {
      cor = "blue"
    },
    "maximum_precipitation" = {
      cor = "DodgerBlue"
    },
    "minimum_relative_air_humidity" = {
      cor = "DarkCyan"
    },
    "maximum_relative_air_humidity" = {
      cor = "DarkCyan"
    },
    "wind_speed" = {
      cor = "DarkGray"
    },
    "global_radiation" = {
      cor = "orange"
    },
    "rain" = {
      cor = "LightSteelBlue"
    }
  )
  return(cor)
}

#======================================================================
# Metodo para obter as legendas para o grafico
#
# @param variavelSelected variavel selecionada
# @return objeto do tipo string com a legenda do grafico
#======================================================================
graficos.provider.grafico.legenda = function(variavelSelect) {
  legenda = NULL
  switch (
    variavelSelect,
    "minimum_temperature" = {
      legenda = "Temperatura mínima do ar(*C)"
    },
    "maximum_temperature" = {
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
    "global_radiation" = {
      legenda = "Radiação solar global(MJ/m2)"
    },
    "rain" = {
      legenda = "Precipitação Pluvial(mm)"
    }
  )
  return(legenda)
}

#======================================================================
# Metodo para obter os anos para atualizar input
#
# @param dados base de dados da estacao
# @return vetor com datas
#======================================================================
graficos.provider.grafico.anos = function(dados) {
  anos = unique(format(dados$data, "%Y"))
  anos = sort(as.numeric(anos))
  return(anos)
}

#======================================================================
# Metodo para contar os NA de um vetor
#
# @param values vetor a ser contado os NA
# @return porcentagem de NA
#======================================================================
naCounter = function(values) {
  index = which(is.na(values))
  rate = length(index) / length(values)
  return(rate * 100)
}

#======================================================================
# Metodo para gerar o range de anos
#
# @param minData data minima
# @param maxData data maxima
# @return vetor com periodo de datas
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

#======================================================================
# Metodo para obter os dados para gerar o grafico da anomalia da temperatura
#
# @param dados objeto data.frame com dados completos
#======================================================================

grafico.provider.dadosPrec = function(dados) {
  
  #Calculando precipitacao media
  dados$ta = (dados$maximum_temperature + dados$minimum_temperature) / 2
  
  #Convetendo coluna data
  dados$data = as.Date(dados$data, "%Y-%m-%d")
  
  #Selecionando colunas
  dados = dados[, c("data", "rain", "ta")]
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
  data = grafico.provider.safra(data)
  
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