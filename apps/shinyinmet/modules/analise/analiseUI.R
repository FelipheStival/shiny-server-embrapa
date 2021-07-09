#==================================================================
# Analise tabela UI
#==================================================================
analiseUI = function() {
  tabItem(tabName = "tabelaAnalise",
          tabBox(
            width = "100%",
            selected = "Tabela sumario",
            tabPanel(
              "Tabela sumario",
              withSpinner(dataTableOutput("tabelaSumario",width = "100%",height = "80vh")),
              downloadButton("DownloadSumario", label = "Download")
            )
          )
  )
}

#==================================================================
# dados perdidos UI
#==================================================================
dadosperdidosUI = function() {
  tabItem(tabName = "dadosPerdidosUI",
          box(
            width = 12,
            withSpinner(plotOutput("dadosPerdidosPlot",width = "100%",height = "85vh"))
          )
  )
}

#==================================================================
# Tabela menu item
#==================================================================
itemMenuAnalise = function() {
  #criando janela
  menuItem(
    text = "Analise",
    tabName = "analiseUI",
    icon = icon("search"),
    menuSubItem(
      text = "Tabela",
      tabName = "tabelaAnalise",
      icon = icon("bar-chart")
    ),
    menuSubItem(
      text = "Dados perdidos",
      tabName = "dadosPerdidosUI",
      icon = icon("bar-chart")
    )
  )
}