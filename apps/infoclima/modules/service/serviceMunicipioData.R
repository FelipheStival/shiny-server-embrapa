#==============================================#
# Retorna os dados do grid para gerar os graficos.
# A tabela retornada devera possuir a coluna data.
# municipio => nome do municipio a ser filtrado.
# dataRange => periodo de dias para consulta.
serviceMunicipioData = function(estado = "Goias", municipio = "Goias", dataRange, global) {
        
     variables = paste(c("data" ,"prec", "hum", "rad", "tmax", "tmin", "u2", "eto"), collapse = ",")
     query = sprintf("select %s from grid_%s where municipio = '%s' and data between '%s' and '%s'", variables, estado, municipio, dataRange[1], dataRange[2])
     tabela = executeQuery(query)
     tabela = Arrendondar_valores(tabela)
     return(tabela)
}
#==============================================#

#==============================================#
#Arrendonda valores para duas casas decimais
Arrendondar_valores = function(tabela){
     Nomes_tabela = names(tabela)
     for(NomeColuna in Nomes_tabela){
          if(is.numeric(tabela[[NomeColuna]])){
               tabela[[NomeColuna]] = round(tabela[[NomeColuna]],2)
          }
     }
     return(tabela)
}
