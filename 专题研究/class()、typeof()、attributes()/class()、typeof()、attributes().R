# 以下内容改编自ChatGPT

## 一、向量
# “:”号生成整数序列，这是一个优化行为，直接返回integer vector
x1 <- 1:3
# 赋予names属性
x2 <- 1:3
names(x2) <- c(letters[1:3])
# 一个个输入数字，默认是double
x3 <- c(1,2,3)
# 如果想让它是整数，需要显式写1L
x4 <- c(1L,2L,3L)
#rfr 关于integer和double的更详细的区别，参考“代码备忘录-R_Interger v.s. Double”

#* 对【向量】，class()返回元素类型
class(x1) # integer
class(x2) # integer
class(x3) # numeric（底层是double）
class(x4) # integer

#* 对【原子向量】（见文末介绍），typeof()返回对象的底层存储类型，调试、检查底层类型（比class更底层）
typeof(x1) # integer
typeof(x2) # integer
typeof(x3) # double（numeric的底层）
typeof(x4) # integer

# attributes()返回对象的所有属性（names、class、dim等）
attributes(x1) # NULL
attributes(x2) # 有names属性
attributes(x3) # NULL
attributes(x4) # NULL

# is.vector()判断对象是否是向量
is.vector(x1) # TRUE
is.vector(x2) # TRUE
is.vector(x3) # TRUE
is.vector(x4) # TRUE

# mode()返回对象的传统模式（早期S语言用的），很少用，主要为了兼容旧代码
mode(x1) # numeric（底层是integer）
mode(x2) # numeric（底层是integer）
mode(x4) # numeric（底层是double）
mode(x3) # numeric（底层是integer）

## 二、矩阵
m <- matrix(1:6, nrow = 2)

#* 对【更复杂的对象】，class()返回对象的S3类名（数据结构）
class(m) # "matrix" "array"
# 注意：矩阵是array的子类

typeof(m) # "integer"
# 底层还是整数

attributes(m)
# $dim
# [1] 2 3
# 包含dim属性
#* 注意：虽然class()返回"matrix" "array"，但是矩阵不包含class属性（对比下文的因子和数据框）

is.vector(m) # FALSE
is.matrix(m) # TRUE

## 三、因子
f <- factor(c("a", "b", "a"))

class(f) # "factor"

typeof(f) # "integer"
#* 注意：底层其实是整数，存的是水平索引

attributes(f)
# $levels
# [1] "a" "b"
# $class
# [1] "factor"
#* 注意：相比矩阵,还多一个class属性

is.vector(f) # FALSE
is.factor(f) # TRUE

## 四、列表
lst <- list(x1,m,f,df)

class(lst) # "list"

typeof(lst) # "list"
#* 注意：对【递归向量】（仅包含列表这一类），typeof()返回list表示“这是一个递归向量 (recursive vector)，即一种可以包含任意R对象的容器，每个元素可以是不同类型、不同长度”（来自ChatGPT）
#* 从更高的视角看，typeof()返回的是R内部“这个对象是哪种C结构”的标识，对列表而言，这是R在C层的类型VECSXP，和原子向量的INTSXP/REALSXP等并列（来自ChatGPT）

attributes(lst) # NULL
#* 注意：列表没有任何属性

is.vector(lst) # TRUE
#* 注意：R关于?is.vector的帮助文档中提到：“is.vector(x) returns TRUE if x is a vector of the specified mode having no attributes other than names.”意为只有【除去names属性而没有其他属性】的向量，is.vector()才会返回TRUE，这揭示了实际上上述各种复杂的数据结构（矩阵、因子、数据框、列表），其实都是向量，只不过比【简单向量】多了一系列的属性，列表没有任何属性（attributes()返回NULL），因此满足is.vector()返回TRUE的条件
# 但是，如果为列表赋予属性，比如attr(lst,"foo") <- "bar"（赋予列表一个名为“foo”的属性，其内容为“bar”），此时is.vector()就会返回FALSE

is.list(lst) # TRUE

## 五、数据框
df <- data.frame(x = 1:3, y = c("a", "b", "c"))

class(df) # "data.frame"

typeof(df)# "list"
#* 注意：数据框其实是一类特殊的列表，所以typeof()返回list

attributes(df)
# $names
# [1] "x" "y"
# $row.names
# [1] 1 2 3
# $class
# [1] "data.frame"
#* 注意：相比矩阵，将dim属性分为names属性（列）和row.names属性（行），并且多了一个class属性

is.vector(df)# FALSE
is.data.frame(df) # TRUE

## 六、原子向量 v.s. 递归向量
# 向量、矩阵、因子只能容纳同质的元素，因此被称为【原子向量】（不是严谨的说法，因为对矩阵和因子来说，is.vector()返回FALSE），is.atomic()返回TRUE，列表【可以】容纳异质的元素，并且可以不断嵌套，因此被称为【递归向量】，is.recursive()返回TRUE，数据框是一类特别的列表，is.recursive()也返回TRUE
is.atomic(x1) # TRUE
is.atomic(m) # TRUE
is.atomic(f) # TRUE
is.atomic(df) # FALSE
is.atomic(lst) # FALSE

is.recursive(x1) # FALSE
is.recursive(m) # FALSE
is.recursive(f) # FALSE
is.recursive(df) # TRUE
is.recursive(lst) # TRUE






