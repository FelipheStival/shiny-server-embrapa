#==============================================#
# Cria o menu para a configuracao para as analises
fluidRow.create = function(disableVariable = FALSE, disableInterval = FALSE, disableSlice = FALSE, nameInputOgg = 'oggrTemp') {
     box( width = 4,
          if(!disableVariable)
               selectInput("variableSelected", "Selecione a variavel:", 
                           c("Precipitacao (mm)", "Temperatura maxima (*C)", "Temperatura minima (*C)", "Radiacao solar global(MJ/m2)", "Umidade (%)", "Velocidade do Vento (m/s)", "Evatotranspiracao de referencia (mm)", "Grau Dia (*C.dia)"), 
                        selected = "Precipitacao"),

          if(!disableInterval)
               selectInput("daysGroupSelected", "Selecione o grupo de dias:", c("10 Dias", "21 Dias", "Mensal"),
                        selected = "Mensal"),
     
          if(!disableSlice)
               sliderInput(nameInputOgg, label = "Selecione a temperatua base:", min = 0, max = 15, value = 7),

          h3(p(textOutput("municipioSelect")))
     )
}
#==============================================#

#==============================================#
# Exibe o elemento "mapa" selecionado pelo menu da barra lateral
# See: sidebarMenu.create()
tabItem.map.display = function() {
     
     tabItem(tabName = "mapa",
          leafletOutput("mapaEstacoes")
     )
}
#==============================================#

#==============================================#
# Exibe o elemento "grafico-basico" selecionado pelo menu da barra lateral
# See: sidebarMenu.create()
tabItem.plot.display = function(tabId, plotId, width = 8) {
     tabItem(tabName = tabId, 
          box( width = width,
               plotOutput(plotId)
          )
     )
}
#==============================================#

#==============================================#
# Exibe o elemento "tabela" selecionado pelo menu da barra lateral
# See: sidebarMenu.create()
tabItem.tabela.display = function() {
     tabItem(tabName = "tabela",
             dataTableOutput("tabelaEstacoes"),
             downloadButton('downloadDataCsv', 'Download (csv)')
     )
}
#==============================================#

#==============================================#
# Cria o corpo do dashboard
dashboardBody.create = function() {
     dashboardBody(

          uiOutput("boxConfig"),
          
          #==============================================#
          tags$style(type = "text/css", "#mapaEstacoes {height: calc(100vh - 80px) !important;}"),
          #==============================================#  

          #==============================================#
          tabItems(
               tabItem.map.display(),
               tabItem.plot.display("grafico-basico", "graficoSeasBasico"),
               tabItem.plot.display("heatmap", "graficoSeasHeatMap"),
               tabItem.plot.display("prec-geral", "graficoSeasPrecipitacaoGeral"),
               tabItem.plot.display("prec-acumulativa", "graficoSeasPrecipitacaoAcumulativa", width = 12),
               tabItem.plot.display("wet-dry", "graficoSeasPrecip2"),
               tabItem.plot.display("chuvas", "periodoChuva", width = 12),
               tabItem.tabela.display()
          )
          #==============================================#
     )
}
#==============================================#