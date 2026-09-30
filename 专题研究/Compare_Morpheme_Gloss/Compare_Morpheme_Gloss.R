library(tidyverse)

# 读取数据
txt <- readLines("./专题研究/Compare_Morpheme_Gloss/Source/yuwanh'ao-de.txt")
vec_phrase <- txt[42] # 句子向量
vec_morpheme <- txt[46] # 语素向量
vec_gloss <- txt[48] # 标注向量

vec_phrase
vec_morpheme
vec_gloss

# 构造一个函数，在"="和"-"前面添加一个空格" "
AddSpace <- function (vec) {
  vec_add_space <- vec %>% 
    str_replace_all(
      "=|-",
      ~for (i in c("=","-")) {
        if (.x == i) {
          return(str_c(" ",.x))
        }
      }
    )
  return(vec_add_space)
}

# 构造一个函数，根据指定的分隔符拆分字符串，并进行归一化
Split <- function (vec,delimiter) {
  vec_split <- vec %>% 
    str_split_1(delimiter) %>%
    str_trim %>%
    str_replace_all("\\s+"," ") %>%
    keep(nzchar)
  return(vec_split)  
}

# 为语素向量和标注向量中的"="和"-"的前面添加空格" "
vec_morpheme_add_space <- vec_morpheme %>% AddSpace()
vec_gloss_add_space <- vec_gloss %>% AddSpace()

vec_morpheme_add_space
vec_gloss_add_space

# 将句子向量、语素向量和标注向量按照小句标记","切分成小句单位
lst_phrase_as_clause <- vec_phrase %>% Split(",")
lst_morpheme_as_clause <- vec_morpheme_add_space %>% Split(",")
lst_gloss_as_clause <- vec_gloss_add_space %>% Split(",")

lst_phrase_as_clause
lst_morpheme_as_clause
lst_gloss_as_clause

# 将小句单位的句子向量" "拆分成词语单位
lst_phrase_as_word <- lst_phrase_as_clause %>% map(~Split(.x," "))

# 将小句单位的语素向量和标注向量按照语素标记" "拆分成语素单位
lst_morpheme_as_morpheme <- lst_morpheme_as_clause %>% map(~Split(.x," "))
lst_gloss_as_morpheme <- lst_gloss_as_clause %>% map(~Split(.x," "))

lst_phrase_as_word
lst_morpheme_as_morpheme
lst_gloss_as_morpheme

# 将语素单位和标注单位以小句为单位一一对应，生成对照表
lst_compare_morpheme_gloss <- map2(
  lst_morpheme_as_morpheme,
  lst_gloss_as_morpheme,
  function (vec_morpheme,vec_gloss) {
    tbl <- tibble(
      Morpheme = c("Morpheme",vec_morpheme),
      Gloss = c("Gloss",vec_gloss),
      Equal = if_else(
        str_detect(Morpheme,"=|-") & str_detect(Gloss,"=|-"),
        "gwg", # = "grammatical word gloss"
        if_else(
            Morpheme == Gloss,
            "",
            "to_check"
        )
      )
    ) %>% 
      t() %>% 
      `colnames<-`(c("V",str_c("V",1:(ncol(.)-1)))) %>% 
      as_tibble()
    return(tbl)
  }
)
lst_compare_morpheme_gloss
clause_1 <- lst_compare_morpheme_gloss[[1]] # 第一个小句
clause_2 <- lst_compare_morpheme_gloss[[2]] # 第二个小句
clause_3 <- lst_compare_morpheme_gloss[[3]] # 第三个小句
clause_4 <- lst_compare_morpheme_gloss[[4]] # 第四个小句
