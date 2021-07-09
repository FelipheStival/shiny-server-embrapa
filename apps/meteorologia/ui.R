
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(shinydashboard)
library(leaflet)
library(data.table)

dashboardPage(
     
     #==============================================#
     # Cabecalho do dashboard
     dashboardHeader(disable = T),
     #==============================================#
     
     #==============================================#
     # Barra lateral do dashboard
     dashboardSidebar(
          
          uiOutput("developer"),
          
          hr(),
          
          sidebarMenu(
               menuItem("Mapa", tabName = "map", icon = icon("map-marker")),
               menuItem("Graficos", tabName = "graficos", icon = icon("line-chart")),
               menuItem("Tabela", tabName = "tabela", icon = icon("table"))
          ),
          
          hr(),
          
          #==============================================#
          selectInput("estadoSelect", "Selecione o(s) estado(s):", "Todos", selected = "Todos"), 
          #==============================================#
          
          #==============================================#
          selectInput("estacaoSelect", "Selecione a estacao:", ".CNPAF.1",selected = ".CNPAF.1"),
          #==============================================#
          
          #==============================================#
          dateRangeInput("intervalo", "Selecione o periodo:", min = "1980-01-01", start = "1980-01-01"),
          #==============================================#
          
          hr()
     ),
     #==============================================#
     
     #==============================================#
     # Corpo do dashboard
     dashboardBody(
          
          #==============================================#
          tags$style(type = "text/css", "#estacoesMap {height: calc(100vh - 80px) !important;}"),
          #==============================================#          
          
          #==============================================#
          tabItems(
               
               #==============================================#
               tabItem(tabName = "map",
                       leafletOutput("estacoesMap")
               ),
               #==============================================#
               
               #==============================================#
               tabItem(tabName = "graficos",
                       
                       fluidRow(
                            column(3,
                                   selectInput("variableSelected", "Selecione a variavel:", "Precipitacao", selected = "Precipitacao")
                            ),
                            
                            column(3,
                                   selectInput("intervalSelected", "Selecione o grupo de dias:", c("5 Dias","10 Dias","15 Dias" ,"20 Dias","25 Dias","Mensal"), selected = "Mensal")
                            ),
                            
                            column(3,
                                   sliderInput("sliceOutput", label = "Selecione a temperatua base:", min = 0, max = 30, value = 10)
                            )
                       ),
                       
                       tabBox(id = "abas", title = "",
                              width = NULL, height = NULL,
                              
                              tabPanel("Basico",
                                       plotOutput("graficoSeasBasico")
                              ),
                              tabPanel("HeatMap",
                                       plotOutput("graficoSeasHeatMap") 
                              ),
                              tabPanel("Precipitacao",
                                       plotOutput("graficoSeasPrecip1"),
                                       plotOutput("graficoSeasPrecip2")
                              )
                       )
                       
               ),
               #==============================================#
               
               #==============================================#
               tabItem(tabName = "tabela",
                       dataTableOutput("tabelaEstacoes"),
                       downloadButton('downloadDataCsv', 'Download (csv)'),
                       downloadButton('downloadDataDssat', 'Download (dssat)')
               )
               #==============================================#
               
          )
          #==============================================#
          
     )
     #==============================================#
     
)