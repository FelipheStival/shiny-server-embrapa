#==================================================================
# sobre UI
#==================================================================
createSobreUI = function(){
  
  #criando janela
  tabItem(tabName = "sobreTab",
    tags$div(
      id = "container-image-sobre",
      tags$img(src = "img//Embrapa.png",id = "logo-embrapa")
    )
          
  )
  
}


#==================================================================
# sobre menuItem
#==================================================================
itemSobreUI = function(){
  
  menuItem(text = "Sobre",
           tabName = "sobreTab",
           icon = icon("question-circle")
           
  )
  
}