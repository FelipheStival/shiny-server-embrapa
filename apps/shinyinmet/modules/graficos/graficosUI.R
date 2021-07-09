#==================================================================
# Mapa Matriz UI
#==================================================================
createMapaMatrizUI = function() {
  #criando janela
  tabItem(tabName = "mapaMatrizplot",
          box(
            width = 4,
            selectInput(
              inputId = "variavelSelect",
              label = "Selecione a variavel:",
              choices = c(
                "Precipitação Pluvial(mm)" = "rain",
                "Temperatura máxima do ar(*C)" = "maximum_temperature",
                "Temperatura mínima do ar(*C)" = "minimum_temperature",
                "Radiação solar global(MJ/m2)" = "global_radiation",
                "Umidade Relativa mínima do ar(%)" = "minimum_relative_air_humidity",
                "Umidade Relativa máxima do ar(%)" = "maximum_relative_air_humidity",
                "Velocidade do vento(%)" = "wind_speed"
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
          box(
            width = 8,
            withSpinner(plotOutput("Matrizplot", width = "100%", height = "85vh"))
             )
          )
}

#==================================================================
# Precipitacao UI
#==================================================================
createPrecipitacaoUI = function() {
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
              withSpinner(plotOutput("plotPrecipitacao", width = "100%", height = "85vh"))
              )
          )
}

#==================================================================
# Precipitacao acumulada UI
#==================================================================
createPrecipitacaoCumulativaUI = function() {
  #criando janela
  tabItem(tabName = "PrecipitacaoCumulativa",
          box(width = 12,
              withSpinner(plotOutput("PrecipitacaoCumulativaPlot",width = '100%',height = "85vh"))))
}

#==================================================================
#  Anomalia Precipitacao IU
#==================================================================
createPrecipitacaoAnomaliaUI = function() {
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
# Periodo chuvoso UI
#==================================================================
createPeriodoChuvosoUI = function() {
  #criando janela
  tabItem(tabName = "periodoChuvosoPlot",
          box(width = 12,
              height = "85vh",
              withSpinner(plotOutput(
                "periodoChuvosoPlot",
                width = "100%",
                height = "85vh"
              ))))
}


#==================================================================
# Anomalia temperatura UI
#==================================================================
createAnomaliaTemperaturaUI = function() {
  #criando janela
  tabItem(tabName = "AnomaliaTemperaturaPlot",
          box(
            width = 12,
            withSpinner(plotOutput("AnomaliaTemperaturaPlot", width = "100%",height = "85vh"))
          ))
}


#==================================================================
# grafico dia seco e umido
#==================================================================
createDiaSecoUmidoUI = function() {
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
              withSpinner(plotOutput("secoUmidoPlot", width = "100%",height = "85vh"))
              )
          )
}


#==================================================================
# grafico Boxplot chuvoso UI
#==================================================================
createGraficoBasicoUI = function() {
  #criando janela
  tabItem(tabName = "graficosPerdidosPlot",
          box(
            width = 4,
            selectInput(
              inputId = "boxplotVariavel",
              label = "Selecione a variavel:",
              choices = c(
                "Temperatura mínima do ar(*C)" = "minimum_temperature",
                "Temperatura máxima do ar(*C)" = "maximum_temperature",
                "Umidade Relativa mínima do ar(%)" = "minimum_relative_air_humidity",
                "Umidade Relativa máxima do ar(%)" = "maximum_relative_air_humidity",
                "Velocidade do Vento(%)" = "wind_speed",
                "Radiação solar global(MJ/m2)" = "global_radiation",
                "Precipitação Pluvial(mm)" = "rain"
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
# Graficos menu item
#==================================================================
itemMenuGraficos = function() {
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
  )
  
}