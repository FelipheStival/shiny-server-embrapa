#=========================================================================
# Script para fazer a instalacao dos pacotes necessarios
#
# modo de usar: Os pacote necessarios devem ser adicionados a variavel
# pacotes,a primeira posicao do vetor e o nome do pacote e a segunda e
# a versao.
#=========================================================================


#=========================================================================
# Depedencias script
#=========================================================================
if (!require(devtools)) {
  install.packages("devtools")
}
require(devtools)

#=========================================================================
# Lista de pacotes a serem instalados
#=========================================================================
pacotes = list(
  c("dplyr", "1.0.7"),
  c("shiny", "1.6.0"),
  c("shinydashboard", "0.7.1"),
  c("leaflet", "2.0.4.1"),
  c("shinycssloaders", "1.0.0"),
  c("seas", "0.5-2"),
  c("reshape2", "1.4.4"),
  c("DT", "0.18"),
  c("stringr", "1.4.0"),
  c("ggthemes", "4.2.4"),
  c("ggrepel", "0.9.1"),
  c("RJDBC", "0.2-8"),
  c("ggplot2", "3.3.5"),
  c("lubridate", "1.7.10"),
  c("ggrepel", "0.9.1"),
  c("shinyjs", "2.0.0"),
  c("data.table", "1.14.0"),
  c("shinymanager", "1.0.400")
)

# instalando pacotes
sapply(pacotes, function(pacote) {
  tryCatch(
    expr = {
      install_version(
        package = pacote[1],
        version = pacote[2],
        force = T,
        quiet = T
      )
      message(sprintf(
        "Pacote: %s foi instalado, versao instalada : %s ",
        pacote[1],
        pacote[2]
      ))
    },
    error = function(e) {
      message(sprintf("Pacote: %s não foi instalado", pacote[1]))
    },
    warning = function(w) {
      message(sprintf("Pacote: %s não foi instalado", pacote[1]))
    }
  )
  
})