library(tidyverse)
# 部分注释来自Copilot的自动补全。
# 本文件涉及以下几个函数：
# expand.grid()、expand_grid()、expand()、nesting()、crossing()、complete()
# 其中expand.grid()函数属于基础命令，其他函数属于tidyverse包中的tidyr包。

# 构造一个数据框
tbl <- tibble(
    A = c(3,1,2),
    B = c("a","a","b")
)
tbl

# （1）expand.grid()函数
# 基础命令中存在expand.grid()函数，用于生成由所有可能的组合（笛卡尔积）构成的数据框。
# expand.grid()函数除了可以应用于几个向量，【也可以应用于单个数据框】，以下两条命令结果相同。
# expand.grid()函数不会自动删除重复的组合，也不会排序。
# expand.grid()函数的结果是一个data.frame。
expand.grid(
    A = c(3,1,2),
    B = c("a","a","b")
) # "3-a"、"1-a"、"2-a"各出现了两次
tbl %>% expand.grid() # expand_grid()函数无法达到这一效果

# （2）expand_grid()函数
# expand_grid()函数通常应用于几个向量，或者用于连接数据框和向量，而不是单个数据框。
# expand_grid()函数不会自动删除重复的组合，也不会排序。
# expand_grid()函数的结果是一个tibble。
expand_grid(
    A = c(3,1,2),
    B = c("a","a","b")
) # "3-a"、"1-a"、"2-a"各出现了两次

#* 因此tidyverse包中其实缺少一个类似于expand.grid()函数的命令，能够应用于单个数据框。

# （3）crossing()函数
# crossing()函数通常应用于几个向量，或者用于连接数据框和向量，而不是单个数据框。
# crossing()函数会自动删除重复的组合，并排序。
# crossing()函数的结果是一个tibble。
crossing(
    A = c(3,1,2),
    B = c("a","a","b")
) # "1-a"、"2-a"、"3-b"均只出现了一次

# （4）expand()函数
# expand()函数只应用于数据框。
# expand()函数会自动删除重复的组合，并排序。
# expand()函数的结果是一个tibble。
tbl %>% expand(A,B) # 结果和crossing()函数相同

# （5）nesting()函数
# nesting()函数在expand()内部使用，用于给出仅存在于当前表格中的组合。
tbl %>% expand(nesting(A,B))

# （6）complete()函数
# complete()函数实际封装了expand()函数、full_join()函数和replace_na()函数，用于生成当前表格中的指定列组合与所有可能组合相比得到的隐性缺失值。
# 隐性缺失值（implicit missing values），隐性缺失值是指在原始数据中不存在的数据组合，相对于显性缺失值（explicit missing values），显性缺失值是指在原始数据中存在但值为NA的数据。
# complete()函数只应用于数据框。
# 虽然complete()函数封装的expand()会自动删除重复的组合，并排序，但是同样由其封装的full_join()函数却有可能重新引入重复的组合，这主要是指存在重复行的情况。
# complete()函数的结果是一个tibble。
tbl1 <- tibble(
    A = c(3,1,2),
    B = c("a","a","b"),
    C = c("A","B","C")
)
tbl1
tbl1 %>% expand(A,B) %>% full_join(tbl1)
tbl1 %>% complete(A,B) # 结果和上一条命令相同
#* complete()函数的列参数数量应该大于1，小于总列数，否则得到的结果不可能包含缺失值。

tbl2 <- tibble(
    A = c(1,1,2),
    B = c("a","a","b"),
    C = c("A","A","B")
)
tbl2
tbl2 %>% expand(A,B) %>% full_join(tbl2)
tbl2 %>% complete(A,B) # 第一行和第二行为重复行，full_join()函数会导致结果中保留这两行重复行
