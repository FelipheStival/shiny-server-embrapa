# Mapa service
mapaServer = function(input, output, session) {
  
  # Botao retornar
  observeEvent(input$btnRetonarExperimentos,
               change_page('/')
  )
  
  # Obter estados
  observe({
    estados = provider.obterEstados()
    updateSelectInput(
      session = session,
      inputId = "estadoInput",
      choices = estados$nome,
      selected = estados$nome[1]
    ) 
  })
  
  # Obter cidades
  observe({
    if(!is.null(input$estadoInput)){
      cidades = provider.obterCidades(input$estadoInput)
      updateSelectInput(
        session = session,
        inputId = "cidadeInput",
        choices = cidades$nome,
        selected = cidades$nome[1]
      ) 
    }
  })
  
  
  # Reactive para conseguir os dados dos municipios
  cidades = reactive({
    dados = provider.obterCidades(input$estadoInput)
    return(dados)
  })
  
  # Reative para conseguir os dados climaticos
  dadosClimaticos = reactive({
    dados = provider.obterClimaticos(input$cidadeInput,
                                     input$periodoInput
                                     )
  })
  
  
  # Reative para conseguir os dados anomalia
  dadosAnomaliaTemperatura = reactive({
    dados = grafico.provider.dadosPrec(dadosClimaticos(),input$safraGrupoInput)
    return(dados)
  })
  
  # Saida tabela
  output$tabelaDados = renderDataTable({
    provider.renomear.colunas(dadosClimaticos())
  },options = list(
    lengthMenu = c(5, 10, 15, 20),
    pageLength = 15,
    scrollX = TRUE
  ))
  
  # Download dados
  output$downloadDados = downloadHandler(
    filename = function() {
      paste(
        'dados',
        "-",
        input$periodoInput[1],
        "-",
        input$periodoInput[2],
        '.csv',
        sep = ''
      )
    },
    content = function(con) {
      write.csv(dadosClimaticos(), con)
    }
  )
  
  # Atualizando input ano anomalia
  observe({
    if (!is.null(input$cidadeInput) && input$cidadeInput != '') {
      
      # Obtendo range data
      rangeDate = c(min(dadosClimaticos()$data),
                    max(dadosClimaticos()$data))
      
      # Gerando anos
      anos = graficos.provider.rangeDate(rangeDate[1], rangeDate[2])
      
      # Atualizando input
      updateSelectInput(session = session,
                        inputId = "anoSelectAnomalia",
                        choices = anos)
    }
  })
  
  # Saida grafica mapa
  output$mapaEstacoes = renderLeaflet({
    mapaChart(
      mapa.provider.dadosMapa()
    )
  })
  
  # Evento click mapa
  observe({
    if (!is.null(input$mapaEstacoes_marker_click$id)) {
      updateSelectInput(
        session = session,
        inputId = "cidadeInput",
        selected = input$mapaEstacoes_marker_click$id
      )
    }
  })
  
  
  # Saida grafica boxplot
  output$graficosPerdidosPlot = renderPlot({
    grafico.boxplot(
      tabela = dadosClimaticos(),
      nomeEstacao = input$cidadeInput,
      Grupodias = input$grupodiasBoxPlot,
      colunaVariavel = input$boxplotVariavel,
      color = graficos.provider.grafico.cor(input$boxplotVariavel),
      ylab = graficos.provider.grafico.legenda(input$boxplotVariavel)
    ) 
  })
  
  # Saida grafica grafio matriz
  output$Matrizplot = renderPlot({
    graficos.GraficoMatriz(
      dados = dadosClimaticos(),
      Municipio = input$cidadeInput,
      Coluna = input$variavelSelect,
      cor = graficos.provider.grafico.cor(input$variavelSelect),
      intervalo = input$grupoDiasSelect
    )
  })
  
  # Saida grafica precipitacao
  output$plotPrecipitacao = renderPlot({
      grafico.precipitacao(
        dados = dadosClimaticos(),
        Municipio = input$cidadeInput,
        Grupodias = input$grupoDiasSelectPrec,
        Coluna = "precip"
      ) 
  })
  
  # Saida grafica precipitacao cumulativa
  output$PrecipitacaoCumulativaPlot = renderPlot({
    grafico.precipitacaoAcumulada(
      tabela = dadosClimaticos(),
      Municipio = input$cidadeInput,
      Coluna = "precip"
    ) 
  })
  
  # Saida grafica seco e umido
  output$secoUmidoPlot = renderPlot({
      grafico.diaSecoUmido(
        tabela = dadosClimaticos(),
        colunaPrecipitacao = "precip",
        Municipio = input$cidadeInput,
        intervalo = input$secoUmidoGrupoDias
      ) 
  })
  
  # Saida grafico periodo chuvoso
  output$periodoChuvosoPlot = renderPlot({
      graficos.periodoClimatico(
        dados = dadosClimaticos(),
        Municipio = input$cidadeInput,
        Coluna = "precip"
      ) 
  })
  
  # Saida grafica anomalia temperatura
  output$AnomaliaTemperaturaPlot = renderPlot({
      grafico.anomalia.temperatura(
        data_inv = dadosAnomaliaTemperatura(),
        municipio = input$cidadeInput,
        meses = input$safraGrupoInput,
        nomesMeses = provider.meses.analises.nomes(input$safraGrupoInput))
  })
  
  # Saida grafica anomalia precipitacao
  output$anomaliaPrecipitacaoPlot = renderPlot({
      grafico.GraficoAnomalia(
        cidade = input$cidadeInput,
        ano = input$anoSelectAnomalia,
        coluna = "rain",
        dadosClimaticos(),
        ylab = "precipitacao",
        Escala = 100)
  })
  
}