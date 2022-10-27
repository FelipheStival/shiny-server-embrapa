#================================================
# Metodo para obter os dados dos genotipos
#================================================
experimentos.provider.dados = function() {
  statement = "SELECT ensaios.id,
     id_ensaio,
	   estados.nome as estado,
	   cidades.nome as cidade,
	   locais.nome as local,
	   tipos_de_graos.sigla as tipo_de_grao,
	   genotipos.nome as genotipo,
	   safra,
	   repeticao,
	   ROUND(produtividade,2) as produtividade,
	   data_semeadura,
	   data_emergencia,
	   data_inicio_floracao,
	   data_inicio_ponto_colheita,
	   data_inicio_colheita,
	   epoca,
	   cultura.nome as cultura,
	   locais.nome as local,
	   irrigacao,
	   fungicida
	FROM public.ensaios
	JOIN genotipos ON ensaios.id_genotipo = genotipos.id
	JOIN locais ON ensaios.id_local = locais.id
	JOIN cidades ON locais.id_cidade = cidades.id
	JOIN estados ON cidades.id_estado = estados.id
	JOIN tipos_de_graos ON genotipos.id_tipo_grao = tipos_de_graos.id
	JOIN cultura ON ensaios.id_cultura = cultura.id"
  
  dados = banco.provider.executeQuery(statement, DOENCA_DB_DATABASE)
  return(dados)
}

#================================================
# Metodo para obter dados unicos de uma coluna
#================================================
experimentos.provider.unique = function(dados, coluna) {

  dados = unique(dados[, coluna])
  return(dados)
}

#================================================
# Metodo para filtrar o data.frame
#================================================
experimentos.provider.dadosFiltrados = function(dados, input) {
  
  # Criando data.frame a ser filtrado
  filtrado = dados
  
  # Checando todos
  indexCultura = which(input[['culturaInputDoencas']] == "Todos")
  indexCidade = which(input[['cidadeInputDoencas']] == "Todos")
  indexEstado = which(input[['estadoInputDoencas']] == "Todos")
  indexTipoGrao = which(input[['tipodegraoInputDoencas']] == "Todos")
  indexEpoca = which(input[['epocaInputDoencas']] == "Todos")
  indexSafra = which(input[['safraInputDoencas']] == "Todos")
  
  
  # Filtrando cultura
  if(length(indexCultura) == 0 & !is.null(input$culturaInputDoencas)){
    filtrado = filtrado[filtrado$cultura %in% input$culturaInputDoencas,]
  }
  
  # Filtrando cidade
  if(length(indexCidade) == 0 & !is.null(input$cidadeInputDoencas)){
    filtrado = filtrado[filtrado$cidade %in% input$cidadeInputDoencas,]
  }
  
  # Filtrando estado
  if(length(indexEstado) == 0 & !is.null(input$estadoInputDoencas)){
    filtrado = filtrado[filtrado$estado %in% input$estadoInputDoencas, ]
  }
  
  # Filtrando tipo de grao
  if(length(indexTipoGrao) == 0 & !is.null(input$tipodegraoInputDoencas)){
    filtrado = filtrado[filtrado$tipo_de_grao %in% input$tipodegraoInputDoencas, ]
  }
  
  # Filtrando safra
  if(length(indexSafra) == 0 & !is.null(input$safraInputDoencas)){
    filtrado = filtrado[filtrado$safra %in% input$safraInputDoencas, ]
  } 
  
  # Filtrando irrigacao e fungicida
  filtrado = filtrado[filtrado$irrigacao %in% input$irrigacaoInputDoencas &
                      filtrado$fungicida %in% input$fungicidaInputDoencas &
                      filtrado$cultura   %in% input$culturaInputDoencas, ]
  
  return(filtrado)
}

TE1 = function(df, y, rep, gen, trials, accuracy) {
  tryCatch(
    expr = {
      
      dfa = df[, c(y, gen, rep, trials)]
      names(dfa) = c("y", "g", "r", "e")
      
      Ntrials = length(unique(dfa$e))
      results = matrix(nrow = Ntrials, ncol = 13)
      colnames(results) = c(
        "CodigodoExperimento",
        "mean",
        "BLUE",
        "MEDIA_ARITMETICA",
        "Vg",
        "Vres",
        "Vf",
        "h2",
        "rgg",
        "CVg",
        "CVe",
        "CV",
        "Diagnostico"
      )
      
      for (index in 1:Ntrials) {
        
        id = unique(dfa$e)[index]
        subsetIndex = which(dfa$e == id)
        subsetTable = dfa[subsetIndex, ]
        
        index.validade = mean(subsetTable$y)
        
        r = length(unique(subsetTable$r))
        MEDIA_ARITMETICA =  mean(subsetTable$y, na.rm = TRUE)
        
        if(r > 1){
          
          modelo = lmer(y ~ 1 + r + (1|g), subsetTable)
          vg = VarCorr(modelo)[[1]][1]
          
          vres = sigma(modelo) ^ 2
          vf = vg + vres
          h2 = vg / (vg + (vres / r))
          m = fixef(modelo)[[1]]
          CV = 100 * attr(VarCorr(modelo), "sc") / m
          cvg = 100 * (sqrt(vg) / m)
          cve = 100 * (sqrt(vf) / m)
          rgg = sqrt(1 - (1 / (1 + r * (cvg / cve) ^ 2)))
          BLUE = summary(modelo)$coefficients[1,1]
          
          
          res.row = c(as.character(id), m, BLUE, MEDIA_ARITMETICA, vg, vres, vf, h2, rgg, cvg, cve, CV, NA)
          results[index, ] = res.row 
          
        } else {
          res.row = c(as.character(id),NA, NA, MEDIA_ARITMETICA, NA, NA, NA, NA, NA, NA, NA, NA, NA)
          results[index, ] = res.row 
        }
      }
      
      r7 = as.numeric(results[, 7])
      acc = r7 < accuracy
      splitRate = as.vector(table(acc))
      splitRate = round(splitRate / sum(splitRate), 2)
      splitRate = sprintf("%s (%s", c("remover", "manter"), splitRate[2:1] * 100)
      splitRate = paste0(splitRate, "%)")
      
      valid = ifelse(acc, splitRate[1], splitRate[2])
      
      results[, 13] = valid
      results = data.frame(results)
      results[, 12] = as.numeric(as.character(results[, 12]))
      results[, 12] = ifelse(results[, 12] > 100 |
                               results[, 12] < 0, NA, results[, 12])
      
      return(results)
    },
    error = function(e) {
      return(NULL)
    }
  )
}

service.getDiagostico = function(tabela, inputUsuario) {
  
  # Obtendo dados necessarios para gerar modelo
  dadosModelo = tabela[,c("id_ensaio", "genotipo", "repeticao", "safra", "cidade", "local", "irrigacao","fungicida","estado","tipo_de_grao", "epoca", "produtividade", "cidade")]
  dadosModelo = na.exclude(dadosModelo)
  
  # Preparando dados
  dadosModelo$repeticao = as.character(dadosModelo$repeticao)
  dadosModelo$epoca = as.factor(dadosModelo$epoca)
  dadosModelo$genotipo = as.factor(dadosModelo$genotipo)
  dadosModelo$local = as.factor(dadosModelo$local)
  
  # Definindo o modelo de diagnostico dos experimentos
  mdl_trials = lmer(produtividade ~ repeticao + (1|genotipo), data = dadosModelo, REML = TRUE)
  
  # Modelo linear (sem o efeito aleatório)
  mdl_glm_trials = glm(produtividade ~ repeticao, data = dadosModelo, family = gaussian(link='identity'))
  
  # "genotipo" é a entrada da variável com efeito aleatório
  # "repeticao" é a entrada como efeito fixo
  tab_resultados = gera_tabela_por_trial(dadosModelo, mdl_trials, "repeticao", "genotipo")$tab
  tab_resultados_glm = gera_tabela_por_trial_glm(dadosModelo, mdl_glm_trials, "repeticao")$tab
  
  # Obtemos assim os indicadores BLUE e BLUP
  indicadores_bind = tibble(`Codigodo Experimento` = tab_resultados$id_ensaio,
                             `Média BLUP (kg/ha)` = round(tab_resultados$MediaPonderada,0), 
                             `Valor BIC (BLUP)` = round(tab_resultados$BIC,0),
                             `Média BLUE(kg/ha)` = round(tab_resultados_glm$MediaPonderada,0), 
                             `Valor BIC(BLUP)` = round(tab_resultados_glm$BIC,0),
                             `MEDIA ARITMETICA(kg/ha)` = round(tab_resultados_glm$MediaPonderada,0),
                             `Local` = tab_resultados$Local,
                             `Cidade` = tab_resultados$Cidade,
                             `UF` = tab_resultados$UF,
                             `Irrigação` = ifelse(inputUsuario$irrigacaoInputDoencas == 't', 'Sim', 'Nao'),
                             `Fungicida` = ifelse(inputUsuario$fungicidaInputDoencas == 't', 'Sim', 'Nao'),
                             `Tipo de grão` = capture.output(cat(inputUsuario$tipodegraoInputDoencas, sep = ','))
  )
  
  return(indicadores_bind)
  
}

service.getY = function(tabela, relatorio = FALSE) {
  tryCatch(
    expr = {
      
      tabela$ano = as.Date(tabela$data_semeadura)
      tabela$ano = format(tabela$ano, "%Y")
      Y = y.matrix.2(
        trait = "produtividade",
        gid = "genotipo",
        rep = "repeticao",
        year = "safra",
        site = "local",
        df = tabela
      )
      if(relatorio){
        Y = Y$Adjusted.Means.df
      }
        
      return(Y)
    },
    error = function(e){ 
      msg = paste("Erro",e,sep = ":")
      cat(msg)
      return(NULL)
    }
  )
}

service.getMean = function(tabela, input) {
  
  Y = service.getY(tabela)
  Y1 = as.data.frame(Y[[1]])
  
  t1 = Y1 %>%
    group_by(gid, site) %>%
    dplyr::summarize(mean = mean(y, na.rm = TRUE))
  
  t1 = data.frame(t1)
  
  indexSelecionados = which(!input$GenotipoSelectDoencas %in% "Todos")
  
  if (!is.null(input$GenotipoSelectDoencas) &&
      length(indexSelecionados) > 0) {
    GenNames = input$GenotipoSelectDoencas[indexSelecionados]
    t1 = t1[t1$gid %in% GenNames, ]
  }
  
  
  return(t1)
}
#==============================================#
naCounter = function(values) {
  index = which(is.na(values))
  rate = length(index) / length(values)
  return(rate * 100)
}
#==============================================#

#==============================================#
y.matrix.2 = function(df,trait,rep,site, gid, year){
  
  dataset = df[,c(trait, rep, site, gid, year)]
  names(dataset) = c("trait","rep", "site", "gid", "year")
  yearBackup = unique(dataset$year)
  siteBackup = unique(dataset$site)
  
  r = length(unique(dataset$rep))
  y = length(unique(dataset$year))
  s = length(unique(dataset$site))
  
  
  if(length(unique(dataset$site)) > 1){
    
    if(length(unique(dataset$year)) > 1){
      
      
      mix.model.an = lmer(trait~rep:site:year+(1|gid)+(1|gid:site) + (1|gid:year) + (1|gid:site:year),data= dataset)
      
      rn = ranef(mix.model.an)
      
      g = convertModel(rn$"gid", c("gid", "g.hat"))
      gy = convertModel(rn$"gid:year", c("gid","year", "gy.hat"))
      gl = convertModel(rn$"gid:site", c("gid","site", "gl.hat"))
      gly = convertModel(rn$"gid:site:year", c("gid","site","year", "gly.hat"))
      
      resposta = merge(g, gy, by = c("gid"))
      resposta = merge(resposta, gl, by = c("gid"))
      resposta = merge(resposta, gly, by = c("gid","site","year")) 
      
    } else {
      
      mix.model.an = lmer(trait~rep:site + (1|gid)+(1|gid:site),data= dataset)
      
      rn = ranef(mix.model.an)
      
      g = convertModel(rn$"gid", c("gid", "g.hat"))
      gy = convertModel(rn$"gid", c("gid", "gy.hat"))
      gl = convertModel(rn$"gid:site", c("gid","site", "gl.hat"))
      gly = convertModel(rn$"gid:site", c("gid","site", "gly.hat"))
      
      resposta = merge(g, gy, by = c("gid"))
      resposta = merge(resposta, gl, by = c("gid"))
      resposta = merge(resposta, gly, by = c("gid","site")) 
      resposta$year = yearBackup
    }
    
  } else {
    
    if(length(unique(dataset$year)) > 1){
      
      mix.model.an = lmer(trait~rep:year+(1|gid) + (1|gid:year) + (1|gid:year),data= dataset)
      
      rn = ranef(mix.model.an)
      
      g = convertModel(rn$"gid", c("gid", "g.hat"))
      gy = convertModel(rn$"gid:year", c("gid","year", "gy.hat"))
      gl = convertModel(rn$"gid", c("gid", "gl.hat"))
      gly = convertModel(rn$"gid:year", c("gid","year", "gly.hat"))
      
      resposta = merge(g, gy, by = c("gid"))
      resposta = merge(resposta, gl, by = c("gid"))
      resposta = merge(resposta, gly, by = c("gid","year")) 
      resposta$site = siteBackup
      
    } else {
      
      mix.model.an = lmer(trait~rep +(1|gid),data= dataset)
      
      rn = ranef(mix.model.an)
      
      g = convertModel(rn$"gid", c("gid", "g.hat"))
      gy = convertModel(rn$"gid", c("gid", "gy.hat"))
      gl = convertModel(rn$"gid", c("gid", "gl.hat"))
      gly = convertModel(rn$"gid", c("gid", "gly.hat"))
      
      resposta = merge(g, gy, by = c("gid"))
      resposta = merge(resposta, gl, by = c("gid"))
      resposta = merge(resposta, gly, by = c("gid"))
      resposta$site = siteBackup
      resposta$year = yearBackup
      
    }
    
  }
  
  fn = fixef(mix.model.an)[1]
  resposta$y = resposta$g.hat + resposta$gl.hat + resposta$gy.hat + resposta$gly.hat + fn
  resposta = resposta[,c('gid','site','year','g.hat','gy.hat','gl.hat','gly.hat','y')]
  
  hat_table = resposta[,4:7]
  resposta$y.cor = apply(hat_table, 1, function(x) {
    return(sum(x,na.rm=T) + fn)
  })
  
  resp_list = list()
  resp_list$Adjusted.Means.df = resposta
  resp_list$Mu = fn
  resp_list$comps = Comp.var(mix.model.an,r=r,s=s,y=y)
  
  return(resp_list)
}
#==============================================#

#==============================================#
convertModel = function(list_table, colNames) {
  
  rowValues = strsplit(row.names(list_table), split = ":")
  resposta = do.call(rbind, rowValues)
  
  resposta = data.frame(resposta)
  resposta$hat = list_table[,1]
  names(resposta) = colNames
  
  return(resposta)
}
#==============================================#

#==============================================#
Comp.var = function(model,r,s,y) {
  
  vcor = VarCorr(model)
  
  var.total = sum(vcor$"gid"[1], vcor$"gid:year"[1], vcor$"gid:site"[1], vcor$"gid:site:year"[1],sigma(model)^2)
  h2.plot = vcor$"gid"[1]/(vcor$"gid"[1]+vcor$"gid:year"[1] + vcor$"gid:site"[1]+vcor$"gid:site:year"[1]+sigma(model)^2)
  
  Cgy = vcor$"gid:year"[1]/var.total
  Cgl = vcor$"gid:year"[1]/var.total
  Cgly = vcor$"gid:site:year"[1]/var.total
  
  h2.mean = vcor$"gid"[1]/(vcor$"gid"[1]+(vcor$"gid:year"[1]/y) + (vcor$"gid:site"[1]/s)+(vcor$"gid:site:year"[1]/(y*s))+(sigma(model)^2)/(y*r*s))
  return(list(h2.mean=h2.mean,h2.plot=h2.plot,Cgy=Cgy, Cgl = Cgl, Cgly = Cgly))
}
#==============================================#

mean_fun = function(mdl, tabela, spec){
  
  require(dplyr)
  # Get p-values
  p_vals = as.data.frame(summary(mdl)[4])[4]
  names(p_vals) = c("pval")
  # Exclude '(INTERCEPT)' rowname
  p_vals = p_vals[-1, ,FALSE]
  # Genotypes (or specs) greater than 5%
  gen_intcpt = p_vals %>% filter(pval > 0.05) %>% rownames()
  gen_intcpt = str_remove(gen_intcpt, spec)
  #print(gen_intcpt)
  # Separate intercept value
  intcpt = coef(mdl)[1]
  # All genotypes
  gens = p_vals %>% rownames()
  gens = str_remove(gens, spec)
  
  tabela_mean = data.frame(genotipo = c(), emmean = c())
  i = 2
  for(gid in gens){
    if(gid %in% gen_intcpt){
      tabela_mean = rbind(tabela_mean, data.frame(genotipo = gid, emmean = intcpt))
    }
    else{
      tabela_mean = rbind(tabela_mean, data.frame(genotipo = gid, emmean = intcpt + coef(mdl)[i]))
    }
    
    i = i + 1
  }
  
  rownames(tabela_mean) = NULL
  tabela_mean
}


mean_fun = function(mdl, tabela, spec){
  
  # Get p-values
  p_vals = as.data.frame(summary(mdl)[4])[4]
  names(p_vals) = c("pval")
  # Exclude '(INTERCEPT)' rowname
  p_vals = p_vals[-1, ,FALSE]
  # Genotypes (or specs) greater than 5%
  gen_intcpt = p_vals %>% filter(pval > 0.05) %>% rownames()
  gen_intcpt = str_remove(gen_intcpt, spec)
  #print(gen_intcpt)
  # Separate intercept value
  intcpt = coef(mdl)[1]
  # All genotypes
  gens = p_vals %>% rownames()
  gens = str_remove(gens, spec)
  
  tabela_mean = data.frame(genotipo = c(), emmean = c())
  i = 2
  for(gid in gens){
    if(gid %in% gen_intcpt){
      tabela_mean = rbind(tabela_mean, data.frame(genotipo = gid, emmean = intcpt))
    }
    else{
      tabela_mean = rbind(tabela_mean, data.frame(genotipo = gid, emmean = intcpt + coef(mdl)[i]))
    }
    
    i = i + 1
  }
  
  rownames(tabela_mean) = NULL
  tabela_mean
}

#==============================================
# Prepara o banco de dados para ser plotado 
#==============================================
model.GGE = function(tabela) {
  Y = model.Values(tabela)
  gge.model = NULL
  if(!is.null(Y)){
    validate.model = gge(acast(Y, genotipo ~ id_gge, value.var = "emmean"))
    validate.NA = colSums(is.na(validate.model$x))
    validate.NA = length(validate.NA[validate.NA > 1])
    if(validate.NA < 1){
      gge.model = validate.model
    }
  }
  return(gge.model)
}
#==============================================#
model.Values = function(tabela) {
  tryCatch(
    expr = {
      # modelo de efeito fixo
      fixed = dlply(tabela, .(id_ensaio), function(x)
        lm(produtividade ~ genotipo, x))
      means = llply(fixed, function(x)
        mean_fun(x, tabela, spec = "genotipo"))
      
      y = NULL
      for (j in 1:length(means)) {
        y = rbind(y, data.frame(means[[j]], id_ensaio = names(means)[j]))
      }
      
      W = unique(tabela[, c(2, 5)])
      Y = merge(y, W, by = "id_ensaio")
      
      
      Y$id_gge = Y$local
      
      return(Y)
    },
    error = function(e) {
      return(NULL)
    }
  )
}
#==============================================#

#==============================================#
model.deno = function(tabela) {
  Y = model.Values(tabela)
  if(!is.null(Y)){
    tryCatch(
      expr = {
        
        Ym = acast(Y,genotipo ~ id_gge, value.var="emmean")
        ysea = t(gge(Ym)$x)
        
        dd = dist(ysea, method = "euclidean")
        hc = hclust(dd, method = "ward.D2")
        
        return(hc)   
      },
      error = function(e){ 
        return(NULL)
      }
    )
  }
}
#==============================================#

#==============================================#
model.dadosRelatorio = function(dadosRelatorio){
  
  dadosRelatorio = as.data.frame(dadosRelatorio[[1]])
  
  dadosRelatorio = dadosRelatorio %>%
    group_by(gid) %>%
    dplyr::summarize(mean = mean(y, na.rm = TRUE))
  
  return(dadosRelatorio)
}
#==============================================#


#==============================================#
# Calcula os preditos com base no banco de dados, ajustando o modelo adequado
# Note que df nesse caso é o banco de dados filtrado acima

calcula_predict = function(df, trait, rep, site, gid, year, mediaFilterSelect = "TODOS"){
  
  dataset = df[,c(trait, rep, site, gid, year)]
  dataset$rep = as.factor(dataset$rep)
  names(dataset) = c("trait","rep", "site", "gid", "year")
  yearBackup = unique(dataset$year)
  siteBackup = unique(dataset$site)
  
  r = length(unique(dataset$rep))
  y = length(unique(dataset$year))
  s = length(unique(dataset$site))
  
  if(length(unique(dataset$site)) > 1){
    if(length(unique(dataset$year)) > 1){
      mix.model.an = lmer(trait~rep:site:year+(1|gid)+(1|gid:site) + (1|gid:year) + (1|gid:site:year),data= dataset)
    } else {
      mix.model.an = lmer(trait ~ rep:site + (1|gid) + (1|gid:site), data = dataset)
    }
    
  } else {
    if(length(unique(dataset$year)) > 1){
      mix.model.an = lmer(trait ~ rep:year + (1|gid) + (1|gid:year), data= dataset)
    } else {
      mix.model.an = lmer(trait~rep +(1|gid),data= dataset)
    }
  }
  
  fn = fixef(mix.model.an)[1]
  resposta = dataset
  resposta$predicts = predict(mix.model.an, newdata = dataset, allow.new.levels = TRUE)
  resposta = resposta[,c('gid','site','year','predicts')]
  mediaPredict = mean(resposta$predicts)
  
  
  resp_list = list()
  resp_list$pred = resposta
  resp_list$Mu = fn
  resp_list$mdl = mix.model.an
  
  return(resp_list)
}
#==============================================#

#==============================================#
plot_predict = function(data_plot){
  
  # Inicializa lista de gráficos
  graficos = list()
  
  # Barplot
  # para conseguir fazer esse gráfico preciso modificar um pouco os dados
  
  modified_data = data_plot %>% 
    # Agrupar por genotipo e calcular media e mediana
    group_by(gid) %>% 
    summarise(mean_pred = mean(predicts), median = median(predicts))
  
  # Muda o df para formato long
  long = melt(modified_data,id.vars="gid")
  
  
  graficos$barplot = ggplot(data = long, aes(x=reorder(gid,value), y=value, fill=variable)) + 
    geom_bar(stat = "identity",
             position="dodge") +
    xlab("Genótipos") +
    ylab("Predict") +
    coord_flip() + 
    scale_fill_discrete(name="",
                        labels=c("Média", "Mediana"))+
    scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) +
    theme_light()
  
  # Boxplot locais
  locais = unique(data_plot$site)
  i = 2
  for (loc in locais) {
    
    graficos[[i]] = ggplot(data = data_plot %>% filter(site == loc), aes(x=reorder(gid,predicts), y=predicts)) + 
      geom_boxplot( fill = "lightyellow") + 
      stat_boxplot(geom ='errorbar') + 
      xlab("Genótipos") +
      ylab("Produtividade predita") +
      coord_flip() + 
      theme_light() +
      facet_grid(~site)
    
    names(graficos)[i] = paste0("graficoboxplot",loc)
    
    i = i + 1
  }
  
  locais = unique(data_plot$site)
  i = 2
  for (loc in locais) {
    
    graficos[[i]] = ggplot(data = data_plot %>% filter(site == loc), aes(x=reorder(gid,predicts), y=predicts)) + 
      geom_boxplot( fill = "lightyellow") + 
      stat_boxplot(geom ='errorbar') + 
      xlab("Genótipos") +
      ylab("Predict") +
      coord_flip() + 
      theme_light() +
      facet_grid(~site)
    
    names(graficos)[i] = paste0("graficoboxplot",loc)
    
    i = i + 1
  }
  
  # Heatmap (Locais e genótipos)
  graficos$heatmap = data_plot %>% 
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
  
  # Clusters
  cluster_data = data_plot %>% 
    # Agrupar por genotipo e calcular media
    group_by(gid) %>% 
    summarise(mean_pred = mean(predicts))
  # Selecionar o numero de clusters
  k_val = 5
  # Salva os clusters referentes a cada observacao
  set.seed(123)
  clusters_obs = kmeans(cluster_data[2], k_val, nstart = 50)$cluster
  # Adiciona os clusters no df
  cluster_data = data.frame(cluster_data, grupos = (clusters_obs))
  # Coloca o df em ordem crescente
  cluster_data = cluster_data[order(cluster_data$mean_pred),]
  rownames(cluster_data) = NULL
  
  # Fixa um df para colocar o numero de clusters em ordem crescente
  cluster_data_pin = cluster_data
  s_want = 1:length(unique(clusters_obs))
  s_now = unique(cluster_data$cluster)
  # Finalmente coloca em ordem crescente
  for(i in 1:length(unique(clusters_obs))){
    
    cluster_data_pin[cluster_data == s_now[i]] = s_want[i]
    
  }
  
  # Precisamos obter tambem os intervalos de cada cluster
  # Simulando de 1 em 1
  set.seed(123)
  clusters_obs_sim = kmeans(min(cluster_data$mean_pred):max(cluster_data$mean_pred), k_val, nstart = 50)$cluster
  
  sim_data = data.frame(predicts = min(cluster_data$mean_pred):max(cluster_data$mean_pred), grupos = clusters_obs_sim) %>% group_by(grupos)
  sim_data = data.frame(sim_data)
  
  sim_data = sim_data[order(sim_data$predicts),]
  sim_data_pin = sim_data
  
  #seq_want = 1:length(unique(res.km.real))
  s_now_sim = unique(sim_data_pin$grupos)
  
  for(i in 1:length(unique(clusters_obs_sim))){
    
    sim_data_pin[sim_data == s_now_sim[i]] = s_want[i]
    
  }
  
  # Definir intervalos entre os clusters
  intervals = matrix(nrow = length(unique(sim_data_pin$grupos)),ncol = 2)
  for(i in 1:length(unique(sim_data_pin$grupos))){
    
    intervals[i,1] = round(min(sim_data_pin %>% filter(grupos == i) %>% summarise(predicts)),0)-1
    intervals[i,2] = round(max(sim_data_pin %>% filter(grupos == i) %>% summarise(predicts)),0)
    
  }
  
  # Intervalos em string para o grafico
  fill_label = c()
  fill_label[1] = paste0("[",intervals[1,1],",",intervals[1,2],"]")
  
  for(i in 2:length(unique(sim_data_pin$grupos))){
    
    fill_label[i] = paste0("(",intervals[i,1],",",intervals[i,2],"]")
    
  }
  
  # Enfim o grafico do cluster
  graficos$cluster = ggplot(cluster_data_pin, aes(x=grupos, y=reorder(gid,grupos), fill = as.factor(grupos))) +
    geom_bar(stat='identity') +
    theme(axis.text.x = element_blank(),
          axis.ticks.x = element_blank()) +
    labs(y = "Genótipos", 
         x = "",
         fill = "Grupos (kg/ha)",
    ) +
    scale_fill_discrete(labels = fill_label)
  
  return(graficos)
  
}
#==============================================#

#==============================================#
# Função para clusterizar o banco de dados e ordená-los
#==============================================#
ordena_cluster = function(tabela, coluna_cluster){
  # Cluster
  km = kmeans(tabela[coluna_cluster], 3, nstart = 75)
  # Adicionar os grupos em uma coluna do banco de dados
  cluster_data = data.frame(tabela, classificacao = km$cluster)
  # Sequência para ordenar
  s_want = c("Low","Medium","High")
  # Sequência existente
  s_now = unique(cluster_data$classificacao)
  # Finalmente coloca em ordem crescente
  for(i in 1:length(unique(cluster_data$classificacao))){
    
    cluster_data[cluster_data == s_now[i]] = s_want[i]
    
  }
  
  # classificacao como fator
  cluster_data$classificacao = as.factor(cluster_data$classificacao)
  
  return(cluster_data)
}

#==============================================#
# Função para contar as classificações
#==============================================#
count_class = function(tabela_cluster){
  
  genotipos = unique(tabela_cluster$genotipo)
  locais = unique(tabela_cluster$local)
  
  contagens = data.frame(genotipo = c(), local = c(), Low = c(), Medium = c(), High = c())
  
  for(gid in genotipos){
    
    for(loc in locais){
      contagens = rbind(contagens,
                         data.frame(
                           genotipo = gid,
                           local = loc,
                           Low = length(subset(tabela_cluster, genotipo == gid & classificacao == "Low" & local == loc)$classificacao),
                           Medium = length(subset(tabela_cluster, genotipo == gid & classificacao == "Medium" & local == loc)$classificacao),
                           High = length(subset(tabela_cluster, genotipo == gid & classificacao == "High" & local == loc)$classificacao)))
    }
    
  }
  return(contagens)
}

#==============================================#
# PGP (Potencial Gen. de Prod.)
#==============================================#
gen_prod_pot <- function(dados){
  
  tab_cluster <- ordena_cluster(dados, "produtividade")
  tab_classe <- count_class(tab_cluster)
  
  tab_classe$totalcont <- rowSums(tab_classe[3:5])
  tab_classe$a <- tab_classe$Low/tab_classe$totalcont
  tab_classe$b <- tab_classe$Medium/tab_classe$totalcont
  tab_classe$c <- tab_classe$High/tab_classe$totalcont
  
  A <- 0
  B <- 5
  C <- 10
  
  tab_classe$notas <- A*tab_classe$a + B*tab_classe$b + C*tab_classe$c
  tab_classe <- na.omit(tab_classe)
  
  return(tab_classe)
}
