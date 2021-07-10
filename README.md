# Servidor Shiny Server Embrapa

Servidor Shiny-Server Embrapa arroz e Feijão.

# Estrutura das pastas

Os arquivos para a criaçao do container foram dividos em quatro pastas.

:file_folder: /apps/ essa pasta contém os aplicativos que serão utilizados no servidor. <br>
:file_folder: /conf/ essa pasta contém o arquivo de configuração do servidor. <br>
:file_folder: /drivers/ essa pasta contém os drivers que serão utilizados para a conexão com os banco de dados. <br>
:file_folder: /scripts/ essa pasta contém os scripts que serão utilizados na criaçao do container. <br>
:bookmark_tabs: Dockerfile é o arquivo onde estão os passos para que o container seja criado. <br>

# Como instalar

O primeiro passso para fazer a instalação é fazer o download do Docker, a instalação pode ser feita seguindo o tutorial do seguinte link. <br>

https://docs.docker.com/engine/install/ <br>

Depois de instalar o Docker, deve ser feito o clone do repositório. Escolhe um diretorio no seu computador e execute o comando: <br>

```
git clone https://github.com/FelipheStival/shiny-server-embrapa#servidor-shiny-server-embrapa
```