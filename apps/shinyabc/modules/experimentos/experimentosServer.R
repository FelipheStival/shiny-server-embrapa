# Doenca service
experimentoServer = function(input, output, session) {
  
  # Botao retornar
  observeEvent(input$btnRetonarClima,
               change_page('/')
  )
  
  # dados doenca input service
  dadosEnsaios = reactive({
    dados = experimentos.provider.dados()
    return(dados)
  })
  
  # Dados filtrados
  dadosFiltrados = reactive({
    dados = experimentos.provider.dadosFiltrados(dadosEnsaios(), input)
    return(dados)
  })
  
  # dados analise estatistica
  dadosEstatistica = reactive({
    y = service.getY(dadosFiltrados())
    return(y)
  })
  
  # dados analise estatistica media
  dadosEstatisticaMedia = reactive({
    y = service.getMean(dadosFiltrados(), input)
    return(y)
  })
  
  # dados para gear o relatorio
  dadosRelatorio = reactive({
    y = service.getY(dadosFiltrados())
    y = model.dadosRelatorio(y)
    return(y)
  })
  
  # Dados experimentos
  dadosExperimentos = reactive({
    mediaSelect = input$select_analiseEstatistica_media
    y = calcula_predict(dadosFiltrados(), "produtividade", "repeticao", "local","genotipo", "safra", mediaSelect)
    return(y$pred)
  })
  
  # Atualizando input cultura
  observe({
    culturas = experimentos.provider.unique(dadosEnsaios(), 'cultura')
    updateSelectInput(
      session = session,
      inputId = "culturaInputDoencas",
      choices = culturas,
      selected = culturas[1]
    )
  })
  
  # Atualizando input safras
  observe({
    safras = sort(experimentos.provider.unique(dadosEnsaios(), 'safra'))
    updateSelectInput(
      session = session,
      inputId = "safraInputDoencas",
      choices = safras,
      selected = "12/13"
    ) 
  })
  
  # Atualizando input estado
  observe({
    estados = experimentos.provider.unique(dadosEnsaios(), 'estado')
    updateSelectInput(
      session = session,
      inputId = "estadoInputDoencas",
      choices = c("Todos", estados),
      selected = "Todos"
    ) 
  })
  
  # Atualizando input cidades
  observe({
    cidades = experimentos.provider.unique(dadosEnsaios(), 'cidade')
    updateSelectInput(
      session = session,
      inputId = "cidadeInputDoencas",
      choices = c("Todos", cidades),
      selected = "Todos"
    ) 
  })
  
  # Atualizando input tipo de grao
  observe({
    tipoGraos = experimentos.provider.unique(dadosEnsaios(), 'tipo_de_grao')
    updateSelectInput(
      session = session,
      inputId = "tipodegraoInputDoencas",
      choices = c("Todos", tipoGraos),
      selected = "Todos"
    ) 
  })
  
  # Atualizando input epoca
  observe({
    epocas =  experimentos.provider.unique(dadosEnsaios(), 'epoca')
    updateSelectInput(
      session = session,
      inputId = "epocaInputDoencas",
      choices = c("Todos", epocas),
      selected = "Todos"
    ) 
  })
  
  # Atualizando input local analise estatistica
  observe({
    locais = experimentos.provider.unique(dadosFiltrados(), 'local')
    updateSelectInput(
      session = session,
      inputId = "select_analiseEstatistica_local",
      choices = locais
    )
  })
  
  # Atualizando lista genotipos grafico linhas
  observe({
    genotipos = experimentos.provider.unique(dadosFiltrados(), 'genotipo')
    updateSelectInput(
      session = session,
      inputId = "GenotipoSelectDoencas",
      choices = genotipos,
      selected = genotipos[1]
    )
  })
  
  output$tabela_diagnostico_Exibir = renderDataTable({
    
    diagnostico = service.getDiagostico(dadosFiltrados(), input)
    
    validate(
      need(!is.null(diagnostico), "Nao ha dados suficientes para exibicao da tabela.")
    )
    
    return(diagnostico)
    
  },options = list(lengthMenu = c(5,10, 25), pageLength = 5))
  #==============================================#
  
  #==============================================#
  output$botao_diagnostico_Download = downloadHandler(
    
    filename = function() {
      paste('diagnostico_', Sys.Date(), '.csv', sep='')
    },
    content = function(con) {
      
      diagnostico = service.getDiagostico(dadosFiltrados())
      write.csv(diagnostico, con)
      
    }
  )
  
  output$grafico_dadosPerdidos_Estatistica = renderPlot({
    
    #====================================#
    # Validacao
    
    validate.ids_data = length(unique((dadosFiltrados()$id_ensaio)))
    
    validate(
      need(validate.ids_data > 0,
           "Nao ha dados suficientes para exibicao do grafico.")
    )
    
    #====================================#
    
    graphics.dadosPerdidos_Estatistica(dadosFiltrados())
    
  })
  
  
  #==============================================#
  # Grafico "Resumo"
  output$grafico_analiseEstatistica_Resumo = renderPlot({
    
    #====================================#
    # Validacao
    validate(
      need(!is.null(dadosFiltrados()), "Nao ha dados suficientes para exibicao do grafico."),
      need(length(unique(dadosFiltrados()$rep)) > 1, "Nao ha repetições suficientes para exibicao do grafico.")
    )
    
    #====================================#
    mediaSelect = input$select_analiseEstatistica_media
    grafico.analiseEstatistica_Resumo(dadosExperimentos(), mediaSelect)
    
  })
  #==============================================#
  
  #==============================================#
  # Grafico "Unitario"
  output$grafico_analiseEstatistica_Unitario = renderPlot({
    #====================================#
    # Validacao
    
    validate(
      need(!is.null(dadosEstatistica()),
           "Nao ha dados suficientes para exibicao do grafico."),
      need(length(unique(dadosFiltrados()$rep)) > 1, "Nao ha repetições suficientes para exibicao do grafico.")
    )
    
    #====================================#
    dataPlot = calcula_predict(dadosFiltrados(), "produtividade", "repeticao", "local","genotipo", "safra")
    grafico.analiseEstatistica_Unitario(dataPlot$pred, input$select_analiseEstatistica_local)
    
  })
  #==============================================#
  
  #==============================================#
  # Grafico "Heatmap"
  output$grafico_analiseEstatistica_Heatmap = renderPlot({
    
    #====================================#
    # Validacao
    validate.ids_data = length(unique((dadosFiltrados()$id_ensaio)))
    
    validate(
      need(validate.ids_data > 1, "Nao ha dados suficientes para exibicao do grafico."),
      need(length(unique(dadosFiltrados()$rep)) > 1, "Nao ha repetições suficientes para exibicao do grafico.")
    )
    #====================================#
    
    dataPlot = calcula_predict(dadosFiltrados(), "produtividade", "repeticao", "local","genotipo", "safra")
    grafico.analiseEstatistica_Heatmap(dataPlot$pred)
    
  })
  #==============================================#
  
  #==============================================#
  # Grafico "Analise cluster"
  output$grafico_geral_cluster = renderPlot({
    
    #====================================#
    # Validacao
    validate.ids_data = length(unique((dadosFiltrados()$id_ensaio)))
    
    validate(
      need(validate.ids_data > 1, "Nao ha dados suficientes para exibicao do grafico."),
      need(length(unique(dadosFiltrados()$rep)) > 1, "Nao ha repetições suficientes para exibicao do grafico.")
    )
    #====================================#
    mediaSelect = input$select_analiseEstatistica_media
    grafico.analiseCluster(dadosExperimentos(), mediaSelect)
    
  })
  
  
  #==============================================#
  # Grafico "linhas"
  output$graficolinha = renderPlot({
    
    #====================================#
    # Validacao
    validate.ids_data = length(unique((dadosFiltrados()$id_ensaio)))
    
    validate(
      need(validate.ids_data > 1,
           "Nao ha dados suficientes para exibicao do grafico.")
    )
    
    grafico.GraficoLinhas(dadosEstatisticaMedia())
    
  })
  
  #==============================================#
  # Grafico "Quem vence e aonde"
  output$grafico_analiseGGE_QuemVenceEAonde = renderPlot({
    
    gge = model.GGE(dadosFiltrados()) 
    
    #====================================#
    # Validacao
    validate.ids_data = length(unique((dadosFiltrados()$id_ensaio)))
    
    validate(
      need(validate.ids_data > 1 & !is.null(gge),
           "Nao ha dados suficientes para exibicao do grafico.")
    )
    #====================================#
    grafico.analiseGGE_QuemVenceEAonde(gge)
  })
  #==============================================#
  
  #==============================================#
  # Grafico "Ordem de Ambiente"
  output$grafico_analiseGGE_OrdemDeAmbiente = renderPlot({
    
    gge = model.GGE(dadosFiltrados())
    
    #====================================#
    # Validacao
    
    validate.ids_data = length(unique((dadosFiltrados()$id_ensaio)))
    
    validate(
      need(validate.ids_data > 1 & !is.null(gge),
           "Nao ha dados suficientes para exibicao do grafico.")
    )
    #====================================#
    
    
    grafico.analiseGGE_OrdemDeAmbiente(gge)
  })
  #==============================================#
  
  #==============================================#
  # Grafico "Ordem de genotipo"
  output$grafico_analiseGGE_OrdemDeGenotipo = renderPlot({
    
    gge = model.GGE(dadosFiltrados())
    
    #====================================#
    # Validacao
    
    validate.ids_data = length(unique((dadosFiltrados()$id_ensaio)))
    
    validate(
      need(validate.ids_data > 1 & !is.null(gge),
           "Nao ha dados suficientes para exibicao do grafico.")
    )
    #====================================#
    
    grafico.analiseGGE_OrdemDeGenotipo(gge)
  })
  #==============================================#
  
  #==============================================#
  # Grafico "Relacao entre ambientes"
  output$grafico_analiseGGE_RelacaoEntreAmbientes = renderPlot({
    
    gge = model.GGE(dadosFiltrados())
    
    #====================================#
    # Validacao
    
    validate.ids_data = length(unique((dadosFiltrados()$id_ensaio)))
    
    validate(
      need(validate.ids_data > 1 & !is.null(gge),
           "Nao ha dados suficientes para exibicao do grafico.")
    )
    #====================================#
    
    grafico.analiseGGE_RelacaoEntreAmbientes(gge)
  })
  #==============================================#
  
  #==============================================#
  # Grafico "Estabilidade / Media"
  output$grafico_analiseGGE_EstabilidadeMedia = renderPlot({
    
    gge = model.GGE(dadosFiltrados())
    
    #====================================#
    # Validacao
    
    validate.ids_data = length(unique((dadosFiltrados()$id_ensaio)))
    
    validate(
      need(validate.ids_data > 1 & !is.null(gge),
           "Nao ha dados suficientes para exibicao do grafico.")
    )
    #====================================#
    
    grafico.analiseGGE_EstabilidadeMedia(gge)
  })
  #==============================================#
  
  #==============================================#
  # Grafico "Denograma"
  output$grafico_analiseGGE_Denograma = renderPlot({
    
    deno = model.deno(dadosFiltrados())
    
    #====================================#
    # Validacao
    validate.ids_data = length(unique((dadosFiltrados()$id_ensaio)))
    
    validate(
      need(validate.ids_data > 1 & !is.null(deno),
           "Nao ha dados suficientes para exibicao do grafico.")
    )
    #====================================#
    
    grafico.analiseGGE_Denograma(deno)
  })
  #==============================================#
  
  #==============================================#
  # Download relatorio"
  output$downloadRelatorio = downloadHandler(
    
    filename = function() {
      paste("my-report", sep = ".", switch(
        input$inputRelatorioFormato, PDF = "pdf", HTML = "html", Word = "docx"
      ))
    },
    
    content = function(file) {
      src <- normalizePath("report.Rmd")
      owd <- setwd(tempdir())
      on.exit(setwd(owd))
      file.copy(src, "report.Rmd", overwrite = TRUE)
      
      out <- render("report.Rmd", switch(
        input$inputRelatorioFormato,
        PDF = pdf_document(), HTML = html_document(), Word = word_document()
      ))
      
      file.rename(out, file)
    }
  )
  
}