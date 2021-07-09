
#==============================================#
# Carregando pacotes a serem utilizados
app.LoadPackages = function() 
{
  #=============================================#
  # Iniciando bibliotecas web
  
  require(shiny) # basico para web
  require(shinydashboard) # interface estilo bootsrap
  require(leaflet)
  require(seas)
  require(ggplot2)
  require(dplyr)
  require(lubridate)
  require(stringr)
  require(ggrepel)
  require(shinyjs)
  require(shinycssloaders)
  require(reshape2)
  require(ggthemes)
  require(RJDBC)
  
  #==============================================#

  
  #==============================================#
}

#==============================================#
# Carregando arquivos compilados
app.LoadModules = function() {
  modulos = list.files(pattern = ".R$",
                       recursive = T,
                       full.names = T)
  index = which(modulos %in% "./app.R")
  modulos = modulos[-index]
  log = sapply(modulos,source)
}
#==============================================#

#==============================================#

app.LoadPackages()
app.LoadModules()

shinyApp(ui,server)

