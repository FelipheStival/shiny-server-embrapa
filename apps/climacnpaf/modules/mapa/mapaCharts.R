#==================================================================
# Metodo para criar o mapa
#
# @param coords data.frame com coordenadas das estacoes
# @return objeto leaflet com o desenho do mapa
#==================================================================
mapaChart = function(coords){
  
  mapaChart = leaflet(data = coords) %>% 
    addTiles() %>%
    
    #Carregando mapa no centro do brasil
    setView(lng = -49.3882601357422, 
            lat = -16.523253830270647,
            zoom = 4) %>%
    
    #marcando estacoes no mapa
    addMarkers(lng=~longitude, 
               lat=~latitude,
               popup = ~ paste("<strong>",
                               municipio,
                               "</strong><br>",
                               "<br><strong>Lat: </strong>",
                               latitude,"<br>","<strong>Long: </strong>:",
                               longitude),
               clusterOptions = markerClusterOptions()
               ,layerId = ~id_estacao) %>%
    
    #adicionando opcoes de tiras
    addProviderTiles(provider = "OpenTopoMap",
                     group = "Topografia") %>%
    addProviderTiles(provider = "Esri.WorldImagery",
                     group = "Satelite") %>%
    
    #controles da tira escolhida
    addLayersControl(baseGroups = c("Topografia", "Satelite"),
                     options = layersControlOptions(collapsed = FALSE))
  
  return(mapaChart)
}