library(tidyverse)

# pivot_longer()函数的cols_vary参数和pivot_wider()函数的names_vary参数
# pivot_longer()函数，当cols参数为多列时，cols_vary参数会对结果产生影响
tbl1 <- tibble(
    FC = c("a1","a2"),
    LT = c("b1","b2")
)
tbl1_longer_fastest <- tbl1 %>% 
    pivot_longer(
        cols = c(FC,LT),
        names_to = "NAME",
        values_to = "SYLLABLE",
        cols_vary = "fastest" # 默认值
    )
tbl1_longer_slowest <- tbl1 %>% 
    pivot_longer(
        cols = c(FC,LT),
        names_to = "NAME",
        values_to = "SYLLABLE",
        cols_vary = "slowest"
    )
tbl1
tbl1_longer_fastest # 默认值，优先以行（此处可以具体化为“概念”）为单位
tbl1_longer_slowest # 优先以列（此处可以具体化为“语言”）为单位

# pivot_wider()函数，当values_from参数为多列时，names_vary参数会对结果产生影响
tbl2 <- tibble(
    ASSIST = c(1,1,2,2),
    NAME = c("FC","LT","FC","LT"),
    INITIAL = c("a1","a2","a1","a3"),
    RHYME = c("b1","b2","b1","b3")
)
tbl2_wider_fastest <- tbl2 %>% 
    pivot_wider(
        names_from = c(NAME),
        values_from = c(INITIAL,RHYME),
        names_glue = "{.value}_{NAME}",
        names_vary = "fastest" # 默认值
    )
tbl2_wider_slowest <- tbl2 %>% 
    pivot_wider(
        names_from = c(NAME),
        values_from = c(INITIAL,RHYME),
        names_glue = "{.value}_{NAME}",
        names_vary = "slowest"
    )
tbl2
tbl2_wider_fastest # 默认值，优先以VALUE列（此处可以具体化为“音系范畴：声韵调”）为单位
tbl2_wider_slowest # 优先以NAME列（此处可以具体化为“语言”）为单位

# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------以下是早先学习这两个函数的笔记

# 载入例表
FC_rule_longer_example <- read.csv("FC_rule_longer_example.csv") %>% 
    distinct() %>% 
    mutate(across(everything(),str_trim))
LT_rule_wider_example <- read.csv("LT_rule_wider_example.csv")  %>% 
    replace(is.na(.),"") 


## 将宽表格转换为长表格
# 注意要先将列名称修改为可供pivot_longer函数处理的格式
LT_rule_wider01 <- LT_rule_wider_example %>% 
    rename(
        Regex_1 = Cond1,
        Regex_2 = Cond2,
        Reflex_1 = Reflex1,
        Reflex_2 = Else
    ) %>% 
    select(!Reflex2)

# 使用names_to参数搭配names_sep参数进行转换
LT_rule_wider_to_longer1 <- LT_rule_wider01 %>% 
    pivot_longer(
            cols = c(Regex_1,Regex_2,Reflex_1,Reflex_2), # 设置转换所涉及的列
            names_to = c(".value","a"), # ".value"代表宽表格中相同的【主列名】，转换后成为长表格中的各列列名，宽表格中同一【主列名】后的各个【列名前/后缀】在转换后会进入长表格中的同一列，以标示【主列名】的不同来源，"a"为该列列名，如果长表格中使用的是【列名后缀，则".value"在前，"a"在后，如果长表格中使用的是【列名前缀】，则"a"在前，".value"在后】
            names_sep = "_" # 标示【主列名】和【列名前/后缀】之间的分隔符
    ) %>% 
    select(Type,PEM,Regex,Reflex,NatrlCls)
#* 注意，由于原始数据没有区分NatrlCls_a1和NatrlCls_a2，因此转换后的表格中的NatrlCls一列的数据凡是遇上a2行的时候，需要进行修改，下同

LT_rule_wider02 <- LT_rule_wider_example %>% 
    rename(
        a1_Regex = Cond1, # 注意由于数字不能作为变量名的第一个字符，因此在前面加上一个a
        a2_Regex = Cond2,
        a1_Reflex = Reflex1,
        a2_Reflex = Else
    ) %>% 
    select(!Reflex2)

# 使用names_to参数搭配names_pattern参数进行转换
LT_rule_wider_to_longer2 <- LT_rule_wider02 %>% 
    pivot_longer(
            cols = c(a1_Regex,a2_Regex,a1_Reflex,a2_Reflex),
            names_to = ".value", # names_to参数可以只出现".values"这一个论元，此时必须使用names_pattern参数
            names_pattern = ".*_(.*)" # names_sep参数可以改成names_pattern参数，只有names_to参数中出现的论元此处才用括号括起来，此时是通过括号的位置来区分【主列名】和【列名前/后缀】
    ) %>% 
    select(Type,PEM,Regex,Reflex,NatrlCls)

## 通过以上对比，可以发现【长表格转换为宽表格】和【宽表格转换为长表格】各有其需要提前准备的工作：前者需要先按照一定的标准进行分组，然后新增一列标示出各个分组内的序号，作为转换后宽表格的【列名后缀】，后者需要提前将列名修改为可供pivot_longer函数处理的格式："【列名前缀】+分隔符+【主列名】"或者"【主列名】+分隔符+【列名后缀】"，相比起来，后者的准备工作更复杂一些