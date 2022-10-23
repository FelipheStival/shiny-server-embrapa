#================================================
# Metodo para obter os dados das doencas
#================================================
getDadosDoencasProvider = function(){
  sql = 'select distinct
          	  lo.NOME as local,
              ci.NOME as cidade,
              es.NOME as estado,
              en.FUNGICIDA as fungicida,
              en.IRRIGACAO as irrigacao,
              ge.NOME as genotipo,
              ti.SIGLA as tipo_de_grao,
              en.REPETICAO as repeticao,
              en.DATA_SEMEADURA as data_semeadura,
              gd.VALOR_FS as valor_FS,
          	  gd.VALOR_FO as valor_FO,
              en.SAFRA as safra,
              en.ID_ENSAIO as id_ensaio
          from
          	GENOTIPOS_DOENCAS gd
          	JOIN ENSAIOS en on en.ID_GENOTIPO = gd.ID_GENOTIPO
          	JOIN genotipos ge on ge.ID = en.ID_GENOTIPO
          	JOIN locais lo on lo.ID = en.ID_LOCAL
          	JOIN cidades ci on ci.ID = lo.ID_CIDADE
          	JOIN estados es on es.ID = ci.ID_ESTADO
          	JOIN tipos_de_graos ti on ti.ID = ge.ID_TIPO_GRAO
  ';
  
  set.seed(12432)
  
  dados = banco.provider.executeQuery(sql, DOENCA_DB_DATABASE)
  dados = dados[,c('local', 'cidade', 'estado', 'fungicida', 'irrigacao', 'genotipo', 'tipo_de_grao', 'repeticao', 'data_semeadura', 'valor_fs', 'valor_fo', 'safra', 'id_ensaio')]
  names(dados) = c('local', 'cidade', 'estado', 'fungicida', 'irrigacao', 'genotipo', 'tipo_de_grao', 'repeticao', 'data_semeadura', 'FS', 'FO', 'safra', 'id_ensaio')
  
  wdata <- dados %>% filter(!is.na(FO), !is.na(FS), FO <= 10, FS <= 10) %>% mutate(FO = str_replace(FO, ",", "."),
                                                                                   FS = str_replace(FS, ",", ".")) %>% 
    mutate(FO = as.numeric(FO), FS = as.numeric(FS)) %>% 
    mutate(genotipo = as.factor(genotipo))
  
  agrupados <- wdata %>% group_by(genotipo, cidade, safra) %>% dplyr::summarize(Media_fs = mean(FS),
                                                                         Media_fo = mean(FO),
                                                                         quantidade = n())
  fo_modelo <- KMEANS(agrupados$Media_fo, k = 3)
  fs_modelo <- KMEANS(agrupados$Media_fs, k = 3)
  
  
  mudanca <- tibble(notas = seq(0, 10, 0.001), previsao_fs = as.factor(predict(fs_modelo, notas)), 
                    previsao_fo = as.factor(predict(fo_modelo, notas)))
  
  
  
  fs_mudanca <- mudanca %>% group_by(previsao_fs) %>% summarize(maximo = max(notas))
  fo_mudanca <- mudanca %>% group_by(previsao_fo) %>% summarize(maximo = max(notas))
  
  ordem_fo <- c("1", "2", "3")
  ordem_fs <- c("3", "1", "2")
  ordem <- c("Resistente", "Neutro", "Sensível")
  
  wdata <- wdata %>% mutate(previsao_fs = factor(predict(fs_modelo, FS), levels = ordem_fs, label = ordem) , 
                            previsao_fo = factor(predict(fo_modelo, FO), levels = ordem_fo, label = ordem))
  
  list = list()
  list[[1]] = agrupados
  list[[2]] = fs_modelo
  list[[3]] = fo_modelo
  list[[4]] = ordem_fs
  list[[5]] = ordem_fo
  list[[6]] = ordem
  
  return(list)
  
}

funcaoAgregacao = function(x){
  if(x){
    return(x)
  }
  return(NA)
}

