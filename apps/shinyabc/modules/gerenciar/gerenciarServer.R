# Gerenciar server
gerenciarServer = function(input, output, session) {
  
  # Lendo tabela
  dadosTabela = reactive({
    
    dados = NULL
    
    if(!is.null(input$arquivo)){
      dados = read.table(input$arquivo$datapath,
                         header = input$header,
                         sep = input$sep,
                         stringsAsFactors = F)
    }
    
    return(dados)
    
  })
  
  # Tabela upload
  output$tabelaUpload = renderDataTable({
    datatable(dadosTabela(),options = list(scrollY = '700px'))
  })
  
  # Evento clicar botao
  observeEvent(input$salvarDados, {
    if(!is.null(dadosTabela())){
      
        if(inserirNovosDados(dadosTabela())){
            shinyalert(
              title = 'Upload realizado com sucesso',
              text = 'O banco de dados foi atualizado com sucesso',
              type = "success"
            )
        }
        
      
    } else {
      
      # alerta arquivo vazio
      shinyalert(
        title = 'Arquivo não encontrado',
        text = 'O arquivo não foi encontrado ou é inválido',
        type = "error"
      )
      
    }
    
  })
}