# Grafico local
gerador_graficos = function(banco, filtroSafra){
  
  
  agrupados = banco[[1]]
  fs_modelo = banco[[2]]
  fo_modelo = banco[[3]]
  ordem_fs = banco[[4]]
  ordem_fo = banco[[5]]
  ordem = banco[[6]]
  
  informacao <- agrupados %>% dplyr::filter(safra == filtroSafra) %>% group_by(genotipo) %>%
    dplyr::summarize(Media_Fs = mean(Media_fs), Media_Fo = mean(Media_fo), predito_fs = 
                predict(fs_modelo, Media_Fs), predito_fo = predict(fo_modelo, Media_Fo)) %>% mutate(predito_fs = factor(predito_fs, levels = ordem_fs, label = ordem),
                                                                                                    predito_fo = factor(predito_fo, levels = ordem_fo, label = ordem))
  
  grafico1 <- ggplot(informacao, aes(reorder(genotipo, -Media_Fo), Media_Fo, fill = predito_fo)) + 
    geom_col() +
    theme_bw() + 
    labs(x = "Genótipos", y = "Valor Médio", title = paste("Cidade", filtroSafra), color = "Grupos", 
         fill = "Fusarium oxysporum") +
    coord_flip() + 
    scale_fill_brewer(palette = "Dark2")+
    theme(legend.position = "top", 
          legend.title = element_text(colour="blue", size=10,  face="bold"),
          axis.text =   element_text(face="bold")) 
  
  grafico2 <- ggplot(informacao, aes(reorder(genotipo, -Media_Fs), Media_Fs, fill = predito_fs)) + 
    geom_col() +
    theme_bw() + 
    labs(x = "Genótipos", y = "Valor Médio", title = paste("Cidade", filtroSafra), color = "Grupos", fill= "Fusarium solani") +
    coord_flip() + scale_fill_brewer(palette = "Dark2")+
    theme(legend.position = "top", 
          legend.title = element_text(colour="red", size=10,  face="bold"),
          axis.text =  element_text(face="bold" ))
  
  grafico = plot_grid(grafico1, grafico2)
  
  return(grafico)
}

# Grafico Geral
gerador_graficos_cidade = function(banco, local){
  
  agrupados = banco[[1]]
  fs_modelo = banco[[2]]
  fo_modelo = banco[[3]]
  ordem_fs = banco[[4]]
  ordem_fo = banco[[5]]
  ordem = banco[[6]]
  
  informacao <- agrupados %>% dplyr::filter(cidade == local) %>% group_by(genotipo) %>%
    dplyr::summarize(Media_Fs = mean(Media_fs), Media_Fo = mean(Media_fo), predito_fs = 
                predict(fs_modelo, Media_Fs), predito_fo = predict(fo_modelo, Media_Fo)) %>% mutate(predito_fs = factor(predito_fs, levels = ordem_fs, label = ordem),
                                                                                                    predito_fo = factor(predito_fo, levels = ordem_fo, label = ordem))
  
  grafico1 <- ggplot(informacao, aes(reorder(genotipo, -Media_Fo), Media_Fo, fill = predito_fo)) + 
    geom_col() +
    theme_bw() + 
    labs(x = "Genótipos", y = "Valor Médio", title = paste("Cidade", local), color = "Grupos", 
         fill = "Fusarium oxysporum") +
    coord_flip() + 
    scale_fill_brewer(palette = "Dark2")+
    theme(legend.position = "top", 
          legend.title = element_text(colour="blue", size=10,  face="bold"),
          axis.text =   element_text(face="bold")) 
  
  
  
  grafico2 <- ggplot(informacao, aes(reorder(genotipo, -Media_Fs), Media_Fs, fill = predito_fs)) + 
    geom_col() +
    theme_bw() + 
    labs(x = "Genótipos", y = "Valor Médio", title = paste("Cidade", local), color = "Grupos", fill= "Fusarium solani") +
    coord_flip() + scale_fill_brewer(palette = "Dark2")+
    theme(legend.position = "top", 
          legend.title = element_text(colour="red", size=10,  face="bold"),
          axis.text =  element_text(face="bold" ))
  
  grafico = plot_grid(grafico1, grafico2)
  
  return(grafico)
}