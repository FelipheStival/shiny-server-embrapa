#================================================================
# Gerenciar Provider
#================================================================
inserirNovosDados = function(novosDados){
  
  # Selecionando colunas para inserir
  nomesColunas  = c(
    'id_ensaio',
    'safra',
    'irrigacao',
    'fungicida',
    'repeticao',
    'produtividade',
    'data_semeadura',
    'data_emergencia',
    'data_inicio_floracao',
    'data_inicio_ponto_colheita',
    'data_inicio_colheita',
    'epoca',
    'Local',
    'Genotipo',
    'id_cultura'
  )
  dadosInserir = novosDados[,nomesColunas]
  NumeroLinhas = nrow(dadosInserir)
  salvar = TRUE
  
  # Realizando verificacoes
  if(!is.character(novosDados$id_ensaio))
  {
    
    shinyalert(
      title = 'Tipo de dado invalido',
      text = 'A coluna id_ensaio deve ser texto',
      type = "error"
    )
    salvar = FALSE
  }
  
  if(!is.character(novosDados$irrigacao))
  {
    shinyalert(
      title = 'Tipo de dado invalido',
      text = 'A coluna irrigacao deve ser booleana',
      type = "error"
    )
    
    salvar = FALSE
  }
  
  if(!is.character(novosDados$safra))
  {
    shinyalert(
      title = 'Tipo de dado invalido',
      text = 'A coluna safra deve ser texto',
      type = "error"
    )
    salvar = FALSE
  }
  
  if(!is.character(novosDados$fungicida))
  {
    shinyalert(
      title = 'Tipo de dado invalido',
      text = 'A coluna fungicida deve ser booleana',
      type = "error"
    )
    
    salvar = FALSE
  }
  
  if(!is.numeric(novosDados$repeticao))
  {
    shinyalert(
      title = 'Tipo de dado invalido',
      text = 'A coluna repeticao deve ser numerica',
      type = "error"
    )
    
    salvar = FALSE
  }
  
  if(!is.numeric(novosDados$epoca))
  {
    shinyalert(
      title = 'Tipo de dado invalido',
      text = 'A coluna epoca deve ser numerica',
      type = "error"
    )
    
    salvar = FALSE
  }
  
  if(!is.character(novosDados$Local))
  {
    
    shinyalert(
      title = 'Tipo de dado invalido',
      text = 'A coluna id_local deve ser texto',
      type = "error"
    )
    salvar = FALSE
  }
  
  if(!is.character(novosDados$Genotipo))
  {
    
    shinyalert(
      title = 'Tipo de dado invalido',
      text = 'A coluna id_genotipo deve ser texto',
      type = "error"
    )
    salvar = FALSE
  }
  
  if(!is.character(novosDados$id_cultura))
  {
    
    shinyalert(
      title = 'Tipo de dado invalido',
      text = 'A coluna id_cultura deve ser texto',
      type = "error"
    )
    salvar = FALSE
  }
  
  if(isTRUE(salvar)){
    
    # Verificacoes 
    conexao = banco.provider.openConnection('ensaios')  
    
    # Lendo linha e transformando em Query
    for(i in 1:NumeroLinhas){
      linha = dadosInserir[i,]
      
      # Verificando se existe dado
      if(linha$id_ensaio != ''){
        
        # Obtendo nome do local
        IDlocal = procurarIdLocal(conexao,linha$Local)
        
        # Obtendo ID do genotipo
        IDGenotipo = procurarIdGenotipo(conexao, linha$Genotipo)
        
        # Obtendo ID da cultura
        IDCultura = procurarIdCultura(conexao, linha$id_cultura)
        
        # Criando dataFrame para inserir
        dataFrameInserir = data.frame(
          id_ensaio = linha$id_ensaio,
          safra =  linha$safra,
          irrigacao = linha$irrigacao,
          fungicida = linha$fungicida,
          repeticao  = linha$repeticao,
          produtividade = linha$produtividade,
          data_semeadura = linha$data_semeadura,
          data_emergencia = linha$data_emergencia,
          data_inicio_floracao = linha$data_inicio_floracao,
          data_inicio_ponto_colheita = linha$data_inicio_ponto_colheita,
          data_inicio_colheita  = linha$data_inicio_colheita,
          epoca = linha$epoca,
          id_local = IDlocal,
          id_genotipo = IDGenotipo,
          id_cultura = IDCultura
        )
        
        # Transformando em query e inserindo dados
        query = sqlAppendTable(conexao, 'ensaios', dataFrameInserir)
        dbSendUpdate(conexao, query) 
      }
    }
    dbDisconnect(conexao)
    return(TRUE)
  }
  
  return(FALSE)

}

#=============================================
# Metodo para obter o ID do local pelo nome
#=============================================
procurarIdLocal = function(conexao, nomeLocal){
  sql = "SELECT * FROM locais WHERE nome = '%s'"
  sql = sprintf(sql, nomeLocal)
  result = dbGetQuery(conexao, sql)
  if(nrow(result)){
    return(result$id)
  }
}

#=============================================
# Metodo para obter o ID do Genotipo
#=============================================
procurarIdGenotipo = function(conexao,nomeGenotipo){
  sql = "SELECT * FROM genotipos WHERE nome = '%s'"
  sql = sprintf(sql, nomeGenotipo)
  result = dbGetQuery(conexao, sql)
  if(nrow(result)){
    return(result$id)
  }
}

#=============================================
# Metodo para obter o ID da cultura
#=============================================
procurarIdCultura = function(conexao, nomeCultura){
  sql = "SELECT * FROM cultura WHERE nome = '%s'"
  sql = sprintf(sql, nomeCultura)
  result = dbGetQuery(conexao, sql)
  if(nrow(result)){
    return(result$id)
  }
}