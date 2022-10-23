#==================================================================
# Anomalia temperatura UI
#==================================================================
create.pagina.grafico.Temperatura = function() {
  #criando janela
  tabItem(tabName = "AnomaliaTemperaturaPlot",
          box(
            width = 3,
            selectInput(
              inputId = "safraGrupoInput",
              label = "Selecione o grupo de dias:",
              choices = c("Safra",
                          "Verao",
                          "Outono",
                          "Inverno",
                          "Primavera"),
              selected = "Safra"
            ),
          ),
          box(width = 9,
              withSpinner(
                plotOutput(
                  "AnomaliaTemperaturaPlot",
                  width = "100%",
                  height = "85vh"
                )
              )))
}

#==================================================================
# Precipitacao acumulada UI
#==================================================================
create.pagina.grafico.cumulativa = function() {
  #criando janela
  tabItem(tabName = "PrecipitacaoCumulativa",
          box(width = 12,
              withSpinner(
                plotOutput(
                  "PrecipitacaoCumulativaPlot",
                  width = '100%',
                  height = "85vh"
                )
              )))
}


#==================================================================
# Precipitacao UI
#==================================================================
create.pagina.grafico.precipitacao = function() {
  #criando janela
  tabItem(tabName = "Precipitacaoplot",
          box(
            width = 4,
            selectInput(
              inputId = "grupoDiasSelectPrec",
              label = "Selecione o grupo de dias:",
              choices = c(
                "10 dias" = 10,
                "21 dias" = 21,
                "Mensal" = "mon"
              )
            )
          ),
          box(width = 8,
              withSpinner(
                plotOutput("plotPrecipitacao", width = "100%", height = "85vh")
              )))
}

#==================================================================
# grafico dia seco e umido
#==================================================================
create.pagina.grafico.secoUmido = function() {
  #criando janela
  tabItem(tabName = "diaSecoUmido",
          box(
            width = 4,
            selectInput(
              inputId = "secoUmidoGrupoDias",
              label = "Selecione o grupo de dias:",
              choices = c(
                "10 dias" = 10,
                "21 dias" = 21,
                "Mensal" = "mon"
              )
            )
          ),
          box(width = 8,
              withSpinner(
                plotOutput("secoUmidoPlot", width = "100%", height = "85vh")
              )))
  
}

#==================================================================
# Periodo chuvoso UI
#==================================================================
create.pagina.grafico.periodoChuvoso = function() {
  #criando janela
  tabItem(tabName = "periodoChuvosoPlot",
          box(
            width = 12,
            height = "85vh",
            withSpinner(
              plotOutput("periodoChuvosoPlot",
                         width = "100%",
                         height = "85vh")
            )
          ))
}

#==================================================================
#  Anomalia Precipitacao IU
#==================================================================
create.pagina.grafico.anomaliaPrecipitacao = function() {
  #criando janela
  tabItem(tabName = "AnomaliaPrecipitacaoplot",
          box(
            width = 3,
            selectInput(
              inputId = "anoSelectAnomalia",
              label = "Selecione o ano: ",
              choices = NULL
            )
          ),
          box(width = 9,
              withSpinner(
                plotOutput(
                  "anomaliaPrecipitacaoPlot",
                  width = "100%",
                  height = "85vh"
                )
              )))
}

#==================================================================
# Pagina grafico basico
#==================================================================
create.pagina.grafico.basico = function() {
  tabItem(tabName = "graficosPerdidosPlot",
          box(
            width = 4,
            selectInput(
              inputId = "boxplotVariavel",
              label = "Selecione a variavel:",
              choices = c(
                "Temperatura mínima do ar(ºC)" = "tmin",
                "Temperatura máxima do ar(ºC)" = "tmax",
                "Temperatura média (ºC)" = "tmed",
                "Umidade relativa do ar média (%)" = "urmed",
                "Velocidade média do vento (m/s)" = "vento",
                "Velocidade máxima do vento (m/s)" = "vtmax",
                "Radiação solar global (MJ/m2.dia)" = "rad",
                "precipitação (mm)" = "precip",
                "temperatura do solo (ºC)" = "tsolo"
              )
            ),
            selectInput(
              inputId = "grupodiasBoxPlot",
              label = "Selecione o grupo de dias:",
              choices = c(
                "10 Dias" = 10,
                "21 Dias" = 21,
                "Mensal" = "Mon"
              )
            )
          ),
          box(width = 8,
              withSpinner(
                plotOutput(
                  "graficosPerdidosPlot",
                  width = "100%",
                  height = "80vh"
                )
              )))
}

#==================================================================
# Pagina grafico Matriz
#==================================================================
create.pagina.grafico.matriz = function() {
  #criando janela
  tabItem(tabName = "mapaMatrizplot",
          box(
            width = 4,
            selectInput(
              inputId = "variavelSelect",
              label = "Selecione a variavel:",
              choices = c(
                "Temperatura mínima do ar(ºC)" = "tmin",
                "Temperatura máxima do ar(ºC)" = "tmax",
                "Temperatura média (ºC)" = "tmed",
                "Umidade relativa do ar média (%)" = "urmed",
                "Velocidade média do vento (m/s)" = "vento",
                "Velocidade máxima do vento (m/s)" = "vtmax",
                "Radiação solar global (MJ/m2.dia)" = "rad",
                "precipitação (mm)" = "precip",
                "temperatura do solo (ºC)" = "tsolo"
              )
            ),
            selectInput(
              inputId = "grupoDiasSelect",
              label = "Selecione o grupo de dias:",
              choices = c(
                "10 dias" = 10,
                "21 dias" = 21,
                "Mensal" = "mon"
              )
            )
          ),
          box(width = 8,
              withSpinner(
                plotOutput("Matrizplot", width = "100%", height = "85vh")
              )))
}

#==================================================================
# Pagina tabela
#==================================================================
create.pagina.tabela = function() {
  tabItem(tabName = "tabelaTab",
          tabBox(
            width = "100%",
            selected = 'Tabela',
            tabPanel(
              'Tabela',
              withSpinner(dataTableOutput('tabelaDados')),
              downloadButton("downloadDados", "Download")
            )
          ))
}

#==================================================================
# Pagina mapa
#==================================================================
create.pagina.mapa = function() {
  tabItem(tabName = "mapaTab",
          withSpinner(
            leafletOutput(
              outputId = "mapaEstacoes",
              width = "100%",
              height = "90vh"
            )
          ))
}


# Criar side bar
create.side.bar = function() {
  sidebarMenu(
    menuItem(
      text = "Mapa",
      tabName = "mapaTab",
      icon = icon("map"),
      selected = T
    ),
    menuItem(
      text = "Tabela",
      tabName = "tabelaTab",
      icon = icon("table")
    ),
    menuItem(
      text = "Gráficos",
      tabName = "analiseUI",
      icon = icon("line-chart"),
      menuSubItem(
        text = "Gráfico básico",
        tabName = "graficosPerdidosPlot",
        icon = icon("bar-chart")
      ),
      menuSubItem(
        text = "Mapa matriz",
        tabName = "mapaMatrizplot",
        icon = icon("bar-chart")
      ),
      menuSubItem(
        text = "Precipitação",
        tabName = "Precipitacaoplot",
        icon = icon("bar-chart")
      ),
      menuSubItem(
        text = "Anomalia Precipitação",
        tabName = "AnomaliaPrecipitacaoplot",
        icon = icon("bar-chart")
      ),
      menuSubItem(
        text = "Anomalia Temperatura Precipitação",
        tabName = "AnomaliaTemperaturaPlot",
        icon = icon("bar-chart")
      ),
      menuSubItem(
        text = "Precipitação cumulativa",
        tabName = "PrecipitacaoCumulativa",
        icon = icon("bar-chart")
      ),
      menuSubItem(
        text = "Dia seco e umido",
        tabName = "diaSecoUmido",
        icon = icon("bar-chart")
      ),
      menuSubItem(
        text = "Periodo Chuvoso",
        tabName = "periodoChuvosoPlot",
        icon = icon("bar-chart")
      )
    ),
    menuItem(
      text = "Selecione a estação",
      icon = icon("street-view"),
      selectInput(
        inputId = "estadoInput",
        label = "Selecione o estado:",
        choices = "SC"
      ),
      selectInput(
        inputId = "cidadeInput",
        label = "Selecione a cidade: ",
        choices = NULL
      ),
      dateRangeInput(
        inputId = "periodoInput",
        label = "Selecione o período:",
        start = '2000-02-11',
        end = '2021-02-15'
      )
    )
  )
}



# Pagina clima
climaUI = div(id = "clima-container",
              dashboardPage(
                #========================header=========================
                
                dashboardHeader(title =  "Clima",
                                tags$li(
                                  class = "dropdown",
                                  actionLink(
                                    inputId = "btnRetonarClima",
                                    label = "Voltar",
                                    icon = icon("sign-out"),
                                    style = "font-size: 1.5em;"
                                  )
                                )),
                
                #=======================================================
                
                
                #=======================SiderBar========================
                
                dashboardSidebar(width = 260,
                                 sidebarMenu(create.side.bar())),
                
                #========================================================
                
                
                #=======================body=============================
                
                dashboardBody(
                  tabItems(
                    create.pagina.mapa(),
                    create.pagina.tabela(),
                    create.pagina.grafico.basico(),
                    create.pagina.grafico.matriz(),
                    create.pagina.grafico.precipitacao(),
                    create.pagina.grafico.cumulativa(),
                    create.pagina.grafico.secoUmido(),
                    create.pagina.grafico.periodoChuvoso(),
                    create.pagina.grafico.Temperatura(),
                    create.pagina.grafico.anomaliaPrecipitacao()
                  )
                )
                
                #========================================================
              ))
