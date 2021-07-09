#==================================================================
# Mapa UI
#==================================================================
createMapaUI = function() {
  #criando janela
  tabItem(tabName = "mapaTab",
          withSpinner(
            leafletOutput(
              outputId = "mapaEstacoes",
              width = "100%",
              height = "90vh"
            )
          ))
  
}

#==================================================================
# Mapa menuItem
#==================================================================
itemMenuMapa = function() {
  menuItem(text = "Mapa",
           tabName = "mapaTab",
           icon = icon("map"))
  
}