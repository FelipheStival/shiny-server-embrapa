# SCRIPT MODIFICADO PARA GLMs SEM EFEITOS ALEATÓRIOS

#---- Separa os termos para o intercept
select_cat_to_intercept_glm <- function(glm_model, cat_var){
  
  # Primeiramente retiramos a tabela com os p-valores do summary
  coef_tab <- data.frame(coef(summary(glm_model)))
  col_change <- c("Estimate","Std_Error", "t_value","p_value")
  colnames(coef_tab) <- col_change
  
  # Pegando o nome das categorias para iterar no for
  cat_names <- sort(unique(cat_var))[-1:0]
  
  # Abrindo um data.frame limpo pra ser preenchido
  cat_to_intercept <- data.frame(cat = c(), p.value = c())
  
  for (cat in cat_names){
    # pega p-valor correspondente a cada classe 
    p.values <- coef_tab[grepl(paste(cat, sep = ""), row.names(coef_tab)), "p_value"]
    #print(p.values)
    
    if (p.values > 0.05){
      cat_to_intercept <- rbind(cat_to_intercept,
                                data.frame(cat = cat, p.value = p.values))
    }
    
    if (nrow(cat_to_intercept) != 0){
      cat_to_intercept %>% arrange(desc(p.value))
    }
    else{
      0
    }  
  }
  
  return(cat_to_intercept)
}

#-------------------------------------------------------------------------------
# Indicador:(intercept*length(cat_intercept[1]) + 
#           (intercept+repeticao2)*length(cat_intercept[2]) +
#            ... + (intercept+repeticao4)*length(cat_intercept[4]))/n
#
# Criar uma tabela com o indicador e o BIC de cada modelo


calcula_indicador_glm <- function(glm_model, data, col_cat){
  
  cat_vec_up <- data %>% pull(col_cat)
  cat_names <- sort(unique(cat_vec_up))
  # Valor do efeito fixo
  eff <- as.numeric(coef(glm_model))
  
  # Valor para iniciar o loop
  media <- eff[1]*length(which(cat_vec_up == sort(unique(cat_vec_up))[1]))
  
  # Calcula o numerador
  for (i in 2:length(eff)){
    media <- media + (eff[1]+eff[i])*length(which(cat_vec_up == cat_names[i]))
    #print(media)
  }
  
  # Finalmente obtemos a media ponderada
  media <- media/length(cat_vec_up)
  
  return(media)
}

#-------------------------------------------------------------------------------
# Gera lista: modelo otimizado, indicador, 
optim_model_glm <- function(data, glm_model, col_cat){
  
  # Salva o vetor da variável de interesse
  cat_vec <- data %>% pull(col_cat)
  
  if(length(unique(cat_vec)) > 1){
    # Pega as categorias a serem jogadas no intercepto
    cat_vec_to_intercept <- select_cat_to_intercept_glm(glm_model, cat_vec)$cat
    # Salva a categoria que já está inserida no intercept
    intercept_cat <- sort(unique(cat_vec))[1]
    
    data_updated <- data.frame()
    
    # Atualiza o banco de dados jogando as categorias não significativas 
    # no intercept
    data_updated <- data %>%
      dplyr::mutate(transformed_col = dplyr::case_when(
        .data[[col_cat]] %in% cat_vec_to_intercept ~ intercept_cat,
        !.data[[col_cat]] %in% cat_vec_to_intercept ~ .data[[col_cat]]
      )) %>%
      as.data.frame()
    
    data_updated[, col_cat] <- data_updated[, "transformed_col"]
    data_updated <- data_updated %>%
      select(-transformed_col)
    
    # Atualiza o modelo se existem pelo menos dois fatores e calcula O indicador
    cat_vec_up <- data_updated %>% pull(col_cat)
    
    if(length(unique(cat_vec_up)) > 1){
      glm_model <- update(glm_model, data = data_updated)
      media <- calcula_indicador_glm(glm_model, data_updated, col_cat)
    }
    
    if(length(unique(cat_vec_up)) == 1){
      lme_model <- glm(produtividade ~ 1, data = data_updated)
      media <- as.numeric(coef(glm_model))[1]
    }
    
    BIC_tab <- BIC(glm_model)
    
    # Retorna banco de dados modificado, o modelo otimizado, o indicador e o BIC
    return(list(data_updated = data_updated, optim_mdl = glm_model, Media_ponderada = media, BIC_tab = as.numeric(BIC_tab)))
  }
  if(length(unique(cat_vec)) > 1){
    (print("Não há categorias suficientes"))
  }
}

#-------------------------------------------------------------------------------
# Aplica as funções pro ensaio
gera_tabela_por_trial_glm <- function(data, glm_model, col_cat){
  
  data <- na.exclude(data)
  
  trial_vec <- data %>% pull("id_ensaio")
  trial_list <- (unique(trial_vec))
  
  tab_results <- NULL
  i <- 1
  for (trial in trial_list){
    
    data_up <- data %>% filter(id_ensaio == trial)
    
    cat_vec <- data_up %>% pull(col_cat)
    
    if(length(unique(cat_vec))>1){
      
      glm_model <- update(glm_model, data = data_up)
      
      tab_results <- rbind(tab_results,
                           tibble(id_ensaio = trial, 
                                  MediaPonderada = unlist(optim_model_glm(data_up, glm_model, col_cat)$Media_ponderada),
                                  BIC = unlist(optim_model_glm(data_up, glm_model, col_cat)$BIC_tab)
                           )
      )
    }
    
    if(length(unique(cat_vec))==1){
      tab_results <- rbind(tab_results,
                           tibble(id_ensaio = trial, 
                                  MediaPonderada = NA,
                                  BIC = NA)
                           )
    }
    
    i<- i+1
  }
  
  return(list(tab = tab_results))
}



