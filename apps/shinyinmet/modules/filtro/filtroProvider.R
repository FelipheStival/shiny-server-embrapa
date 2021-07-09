#==================================================================
# Metodo para obter os estados pelo banco de dados
#
# @param conexao conexao com banco de dados
# @return data.frame com dados dos estados
#==================================================================
filtro.provider.obterEstados = function(conexao) {
  statement = "SELECT DISTINCT state.name
	FROM public.state
	JOIN city ON city.state_id = state.id
	JOIN station ON station.city_id = city.id
	JOIN inmet_daily_data ON inmet_daily_data.station_id = station.id"
  estados = banco.provider.executeQuery(statement)
  return(estados)
}

#==================================================================
# Metodo para obter os municipios
#
# @param conexao conexao com banco de dados
# @param estado estado selecionado
# @return data.frame com cidades
#==================================================================
filtro.provider.obterCidades = function(estado, conexao) {
  statement = sprintf("SELECT DISTINCT city. name as municipio
	                     FROM city
	                     JOIN state ON city.state_id = state.id
	                     JOIN station ON city.id = station.city_id
	                     JOIN inmet_daily_data ON inmet_daily_data.station_id = station.id
	                     WHERE state.name = '%s'",estado)
  cidades = banco.provider.executeQuery(statement)
  return(cidades)
}

#==================================================================
# Metodo para obter as estacoes
#
# @param conexao conexao com banco de dados
# @param estado estado selecionado
# @return dados das estacoes
#==================================================================
filtro.provider.obterEstacao = function(municipio, conexao) {
  statement = sprintf(
    "SELECT station.code,
            city.name
            FROM station
            JOIN city ON station.city_id = city.id
            WHERE city.name  = '%s'",
    municipio
  )
  estacoes = banco.provider.executeQuery(statement)
  return(estacoes)
}

#==================================================================
# Metodo para obter o periodo de datas por cidade
#
# @param municipio string com municipio selecionado
# @param conexao conexao com banco de dados
# @return data.frame com periodo de datas
#==================================================================
filtro.provider.obterPeriodo = function(municipio, conexao) {
  statement = sprintf(
    "SELECT min(inmet_daily_data.measurement_date) as comeco,
            max(inmet_daily_data.measurement_date) as fim
            FROM inmet_daily_data
            JOIN station ON inmet_daily_data.station_id = station.id
					  JOIN city ON station.city_id = city.id
            WHERE city.name = '%s'", 
    municipio
  )
  periodo = banco.provider.executeQuery(statement)
  return(periodo)
}