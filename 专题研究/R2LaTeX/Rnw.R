#rfr 可以参考：https://tex.stackexchange.com/questions/25575/how-can-i-use-a-table-generated-by-r-in-latex
library(tidyverse)
library(readxl)
library(knitr)

knit("./Rnw/test.Rnw","./Tex/test1.tex") # 仅生成tex，输出路径扩展名设置为.tex
knit2pdf("./Rnw/test.Rnw","./Tex/test2.tex",compiler = "xelatex") # 生成tex和pdf，输出路径扩展名设置为.tex
rnw2pdf("./Rnw/test.Rnw","./Tex/test3.pdf",compiler = "xelatex") # 仅生成pdf，输出路径扩展名设置为.pdf，默认使用xelatex编译

# kable：df3
df3 <- read_xlsx("./XLSX/test.xlsx",sheet = 2)
kable(
    df3,
    format = "latex",
    caption = "\\text{kable}"
) %>% 
    write("./Kable/kable.tex")

