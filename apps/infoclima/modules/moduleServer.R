#==============================================#
# Construindo sessao da pagina
server = shinyServer(function(input, output, session) {
     
     #==============================================#     
     # Evento de: Ao clicar no marcador do mapa
     observeEvent(input$mapaEstacoes_marker_click, {
          point = input$mapaEstacoes_marker_click
          posicao = providerMetadata.byCoords(tabelaCoordenadas(), point$lat, point$lng)
          updateSelectInput(session, "municipioSelect", selected = posicao[2])
     })
     #==============================================#     
     
     #==============================================#     
     # Carregando dados Grid para exibicao no mapa
     tabelaCoordenadas = reactive({
          serviceMapa(global)
     })
     #==============================================#
     
     #==============================================#     
     # Carregando dados Grid para analise
     tabelaDados = reactive({
          
          municipio = input$municipioSelect
          estado = providerMetadata.getEstadoNorm(tabelaCoordenadas(), municipio)     

          t = serviceMunicipioData(estado, municipio, input$intervalo, global)
          t = providerOggr(t, input$oggrTemp)
          
          return(t)
     })
     #==============================================#
     
     #==============================================#
     # Atualizando nomes dos estados
     observe({
          nomes = providerMetadata.order(tabelaCoordenadas(), "estado")
          updateSelectInput(session, "estadoSelect", choices = c("Todos",nomes) )
     })
     #==============================================#
     
     #==============================================#
     # Atualizando nomes dos municipios
     observe({
          t = providerMetadata.filterByEstados(tabelaCoordenadas(), input$estadoSelect)
          nomes = providerMetadata.order(t, "municipio")
          updateSelectInput(session, "municipioSelect", choices = nomes)
     })
     #==============================================#
     
     #==============================================#
     # Atualizando intervalo de datas
     observe({
          dataRange = serviceMunicipioIntervalo(input$municipioSelect, global)
          
          municipioData = as.Date(tabelaDados()$data)
          
          max.ano = max(municipioData, na.rm = T)
          min.ano = min(municipioData, na.rm = T)
          
          updateDateRangeInput(session, "intervalo", start = min.ano,
                               min = dataRange[1], end = max.ano, max =  dataRange[2])
     })
     #==============================================#
     
     #==============================================#
     # Montando configurações das caixas
     output$boxConfig = renderUI({
          switch (input$sidebar,
                  "mapa" = NULL,
                  "tabela" = NULL,
                  "grafico-basico" = fluidRow.create(),
                  "heatmap" = fluidRow.create(),
                  "prec-geral" = fluidRow.create(disableVariable = TRUE, disableSlice = TRUE),
                  "prec-acumulativa" = NULL, 
                  "wet-dry" = fluidRow.create(disableVariable = TRUE, disableSlice = TRUE),
                  "chuvas" = NULL
          )
     })
     #==============================================#
     
     #==============================================#
     # Exibindo mapa
     output$mapaEstacoes = renderLeaflet({
          t = providerMetadata.filterByEstados(tabelaCoordenadas(), input$estadoSelect)
          graphicsMapa(t, "municipio")
     })
     #==============================================#
     
     #==============================================#
     # Exibindo grafico de analise barplot
     output$graficoSeasBasico = renderPlot({
          
          variavel = input$variableSelected
          periodo = input$daysGroupSelected
          nomeMunicipio = input$municipioSelect
          
          lista = providerInputVariables(variavel, periodo)
          
          graphicsSeasVar(tabelaDados(), nomeMunicipio, lista$variavel,
                          ylab = variavel, intervalo = lista$intervalo, color = lista$cor)
     })
     #==============================================#
     
     #==============================================#
     # Exibindo grafico de analise heatmap
     output$graficoSeasHeatMap = renderPlot({
          
          variavel = input$variableSelected
          periodo = input$daysGroupSelected
          nomeMunicipio = input$municipioSelect
          
          lista = providerInputVariables(variavel, periodo)
          
          graphicsSeasHeatmap(tabelaDados(), nomeMunicipio, lista$variavel, 
                              intervalo = lista$intervalo, color = lista$cor)
     })
     #==============================================#
     
     #==============================================#
     # Exibindo grafico de precipitacao Geral
     output$graficoSeasPrecipitacaoGeral = renderPlot({
          
          variavel = "Precipitacao (mm)"
          periodo = input$daysGroupSelected
          nomeMunicipio = input$municipioSelect
          
          lista = providerInputVariables(variavel, periodo)
          
          graphicsSeasPrecipitacaoGeral(tabelaDados(), nomeMunicipio, lista$variavel, 
                                        lista$intervalo)
     })
     #==============================================#
     
     #==============================================#
     # Exibindo grafico de precipitacao Acumulativa
     output$graficoSeasPrecipitacaoAcumulativa = renderPlot({
          
          variavel = "Precipitacao (mm)"
          periodo = input$daysGroupSelected
          nomeMunicipio = input$municipioSelect
          
          lista = providerInputVariables(variavel, periodo)
          
          graphicsSeasPrecipitacaoAcumulativa(tabelaDados(), nomeMunicipio, lista$variavel, 
                                              lista$intervalo)
     })
     #==============================================#
     
     #==============================================#
     # Exibindo grafico de precipitacao acumulada
     output$graficoSeasPrecip2 = renderPlot({
          
          variavel = "Precipitacao (mm)"
          periodo = input$daysGroupSelected
          nomeMunicipio = input$municipioSelect
          
          lista = providerInputVariables(variavel, periodo)
          
          graphicsSeasPrecip2(tabelaDados(), nomeMunicipio, lista$variavel, lista$intervalo)
     })
     #==============================================#
     
     
     #==============================================#
     # Exibindo grafico de periodo de chuva
     output$periodoChuva = renderPlot({
          
          variavel = "Precipitacao (mm)"
          periodo = input$daysGroupSelected
          nomeMunicipio = input$municipioSelect
          
          lista = providerInputVariables(variavel, periodo)
          
          graphicsPeriodoPrecipitacao(tabelaDados(), nomeMunicipio, lista$variavel)
     })
     #==============================================#
     
     #==============================================#
     # Exibindo tabela
     output$tabelaEstacoes = renderDataTable({
          t = tabelaDados()
          t$oggr = NULL
          
          tabelaUnidade = providerGridTable(t)
          return(tabelaUnidade)
     },options = list(lengthMenu = c(15, 30, 50), pageLength = 15))
     #==============================================#
     
     #==============================================#
     # Download de dados no formato CSV
     output$downloadDataCsv = downloadHandler(
          
          filename = function() { 
               intervalo = as.character(input$intervalo)
               sprintf("Estacao_%s_%s_%s.csv", input$municipioSelect, intervalo[1], intervalo[2]) 
          },
          
          content = function(file) {
               data = tabelaDados()
               data$oggr = NULL
               tabelaExport = providerGridTableToDownload(data)
               write.csv(tabelaExport, file, row.names = F)
          }
     )
     #==============================================#
     
})
#==============================================#