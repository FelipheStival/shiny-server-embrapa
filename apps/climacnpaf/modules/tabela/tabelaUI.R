#==================================================================
# Tabela UI
#==================================================================
tabelaUI = function(){
  
  tabItem(tabName = "tableTab",
          box(width = 12,
              dataTableOutput(outputId = "tabelaEstacao"),
              downloadButton(outputId = "downloadTabela",
                             label = "Download tabela")
              ),
          )
}

#==================================================================
# Tabela menu item
#==================================================================
itemMenuTabela = function(){
  
  menuItem(text = "Tabela",
           tabName = "tableTab",
           icon = icon("table"))
  
}