#==================================================================
# Metodo para obter dados para desenhar o mapa
#
# @estado string com estado selecionado
# @return data.frame com dados filtrados
#==================================================================
mapa.provider.dadosMapa = function(estado){
    statement = sprintf("SELECT DISTINCT station.id, 
            		 station.code as id_estacao,
            		 city.latitude,
            		 city.longitude,
            		 city.name as municipio
	               FROM station 
              	 JOIN city ON station.city_id = city.id
              	 JOIN state ON city.state_id = state.id
                 JOIN inmet_daily_data ON inmet_daily_data.station_id = station.id
                 WHERE state.name = '%s'",estado)
  dados = banco.provider.executeQuery(statement)
  return(dados)
}
