#==================================================================
# Global Server
#
# @input objeto do tipo reactive com os inputs do usuario
# @output objeto do tipo reactive com os outputs do usuario
# @session dados relacionacdos a sessao
#==================================================================

server = shinyServer(function(input, output, session) {
  
  # Login service
  loginServer(input,output,session)
  
  # Filtro service
  filtroServer(input,output,session)
  
  # Mapa
  mapaServer(input,output,session)
  
  # Analise server
  analiseServer(input,output,session)
  
  # Graficos server
  graficosServer(input,output,session)
  
  # Tabela server
  tabelaServer(input,output,session)
  
})
