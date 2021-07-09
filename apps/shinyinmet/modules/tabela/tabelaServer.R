#==================================================================
# Tabela Server
#
# @input objeto do tipo reactive com os inputs do usuario
# @output objeto do tipo reactive com os outputs do usuario
# @session dados relacionacdos a sessao
# @conexao conexao com banco de dados
#==================================================================
tabelaServer = function(input, output, session) {
  
  # Obter dados diarios
  dadosDiarios = reactive({
    dados = tabela.provider.dados(input$cidadeInput,
                                  input$periodoInput[1],
                                  input$periodoInput[2])
    return(dados)
  })
  
  # Obter dados horarios
  dadosHorarios = reactive({
    dados = tabela.provider.dados.horarios(input$cidadeInput,
                                           input$periodoInput[1],
                                           input$periodoInput[2])
    return(dados)
  })
  
  # Dados diarios
  output$dadosDiariosTable = renderDataTable({
    dadosDiarios()
  }, class = "cell-border",
  options = list(
    lengthMenu = c(5, 10, 15, 20),
    pageLength = 10,
    scrollX = TRUE
  ))
  
  # Dados horarios
  output$dadosHorariosTable = renderDataTable({
    dadosHorarios()
  }, class = "cell-border",
  options = list(
    lengthMenu = c(5, 10, 15, 20),
    pageLength = 10,
    scrollX = TRUE
  ))
  
  #Download dados diarios
  output$downloadDiarios = downloadHandler(
    filename = function() {
      paste(
        'dados-diarios',
        "-",
        input$periodoInput[1],
        "-",
        input$periodoInput[2],
        '.csv',
        sep = ''
      )
    },
    content = function(con) {
      write.csv(dadosDiarios(), con)
    }
  )
  
  #Download dados horarios
  output$downloadHorarios = downloadHandler(
    filename = function() {
      paste(
        'dados-horarios',
        "-",
        input$periodoInput[1],
        "-",
        input$periodoInput[2],
        '.csv',
        sep = ''
      )
    },
    content = function(con) {
      write.csv(dadosHorarios(), con)
    }
  )
}