#==============================================#
# Retorna uma tabela tratada com os nomes corretos e suas respectivas unidades.
# tabela => data.frame extraido do banco.
providerGridTable = function(tabela) {
     
     names(tabela) = c("Data", "Precipitacao (mm)", 
                       "Umidade (%)", "Radiacao (MJ/m2)", "Temperatura Maxima (*C)",
                       "Temperatura Minima (*C)", "Velocidade do Vento (m/s)", "Evatotranspiracao (mm)")
     return(tabela)
}
#==============================================#

#==============================================#
# Retorna uma tabela tratada com os nomes corretos para exportacao.
# tabela => data.frame extraido do banco.
providerGridTableToDownload = function(tabela) {
     
     names(tabela) = c("Data", "Precipitacao", 
                       "Umidade", "Radiacao", "Temperatura_Maxima",
                       "Temperatura_Minima", "Velocidade_do_Vento", "Evatotranspiracao")
     return(tabela)
}
#==============================================#