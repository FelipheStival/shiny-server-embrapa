#==================================================================
# Localidade server
#
# @input objeto do tipo reactive com os inputs do usuario
# @output objeto do tipo reactive com os outputs do usuario
# @session dados relacionacdos a sessao
# @data objeto do tipo data.frame com dados das estacoes
#==================================================================
localidadeServer = function(input,output,session,data){
  
  observe({
    
    #lista municipios
    listaMunicipios = listaMunicipios(data)
    
    #carregando lista de municipios no input
    updateSelectInput(session = session,
                      inputId = "cidadeInput",
                      choices = listaMunicipios,
                      selected = listaMunicipios[1]
    )
    
    if(!is.null(input$mapaEstacoes_marker_click$id)){
      
      #obtendo id do municipio selecionado pelo usuario
      estacaoID = input$mapaEstacoes_marker_click$id
      
      #obtendo municipio selecionado
      municipio = obterMunicipio(estacaoID,data)
      
      #atualizando input do usuario com municipio selecionado
      updateSelectInput(session = session,
                        inputId = "cidadeInput",
                        selected = municipio
                        )
      
    }
      
  })
  
}