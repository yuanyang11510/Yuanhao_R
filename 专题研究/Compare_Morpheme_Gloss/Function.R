library(tidyverse)

# 构造一个函数，比对语素内容和标注内容是否相同
Compare_Morpheme_Gloss <- function (txt) {

  # 构造一个内部函数，在"="和"-"前面添加一个空格" "
  AddSpace <- function (vec) {
    vec_add_space <- vec %>% 
      str_replace_all(
        "=|-",
        ~ for (i in c("=","-")) {
          if (.x == i) {
            return(str_c(" ",.x))
          }
        }
      )
    return(vec_add_space)
  }

  # 构造一个内部函数，根据指定的分隔符拆分字符串，并进行归一化
  Split <- function (vec,delimiter) {
    vec_split <- vec %>% 
      str_split_1(delimiter) %>% # 分割字符串
      str_trim() %>%  # 去除首尾空格
      str_replace_all("\\s+"," ") %>% # 将元素内部的多个空格替换为单个空格
      keep(nzchar) # 去除空字符串
    return(vec_split)
  }

  # （0）数据清理
  vec <- txt %>% keep(nzchar) # 去除空字符串

  # （1）以句子为单位将数据对齐
  tbl_1_sentence <- tibble(
      ID_Sentence = vec[seq_along(vec) %% 5 == 1], # 序号
      Sentence = vec[seq_along(vec) %% 5 == 2], # 句子
      Translation = vec[seq_along(vec) %% 5 == 3], # 翻译
      Morpheme = vec[seq_along(vec) %% 5 == 4], # 语素
      Gloss = vec[seq_along(vec) %% 5 == 0] # 标注
    )

  # 为语素列和标注列中的"="和"-"的前面添加空格" "
  tbl_add_space <- tbl_1_sentence %>% 
    mutate(
      Morpheme = AddSpace(Morpheme),
      Gloss = AddSpace(Gloss),
      .keep = "unused"
    )

  # （2）将句子列、语素列和标注列按照小句标记","切分成小句单位
  tbl_2_clause <- tbl_add_space %>% 
    mutate(
      Clause = map(
        Sentence,
        ~ Split(.x,",")
      ),
      .after = Translation
    ) %>% 
    mutate(
      ID_Clause = map2(
        ID_Sentence,Clause,
        ~ str_c(.x,"_",seq_along(.y)
        )
      ),
      .after = ID_Sentence
    ) %>% 
    mutate(
      Morpheme = map(
        Morpheme,
        ~ Split(.x,",")
      ),
      Gloss = map(
        Gloss,
        ~ Split(.x,",")
      ),
      .keep = "unused"
    ) %>% 
    unnest(c(
      ID_Clause,
      Clause,
      Morpheme,
      Gloss
    ))

  # （3）将语素列和标注列中的每个小句再按照语素标记" "拆分成语素单位
  tbl_3_morpheme <- tbl_2_clause %>% 
    mutate(
      Morpheme = map(
        Morpheme,
        ~ Split(.x," ")
      ),
      Gloss = map(
        Gloss,
        ~ Split(.x," ")
      ),
      .keep = "unused"
    ) %>% 
    unnest(c(
      Morpheme,
      Gloss
    ))

  # （4）将语素列和标注列以语素为单位一一对应，判断是否相同
  tbl_4_compare <- tbl_3_morpheme %>% 
    mutate(
      Compare = if_else(
        # 如果Morpheme列和Gloss列中都包含"="或"-"，则标记为"gwg"（grammatical word gloss）
        str_detect(Morpheme, "=|-") &
        str_detect(Gloss, "=|-"),
        "gwg",
        if_else(
          Morpheme == Gloss,
          # 如果Morpheme列和Gloss列相同，则标记为空字符串""
          "",
          # 如果Morpheme列和Gloss列不同，则标记为"to_check"
          "to_check"
        )
      )
    )

    # 可能需要核查的小句
    ID_Clause <- tbl_4_compare %>% 
      filter(Compare == "to_check") %>% 
      pull(ID_Clause) %>% 
      unique()

    # 根据参数mode的取值返回不同的结果
    cat(
        "You could choose the mode :",
        "\n   \033[31mall\033[0m",
        "\nor one of the following ID_Clause :",
        "\n   \033[31m",
        str_c(ID_Clause,collapse = " , "),
        "\033[0m",
        "\nto check.",
        sep = ""
      )
    mode <- readline("Your choice : ")
    
    if (mode == "all") {
      return(tbl_4_compare)
    }
    if (mode %in% ID_Clause) {
      # 根据指定的小句ID筛选数据
      tbl_clause_0 <- tbl_4_compare %>% 
        filter(ID_Clause == mode)
      # 语素、标注和比对结果
      tbl_clause_1 <- tbl_clause_0 %>% 
        select(
          Morpheme,
          Gloss,
          Compare
        ) %>% 
        t() %>% 
        `colnames<-`(str_c("Morph_",1:(ncol(.)))) %>% 
        as_tibble()
      # 小句序号、小句、翻译
      tbl_clause_2 <- tbl_clause_0 %>% 
        select(
          Clause,
          Sentence,
          Translation
        ) %>% 
        distinct() %>% 
        t() %>% 
        `colnames<-`(mode) %>% 
        as_tibble()
      # 将两部分数据合并
      tbl_clause <- bind_cols(
        tbl_clause_1,
        tbl_clause_2
      )
      return(tbl_clause)
    }
}
