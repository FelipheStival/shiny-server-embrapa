#==================================================================
# Server mapa
#
# @input objeto do tipo reactive com os inputs do usuario
# @output objeto do tipo reactive com os outputs do usuario
# @session dados relacionacdos a sessao
# @data objeto do tipo data.frame com dados das estacoes
#==================================================================
mapaServer = function(input,output,session,data){
  
  #==============================================================
  
  output$mapaEstacoes = renderLeaflet({
    
    #obtendo dados das estacoes
    coords = estacoesCords(data)
    
    #plotando mapa
    mapaChart(coords)
    
  })
  
  #==============================================================
  
}