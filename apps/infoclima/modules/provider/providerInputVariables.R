#==============================================#
# Retorna uma lista contendo os atributos para o funcionamento do siistema.
# variavel => nome da variavel (nome da coluna) da tabela.
# intervalo => quantidade de dias.
providerInputVariables = function(variavel, intervalo) {

     resposta = list()
     
     if(length(variavel) == 0)
          variavel = "Precipitacao (mm)"
     
     varco = switch (variavel,
                     "Temperatura maxima (*C)" = c("tmax", "tomato") ,
                     "Temperatura minima (*C)" = c("tmin", "cyan") ,
                     "Precipitacao (mm)" = c("prec","blue") ,
                     "Radiacao solar global(MJ/m2)" = c("rad", "orange") ,
                     "Umidade (%)" = c("hum", "blue"),
                     "Velocidade do Vento (m/s)" = c("u2", "green3") ,
                     "Evatotranspiracao de referencia (mm)" = c("eto", "green3"),
                     "Grau Dia (*C.dia)" = c("oggr", "green3"))
     
     if(length(intervalo) == 0)
          intervalo = "Mensal"
     
     intervalo = switch (intervalo,
                         "10 Dias" = 10,
                         "21 Dias" = 21,
                         "Mensal" = "mon")
     
     resposta$variavel = varco[1]
     resposta$cor = varco[2]
     resposta$intervalo = intervalo
     
     return(resposta)
}
#==============================================#