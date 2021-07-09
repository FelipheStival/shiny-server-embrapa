#==================================================================
# Localidade UI
#==================================================================
itemlocalidadeUI = function(){
  
  menuItem(text = "Selecione a localidade",
           icon = icon("street-view"),
           selectInput(inputId = "cidadeInput",
                       label = "Selecione o municipio:",
                       choices = c("Santo Antonio de Goias"),
                       selected = "Santo Antonio de Goias")
           )
  
}