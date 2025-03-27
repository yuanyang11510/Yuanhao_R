library(tidyverse)

getwd()

# 下面比较原生函数merge()和dplyr包提供的join系列函数的不同
#rfr 关于inner_join()、left_join()、right_join()、full_join()、semi_join()、anti_join()函数的效果可视化演示，可以参考：https://zhuanlan.zhihu.com/p/547945673

X <- data.frame(A = 1:3,B1 = c("x","z","y"))
Y <- data.frame(A = 0,B2 = c("x","z","y","x","z","y"))
X
Y

# merge()函数
# （1）连接列会被放置到新表格的首列
# （2）并且内容会被自动排序
# （3）设置新列下标的参数为suffixes
merge(X,Y,by.x = "B1",by.y = "B2",all = TRUE,suffixes = c(".1",".2")) 
merge(X,Y,by.x = "B1",by.y = "B2",all = TRUE,sort = FALSE,suffixes = c(".1",".2")) # 即使设置sort = FALSE，连接列中内容相同的部分也会被放置到一起，sort参数控制的仅仅是【在这一基础之上】的内容排序与否

# full_join()函数
# 有两种表述连接列的方式，注意用向量表示的时候搭配"="符号，用join_by命令表示的时候搭配"=="符号
# （1）连接列保持在原来的位置
# （2）并且内容相同的部分会被放置到一起，但在此基础上不会再进一步排序，效果和merge()函数中设置sort = FALSE之后的效果相同（该函数也不存在控制这一操作的参数）
# （3）设置新列下标的参数为suffix
full_join(X,Y,by = c("B1" = "B2"),suffix = c(".1",".2")) 
full_join(X,Y,by = join_by("B1" == "B2"),suffix = c(".1",".2")) 

# merge()函数可以用变量或者函数来间接表示连接列名称
x <- names(X)[2]
y <- names(Y)[2]
merge(X,Y,by.x = x,by.y = y) # 用变量表示
merge(X,Y,by.x = names(X)[2],by.y = names(Y)[2]) # 用函数表示

# join系列函数无法用变量或者函数来间接表示连接列名称，下面这几条命令会报错
#!  full_join(X,Y,by = c(x = y))
#! full_join(X,Y,by = join_by(x == y))
#! full_join(X,Y,by = join_by(names(X)[2] == names(Y)[2]))
# 解决办法如下：使用setNames函数表示连接列
#rfr 可以参考：https://stackoverflow.com/questions/28399065/dplyr-join-on-by-a-b-where-a-and-b-are-variables-containing-strings
full_join(X,Y,by = setNames(y,x)) # 使用setNames函数，注意连接列顺序和表格顺序相反
full_join(X,Y,by = setNames(nm = x,y)) # 如果setNames函数的参数使用"nm ="引出，则不需要调换连接列顺序 
full_join(X,Y,by = setNames(names(Y)[2],names(X)[2]))
full_join(X,Y,by = setNames(nm = names(X)[2],names(Y)[2]))
#? 这一解决办法的原理，以及上述链接中提供的另一个利用structure()函数的解决办法，待研究
