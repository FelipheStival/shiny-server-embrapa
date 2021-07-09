#==============================================#
# Cria o menu de graficos
menuItem.graficos.create = function() {
     menuItem("Graficos", icon = icon("map-marker"),
              menuSubItem("Grafico basico", tabName = "grafico-basico", icon = icon("line-chart")),
              menuSubItem("Mapa matriz", tabName = "heatmap", icon = icon("line-chart")),
              menuSubItem("Precipitacao", tabName = "prec-geral", icon = icon("line-chart")),
              menuSubItem("Precipitacao cumulativa", tabName = "prec-acumulativa", icon = icon("line-chart")),
              menuSubItem("Dia seco e umido", tabName = "wet-dry", icon = icon("line-chart")),
              menuSubItem("Periodo chuvoso", tabName = "chuvas", icon = icon("line-chart"))
     )
}
#==============================================#

#==============================================#
# Cria o menu de graficos
menuItem.input.create = function() {
     menuItem("Variaveis", icon = icon("map-marker"),
              selectInput("estadoSelect", "Selecione o estado:", "Todos", selected = "Todos"), 
              selectInput("municipioSelect", "Selecione o municipio:", "Goias", selected = "Goias"),
              dateRangeInput("intervalo", "Selecione o periodo:", min = "1980-01-01", start = "1980-01-01")
     )
}
#==============================================#

#==============================================#
# Cria o menu de barra laterial
sidebarMenu.create = function() {
     sidebarMenu( id = "sidebar",
          menuItem("Mapa", tabName = "mapa", icon = icon("map-marker")),
          menuItem("Tabela", tabName = "tabela", icon = icon("table")),
          
          menuItem.graficos.create(),
          menuItem.input.create()
     )
}

#==============================================#
# Cria a barra lateral do dashboard
dashboardSidebar.create = function() {
     dashboardSidebar(
          sidebarMenu.create()
     )
}
#==============================================#
