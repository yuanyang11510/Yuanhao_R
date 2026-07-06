library(tidyverse)
source("./Function.R")
getwd()

# ----------------------------------------------------------------------------
# 应用：

df_original <- read_csv("./RawData/txt_original.csv")
df_original_transformed <- df_original %>% 
  mutate(across(everything(),~str_remove_all(.x,"\\{.+?\\}")))

df_model <- read_csv("./RawData/txt_model.csv")

df_connect <- Connect(df_original_transformed,df_model)

df_modify <- left_join(
  df_original_transformed,
  df_connect,
  by = "PCM_original"
) %>% 
  select(PCM_modify)

# write_csv(df_modify,"./Result/txt_modify.csv")

# ----------------------------------------------------------------------------

