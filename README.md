# Servidor Shiny Server Embrapa

Servidor Shiny-Server Embrapa arroz e Feijão.

# Sumário

<!--ts-->
   * [1. Sumário](#Sumário)
   * [2. Estrutura das pastas](#Estrutura-das-pastas)
   * [3. Pré-requisitos](#Pré-requisitos)
      * [3.1.  Docker](#Docker)
         * [3.2. Ubuntu](#Ubuntu)
		 * [3.3. CentOS](#CentOS)
   * [4. Instalação](#Instalação)
   * [5. Como adicionar um aplicativo no servidor ](#Como-adicionar-um-aplicativo-no-servidor )
<!--te-->

# Estrutura das pastas

Os arquivos para a criaçao do container foram dividos em quatro pastas.

| path  |  Descrição  |
| ------------------- | ------------------- |
|  /apps/ |  Aplicativos que serão colocados no servidor. |
|  /conf/ |  Pasta onde fica a configuração do Shiny-Server. |
|  /scripts/ |  Scripts que serão usados na criaçao do container. |

# Pré-requisitos

Antes de começar, você precisa ter instalado em sua máquina as seguintes ferramentas: <br>

<!--ts-->
   * [1. Instalar Docker](#Docker)
      * [1.1 Ubuntu](#Ubuntu)
	  * [1.2 CentOS](#CentOS)
   * [2. Iniciar serviço docker](#Iniciar-serviço-docker)
<!--te-->


### 1. Docker
Caso você não tenha o Docker instalado, execute o comando abaixo de acordo com a sua distribuição. <br>

##### 1.1. Ubuntu
 ```
 sudo apt-get update
 ```
 ```
 sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
 ```
 ```
 curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
 ```
 ```
 sudo apt-get update
 ```
 ```
 sudo apt-get install docker-ce docker-ce-cli containerd.io
 ```

##### 1.2. CentOS
 ```
 sudo yum install -y yum-utils
 ```
 ```
 sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
 ```
 ```
 sudo yum install docker-ce docker-ce-cli containerd.io
 ```

#### 2. Iniciar serviço docker

Depois que o docker estiver instalado, inicie o serviço com o seguinte comando:
```
 sudo systemctl start docker
```
 
# Instalação

<!--ts-->
   * [1. Clonar repositório](#Clonar-repositório)
   * [2. build servidor](#Criar-build-servidor)
<!--te-->

#### 1. Clonar repositório
Escolha um diretorio no seu computador e execute o comando: <br>

```
git clone https://github.com/FelipheStival/shiny-server-embrapa
```

Mude o diretório para a pasta base do repositório: <br>

```
cd shiny-server-embrapa
```

#### 2. Criar build servidor
Dentro da pasta do repositório, deve ser feita a build da imagem. Dentro da pasta do repositório, execute o seguinte comando:

```
docker build -t shiny-server . 
```

Execute o comando abaixo para iniciar o servidor:
```
docker run -p 3838:3838 -d  -v /export/shiny-log/:/var/log/shiny-server shiny-server
```

Acesse o endereço http://localhost:3838, caso apareça a página de "boas-vindas" do Shiny-Server o servidor está funcionando corretamente.

# Como adicionar um aplicativo no servidor 

<!--ts-->
   * [1. Clonar repositório](#1. Clonar-repositório)
   * [2. Adicionar aplicativo ao servidor](#2. Adicionar-aplicativo-ao-servidor)
   * [3. Adicionar dependências ao servidor](#3.-Adicionar-dependências)
   * [4. Criar nova build](####-4.-Criar-nova-build)
<!--te-->

#### 1. Clonar repositório
Primeiro deve ser feito o clone do repositório, Escolhe um diretorio no seu computador e execute o comando: <br>
```
git clone https://github.com/FelipheStival/shiny-server-embrapa
```

#### 2. Adicionar aplicativo ao servidor
Para adicionadar um aplicativo ao servidor, copie o código fonte do aplicativo para a pasta /apps/

#### 3. Adicionar dependências
Depois de copiar o aplicativo para a pasta, adicione as bibliotecas usadas no aplicativo no arquivo /scripts/instalacao.R, as dependências devem ser adicionadas a variável "pacotes". Exemplo:

```r
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
  c("shinymanager", "1.0.400") # Adicionar pacotes após essa linha.
)
```

#### 4. Criar nova build

Acesse o diretorio do repositório: 
```
cd shiny-server-embrapa
```
Faça a build do container com o novo aplicativo.
```
docker build -t shiny-server . 
```
Execute o comando abaixo para iniciar o servidor:
```
docker run -p 3838:3838 -d  -v /export/shiny-log/:/var/log/shiny-server shiny-server
```

Acesse o endereço http://localhost:3838/NOME_APLICATIVO.