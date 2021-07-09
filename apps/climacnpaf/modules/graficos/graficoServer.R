#==================================================================
# Grafico server
#
# @input objeto do tipo reactive com os inputs do usuario
# @output objeto do tipo reactive com os outputs do usuario
# @session dados relacionacdos a sessao
# @data objeto do tipo data.frame com dados das estacoes
#==================================================================
graficoServer = function(input, output, session, data) {
  
  #Dados grafico anomalia
  dadosAnomalia = reactive({
    dados = provider.grafico.dadosPrec(input$periodoData, input$cidadeInput, data)
    return(dados)
  })
  
  #Dados grafico filtrado
  dadosFiltrados = reactive({
    dados = provider.grafico.dados(input$periodoData, input$cidadeInput, data)
    return(dados)
  })
  
  #Dados anomalia temperatura 
  dadosTemperatura = reactive({
    dados = provider.grafico.anomalia.temperatura(input$cidadeInput, data)
  })
  
  
  #Atualizando input graficos
  observeEvent(input$variavelInput, {
    op = provider.grafico.opcoes(input$variavelInput)
    
    updateSelectInput(
      session = session,
      inputId = "graficoSelectInput",
      choices = op,
      selected = op[1]
    )
  })
  
  #Atualizando inputs ano anomalia
  observe({
    if (nrow(dadosFiltrados()) > 0) {
      anos = provider.grafico.anos(dadosFiltrados()$data)
      updateSelectInput(session = session,
                        inputId = "anomaliaAnoInput",
                        choices = anos)
    }
  })
  
  #habilitando inputs
  observeEvent(input$graficoSelectInput, {
    switch (
      input$graficoSelectInput,
      "Grafico basico" = {
        enable("grupoDiasInput")
        disable("anomaliaAnoInput")
      },
      "Precipitacao" = {
        enable("grupoDiasInput")
        disable("anomaliaAnoInput")
      },
      "Recarga" = {
        disable("grupoDiasInput")
        disable("anomaliaAnoInput")
      },
      "Periodo Climatico" = {
        disable("grupoDiasInput")
        disable("anomaliaAnoInput")
      },
      "Mapa matriz" = {
        enable("grupoDiasInput")
        disable("anomaliaAnoInput")
      },
      "Anomalia" = {
        disable("grupoDiasInput")
        enable("anomaliaAnoInput")
      },
      "Anomalia Temperatura Precipitacao" = {
        disable("grupoDiasInput")
        disable("anomaliaAnoInput")
      }
    )
    
  })
  
  
  #Plotando graficos
  observe({
    #Obtendo informaçoes graficos
    grafico.legenda = provider.grafico.legenda(input$variavelInput)
    grafico.cor = provider.grafico.cor(input$variavelInput)
    grafico.dias = ifelse(!is.na(as.numeric(input$grupoDiasInput)),
                          as.numeric(input$grupoDiasInput),
                          input$grupoDiasInput)
    
    #Plotando graficos
    output$graficoPlot = renderPlot({
      switch (
        input$graficoSelectInput,
        "Grafico basico" = {
          graficos.GraficoBasico(
            dados = dadosFiltrados(),
            Municipio = input$cidadeInput,
            Coluna = input$variavelInput,
            cor = grafico.cor,
            intervalo = grafico.dias,
            ylab =  grafico.legenda
          )
        },
        "Mapa matriz" = {
          grafico.GraficoMatriz(
            dados = dadosFiltrados(),
            Municipio = input$cidadeInput,
            Coluna = input$variavelInput,
            cor = grafico.cor,
            intervalo = grafico.dias
          )
        },
        "Recarga" = {
          grafico.precipitacaoAcumulada(
            dados = dadosFiltrados(),
            Municipio = input$cidadeInput,
            Coluna = input$variavelInput
          )
        },
        "Precipitacao" = {
          grafico.precipitacao(
            dados = dadosFiltrados(),
            Municipio = input$cidadeInput,
            Grupodias = grafico.dias,
            Coluna = input$variavelInput
          )
        },
        "Periodo Climatico" = {
          grafico.periodoClimatico(dados = dadosFiltrados(),
                                   input$cidadeInput,
                                   input$variavelInput)
        },
        "Anomalia Temperatura Precipitacao" = {
          grafico.anomalia.precipitacao(dadosAnomalia(),
                                       input$cidadeInput)
        },
        "Anomalia" = {
          grafico.anomalia.temperatura(data,input$cidadeInput,input$anomaliaAnoInput)
        }
      )
      
    })
    
  })
}