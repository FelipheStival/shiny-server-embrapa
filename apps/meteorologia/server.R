
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(leaflet)
library(data.table)
source("src//basicfunctions.R")
source("src//graphicfunctions.R")

shinyServer(function(input, output, session) {
     
     #==============================================#     
     observeEvent(input$estacoesMap_marker_click, {
          point = input$estacoesMap_marker_click
          
          estacao.meta = get.estacao.meta(bancoDados, usuario, input$estadoSelect) 
          
          nomes.estacao = as.character(estacao.meta$id_estacao)
          nomes.estacao = sort(nomes.estacao)
          
          estacao.selected = subset(estacao.meta, latitude == point$lat & longitude == point$lng)
          
          updateSelectInput(session, "estacaoSelect",  choices = nomes.estacao, selected = estacao.selected$id_estacao)
          
     })
     #==============================================#     
     
     #==============================================#     
     observeEvent(input$abas,{
          abas = input$abas
          if(abas == "Precipitacao"){
               updateSelectInput(session, "variableSelected", selected = "Precipitacao")
          }
     })
     #==============================================#     
     
     #==============================================#     
     observeEvent(input$variableSelected,{
          abas = input$abas
          if(abas == "Precipitacao"){
               updateSelectInput(session, "variableSelected", selected = "Precipitacao")
          }
     })
     #==============================================#     
     
     #==============================================#     
     observe({start.packages()})
     #==============================================#
     
     #==============================================#
     observe({
          
          estados = get.estados(bancoDados, usuario)
          
          nomes = sprintf("%s - %s", estados$codigoEstado, estados$nome)
          nomes = sort(nomes)
          
          updateSelectInput(session, "estadoSelect", choices = c("Todos",nomes))
     })
     #==============================================#
     
     #==============================================#
     observe({
          
          estacao.meta = get.estacao.meta(bancoDados, usuario, input$estadoSelect) 
          
          nomes.estacao = as.character(estacao.meta$id_estacao)
          nomes.estacao = sort(nomes.estacao)
          
          updateSelectInput(session, "estacaoSelect",  choices = nomes.estacao)
     })
     #==============================================#
     
     #==============================================#
     observe({
          
          estacao.dados = get.estacao(bancoDados, usuario, input$estacaoSelect, input$intervalo) 
          estacao.dados$data = as.Date(estacao.dados$data)
          
          max.ano = max(estacao.dados$data, na.rm = T)
          min.ano = min(estacao.dados$data, na.rm = T)
          
          updateDateRangeInput(session, "intervalo", start = min.ano, min = min.ano, end = max.ano, max =  max.ano)
     })
     #==============================================#
     
     #==============================================#
     observe({
          
          nomes.variavel = get.variaveis()
          updateSelectInput(session, "variableSelected",  choices = nomes.variavel)
     })
     #==============================================#
     
     #==============================================#
     
     output$developer = renderUI({
          url = a("Pedro Henrique S. Farias", href="mailto:pedrohenriquedrim@gmail.com")
          tagList("Developed by : ", url)
     })
     #==============================================#
     
     #==============================================#
     # Exibindo mapa
     output$estacoesMap = renderLeaflet({
          
          inp = input$estadoSelect
          create.map(bancoDados, usuario, inp)
     })
     #==============================================#
     
     #==============================================#
     # Exibindo tabela
     output$tabelaEstacoes = renderDataTable({
          
          get.estacao(bancoDados, usuario, input$estacaoSelect, input$intervalo)
     },options = list(lengthMenu = c(15, 30, 50), pageLength = 15))
     #==============================================#
     
     #==============================================#
     # Exibindo grafico
     output$graficoSeasBasico = renderPlot({
          
          var = input$variableSelected
          var = switch (var,
                        "Temperatura Maxima" = "t_max",
                        "Temperatura Minima" = "t_min",
                        "Precipitacao" = "precipitacao",
                        "Radiacao" = "radiacao",
                        "Graus Dias Acumulado" = "gdd10"
          )
          
          intervalo = input$intervalSelected
          intervalo = switch (intervalo,
                              "5 Dias" = 5,
                              "10 Dias" = 10,
                              "15 Dias" = 15,
                              "20 Dias" = 20,
                              "25 Dias" = 25,
                              "Mensal" = "mon"
          )
          
          tabela = get.estacao(bancoDados, usuario, input$estacaoSelect, input$intervalo)
          grafico.seas.basic(var,input$sliceOutput, intervalo, tabela)
          
     })
     #==============================================#
     
     #==============================================#
     output$graficoSeasPrecip1 = renderPlot({
          
          var = input$variableSelected
          var = switch (var,
                        "Temperatura Maxima" = "t_max",
                        "Temperatura Minima" = "t_min",
                        "Precipitacao" = "precipitacao",
                        "Radiacao" = "radiacao",
                        "Graus Dias Acumulado" = "gdd10"
          )
          
          intervalo = input$intervalSelected
          intervalo = switch (intervalo,
                              "5 Dias" = 5,
                              "10 Dias" = 10,
                              "15 Dias" = 15,
                              "20 Dias" = 20,
                              "25 Dias" = 25,
                              "Mensal" = "mon"
          )
          
          tabela = get.estacao(bancoDados, usuario, input$estacaoSelect, input$intervalo)
          grafico.seas.precip1(intervalo, var, input$sliceOutput, tabela)
     })
     #==============================================#
     
     #==============================================#
     output$graficoSeasPrecip2 = renderPlot({
          
          intervalo = input$intervalSelected
          intervalo = switch (intervalo,
                              "5 Dias" = 5,
                              "10 Dias" = 10,
                              "15 Dias" = 15,
                              "20 Dias" = 20,
                              "25 Dias" = 25,
                              "Mensal" = "mon"
          )
          
          tabela = get.estacao(bancoDados, usuario, input$estacaoSelect, input$intervalo)
          grafico.seas.precip2(intervalo, input$sliceOutput, tabela)
     })
     #==============================================#
     
     
     #==============================================#
     # Exibindo grafico especifico
     output$graficoSeasHeatMap = renderPlot({
          
          var = input$variableSelected
          var = switch (var,
                        "Temperatura Maxima" = "t_max",
                        "Temperatura Minima" = "t_min",
                        "Precipitacao" = "precipitacao",
                        "Radiacao" = "radiacao",
                        "Graus Dias Acumulado" = "gdd10"
          )
          
          intervalo = input$intervalSelected
          intervalo = switch (intervalo,
                              "5 Dias" = 5,
                              "10 Dias" = 10,
                              "15 Dias" = 15,
                              "20 Dias" = 20,
                              "25 Dias" = 25,
                              "Mensal" = "mon"
          )
          
          tabela = get.estacao(bancoDados, usuario, input$estacaoSelect, input$intervalo)
          grafico.seas.heatmap(var,input$sliceOutput, intervalo, tabela)
     })
     #==============================================#
     
     #==============================================#
     output$downloadDataCsv = downloadHandler(
          
          filename = function() { 
               intervalo = as.character(input$intervalo)
               sprintf("Estacao_%s_%s_%s.csv", input$estacaoSelect, intervalo[1], intervalo[2]) 
          },
          
          content = function(file) {
               data = get.estacao(bancoDados, usuario, input$estacaoSelect, input$intervalo)
               write.csv(data, file, row.names = F)
          }
     )
     #==============================================#
     
     #==============================================#
     output$downloadDataDssat = downloadHandler(
          
          filename = function() { 
               intervalo = as.character(input$intervalo)
               sprintf("Dssat_Estacao_%s_%s_%s.tar", input$estacaoSelect, intervalo[1], intervalo[2]) 
          },
          
          content = function(file) {
               data = get.estacao(bancoDados, usuario, input$estacaoSelect, input$intervalo)
               getDssatFiles(data, bancoDados,usuario, input$estadoSelect)
               tar(tarfile = file, files = "files")
          }
     )
     #==============================================#
})
