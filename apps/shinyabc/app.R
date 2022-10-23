
#==============================================#
# Carregando pacotes a serem utilizados
app.LoadPackages = function()
{
    #=============================================#
    # Iniciando bibliotecas web
    require(shiny) 
    require(shinydashboard)
    require(shinymanager)
    require(shiny.router)
    require(leaflet)
    require(shinycssloaders)
    require(RJDBC)
    require(seas)
    require(ggplot2)
    require(reshape2)
    require(dplyr)
    require(lubridate)
    require(stringr)
    require(ggrepel)
    require(ggthemes)
    require(scatterD3)
    require(lme4)
    require(shinyWidgets)
    require(forcats)
    require(emmeans)
    require(gge)
    require(GGEBiplots)
    require(ape)
    require(rmarkdown)
    require(knitr)
    require(tinytex)
    require(DT)
    require(shinythemes)
    require(shinyalert)
    require(tidyverse)
    require(RVAideMemoire)
    require(caret)
    require(lmerTest)
    require(broom.mixed)
    require(plyr)
    require(cluster)
    require(fdm2id)
    require(cowplot)
  
    #==============================================#
}

#==============================================#
# Carregando labels pagina login
app.loadLabels = function(){
    
    # Configurando labels
    set_labels(
        language = "en",
        "Please authenticate" = "Autentica\u00e7\u00e3o",
        "Username:" = "Usu\u00e1rio :",
        "Password:" = "Senha :",
        "Login" = "Conectar",
        "Username or password are incorrect" = "Usu\u00e1rio ou senha incembrorreto",
        "Your account has expired" = "Sua conta expirou",
        "Please change your password" = "Por favor, mude sua senha",
        "New password:" = "Nova senha :",
        "Confirm password:" = "Confirmar nova senha:",
        "Update new password" = "Atualizar nova senha",
        "Password successfully updated! Please re-login" = "Senha alterada com sucesso! Por favor, autentique-se novamente",
        "The two passwords are different" = "As duas senhas s\u00e3o diferentes",
        "Failed to update password" = "Falha em atualizar a senha",
        "Logout" = "Desconectar",
        "Go to application" = "Ir \u00e0 aplica\u00e7\u00e3o",
        "Administrator mode" = "Modo administrador",
        "Add a user" = "Adicionar usu\u00e1rio",
        "Too many users" = "Muitos usu\u00e1rios",
        "Maximum number of users : %s" = "N\u00f9mero m\u00e1ximo : %s",
        "Failed to update user" = "Falha em atualizar usu\u00e1rio",
        "User successfully updated" = "Usu\u00e1rio atualizado com sucesso",
        "Cancel" = "Cancelas",
        "Confirm new user" = "Confirmar novo usu\u00e1rio",
        "Confirm change" = "Confirmar mudan\u00e7a",
        "Are you sure to remove user(s): %s from the database ?" = "Tem certeza que deseja remover o(s) usu\u00e1rio(s) %s do banco de dados?",
        "Delete user(s)" = "Deletar usu\u00e1rio(s)",
        "Delete user" = "Deletar usu\u00e1rio",
        "Edit user" = "Modificar usu\u00e1rio",
        "User already exist!" = "O usu\u00e1rio j\u00e1 existe!",
        "Dismiss" = "Fechar",
        "New user %s succesfully created!" = "Novo usu\u00e1rio %s criado com sucesso!",
        "Ask to change password" = "Pedir para alterar a senha",
        "Confirm" = "Confirmar",
        "Ask %s to change password on next connection?" = "Pedir a %s para alterar a senha na pr\u00f3xima conex\u00e3o?",
        "Change saved!" = "Mudan\u00e7as salvas!",
        "Failed to update the database" = "Erro em atualizar o banco de dados",
        "Password does not respect safety requirements" = "Senha n\u00e3o conforme com as exig\u00eancias de seguran\u00e7a",
        "Password must contain at least one number, one lowercase, one uppercase and must be at least length 6." = "A senha deve conter pelo menos um n\u00famero, uma letra min\u00fascula, uma letra mai\u00fascula e deve ter pelo menos 6 caracteres",
        "Number of connections per user" = "N\u00famero de conex\u00f5es por usu\u00e1rio",
        "Number of connections per day" = "N\u00famero de conex\u00f5es por dia",
        "Total number of connection" = "N\u00famero total de conex\u00f5es",
        "You can\'t remove yourself!" = "Voc\u00ea n\u00e3o pode se remover!",
        "User:" = "Usu\u00e1rio :",
        "Period:" = "Per\u00edodo :",
        "Last week" = "Semana passada",
        "Last month" = "M\u00eas passado",
        "All period" = "Todo per\u00edodo",
        "Home" = "In\u00edcio",
        "Select all shown users" = "Selecionar todos os usu\u00e1rios mostrados",
        "Remove selected users" = "Remover usu\u00e1rios selecionados",
        "Force selected users to change password" = "For\u00e7ar usu\u00e1rio selecionado a mudar a senha",
        "Users" = "Usu\u00e1rios",
        "Passwords" = "Senhas",
        "Download logs database" = "Fazer download dos logs do banco de dados",
        "Download SQL database" = "Fazer download do banco de dados SQL",
        "Reset password for %s?" = "Resetar a senha de %s?",
        "Reset password" = "Resetar a senha",
        "Temporary password:" = "Senha tempor\u00e1ria",
        "Password succesfully reset!" = "Senha resetada com sucesso!",
        "You are not authorized for this application" = "Voc\u00ea n\u00e3o est\u00e1 autorizado a utilizar esse aplicativo",
        "Language"  = "L\u00edngua"
    )
    
}
#==============================================#

#==============================================#
# Carregando arquivos compilados
app.LoadModules = function() {
  
    # Carregando modulos secundarios
    modulos = list.files(path = 'modules',
                         pattern = ".R$",
                         recursive = T,
                         full.names = T
                         )
    log = sapply(modulos,source,encoding="utf-8")
    
    # Carregando modulos principal
    modulos = list.files(path = 'cor',
                         pattern = ".R$",
                         recursive = T,
                         full.names = T
    )
    log = sapply(modulos,source,encoding="utf-8")
}
#==============================================#


app.LoadPackages()
app.loadLabels()
app.LoadModules()

shinyApp(ui, server)
