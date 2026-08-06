# 如果本地还没有安装这三个包，运行以下命令
# install.packages(c("tidyverse","readelan","openxlsx"))

# 加载包
library(tidyverse)
library(readelan)
library(openxlsx)

# 导入.eaf文件，每次只需要将"./Source/"之后的内容修改为当前处理的文件名即可，形式为"XXX.eaf"
# 记得设置fill_times = FALSE，否则和morph有关的信息会被筛除
tbl_eaf <- read_eaf("./Source/ybe202408200201-int_20260803.eaf",fill_times = FALSE)

# 构造一个函数，将子节点上移至父节点
children2parent = function (df,colname_children,colname_parent) {
  i = 0
  col_children = df[[colname_children]]
  colname_parent_i = str_c(colname_parent,"_",i)
  df = df %>% 
    rename(!!sym(colname_parent_i) := all_of(c(colname_parent)))

  repeat {
    col_parent_j = df[[colname_parent_i]]
    i = i + 1
    colname_parent_i = str_c(colname_parent,"_",i)
    df = df %>% 
      mutate(
        !!sym(colname_parent_i) := coalesce(
          col_parent_j[match(col_parent_j,col_children)],
          col_parent_j
        )
      )
    col_parent_i = df[[colname_parent_i]]

    if (identical(col_parent_i,col_parent_j)) {break}
  }
  return(df)
}

# 处理数据
# 预处理：将最高层节点的上层节点从NA（不存在）设置为其本身
tbl_pre <- tbl_eaf %>% 
  select(participant,annotation,tier,a,a_ref) %>% 
  mutate(a_ref = if_else(is.na(a_ref),a,a_ref))

# 识别节点层次
# children2parent()函数结果得到a_ref_0、a_ref_1、a_ref_2、a_ref_3四列，a_ref_3列和a_ref_2列内容相同，已删除
# a -> a_ref_0 -> a_ref_1 -> a_ref_3每一步的操作都是所有子节点顺次向上挪动到各自的父节点，最高层节点无法再向上移动，因此可以通过节点不再移动的位置来判断起初节点所属的层级
tbl_node <- tbl_pre %>% 
  children2parent("a","a_ref") %>% 
  select(-a_ref_3) %>% 
  mutate(
    Node = case_when(
      a == a_ref_0 ~ 1,
      a_ref_0 == a_ref_1 ~ 2,
      a_ref_1 == a_ref_2 ~3,
      .default = 4
    )
  )

# 原数据中的所有节点（tier列内容）包括（详见文件“节点说明.txt”）：
# (1.1)其他系统创设的元数据节点(interlinear-text-date-created-en、interlinear-text-date-modified-en、interlinear-text-title-en)，没有下层节点
# (1.2)句子空槽位节点(phrase-txt-zh-CN)
  # (2.1)句子标注节点(phrase-txt-ybe、phrase-gls、phrase-segnum)，没有下层节点
  # (2.2)词空槽位节点(word-txt-zh-CN)
    # (3.1)词节点(word-txt-ybe)，没有下层节点
    # (3.2)语素切分节点(morph-txt)
      # (4)语素标注节点(morph-cf、morph-gls、morph-type、morph-hn)

# 处理句子-词，内容包括：
# (1.1/1.2)一层节点
  # (2.1)句子标注节点
    # (3.1)词节点
# 处理时，只需要最后将所有包含“morph”的列以及“word-txt-zh-CN”列删除即可
tbl_phrase_word <- tbl_node %>% 
  select(participant,annotation,tier,a_ref_2) %>% 
  pivot_wider(
    names_from = tier,
    values_from = annotation,
    values_fn = ~str_c(.x,collapse = " ")
  ) %>% 
  select(-contains(c("morph","word-txt-zh-CN")))

# 处理词-语素，内容包括：
# (2.2)词空槽位节点
  # (3.1)词节点
  # (3.2)语素切分节点
    # (4)语素标注节点

# a、a_ref各列中标识符所属的的层级：
# a列：1、2、3、4
# a_ref_0：1、2、3
# a_ref_1：1、2
# a_ref_2：1

# 如果要以词为单位（二层节点中的词空槽位节点）进行处理，可以按照以下步骤进行：
# (1)删除所有一层节点的数据
# (2)二层节点中只保留词空槽位节点的数据（其他节点是句子标注节点）
# (3)将词空槽位节点设置为最高节点：
  # 词空槽位节点(word-txt-zh-CN)
    # 词节点(word-txt-ybe)，没有下层节点
    # 语素切分节点(morph-txt)
      # 语素标注节点(morph-cf、morph-gls、morph-type、morph-hn)
# (4)再次使用children2parent()函数，将剩余节点上移至二层节点

tbl_word_morph <- tbl_pre %>% 
  bind_cols(Node = tbl_node$Node) %>% 
  filter(Node != 1) %>% # 删除所有一层节点的数据
  filter((Node == 2 & !str_detect(a,"^ann\\d+$")) | (Node != 2)) %>% # 二层节点中只保留词空槽位节点的数据
  mutate(a_new = if_else(Node == 2,a,a_ref)) %>% # 将词空槽位节点设置为最高节点
  children2parent("a","a_new") %>% 
  select(-a_new_2) %>% 
  select(participant,annotation,tier,a_new_1) %>% 
  pivot_wider(
    names_from = tier,
    values_from = annotation,
    values_fn = list
  ) %>% 
  # 将词空槽位节点的上层节点补回来
  left_join(
    tbl_pre %>% select(a,a_ref),
    by = join_by(a_new_1 == a),
  ) %>% 
  pivot_longer(
    cols = -c(participant,a_new_1,a_ref),
    names_to = "tier",
    values_to = "annotation",
    values_drop_na = TRUE
  ) %>% 
  # 去除原本作为最高节点的词空槽位节点
  select(-a_new_1) %>% 
  # 将语素（切分）形式、语素标注形式、词典顺序拼接
  mutate(across(annotation,~map(
    .x,
    ~if (any(str_detect(.x,"-"))) {str_c(.x,collapse = "")}
    else {str_c(.x,collapse = "-")}
  ))) %>% 
  pivot_wider(
    names_from = tier,
    values_from = annotation,
    values_fn = ~str_c(.x,collapse = " ")
  )

# 连接句子-词和词-语素
tbl_phrase_word_morph <- full_join(
  tbl_word_morph,
  tbl_phrase_word,
  by = join_by(
    participant,
    a_ref == a_ref_2,
    "Yang Xuefang_word-txt-ybe"
  )
) %>% 
  mutate(across(everything(),~na_if(.x,""))) %>% 
  mutate(across(everything(),~replace_na(.x,"")))

# 核对数据
# 第一列和第二列是两列语素切分形式，第三列和第四列是句子形式
tbl_compare <- tbl_phrase_word_morph %>% 
  select(
    "Yang Xuefang_morph-cf-ybe",
    "Yang Xuefang_morph-txt-ybe",
    "Yang Xuefang_word-txt-ybe",
    "Yang Xuefang_phrase-txt-ybe"
  ) %>% 
  mutate(
    x1_x2 = pull(pick(1)) == pull(pick(2)),
    x3_x4 = pull(pick(3)) == pull(pick(4))
  )

# 导出.csv文件,输出的文件名可以通过"./Result/"之后的内容修改，形式为"XXX.csv"
# 生成的.csv文件里“-”开头的内容会被当做公式，从而显示为“#NAME?”，不方便处理
# 生成的.xlsx文件没这个问题
# write_excel_csv(tbl_phrase_word_morph,"./Result/tbl_phrase_word_morph.csv")
# write_excel_csv(tbl_compare,"./Result/tbl_compare.csv")
# write.xlsx(tbl_phrase_word_morph,"./Result/tbl_phrase_word_morph.xlsx")
# write.xlsx(tbl_compare,"./Result/tbl_compare.xlsx")

