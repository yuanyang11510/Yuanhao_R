library(tidyverse)

# data.frame()函数当中，每列一般输入一个向量，如果输入的是一个列表，data.frame()函数会优先将列表中的每个元素作为一列内容输入，因此列表中有几个元素，就会对应几列内容，列名会根据“列表名 + . + 元素1 + . + 元素2 + ...”的形式构成，如果不存在列表名，默认取“X”。
data.frame(A = list(1:2,3:4,5)) # 输出三列，列名为A.1.2、A.3.4和A.5

# 以上命令的结果类似：
data.frame(A = 1:2,B = 3:4,C = 5)

# 如果想要data.frame()将输入其中的列表作为单独的一列，需要在列表外面加一层I()函数，表示禁止data.frame()函数将列表展开为多列。
data.frame(A = I(list(1:2,3:4,5))) # 输出一列，列名为A，每行是一个向量

# tibble()函数中，输入列表时默认不会将列表展开为多列，而是将整个列表作为一列处理。
tibble(A = list(1:2,3:4,5)) # 输出一列，列名为A，每行是一个向量

# mutate()和summarise()函数中，如果RHS输入的是一个列表，默认会将整个列表作为一列处理，列表中的每个元素对应新列中的各行内容，而不会将列表展开为多列，不管数据框原本是dataframe还是tibble。
data.frame(A = 1:2) %>% mutate(B = list(3:4)) # 添加新的一列B，由于列表中只有一个元素，因此扩展到各行
tibble(A = 1:2) %>% mutate(B = list(3:4)) # tibble的表现和dataframe一致

data.frame(A = 1:2) %>% mutate(B = list(3:4,5)) # 添加新的一列B，由于列表中的元素数量和原数据框的行数相同，因此每行对应一个列表元素
tibble(A = 1:2) %>% mutate(B = list(3:4,5)) # tibble的表现和dataframe一致

data.frame(A = c(1,1,2,2)) %>% summarise(.by = A,B = list(A)) # 添加新的一列B，A列的每个分组被压缩成一行，B列的每行内容来自A列每个分组内的元素，此处B列的各行是一个向量
tibble(A = c(1,1,2,2)) %>% summarise(.by = A,B = list(A)) # tibble的表现和dataframe一致

