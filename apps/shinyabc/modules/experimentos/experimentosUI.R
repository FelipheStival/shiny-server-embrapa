#==============================================
# Aba "analise gge"
#==============================================
tabItem.analiseGGE = function() {
  tabItem(
    tabName = "analise-gge",
    tabBox(
      width = "100%",
      height = "90vh",
      
      tabPanel(
        "Quem vence e aonde",
        plotOutput(
          "grafico_analiseGGE_QuemVenceEAonde",
          width = "100%",
          height = "85vh"
        ) %>% withSpinner(color = "#0dc5c1")
      ),
      
      tabPanel(
        "Ordem de ambiente",
        plotOutput(
          "grafico_analiseGGE_OrdemDeAmbiente",
          width = "100%",
          height = "85vh"
        ) %>% withSpinner(color = "#0dc5c1")
      ),
      
      tabPanel(
        "Ordem de genotipo",
        plotOutput(
          "grafico_analiseGGE_OrdemDeGenotipo",
          width = "100%",
          height = "85vh"
        ) %>% withSpinner(color = "#0dc5c1")
      ),
      
      tabPanel(
        "Relacao entre ambientes",
        plotOutput(
          "grafico_analiseGGE_RelacaoEntreAmbientes",
          width = "100%",
          height = "85vh"
        ) %>% withSpinner(color = "#0dc5c1")
      ),
      
      tabPanel(
        "Estabilidade / Media",
        plotOutput(
          "grafico_analiseGGE_EstabilidadeMedia",
          width = "100%",
          height = "85vh"
        ) %>% withSpinner(color = "#0dc5c1")
      ),
      
      tabPanel(
        "Dendrograma",
        plotOutput(
          "grafico_analiseGGE_Denograma",
          width = "100%",
          height = "85vh"
        ) %>% withSpinner(color = "#0dc5c1")
      )
    )
  )
}

#==============================================
# Aba "heatmap"
#==============================================
tabItem.graficoHeatMap = function() {
  tabItem(tabName = "analise-hetmap",
          box(
            width = 12,
            plotOutput(
              "grafico_analiseEstatistica_Heatmap",
              width = "100%",
              height = "85vh"
            ) %>% withSpinner(color = "#0dc5c1")
          ))
}

#==============================================
# Aba "Grafico linhas"
#==============================================
tabItem.graficoLinhas = function() {
  tabItem(tabName = "grafico-linhas",
          box(
            width = 2,
            selectInput(
              "GenotipoSelectDoencas",
              "Escolha os genotipos",
              selected = NULL,
              choices = NULL,
              multiple = T,
              selectize = T
            )
          ),
          box(
            width = 10,
            plotOutput("graficolinha", width = "100%", height = "80vh")  %>% withSpinner(color = "#0dc5c1")
          ))
}

#==============================================
# Aba "Analise estatistica"
#==============================================
tabItem.analiseEstatistica = function() {
  tabItem(
    tabName = "analise-estatistica",
    column(
      width = 3,
      box(
        width = 12,
        status = "warning",
        
        # Seletor "Experimento"
        selectInput(
          "select_analiseEstatistica_local",
          "selecione o local:",
          c("AL_TRA"),
          selected = "AL_TRA"
        ),
        
        # Filtro acima ou abaixo da media
        selectInput(
          "select_analiseEstatistica_media",
          "Filtro por média:",
          c("Acima da média" = "ACIMA",
            "Abaixo da média" = "ABAIXO",
            "Todos" = "TODOS"),
          selected = "ACIMA"
        ), 
      ),
      box(
        title = "Download relatorio",
        width = 12,
        status = "warning",
        radioButtons(
          "inputRelatorioFormato",
          "Formato relatorio:",
          c("HTML" = "HTML"),
          inline = T
        ),
        downloadButton('downloadRelatorio', label = "Relatório", class = NULL)
      )
    ),
    column(
      width = 9,
      tabName = "analise-gge",
      tabBox(
        width = "100%",
        height = "75vh",
        
        tabPanel(
          "Gráfico geral",
          tabsetPanel(
            tabPanel('Media geral',
                     plotOutput(
                       "grafico_analiseEstatistica_Resumo",
                       width = "100%",
                       height = "75vh"
                     ) %>% withSpinner(color = "#0dc5c1"),          
            ),
            tabPanel('Gráfico cluster',
                     plotOutput(
                       "grafico_geral_cluster",
                       width = "100%",
                       height = "75vh"
                     ) %>%  withSpinner(color = "#0dc5c1"), 
            )
          )
        ),
        tabPanel(
          "Gráfico media local",
          plotOutput(
            "grafico_analiseEstatistica_Unitario",
            width = "100%",
            height = "80vh"
          ) %>% withSpinner(color = "#0dc5c1")
        )
        
      )
    )
  )
}

#==============================================
# Aba "Dados Perdidos"
#==============================================
tabItem.dadosPerdidos = function() {
  tabItem(
    tabName = "dados-perdidos",
    plotOutput(
      "grafico_dadosPerdidos_Estatistica",
      width = "100%",
      height = "90vh"
    ) %>% withSpinner(color = "#0dc5c1")
  )
}


#==============================================
# Aba "Diagnostico"
#==============================================
tabItem.diagnostico = function() {
  tabItem(
    tabName = "diagnostico",
    box(
      width = 12 ,
      dataTableOutput("tabela_diagnostico_Exibir") %>% withSpinner(color = "#0dc5c1")
    ),
    downloadButton("botao_diagnostico_Download", 'Download (csv)')
  )
}

#==============================================
# Aba "Potencial genótipo produtivo"
#==============================================
tabItem.potencialGenotipo = function(){
  tabItem(
    tabName = "analise-genotipo-produtivo",
    column(
      width = 3,
      box(
        width = 12,
        status = "warning",
        selectInput(
          "select_analiseEstatistica_local_potencial_genotipo",
          "selecione o local:",
          c("AL_TRA"),
          selected = "AL_TRA"
        )
      )
    ),
    column(
      width = 9,
      box(
        width = 12,
        plotOutput('potencialGenotipoPlot', width = '100%', height = "80vh") %>% withSpinner(color = "#0dc5c1")
      )
    )
  )
}

#==============================================
# Aba "Diagnostico"
#==============================================
doencas.sidebar = function() {
  sidebarMenu(
    menuItem(
      "Gráficos",
      tabName = "dados-perdidos",
      icon = icon("line-chart"),
      menuSubItem(
        "Dados Perdidos",
        tabName = "dados-perdidos",
        icon = icon("line-chart"),
        selected = T
      ),
      menuSubItem(
        "Diagnostico",
        tabName = "diagnostico",
        icon = icon("line-chart")
      ),
      menuItem(
        "Analise Estatistica",
        tabName = "Container-analise-estatistica",
        icon = icon("line-chart"),
        menuSubItem("Analise", tabName = "analise-estatistica"),
        menuSubItem("Heatmap", tabName = "analise-hetmap"),
        menuSubItem("Grafico Linhas", tabName = "grafico-linhas")
      ),
      menuSubItem(
        "Analise GGE",
        tabName = "analise-gge",
        icon = icon("line-chart")
      ),
      menuSubItem(
        "Potencial genótipo produtivo",
        tabName = "analise-genotipo-produtivo",
        icon = icon("line-chart")
      )
    ),
    menuItem(
      text = "Variaveis",
      icon = icon("hand-point-up"),
      selectInput(
        inputId = "culturaInputDoencas",
        label = "Selecione a cultura:",
        choices = "Todos"
      ),
      selectizeInput(
        inputId = "safraInputDoencas",
        label = "Selecione a safra:",
        choices = "12/13",
        options = list(maxItems = 1)
      ),
      selectInput(
        inputId = "estadoInputDoencas",
        label = "Selecione o estado:",
        choices = "Todos",
        multiple = T,
        selectize = T
      ),
      selectInput(
        inputId = "cidadeInputDoencas",
        label = "Selecione a cidade:",
        choices = "Todos",
        multiple = T,
        selectize = T
      ),
      selectInput(
        inputId = "irrigacaoInputDoencas",
        label = "irrigacao:",
        choices = c("Sim" = "t",
                    "Nao" = "f"),
        selected = "Sim"
      ),
      selectInput(
        inputId = "fungicidaInputDoencas",
        label = "fungicida: ",
        choices = c("Sim" = "t",
                    "Nao" = "f"),
        selected = "Sim"
      ),
      selectInput(
        inputId = "tipodegraoInputDoencas",
        label = "Selecione o tipo de grao: ",
        choices = "Todos",
        multiple = T,
        selectize = T
      )
    )
  )
}


# Pagina doencas
experimentosUI = div(id = "clima-container",
                dashboardPage(
                  #========================header=========================
                  
                  dashboardHeader(title =  "Experimentos",
                                  tags$li(
                                    class = "dropdown",
                                    actionLink(
                                      inputId = "btnRetonarExperimentos",
                                      label = "Voltar",
                                      icon = icon("sign-out"),
                                      style = "font-size: 1.5em;"
                                    )
                                  )),
                  
                  #=======================================================
                  
                  #=======================SiderBar========================
                  
                  dashboardSidebar(width = 260,
                                   sidebarMenu(doencas.sidebar())),
                  #========================================================
                  
                  #=======================body=============================
                  dashboardBody(
                    tabItems(
                      tabItem.diagnostico(),
                      tabItem.dadosPerdidos(),
                      tabItem.analiseEstatistica(),
                      tabItem.graficoLinhas(),
                      tabItem.analiseGGE(),
                      tabItem.graficoHeatMap(),
                      tabItem.potencialGenotipo()
                    )
                  )
                  #========================================================
                ))
