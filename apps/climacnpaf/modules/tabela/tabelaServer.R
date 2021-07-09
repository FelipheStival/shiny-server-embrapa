#==================================================================
# Tabela server
#
# @input objeto do tipo reactive com os inputs do usuario
# @output objeto do tipo reactive com os outputs do usuario
# @session dados relacionacdos a sessao
# @data objeto do tipo data.frame com dados das estacoes
#==================================================================
tabelaServer = function(input, output, session, data) {
  #dados filtrados tabela
  dadosEstacao = reactive({
    
    #obter dados da estacao por ID e periodo
    dadosEstacao = dadosTabelaFiltrados(input$cidadeInput,
                                        input$periodoData,
                                        data)
    return(dadosEstacao)
    
  })
  
  
  #tabela com dados da estacao
  output$tabelaEstacao = renderDataTable(dadosEstacao(), options = list(scrollX = T,
                                                                        scrollY = '450px'))
  #download dados estacao
  output$downloadTabela = downloadHandler(
    filename = function() {
      paste(input$cidadeInput, ".csv", sep = "")
    },
    content = function(file) {
      write.csv(dadosEstacao(), file, row.names = FALSE)
    }
  )
  
}