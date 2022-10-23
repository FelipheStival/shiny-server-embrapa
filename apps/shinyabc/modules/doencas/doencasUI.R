# Pagina clima
doencasUI = div(id = "clima-container",
    dashboardPage(
    #========================header=========================
     dashboardHeader(title =  "Doenças",
                    tags$li(
                      class = "dropdown",
                      actionLink(
                        inputId = "btnRetonarDoencas",
                        label = "Voltar",
                        icon = icon("sign-out"),
                                      style = "font-size: 1.5em;"
                                    )
                        )
                    ),
                    
    dashboardSidebar(
      width = 260,
      sidebarMenu(
        menuItem(
          text = "Gráficos doenças",
          tabName = "graficosDoenca",
          icon = icon("line-chart"),
          selected = T
        ),
        menuItem(
          text = "Variaveis",
          icon = icon("hand-point-up"),
          selectizeInput(
            inputId = "safraInputDoencas2",
            label = "Selecione a safra:",
            choices = "12/13",
            options = list(maxItems = 1)
          )
        )
      )
    ),
    dashboardBody(
      tabItems(
        tabItem(
            tabName = "graficosDoenca",
            column(
              width = 3,
              box(
                width = 12,
                selectInput(
                  inputId = "select_doencas_local",
                  label = "selecione a cidade:",
                  choices = c('Arapoti'),
                  selected = 'Arapoti'
                ),
              )
            ),
            column(
              width = 9,
              tabBox(
                width = '100%',
                tabPanel('Grafico Geral', plotOutput('graficoDoencasPlot2', width = '100%', height = '80vh') %>% withSpinner(color = "#0dc5c1")),
                tabPanel('Grafico local', plotOutput('graficoDoencasPlot1', width = '100%', height = '80vh') %>% withSpinner(color = "#0dc5c1"))
              ) 
            )
        )
      )
    )
  )
)
