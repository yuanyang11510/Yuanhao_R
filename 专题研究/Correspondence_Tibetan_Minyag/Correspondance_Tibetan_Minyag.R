library(tidyverse)
library(readxl)

# 快捷键：
# Command + 回车：运行一行
# Command + Shift + 回车：全部运行
# Command + Shift + C：注释/取消注释

# 如果要清空所有变量，运行下面这行代码
# rm(list = ls())

tbl_n <- read_xlsx("./Source/N_Tibetan_Minyag.xlsx") %>% 
  rename(
    木雅语 = 语音形式,
    古藏文 = 藏文转写,
    I_1.Tibetan = 声1...7,
    R_1.Tibetan = 韵1...8,
    I_2.Tibetan = 声2...9,
    R_2.Tibetan = 韵2...10,
    I_3.Tibetan = 声3...11,
    R_3.Tibetan = 韵3...12,
    I_4.Tibetan = 声4...13,
    R_4.Tibetan = 韵4...14,
    I_5.Tibetan = 声5...15,
    R_5.Tibetan = 韵5...16,
    I_1.Minyag = 声1...17,
    R_1.Minyag = 韵1...18,
    I_2.Minyag = 声2...19,
    R_2.Minyag = 韵2...20,
    I_3.Minyag = 声3...21,
    R_3.Minyag = 韵3...22,
    I_4.Minyag = 声4...23,
    R_4.Minyag = 韵4...24,
    I_5.Minyag = 声5...25,
    R_5.Minyag = 韵5...26
  ) %>% 
  select(古藏文,木雅语,中文释义,contains(c("Tibetan","Minyag"))) %>% 
  mutate(
    across(everything(),as.character),
    across(everything(),~replace_na(.x,""))
  )

tbl_adj <- read_xlsx("./Source/Adj_tibetan_minyag.xlsx") %>% 
  rename(
    木雅语 = 语音形式,
    古藏文 = common,
    I_1.Tibetan = 声1,
    R_1.Tibetan = 韵1,
    I_2.Tibetan = 声2,
    R_2.Tibetan = 韵2,
    I_3.Tibetan = 声3,
    R_3.Tibetan = 韵3,
    I_1.Minyag = M声1,
    R_1.Minyag = M韵1,
    I_2.Minyag = M声2,
    R_2.Minyag = M韵2,
    I_3.Minyag = M声3,
    R_3.Minyag = M韵3,
  ) %>% 
  select(古藏文,木雅语,中文释义,contains(c("Tibetan","Minyag"))) %>% 
  mutate(
    across(everything(),as.character),
    across(everything(),~replace_na(.x,""))
  )

tbl_v <- bind_rows(
  read_xlsx("./Source/V_tibetan_minyag.xlsx",sheet = 1) %>% 
    select(infinite,gloss,common,contains(c("声","韵"))) %>% 
    mutate(Class = 1),
  read_xlsx("./Source/V_tibetan_minyag.xlsx",sheet = 2) %>% 
    select(infinite,gloss,common,contains(c("声","韵"))) %>% 
    mutate(Class = 2),
  read_xlsx("./Source/V_tibetan_minyag.xlsx",sheet = 3) %>% 
    select(infinite,gloss,common,contains(c("声","韵"))) %>% 
    mutate(Class = 3),
  read_xlsx("./Source/V_tibetan_minyag.xlsx",sheet = 4) %>% 
    select(infinite,gloss,common,contains(c("声","韵"))) %>% 
    mutate(Class = 4),
  read_xlsx("./Source/V_tibetan_minyag.xlsx",sheet = 5) %>% 
    select(infinite,gloss,common,contains(c("声","韵"))) %>% 
    mutate(Class = 5),
  read_xlsx("./Source/V_tibetan_minyag.xlsx",sheet = 6) %>% 
    select(infinite,gloss,common,contains(c("声","韵"))) %>% 
    mutate(Class = 6),
  read_xlsx("./Source/V_tibetan_minyag.xlsx",sheet = 7) %>% 
  select(infinite,gloss,common,contains(c("声","韵"))) %>% 
  mutate(Class = 7)
) %>% 
  rename(
    木雅语 = infinite,
    中文释义 = gloss,
    古藏文 = common,
    I_1.Tibetan = 声1,
    R_1.Tibetan = 韵1,
    I_2.Tibetan = 声2,
    R_2.Tibetan = 韵2,
    I_3.Tibetan = 声3,
    R_3.Tibetan = 韵3,
    I_1.Minyag = M声1,
    R_1.Minyag = M韵1,
    I_2.Minyag = M声2,
    R_2.Minyag = M韵2,
    I_3.Minyag = M声3,
    R_3.Minyag = M韵3,
  ) %>% 
  select(古藏文,木雅语,中文释义,contains(c("Tibetan","Minyag"))) %>% 
  mutate(
    across(everything(),as.character),
    across(everything(),~replace_na(.x,""))
  )

tbl_tibetan <- read_xlsx("./Source/Tibetan.xlsx") %>% 
  rename(
    康定藏语 = DT,
    古藏文 = CT,
    中文释义 = 汉义,
    I_1.OT = O1,
    R_1.OT = R1,
    I_2.OT = O2,
    R_2.OT = R2,
    I_3.OT = O3,
    R_3.OT = R3,
    I_4.OT = O4,
    R_4.OT = R4,
    I_5.OT = O5,
    R_5.OT = R5,
    I_6.OT = O6,
    R_6.OT = R6,
    I_1.KT = "声1-调1",
    R_1.KT = 韵1,
    I_2.KT = "声2-调2",
    R_2.KT = 韵2,
    I_3.KT = "声3-调3",
    R_3.KT = 韵3,
    I_4.KT = "声4-调4",
    R_4.KT = 韵4,
    I_5.KT = "声5-调5",
    R_5.KT = 韵5,
    I_6.KT = "声6-调6",
    R_6.KT = 韵6
  ) %>% 
  select(古藏文,康定藏语,中文释义,contains(c("OT","KT"))) %>% 
  mutate(
    across(everything(),as.character),
    across(everything(),~replace_na(.x,""))
  )
  
# 最新的做法
# 名词
tbl_corresp_n <- tbl_n %>% 
  pivot_longer(
    cols = contains(c("Tibetan","Minyag")),
    names_to = c("IR",".value"),
    names_sep = "\\." # 或者names_pattern = "([IR]_\\d+)\\.(.+)"
  ) %>% 
  group_by(古藏文,木雅语,中文释义) %>% 
  mutate(
    Syllable_n_Tibetan = length(which(Tibetan != ""))/2,
    Syllable_n_Minyag = length(which(Minyag != ""))/2,
    Syllable_n = str_c("T:", Syllable_n_Tibetan, ";M:", Syllable_n_Minyag)
  ) %>% 
  ungroup()%>% 
  select(-c(Syllable_n_Tibetan,Syllable_n_Minyag)) %>%
  # 筛选出T中的相应音节数的词
  filter(str_detect(Syllable_n,"T:1")) %>% 
  # 筛选出需要考察的音位
  filter(Tibetan == "p") %>% 
  summarise(
    .by = -c(IR,木雅语,古藏文,中文释义,Syllable_n),
    Total = n(),
    IR = str_c(IR,collapse = " ; "),
    木雅语 = str_c(木雅语,collapse = " ; "),
    古藏文 = str_c(古藏文,collapse = " ; "),
    中文释义 = str_c(中文释义,collapse = " ; "),
    Syllable_n = str_c(Syllable_n,collapse = " ; ")
  )

# 形容词
tbl_corresp_adj <- tbl_adj %>% 
  pivot_longer(
    cols = contains(c("Tibetan","Minyag")),
    names_to = c("IR",".value"),
    names_sep = "\\." # 或者names_pattern = "([IR]_\\d+)\\.(.+)"
  ) %>% 
  group_by(古藏文,木雅语,中文释义) %>% 
  mutate(
    Syllable_n_Tibetan = length(which(Tibetan != ""))/2,
    Syllable_n_Minyag = length(which(Minyag != ""))/2,
    Syllable_n = str_c("T:", Syllable_n_Tibetan, ";M:", Syllable_n_Minyag)
  ) %>% 
  ungroup()%>% 
  select(-c(Syllable_n_Tibetan,Syllable_n_Minyag)) %>%
  # 筛选出T中的相应音节数的词
  filter(str_detect(Syllable_n,"T:1")) %>% 
  # 筛选出需要考察的音位
  filter(Tibetan == "dk") %>% 
  summarise(
    .by = -c(IR,木雅语,古藏文,中文释义,Syllable_n),
    Total = n(),
    IR = str_c(IR,collapse = " ; "),
    木雅语 = str_c(木雅语,collapse = " ; "),
    古藏文 = str_c(古藏文,collapse = " ; "),
    中文释义 = str_c(中文释义,collapse = " ; "),
    Syllable_n = str_c(Syllable_n,collapse = " ; ")
  )

# 动词
tbl_corresp_v <- tbl_v %>% 
  pivot_longer(
    cols = contains(c("Tibetan","Minyag")),
    names_to = c("IR",".value"),
    names_sep = "\\." # 或者names_pattern = "([IR]_\\d+)\\.(.+)"
  ) %>% 
  group_by(古藏文,木雅语,中文释义) %>% 
  mutate(
    Syllable_n_Tibetan = length(which(Tibetan != ""))/2,
    Syllable_n_Minyag = length(which(Minyag != ""))/2,
    Syllable_n = str_c("T:", Syllable_n_Tibetan, ";M:", Syllable_n_Minyag)
  ) %>% 
  ungroup()%>% 
  select(-c(Syllable_n_Tibetan,Syllable_n_Minyag)) %>%
  # 筛选出T中的相应音节数的词
  filter(str_detect(Syllable_n,"T:1")) %>% 
  # 筛选出需要考察的音位
  filter(Tibetan == "b") %>% 
  summarise(
    .by = -c(IR,木雅语,古藏文,中文释义,Syllable_n),
    Total = n(),
    IR = str_c(IR,collapse = " ; "),
    木雅语 = str_c(木雅语,collapse = " ; "),
    古藏文 = str_c(古藏文,collapse = " ; "),
    中文释义 = str_c(中文释义,collapse = " ; "),
    Syllable_n = str_c(Syllable_n,collapse = " ; ")
  )

# 古藏语-康定藏语
tbl_corresp_tibetan <- tbl_tibetan %>% 
  pivot_longer(
    cols = contains(c("OT","KT")),
    names_to = c("IR", ".value"),
    names_sep = "\\."
  ) %>% 
  group_by(古藏文, 康定藏语, 中文释义) %>% 
  mutate(
    Syllable_n_OT = length(which(OT != ""))/2,
    Syllable_n_KT = length(which(KT != ""))/2,
    Syllable_n = str_c("OT:", Syllable_n_OT, ";KT:", Syllable_n_KT)
  ) %>% 
  ungroup()%>% 
  select(-c(Syllable_n_OT,Syllable_n_KT)) %>%
  # 筛选出OT的相应音节数的词
  filter(str_detect(Syllable_n,"OT:1")) %>% 
  # 筛选出需要考察的音位
  filter(OT == "b") %>% 
  summarise(
    .by = -c(IR,古藏文,康定藏语,中文释义,Syllable_n),
    古藏文 = str_c(古藏文,collapse = " ; "),
    康定藏语 = str_c(康定藏语,collapse = " ; "),
    中文释义 = str_c(中文释义,collapse = " ; "),
    IR = str_c(IR,collapse = " ; "),
    Total = n(),
    Syllable_n = str_c(Syllable_n,collapse = " ; ")
  )

# 导出表格
# write_excel_csv(tbl_corresp_n,"./Result/Correspondence_N.csv")
# write_excel_csv(tbl_corresp_adj,"./Result/Correspondence_Adj.csv")
# write_excel_csv(tbl_corresp_v,"./Result/Correspondence_V.csv")
# write_excel_csv(tbl_corresp_tibetan,"./Result/Correspondence_Tibetan.csv")

# --------------------------------------------------------------------------------------------

# 以前的做法
# tbl_tibetan <- tbl %>% 
#   select(
#     "语音形式",
#     "搭配",
#     "中文释义",
#     "藏文转写",
#     "common",
#     "prove",
#     "形式结构",
#     "多义词",
#     "分类",
#     "号",
#     contains("Tibetan")
#   )
# 
# tbl_minyag <- tbl %>% 
#   select(
#     "语音形式",
#     "搭配",
#     "中文释义",
#     "藏文转写",
#     "common",
#     "prove",
#     "形式结构",
#     "多义词",
#     "分类",
#     "号",
#     contains("Minyag")
#   )
#   
# tbl_longer_tibetan <- tbl_tibetan %>% 
#   pivot_longer(
#     cols = contains(c("Tibetan")),
#     names_to = "IR.Tibetan",
#     values_to = "Value.Tibetan"
#   ) %>% 
#   mutate(Assist = 1:n())
# 
# tbl_longer_minyag <- tbl_minyag %>% 
#   pivot_longer(
#     cols = contains(c("Minyag")),
#     names_to = "IR.Minyag",
#     values_to = "Value.Minyag"
#   ) %>% 
#   mutate(Assist = 1:n())
# 
# tbl_longer_comparison <- full_join(
#   tbl_longer_tibetan,
#   tbl_longer_minyag,
#   by = c("语音形式","搭配","中文释义","藏文转写","common","prove","形式结构","多义词","分类","号","Assist")
# ) %>% 
#   select(-Assist)






