library(tidyverse)
library(readxl)

getwd()

df0 <- read_xlsx("./Note_Norman.xlsx")

for (i in 1:nrow(df0)) {
  x_i = paste0(
    "\\section{P.",
    df0[[8]][[i]],
    "-",
    paste0(df0[[1]][[i]],df0[[2]][[i]]),
    "}\\index{",
    df0[[1]][[i]],
    "@",
    paste0(df0[[1]][[i]],df0[[2]][[i]]),
    "}",
    "\r",
    "注释原文：",
    "\r\n",
    "\\enquote{",
    df0[[7]][[i]],
    "}"
  )
  write.table(
    x_i,
    "./tex.txt",
    append = T, # 是否覆盖之前写入的内容
    row.names = F, # 是否写入行号
    col.names = F, # 是否写入列号
    eol = "\r\n", # 控制每一行的最后自动加上的字符
    quote = F # 是否再写入内容两边加上引号
  )
}



