# 如果本地还没有安装这两个包，运行以下命令
# install.packages(c("tidyverse","readelan"))

# 加载包
library(tidyverse)
library(readelan)

# 导入.eaf文件，每次只需要将"./Source/"之后的内容修改为当前处理的文件名即可，形式为"XXX.eaf"
tbl_eaf <- read_eaf("./Source/ybe202408200201-int_20260803.eaf") 

# 处理数据
tbl_gloss <- tbl_eaf %>% 
  select(a,annotation,tier,participant,a_ref) %>% 
  mutate(a_new = if_else(is.na(a_ref),a,a_ref),.keep = "unused") %>% 
  distinct() %>% 
  group_by(a_new,tier) %>% 
  mutate(Freq = 1:n()) %>% 
  ungroup() %>% 
  mutate(tier_new = str_c(tier,"_",Freq),.keep = "unused") %>% 
  pivot_wider(
    names_from = tier_new,
    values_from = annotation
  ) %>%
  mutate(across(everything(),~na_if(.x,""))) %>% 
  filter(if_any(!contains(c("participant","a_new")),~!is.na(.))) %>% 
  mutate(across(everything(),~replace_na(.x,"")))

# 导出.csv文件,输出的文件名可以通过"./Result/"之后的内容修改，形式为"XXX.csv"
write_excel_csv(tbl_gloss,"./Result/sample.csv")

