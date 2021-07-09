#==================================================================
# Login Server
#
# @input objeto do tipo reactive com os inputs do usuario
# @output objeto do tipo reactive com os outputs do usuario
# @session dados relacionacdos a sessao
# @data objeto do tipo data.frame com dados das estacoes
#==================================================================
loginServer = function(input,output,session){
  
  # Credenciais
  credentials <- data.frame(
    user = c("embrapa","admin"), # mandatory
    password = c("embrapa","cJXPMHg"), # mandatory
    admin = c(FALSE,TRUE),
    stringsAsFactors = FALSE
  )
  
  # check_credentials directly on sqlite db
  res_auth <- secure_server(
    check_credentials = check_credentials(
      "modules//login//db//login.sqlite"
    )
  )
  
  
}