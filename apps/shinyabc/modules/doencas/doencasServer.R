# Doenca service
doencaServer = function(input, output, session) {
  
  # Botao Voltar
  observeEvent(input$btnRetonarDoencas,
               change_page('/')
  )
  
  # Reactive para conseguir os dados dos municipios
  dadosDoencas = reactive({
    dados = getDadosDoencasProvider()
    return(dados)
  })
  
  # Atualizando safras
  observe({
    
    dados = dadosDoencas()
    dados = dados[[1]]
    
    safras = sort(unique(dados$safra))
    updateSelectInput(
      session = session,
      inputId = "safraInputDoencas2",
      choices = safras,
      selected = safras[1]
    ) 
  })
  
  # Atualizando locais
  observe({
    if(!is.null(input$safraInputDoencas2)){
      
      dados = dadosDoencas()
      dados = dados[[1]]
      dados = dados[dados$safra %in% input$safraInputDoencas2,]
      
      if(nrow(dados) > 0){
        updateSelectInput(
          session = session,
          inputId = "select_doencas_local",
          choices = unique(dados$cidade),
          selected = unique(dados$cidade)[1]
        ) 
      }
    }
  })
  
  # output grafico media geral
  output$graficoDoencasPlot1 = renderPlot({
    localSelect = input$select_doencas_local
    gerador_graficos_cidade(dadosDoencas(), localSelect)
  })
  
  # output grafico local
  output$graficoDoencasPlot2 = renderPlot({
    safraSelect = input$safraInputDoencas2;
    gerador_graficos(dadosDoencas(), safraSelect)
  })
  
}