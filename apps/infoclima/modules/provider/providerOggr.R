#==============================================#
# Retorna uma tabela com a variavel 'oggr'
# tabela => data.frame com as colunas 'tmax' e 'tmin'.
# temperatura => temperatura base para Oggr.
providerOggr = function(tabela, temperatura) {
     
     if(length(temperatura) == 0)
          temperatura = 0
     
     tabela$oggr = (tabela$tmax + tabela$tmin)/2
     tabela$oggr = tabela$oggr - as.numeric(temperatura)
     tabela$oggr[tabela$oggr < 0] = 0

     return(tabela)
}
#==============================================#