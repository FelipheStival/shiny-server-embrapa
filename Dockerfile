#===============================================================================================================
# Obtendo imagem base
#===============================================================================================================
FROM rocker/shiny:3.6.3

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
    openjdk-11-jdk

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
COPY /apps/climacnpaf /srv/shiny-server/climacnpaf
COPY /apps/infoclima /srv/shiny-server/infoclima
COPY /apps/meteorologia /srv/shiny-server/meteorologia
COPY /apps/shinyinmet /srv/shiny-server/shinyinmet

# Copiando drivers para a pastas
COPY /drivers/mysql-connector-java-5.1.48-bin.jar /srv/shiny-server/infoclima/driver
COPY /drivers/mysql-connector-java-5.1.48-bin.jar /srv/shiny-server/climacnpaf/driver
COPY /drivers/mysql-connector-java-5.1.48-bin.jar /srv/shiny-server/meteorologia/driver
COPY /drivers/postgresql-42.2.22.jar /srv/shiny-server/shinyinmet/driver

#================================================================================================================
# Configuracao shiny-server
#================================================================================================================

# Copiando configuracao do servidor
COPY /conf/shiny-server.conf  /etc/shiny-server/shiny-server.conf

# Iniciando servico
CMD ["/usr/bin/shiny-server"]