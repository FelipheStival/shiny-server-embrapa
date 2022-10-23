#==================================================================
# Pagina gerenciar
#==================================================================
gerenciarUI = navbarPage("Gerenciar",
  
  tabPanel("Upload banco",
           
           sidebarLayout(
             sidebarPanel(
               tags$h4("Escolha um arquivo"),
               tags$hr(),
               
               
               #===================Header arquivo=========================
               
               checkboxInput(inputId = "header",
                             label = "Cabecalho",
                             value = TRUE),
               
               #==========================================================
               
               
               #===================Separador arquivo======================
               
               radioButtons(inputId = "sep",
                            'Escolha um separador',
                            choices = c("," = ",",
                                        ";" = ";",
                                        "t" = "\t"),
                            selected = ","
               ),
               
               #==========================================================
               
               #============== Upload arquivo ============================
               fileInput(inputId = "arquivo",
                         label = 'Escolha um arquivo',
                         accept = c(
                           "text/csv",
                           "text/comma-separated-values,text/plain",
                           ".csv")),
               tags$hr(),
               #==========================================================
               actionButton('salvarDados', 'Salvar dados', icon = icon('upload'))
             ),
             
             mainPanel(
               dataTableOutput('tabelaUpload', width = '100%', height = '100%')
             )
      )
   )
)