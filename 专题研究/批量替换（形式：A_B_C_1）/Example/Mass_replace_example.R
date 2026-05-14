library(tidyverse)
source("./Function.R")
getwd()

# ----------------------------------------------------------------------------
# 示例：

# 情形一：将“*pʰ_bʰ_1”替换成“pʰ{f}_bʰ{f}_1”
df_original_1 <- read_csv("./Example/RawData_Example/txt_original_1.csv")

df_model_1 <- read_csv("./Example/RawData_Example/txt_model_1.csv")

df_connect_1 <- Connect(df_original_1,df_model_1)

df_modify_1 <- left_join(
  df_original_1,
  df_connect_1,
  by = "PCM_original"
) %>% 
  select(PCM_modify)

# write_csv(df_modify_1,"./Example/Result_Example/txt_modify_1.csv")

# ----------------------------------------------------------------------------

# 情形二：将“ot{(uai);(ue)}_yot{uai;ue}_1”替换成“ot{uai;ue}_yot{uai;ue}_1”
# 情形二可以看作情形一的推广，应用中可以兼容情形一
df_original_2 <- read_csv("./Example/RawData_Example/txt_original_2.csv")
df_original_2_transformed <- df_original_2  %>% 
  mutate(across(everything(),~str_remove_all(.x,"\\{.+?\\}"))) # 转换成情形一来解决

df_model_2 <- read_csv("./Example/RawData_Example/txt_model_2.csv")

df_connect_2 <- Connect(df_original_2_transformed,df_model_2)

df_modify_2 <- left_join(
  df_original_2_transformed,
  df_connect_2,
  by = "PCM_original"
) %>% 
  select(PCM_modify)

# write_csv(df_modify_2,"./Example/Result_Example/txt_modify_2.csv")

# ----------------------------------------------------------------------------


