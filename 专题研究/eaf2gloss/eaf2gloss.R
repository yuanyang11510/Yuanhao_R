# 如果本地还没有安装这三个包，运行以下命令
# install.packages(c("tidyverse","readelan","openxlsx"))

# 加载包
library(tidyverse)
library(readelan)
library(openxlsx)

# 导入.eaf文件，每次只需要将"./Source/"之后的内容修改为当前处理的文件名即可，形式为"XXX.eaf"
# 记得设置fill_times = FALSE
tbl_eaf <- read_eaf("./Source/ybe202408200201-int_20260803.eaf",fill_times = FALSE) 

# 处理数据
# 预处理
tbl_pre <- tbl_eaf %>% 
  select(a,annotation,tier,participant,a_ref) %>% 
  mutate(a_new = if_else(is.na(a_ref),a,a_ref),.keep = "unused") %>% 
  distinct()

# 选择一：合并处理
tbl_general <- tbl_pre %>% 
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

# 选择二：分开处理
# 语素标注
tbl_morph_gloss <- tbl_pre %>% 
  filter(tier %in% c(
    "Yang Xuefang_morph-cf-ybe",
    "Yang Xuefang_morph-gls-en",
    "Yang Xuefang_morph-hn-ybe",
    "Yang Xuefang_morph-type",
    "Yang Xuefang_morph-variantTypes-en"
  )) %>% 
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

# 语素切分
tbl_morph_cut <- tbl_pre %>% 
  filter(tier %in% c(
    "Yang Xuefang_morph-txt-ybe",
    "Yang Xuefang_word-txt-ybe"
  )) %>% 
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

# 句子
tbl_sentence <- tbl_pre %>% 
  filter(tier %in% c(
    "Yang Xuefang_phrase-segnum-en",
    "Yang Xuefang_phrase-txt-ybe",
    "Yang Xuefang_phrase-gls-en",
    "Yang Xuefang_phrase-gls-zh-CN"
  )) %>% 
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

# 其他内容
tbl_other <- tbl_pre %>% 
  filter(tier %in% c(
    "Zhencao Zhong_phrase-gls-en",
    "Zhencao Zhong_phrase-segnum-en",
    "Zhencao Zhong_phrase-txt-zh-CN",
    "Zhencao Zhong_word-txt-zh-CN",
    "interlinear-text-date-created-en" , 
    "interlinear-text-date-modified-en",
    "Zhencao Zhong_phrase-gls-zh-CN"
  )) %>% 
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
# 生成的.csv文件里“-”开头的内容会被当做公式，从而显示为“#NAME?”，不方便处理
# 生成的.xlsx文件没这个问题
# write_excel_csv(tbl_general,"./Result/tbl_general.csv")
# write.xlsx(tbl_general,"./Result/tbl_general.xlsx")
# write.xlsx(tbl_morph_gloss,"./Result/tbl_morph_gloss.xlsx")
# write.xlsx(tbl_morph_cut,"./Result/tbl_morph_cut.xlsx")
# write.xlsx(tbl_sentence,"./Result/tbl_sentence.xlsx")
# write.xlsx(tbl_other,"./Result/tbl_other.xlsx")

