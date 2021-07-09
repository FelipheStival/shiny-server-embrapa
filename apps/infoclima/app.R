#==============================================#
# Carregando pacotes a serem utilizados
app.LoadPackages = function() {
     #==============================================#
     # Iniciando bibliotecas web
     
     require(shiny) # basico para web
     require(shinydashboard) # interface estilo bootsrap
     #==============================================#
     
     #==============================================#
     # Iniciando bibliotecas de analise
     require(leaflet) # mapa
     require(ggplot2) # graficos
     require(seas) # analise climatologica
     require(data.table) # leitura de big data
     require(reshape2) # manipulacao de tabelas
     require(RJDBC)
     #==============================================#
}
#==============================================#

#==============================================#
# Carregando arquivos compilados
app.LoadModules = function() {
     modulos = list.files(pattern = ".R$",
                          recursive = T,
                          full.names = T)
     index = which(modulos %in% "./app.R")
     modulos = modulos[-index]
     log = sapply(modulos,source,encoding="utf-8")
}
#==============================================#

app.LoadPackages()
app.LoadModules()

shinyApp(ui, server)
