# compute for AND combination and OR combination separately
  pred <- enframe(rowMeans(pred_matrix(x)),
                  name='Sample_ID', value="pred_status") %>% 
    full_join(tibble(Sample_ID=rownames(meta(x)),
                     ca_status=meta(x)$coded_ca), by='Sample_ID') %>% 
    full_join(enframe(label(x)$label, 
                      name='Sample_ID', value='Group'), by='Sample_ID')
  pred$ca_status <- as.numeric(pred$ca_status)
  # AND combo
  combo <- pred %>% 
    filter(ca_status!=0) %>% 
    mutate(ca_status=case_when(ca_status==-1~0, TRUE~ca_status)) %>% 
    mutate(combo=pred_status*ca_status)
  roc.and.red <- roc(predictor=combo$combo, response=combo$Group, 
                     levels = c(-1, 1), direction = '<')
  
  combo <- pred %>% 
    mutate(ca_status=case_when(ca_status==-1~0, TRUE~ca_status)) %>% 
    mutate(combo=pred_status*ca_status)
  roc.and <- roc(predictor=combo$combo, response=combo$Group, 
                 levels = c(-1, 1), direction = '<')
  
  # OR combo
  combo <- pred %>% 
    filter(ca_status!=0) %>% 
    mutate(ca_status=case_when(ca_status==-1~0, TRUE~ca_status)) %>% 
    mutate(combo=pred_status+ca_status)
  roc.or.red <- roc(predictor=combo$combo, response=combo$Group, 
                    levels = c(-1, 1), direction = '<')
  
  combo <- pred %>% 
    mutate(ca_status=case_when(ca_status==-1~0, TRUE~ca_status)) %>% 
    mutate(combo=pred_status+ca_status)
  roc.or <- roc(predictor=combo$combo, response=combo$Group, 
                levels = c(-1, 1), direction = '<')
  
  df.res <- list('or'=roc.or, 'or.red'=roc.or.red, 
                 'and'=roc.and, 'and.red'=roc.and.red)
  return(df.res)
}
# combine Ca19-9 with microbiome data
sc.ca19=.f_and_or_combination(siamcat.pc)
sc.ca19.pos=.f_and_or_combination(siamcat.pos)
save(sc.ca19.pos,sc.ca19, file = paste0(PARAM$folder.results, 
                                        'ca19-9.combined.Rdata'))


