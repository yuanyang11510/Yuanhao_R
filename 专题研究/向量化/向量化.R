# 向量化处理以下向量：将带"!"的字母改为大写，将带"?"的字母改为小写
Vec <- c("!a","?B","c")
Vec

# 使用ifelse函数，自带向量化
f.ifelse <- function (x) {
  x1 = ifelse(
    grepl("\\!",x),
    toupper(x),
    ifelse(
      grepl("\\?",x),
      tolower(x),
      x
    )
  )
  return(x1)
}
Vec.ifelse <- f.ifelse(Vec)
Vec.ifelse

# 使用if...else函数搭配for循环实现向量化
f.for.if <- function(x) {
  x1 = vector()
  for (i in 1:length(x)) {
    if (grepl("\\!",x[i])) {
      x1[i] = toupper(x[i])
    } else if (grepl("\\?",x[i])) {
      x1[i] = tolower(x[i])
    } else {
      x1[i] = x[i]
    }
  }
  return(x1)
}
Vec.for.if <- f.for.if(Vec)
Vec.for.if

# 使用if...else函数搭配sapply函数实现向量化
f.if <- function (x) {
  if (grepl("\\!",x)) {
    x1 = toupper(x)
  } else if (grepl("\\?",x)) {
    x1 = tolower(x)
  } else {
    x1 = x
  }
  return(x1)
}
Vec.if.sapply <- sapply(Vec,f.if)
Vec.if.sapply

# 使用if...else函数搭配Vectorize函数实现向量化
# 注意Vectorize函数不能直接应用于原型（primitive）函数（比如if...else函数），所以需要先用一个新定义的函数环境将if...else函数封装（encapsulate）起来，再将Vectorize函数应用于这个新函数
f.if.vectorize <- Vectorize(f.if)
Vec.if.vectorize <- f.if.vectorize(Vec)
Vec.if.vectorize

# 另一种不依靠if语句的方法，用下标标记出相应的元素，并分组处理，可以称为“下标法”
f.index <- function (x) {
  x1 = x
  index1 = grepl("\\!",x)
  index2 = grepl("\\?",x)
  x1[index1] = toupper(x1[index1])
  x1[index2] = tolower(x1[index2])
  return(x1)
}
Vec.index = f.index(Vec)
Vec.index



