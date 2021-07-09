#==================================================================
# Global Server
#
# @input objeto do tipo reactive com os inputs do usuario
# @output objeto do tipo reactive com os outputs do usuario
# @session dados relacionacdos a sessao
#==================================================================

server = shinyServer(function(input, output, session) {
  
  data = reactive({
    
    # configurando driver
    driver = JDBC("com.mysql.jdbc.Driver",
                  "driver//mysql-connector-java-5.1.48-bin.jar")
    
    # criando conexao
    conn = dbConnect(driver,
                     sprintf("jdbc:mysql://%s:%s/%s",DB_HOST,DB_PORT,DB_DATABASE),
                     DB_USERNAME,
                     DB_PASSWORD)
    
    statement = "SELECT id_estacao,DATA AS 'data',fonte,codigoOrigem,radiacao,radiacaoFlag,tempMaxima AS temp_max,tempMaximaFlag,tempMinima AS temp_min,tempMaximaFlag, precipitacao,precipitacaoFlag,radiacaoPotencial AS radiacao_pot,latitude,longitude, s.nome AS estado, m.nome AS municipio,m.altitude FROM estacao AS e  LEFT JOIN municipio AS m ON e.codigoMunicipio=m.codigoMunicipio  LEFT JOIN  estado AS s ON e.codigoEstado=s.codigoEstado  WHERE id_estacao = 'BRAZ001' OR  id_estacao = '.CNPAF.1'"
    result = dbGetQuery(conn,statement)
    
    # Disconectando banco
    dbDisconnect(conn)
    
    return(result)
    
  })
  
  
  #Mapa service
  mapaServer(input, output, session, data())
  
  #Localidade service
  localidadeServer(input, output, session, data())
  
  #Data server
  dataServer(input, output, session, data())
  
  #Tabela server
  tabelaServer(input, output, session, data())
  
  #Grafico server
  graficoServer(input, output, session, data())
  
})
