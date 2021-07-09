#==============================================#
# Exibe o mapa contendo as estacoes
# tabela => data.frame com as colunas obrigatorias "latitude" e "longitude" 
# identificador => nome da coluna de identificador
graphicsMapa = function(tabela, identificador){
     
     if(length(tabela) == 1)
          return(NULL)
     
     iNames = which(names(tabela) %in% c(identificador, "latitude", "longitude"))
     
     tabela = tabela[, iNames]
     tabela = unique(tabela)
     
     tabela$latitude = as.numeric(tabela$latitude)
     tabela$longitude = as.numeric(tabela$longitude)
     
     plantIcon = makeIcon(
          iconUrl = "public//pictures//leaves.svg",
          iconWidth = 38, iconHeight = 95,
          iconAnchorX = 22, iconAnchorY = 20
     )
     
     pop = sprintf("<strong>%s</strong><br><b>Lat:</b> %s<br><b>Long:</b> %s",
                   tabela[[identificador]], tabela$latitude, tabela$longitude)
     
     leaflet(tabela) %>%
          addTiles() %>%
          addProviderTiles("OpenTopoMap", group = "Topografia") %>%
          addProviderTiles("Esri.WorldImagery", group = "Satelite") %>%
          addMarkers(lng=~longitude, lat=~latitude, popup=pop, clusterOptions = markerClusterOptions(), icon = plantIcon) %>%
          addLayersControl(
               baseGroups = c("Topografia", "Satelite"),
               options = layersControlOptions(collapsed = FALSE)
          )
}
#==============================================#