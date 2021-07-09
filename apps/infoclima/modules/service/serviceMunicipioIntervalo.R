serviceMunicipioIntervalo = function(municipio = "Goias", global) {
          
     query = sprintf("select max_data, min_data from grid_meta where municipio = '%s'", municipio)
     dataRange = executeQuery(query)
          
     d.max = as.character(dataRange$max_data)
     d.min = as.character(dataRange$min_data)
          
     result = c(d.min, d.max)
     return(result)
}