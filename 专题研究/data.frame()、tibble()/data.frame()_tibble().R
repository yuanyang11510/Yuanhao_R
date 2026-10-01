library(tidyverse)
# 以下注释中的部分内容受了ChatGPT的启发。

# data.frame()函数当中，每列一般输入一个向量，如果输入的是一个列表，data.frame()函数会优先将列表中的每个元素作为一列内容输入，因此列表中有几个元素，就会对应几列内容，列名会根据“列表名 + . + 元素1 + . + 元素2 + ...”的形式构成，如果不存在列表名，默认取“X”。
data.frame(A = list(1:2,3:4,5)) # 输出三列，列名为A.1.2、A.3.4和A.5

# 以上命令的结果类似：
data.frame(A = 1:2,B = 3:4,C = 5)

# 如果想要data.frame()将输入其中的列表作为单独的一列，需要在列表外面加一层I()函数，表示禁止data.frame()函数将列表展开为多列。
data.frame(A = I(list(1:2,3:4,5))) # 输出一列，列名为A，每行是一个向量

# tibble()函数中，输入列表时默认不会将列表展开为多列，而是将整个列表作为一列处理。
tibble(A = list(1:2,3:4,5)) # 输出一列，列名为A，每行是一个向量

# mutate()函数和summarise()函数中，如果RHS输入的是一个列表，默认会将整个列表作为一列处理，列表中的每个元素对应新列中的各行内容，而不会将列表展开为多列，不管数据框原本是dataframe还是tibble。
data.frame(A = 1:2) %>% mutate(B = list(3:4)) # 添加新的一列B，由于列表中只有一个元素，因此扩展到各行
tibble(A = 1:2) %>% mutate(B = list(3:4)) # tibble的表现和dataframe一致

data.frame(A = 1:2) %>% mutate(B = list(3:4,5)) # 添加新的一列B，由于列表中的元素数量和原数据框的行数相同，因此每行对应一个列表元素
tibble(A = 1:2) %>% mutate(B = list(3:4,5)) # tibble的表现和dataframe一致

data.frame(A = c(1,1,2,2)) %>% summarise(.by = A,B = list(A)) # 添加新的一列B，A列的每个分组被压缩成一行，B列的每行内容来自A列每个分组内的元素，此处B列的各行是一个向量
tibble(A = c(1,1,2,2)) %>% summarise(.by = A,B = list(A)) # tibble的表现和dataframe一致

## 以上mutate()函数和summarise()函数中使用list()命令的表现，体现出这两个函数对在其中使用的list()命令的处理方式，一种粗浅的理解是：mutate()和summarise()当中的list()里面的内容会成为新列的内容，而不是说原本每一行或者分组之后每个分组内的内容会被装进一个列表，如果要实现后面这一种效果，就需要在list()的内部再使用一次list()。
# 请看以下命令：
tbl1 <- tibble(
  A = c(1,1,2,2),
  B = 3:6
)
tbl1

# 以下两条命令效果相同
tbl1 %>% summarise(.by = A,C = list(c(3,4))) # 每一行是一个向量c(3,4)
tbl1 %>% summarise(.by = A,C = list(B)) # 每一行是每个分组内的元素组成的向量；数据掩码机制下，"B"可以看做每个分组内部的成员组成的一个向量：c(b1,b2,...)

# 以下两条命令效果相同
tbl1 %>% summarise(.by = A,C = list(list(c(3,4)))) # 每一行是一个列表，该列表中包含一个向量c(3,4)
tbl1 %>% summarise(.by = A,C = list(list(B))) # 每一行是一个列表，该列表中包含一个相应分组中的所有元素组成的向量

# 以下命令会警告：
# Warning message:
# Returning more (or less) than 1 row per `summarise()` group was deprecated in dplyr 1.1.0.
# ℹ Please use `reframe()` instead.
# ℹ When switching from `summarise()` to `reframe()`, remember that `reframe()` always returns an ungrouped data frame and adjust accordingly.
#* 这是因为summarise()期望每个分组返回一行，而list(3,4)会返回多行，从而触发警告。
tbl1 %>% summarise(.by = A,C = list(3,4))

## 更本质的理解是：数据框本质上是一种特殊的列表，每一列是列表中的一个元素，普通列是一个“原子向量”（atomic vector），意为只能存储单一类型元素（比如字符串型、数值型、逻辑型等）的向量，如果希望在一列中存储不同类型的元素，就需要用列表来表示该列（list-column，列表也是一种向量），但不管怎样，每一列的长度应该相等。因此，如果想要在数据框的一个单元格中存储向量元素，就需要将其放进一个列表列中，这就是上文中mutate()函数和summarise()函数中使用list()命令的原因。
# 请看以下命令：
tbl2 <- tibble(
  A = 1:2,
  B = list(1,"a"),
  C = list(c("b"),c("c","d"))
)
tbl2

# 用as.list()函数将该数据框转换为列表，会发现列表中的第二个和第三个仍然是一个列表
tbl2 %>% as.list()

# 如果想要让列表中的第二个和第三个元素不再是列表，而是向量，需要使用map()函数搭配unlist()函数
tbl2 %>% map(unlist)


