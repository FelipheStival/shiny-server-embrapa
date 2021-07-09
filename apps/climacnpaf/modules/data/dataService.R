#==================================================================
# Server data
#
# @input objeto do tipo reactive com os inputs do usuario
# @output objeto do tipo reactive com os outputs do usuario
# @session dados relacionados a sessao
# @data objeto do tipo data.frame com dados das estacoes
#==================================================================
dataServer = function(input,output,session,data){
  
  #atualizar periodo de data por estacao
  observe({
    
    #obtendo nome do municipio selecionado
    municipioSelecionado = input$cidadeInput
    
    #obtendo periodo de datas
    periodo = obterMinMax(municipioSelecionado,data)
    
    #atualizando input
    updateDateRangeInput(session = session,
                         inputId = "periodoData",
                         start = periodo[1],
                         end = periodo[2]
                         )
    
  })
  
}