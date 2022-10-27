#==============================================#
# Grafico "Contagem"
grafico.diagnostico_Contagem = function(tabela) {
  validate.vx = is.na(tabela$h2) | is.infinite(tabela$h2)
  validate.vy = is.na(tabela$rgg) | is.infinite(tabela$rgg)
  
  row.index = which(!validate.vx & !validate.vy)
  col.index = which(names(tabela) %in% c("h2", "rgg", "Diagnostico"))
  tabela = tabela[row.index, col.index]
  
  color.palette = c("#7cb342", "#e53935")
  scatterD3(
    data = tabela,
    x = h2,
    y = rgg,
    col_var = Diagnostico,
    colors = color.palette,
    xlab = "Herdabilidade",
    ylab = "Correlacao genetica entre valor fenotipo e genotipo",
    menu = F,
    xlim = c(0, 1),
    ylim = c(0, 1)
  )
}
#==============================================#

#==============================================#
# Aba "Dados Perdidos"
graphics.dadosPerdidos_Estatistica = function(tabela) {
  namesIndex = which(
    names(tabela) %in% c(
      "id_ensaio",
      "flor_das",
      "flor_dae",
      "ciclo_das",
      "ciclo_dae",
      "produtividade"
    )
  )
  subsetTabela = tabela[, namesIndex]
  
  naTabela = melt(subsetTabela, id.vars = "id_ensaio")
  naTabela = dcast(naTabela,
                   id_ensaio ~ variable,
                   value.var = "value",
                   fun.aggregate = naCounter)
  naTabela = melt(naTabela, id.vars = "id_ensaio")
  
  names(naTabela) = c("Experimento", "Variavel", "Valor")
  
  ggplot(data = naTabela, aes(x = Variavel, y = Experimento)) + geom_tile(aes(fill = Valor), colour = "white") +
    scale_fill_gradient(low = "#7cb342", high = "#e53935") + theme_minimal() +
    theme(text = element_text(size = 15))
}
#==============================================#
# Aba "Estatistica"
# Grafico "Resumo"
grafico.analiseEstatistica_Resumo = function(tabela, mediaSelect = 'TODOS') {
  
  modified_data <- tabela %>% 
    # Agrupar por genotipo e calcular media e mediana
    dplyr::group_by(gid) %>% 
    dplyr::summarise(mean_pred = mean(predicts), median = median(predicts))
  
  
  # Filtrando de acordo com a media selecionada
  mediaPredict <- mean(modified_data$mean_pred)
  if(mediaSelect == 'ACIMA'){
    modified_data =  modified_data[modified_data$mean_pred > mediaPredict,]
  } else if(mediaSelect == "ABAIXO") {
    modified_data =  modified_data[modified_data$mean_pred < mediaPredict,]
  }
  
  # Muda o df para formato long
  long <- melt(modified_data,id.vars="gid")
  
  ggplot(data = long, aes(x=reorder(gid,value), y=value, fill=variable)) + 
    geom_bar(stat = "identity",
             position="dodge") +
    xlab("Genótipos") +
    ylab("Produtividade estimada") +
    coord_flip() + 
    scale_fill_discrete(name="",
                        labels=c("Média", "Mediana"))+
    scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) +
    theme_light() +
    labs(
      title = paste('Média geral', round(mediaPredict), sep = ":")
    )
}
#==============================================#

#==============================================#
# Aba "Estatistica"
# Grafico "Unitario"
grafico.analiseEstatistica_Unitario = function(data_plot, site = "", media = 'TODOS') {
  data_plot = data_plot[data_plot$site == site,]
  ggplot(data = data_plot, aes(x=reorder(gid,predicts), y=predicts)) + 
    geom_boxplot( fill = "lightyellow") + 
    stat_boxplot(geom ='errorbar') + 
    xlab("Genótipos") +
    ylab("Produtividade estimada") +
    coord_flip() + 
    theme_light() +
    facet_grid(~site)
}
#==============================================#

#==============================================#
# Aba "Estatistica"
# Grafico "Heatmap"
grafico.analiseEstatistica_Heatmap = function(tabela) {
  grafico = tabela %>%
    ggplot(aes(x = site, y = gid, fill = predicts)) +
    geom_tile(height = 1.1, color = 'black') +
    scale_fill_gradientn(colors = c("red","green")) +
    labs(
      x = 'Locais',
      y = 'Genótipos',
      fill = 'Produtividade predita (kg/ha)'
    ) +
    theme(
      strip.background = element_blank(),
      panel.border = element_rect(color = 'black', fill = NA, size = 0.8),
      legend.title.align = 0.5
    )
  
  return(grafico)
}
#==============================================#

#==============================================#
# Aba "Estatistica"
# Grafico "Linhas"
grafico.GraficoLinhas = function(dados) {
  
  dados$gid = as.character(dados$gid)
  dados$gid = factor(dados$gid)
  
  #Calculando media por local
  
  dados_mean = dados %>%
    group_by(site) %>%
    dplyr::summarize(Mean = mean(mean, na.rm = TRUE))
  dados_mean = as.data.frame(dados_mean)
  
  #Gerando grafico
  p = ggplot(data = NULL) +
    geom_line(data = dados, aes(
      x = site,
      y = mean,
      group = gid,
      colour = gid
    )) +
    geom_point(
      data = dados_mean,
      aes(x = site, y = Mean),
      shape = 17,
      size = 3
    ) +
    theme(axis.text.x = element_text(angle = 90),
          text = element_text(size = 15)) +
    xlab("Local") +
    ylab("Produtividade (kg/ha)") +
    labs(colour = "Genotipo")
  
  
  return(p)
}

#==============================================#
# Aba "Estatistica"
# Grafico "Linhas"
grafico.analiseCluster = function(data_plot, mediaSelect = 'TODOS'){
  
  # Clusters
  cluster_data <- data_plot %>% 
    # Agrupar por genotipo e calcular media
    dplyr::group_by(gid) %>% 
    dplyr::summarise(mean_pred = mean(predicts))
  
  # Selecionar o numero de clusters
  k_val <- 5
  # Salva os clusters referentes a cada observacao
  set.seed(123)
  clusters_obs <- kmeans(cluster_data[2], k_val, nstart = 50)$cluster
  # Adiciona os clusters no df
  cluster_data <- data.frame(cluster_data, grupos = (clusters_obs))
  # Coloca o df em ordem crescente
  cluster_data <- cluster_data[order(cluster_data$mean_pred),]
  rownames(cluster_data) <- NULL
  
  # Fixa um df para colocar o numero de clusters em ordem crescente
  cluster_data_pin <- cluster_data
  s_want <- 1:length(unique(clusters_obs))
  s_now <- unique(cluster_data$grupos)
  # Finalmente coloca em ordem crescente
  for(i in 1:length(unique(clusters_obs))){
    
    cluster_data_pin[cluster_data == s_now[i]] <- s_want[i]
    
  }
  
  # Precisamos obter tambem os intervalos de cada cluster
  # Simulando de 1 em 1
  set.seed(123)
  clusters_obs_sim <- kmeans(min(cluster_data$mean_pred):max(cluster_data$mean_pred), k_val, nstart = 50)$cluster
  
  sim_data <- data.frame(predicts = min(cluster_data$mean_pred):max(cluster_data$mean_pred), grupos = clusters_obs_sim) %>% group_by(grupos)
  sim_data <- data.frame(sim_data)
  
  sim_data <- sim_data[order(sim_data$predicts),]
  sim_data_pin <- sim_data
  
  #seq_want <- 1:length(unique(res.km.real))
  s_now_sim <- unique(sim_data_pin$grupos)
  
  for(i in 1:length(unique(clusters_obs_sim))){
    
    sim_data_pin[sim_data == s_now_sim[i]] <- s_want[i]
    
  }
  
  # Definir intervalos entre os clusters
  intervals <- matrix(nrow = length(unique(sim_data_pin$grupos)),ncol = 2)
  for(i in 1:length(unique(sim_data_pin$grupos))){
    
    intervals[i,1] <- round(min(sim_data_pin %>% filter(grupos == i) %>% summarise(predicts)),0)-1
    intervals[i,2] <- round(max(sim_data_pin %>% filter(grupos == i) %>% summarise(predicts)),0)
    
  }
  
  # Intervalos em string para o grafico
  fill_label <- c()
  fill_label[1] <- paste0("[",intervals[1,1],",",intervals[1,2],"]")
  
  for(i in 2:length(unique(sim_data_pin$grupos))){
    
    fill_label[i] <- paste0("(",intervals[i,1],",",intervals[i,2],"]")
    
  }
  
  # Filtrando de acordo com a media selecionada
  mediaPredict <- mean(cluster_data_pin$mean_pred)
  if(mediaSelect == 'ACIMA'){
    cluster_data_pin =  cluster_data_pin[cluster_data_pin$mean_pred > mediaPredict,]
  } else if(mediaSelect == "ABAIXO") {
    cluster_data_pin =  cluster_data_pin[cluster_data_pin$mean_pred < mediaPredict,]
  }
  
  # Enfim o grafico do cluster
  ggplot(cluster_data_pin, aes(x=grupos, y=reorder(gid,grupos), fill = as.factor(grupos))) +
    geom_bar(stat='identity') +
    theme(axis.text.x = element_blank(),
          axis.ticks.x = element_blank()) +
    labs(y = "Genótipos", 
         x = "",
         fill = "Grupos (kg/ha)",
    ) +
    scale_fill_discrete(labels = fill_label) +
    labs(
      title = paste('Média geral', round(mediaPredict), sep = ":")
    )
}

#==============================================#
# Aba "Analise GGE"
# Grafico "Quem vence e aonde"
grafico.analiseGGE_QuemVenceEAonde = function(gge.model) {
  plot = WhichWon(gge.model, largeSize = 3, axis_expand = 1.75) + theme_bw()
  label_plot <- plot[["data"]][["label"]]
  
  plot$layers[[7]] <- NULL
  plot$layers[[6]] <- NULL
  plot$layers[[5]] <- NULL
  
  plot <- plot + geom_text_repel(label = label_plot, 
                          color = ifelse(
                            label_plot %in% plot[["plot_env"]][["labelgen"]], "forestgreen", "blue"
                          ),
                          max.overlaps  = 14,
                          max.iter = 10000)
  
  return(plot)
}
#==============================================#

#==============================================#
# Aba "Analise GGE"
# Grafico "Ordem de Ambiente"
grafico.analiseGGE_OrdemDeAmbiente = function(gge.model) {
  plot = RankEnv(gge.model, largeSize = 4, axis_expand = 1.75) + theme_bw()
  return(plot)
}

#==============================================#
# Aba "Analise GGE"
# Grafico "Ordem de genotipo"
grafico.analiseGGE_OrdemDeGenotipo = function(gge.model) {
  plot = RankGen(gge.model,largeSize = 4, axis_expand = 1.6) + theme_bw()
  
  label_plot <- plot[["data"]][["label"]]
  plot$layers[[10]] <- NULL
  plot$layers[[9]] <- NULL
  plot$layers[[8]] <- NULL
  
  plot = plot + geom_text_repel(label = label_plot, 
                             color = ifelse(
                               label_plot %in% plot[["plot_env"]][["labelgen"]], "forestgreen", "blue"
                             ),
                             max.overlaps  = 14,
                             max.iter = 10000)
  return(plot)
}
#==============================================#

#==============================================#
# Aba "Analise GGE"
# Grafico "Relacao entre ambientes"
grafico.analiseGGE_RelacaoEntreAmbientes = function(gge.model) {
  EnvRelationship(gge.model, largeSize = 4, axis_expand = 1.75) + theme_bw()
}
#==============================================#

#==============================================#
# Aba "Analise GGE"
# Grafico "Estabilidade / Media"
grafico.analiseGGE_EstabilidadeMedia = function(gge.model) {
  plot = MeanStability(gge.model, largeSize = 4, axis_expand = 1.75) + theme_bw()
  
  label_plot <- plot[["data"]][["label"]]
  plot$layers[[8]] <- NULL
  plot$layers[[7]] <- NULL
  plot$layers[[6]] <- NULL
  
  plot = plot + geom_text_repel(label = label_plot, 
                             color = ifelse(
                               label_plot %in% plot[["plot_env"]][["labelgen"]], "forestgreen", "blue"
                             ),
                             max.overlaps  = 14,
                             max.iter = 10000)
  
  return(plot)
}
#==============================================#

#==============================================#
# Aba "Analise GGE"
# Grafico "Denograma"
grafico.analiseGGE_Denograma = function(deno) {
  plot(as.phylo(deno), cex = 0.7, label.offset = 0.7, width = 10)
}
#==============================================#

#==============================================#
# Aba "Potencial genótipo produtivo"
# Grafico "Potencial Produtivo"
grafico.pontecialProdutivo = function(dados, localInput) {
  
  plot = ggplot(dados %>% filter(local == localInput), aes(x = genotipo, y = notas, fill = notas, label = round(notas,1))) +
    geom_col(width = 0.85, colour = "black") + 
    coord_polar() +
    scale_fill_gradientn(colors = c("red","yellow","green")) +
    theme_minimal() +
    geom_text(position=position_stack(vjust=0.8), size = 2.8) +
    theme(axis.title=element_blank(),
          axis.text.y=element_blank(),
          axis.text.x=element_text(face= "bold", size = 11),
          axis.ticks=element_blank(),
          panel.grid.major = element_line(size = 0.5, linetype = 'dashed',
                                          colour = "black"), 
          panel.grid.minor = element_line(size = 0.25, linetype = 'dashed',
                                          colour = "black")) +
    labs(fill = "PGP")
  
  return(plot)
  
}
#==============================================#
