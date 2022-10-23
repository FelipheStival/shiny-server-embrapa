#===============================================================================================================
# Obtendo imagem base
#===============================================================================================================
FROM rocker/shiny-verse:4.1.2

#===============================================================================================================
# Instalando bibliotecas necessarias
#===============================================================================================================
RUN apt-get update && apt-get install -y \
    sudo \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
    r-cran-rjava \
    libxml2-dev \
    openjdk-11-jdk \
	libmysqlclient-dev 

#================================================================================================================
# Instalando bibliotecas R
#================================================================================================================
# copiando script de instalacao
COPY /scripts/ ./scripts
# executando script
RUN Rscript /scripts/instalacao.R

#================================================================================================================
# Copiando drivers e aplicativos 
#================================================================================================================

# Copiando aplicativos
COPY /apps/. /srv/shiny-server/

#================================================================================================================
# Configuracao shiny-server
#================================================================================================================

# Copiando configuracao do servidor
COPY /conf/shiny-server.conf  /etc/shiny-server/shiny-server.conf

# Iniciando servico
CMD ["/usr/bin/shiny-server"]