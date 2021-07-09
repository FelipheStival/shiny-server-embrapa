#==================================================================
# Tabela UI
#==================================================================
graficoUI = function() {
  tabItem(tabName = "graficosTab",
          box(width = 12,
              plotOutput("graficoPlot",width = "100%",height = "87vh") %>%
                withSpinner()
              )
          )
}

#==================================================================
# Tabela menu item
#==================================================================
itemMenuGrafico = function() {
  menuItem(
    id = "tabGraficosID",
    text = "Graficos",
    tabName = "graficosTab",
    icon = icon("line-chart"),
    selectInput(
      inputId = "variavelInput",
      label = "Selecione a variavel",
      choices = c(
        "Precipitacao" = "precipitacao",
        "Temperatura maxima do ar" = "temp_max",
        "Temperatura minima do ar" = "temp_min",
        "Radiacao solar global" = "radiacao"
      ),
      selected = c("Precipitacao" = "precipitacao")
    ),
    selectInput(
      inputId = "graficoSelectInput",
      label = "Selecione o grafico",
      choices = c("Grafico basico", "Mapa matriz"),
      selected = "Santo Antonio de Goias"
    ),
    selectInput(
      inputId = "grupoDiasInput",
      label = "Selecione o grupo de dias",
      choices = c(
        "10 dias" = 10,
        "21 dias" = 21,
        "Mensal" = "mon"
      ),
      selected = c("10 dias" = 10)
    ),
    selectInput(
      inputId = "anomaliaAnoInput",
      label = "Selecione o ano",
      choices = "1980-1981"
    ),
    tags$div(
      id = "container-btn-grafico",
      tags$button(
        class = "btn btn-primary btn-sm",
        id = "btn-ver-grafico",
        menuItem(
          text = "Ver grafico",
          tabName = "graficosTab",
          icon = icon("eye")
        )
      )
    )
  )
}