# Servidor Shiny Server Embrapa

Servidor Shiny-Server Embrapa arroz e Feijão.

# Sumário

<!--ts-->
   * [Sobre](#Sobre)
   * [Tabela de Conteudo](#Sumário)
   * [Instalação](#instalacao)
   * [Como usar](#como-usar)
      * [Pre Requisitos](#pre-requisitos)
      * [Local files](#local-files)
      * [Remote files](#remote-files)
      * [Multiple files](#multiple-files)
      * [Combo](#combo)
   * [Tests](#testes)
   * [Tecnologias](#tecnologias)
<!--te-->

# Estrutura das pastas

Os arquivos para a criaçao do container foram dividos em quatro pastas.

| path  |  Descrição  |
| ------------------- | ------------------- |
|  /apps/ |  Aplicativos que serão colocados no servidor |
|  /conf/ |  Pasta onde fica a configuração do Shiny-Server |
|  /drivers/ |  Drivers que são usados para fazer a conexão com o banco de dados |
|  /scripts/ |  Scripts que serão usados na criaçao do container |

# Como instalar:

O primeiro passso para fazer a instalação é fazer a instalação do Docker, execute o comando abaixo de acordo com a sua distribuição. <br>

 <strong>Ubuntu: </strong> <br>
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
 
 <strong>CentOS: </strong> <br>
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

<hr>
Depois de instalar o Docker, deve ser feito o clone do repositório. Escolhe um diretorio no seu computador e execute o comando: <br>

```
git clone https://github.com/FelipheStival/shiny-server-embrapa
```

Mude o diretório para a pasta base do repositório: <br>

```
cd shiny-server-embrapa
```

Depois que o repositório estiver clonado, deve ser feita a build da imagem. Dentro da pasta do repositório, execute o seguinte comando:

```
docker build -t shiny-server . 
```