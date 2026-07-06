# 构造一个连接函数Connect()
Connect <- function (df_original,df_model) {
  
  df_original_treated = df_original %>%
    distinct() %>%
    mutate(
      PCM_original = if_else(
        str_detect(PCM_original,"_\\d+.*"),
        PCM_original,
        paste0(PCM_original,"_0")
      )
    ) %>% 
    mutate(copy_PCM_original = factor(PCM_original,levels = unique(PCM_original))) %>%
    mutate(across(PCM_original,~str_remove_all(.x,"\\*"))) %>%
    separate_wider_regex(
      cols = PCM_original,
      patterns = c(PCM_original = "^.+","_",Suffix = "\\d+.*"),
      too_few = "align_start"
    ) %>%
    separate_wider_delim(
      cols = PCM_original,
      delim = "_",
      names_sep = "_",
      too_few = "align_start"
    ) %>%
    pivot_longer(
      cols = matches("_\\d+"),
      names_to = NULL,
      values_to = "Value",
      values_drop_na = TRUE
    ) %>%
    mutate(
      across(
        Value,
        ~{
          add = if_else(
            str_detect(.x,"^\\(.+\\)$|^\\[.+\\]$"),
            str_replace_all(.x,"^(\\()(.+\\))$|^(\\[)(.+\\])$","\\1\\3*\\2\\4"),
            paste0("*",.x)
          )
          return(add)
        }
      )
    ) %>%
    mutate(across(everything(),~replace_na(.x,"")))

  df_model_treated = df_model %>%
    distinct() %>%
    mutate(Initial_Bare = str_extract(PCM,"^.+(?=\\{)"))
  # 
  df_connect = left_join(
      df_original_treated,
      df_model_treated,
      by = join_by(Value == Initial_Bare)
    ) %>%
    select(-c(Value)) %>%
    group_by(copy_PCM_original,Suffix) %>%
  summarise(PCM_modify = paste0(PCM,collapse = "_"),.groups = "drop") %>%
    mutate(
      PCM_modify = ifelse(
        Suffix != "",
        paste(PCM_modify,Suffix,sep = "_"),
        PCM_modify
      )
    ) %>%
    select(-Suffix) %>% 
    mutate(across(everything(),~str_remove_all(.x,"_0$"))) %>% 
    rename(PCM_original = copy_PCM_original)
  return(df_connect)
}



