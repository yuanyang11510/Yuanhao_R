library(tidyverse)
getwd()

# ----------------------------------------------------------------------------

# 构造一个连接函数Connect()
Connect <- function (df_original,df_model) {
  df_connect = df_original %>% 
    distinct() %>%
    mutate(copy_PCM_original = factor(PCM_original,levels = unique(PCM_original))) %>% 
    separate_wider_regex(
      cols = PCM_original,
      patterns = c(PCM_original = ".+","_",Suffix = "\\d+.*"),
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
    mutate(across(everything(),~replace_na(.x,""))) %>%
    left_join(
      df_model,
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
    rename(PCM_original = copy_PCM_original)
  return(df_connect)
}

# ----------------------------------------------------------------------------

# 情形一：将“*pʰ_bʰ_1”替换成“pʰ{f}_bʰ{f}_1”
df_original_1 <- read_csv("./RawData/txt_original_1.csv") %>% 
  mutate(across(everything(),~str_remove_all(.x,"\\*")))

df_model_1 <- read_csv("./RawData/txt_model_1.csv") %>% 
  distinct() %>% 
  mutate(across(everything(),~str_remove_all(.x,"\\*"))) %>% 
  mutate(Initial_Bare = str_extract(PCM,".+(?=\\{)"))

df_connect_1 <- Connect(df_original_1,df_model_1)

df_modify_1 <- left_join(df_original_1,df_connect_1,by = "PCM_original") %>% 
  select(PCM_modify) %>% 
  mutate(across(PCM_modify,~paste0("*",.x)))

write_csv(df_modify_1,"./Result/txt_modify_1.csv")

# ----------------------------------------------------------------------------

# 情形二：将“ot{(uai);(ue)}_yot{uai;ue}_1”替换成“ot{uai;ue}_yot{uai;ue}_1”
df_original_2 <- read_csv("./RawData/txt_original_2.csv") %>% 
  mutate(
    across(everything(),
           ~str_remove_all(.x,"\\*") %>% 
             str_remove_all("\\{.+?\\}") # across()中使用管道符时，第一个参数位置的占位符“.”不能随便使用
           )
    ) # 转换成情形一来解决

df_model_2 <- read_csv("./RawData/txt_model_2.csv") %>% 
  distinct() %>% 
  mutate(across(everything(),~str_remove_all(.x,"\\*"))) %>% 
  mutate(Initial_Bare = str_extract(PCM,".+(?=\\{)"))

df_connect_2 <- Connect(df_original_2,df_model_2)

df_modify_2 <- left_join(df_original_2,df_connect_2,by = "PCM_original") %>% 
  select(PCM_modify) %>% 
  mutate(across(PCM_modify,~paste0("*",.x)))

write_csv(df_modify_2,"./Result/txt_modify_2.csv")

# ----------------------------------------------------------------------------




