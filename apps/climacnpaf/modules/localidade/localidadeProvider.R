#==================================================================
# Metodo para obter o nome do municipio pelo ID da estacao
#
# @param IDestacao id da estacao
# @param data data.frame com os dados das estacoes
# @return string com o municipio selecionado
#==================================================================
obterMunicipio = function(IDestacao,data){
  
  #obtendo nome do municipio
  municipioSelecionado = data[data$id_estacao %in% IDestacao,]
  municipioSelecionado = unique(municipioSelecionado$municipio)
  
  return(municipioSelecionado)
  
}

#==================================================================
# Metodo para listar todos os municios
#
# @param data data.frame com dados das estacoes
# @return lista com nomes dos municipios
#==================================================================
listaMunicipios = function(data){
  
  #obtendo nome do municipio
  municipios = unique(data$municipio)
  
  return(municipios)
  
}