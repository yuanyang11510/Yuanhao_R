library(tidyverse)
library(openxlsx)
source("./Function.R")

# 读取数据
txt <- readLines("./Source/yuwanh'ao-de.txt")

# 调用函数
df_compare <- Compare_Morpheme_Gloss(txt)

# 写入文件
# 生成的.csv文件里“-”开头的内容会被当做公式，从而显示为“#NAME?”，不方便处理
# 生成的.xlsx文件没这个问题
write_excel_csv(df_compare,"./Result/Compare_Morpheme_Gloss.csv")
write.xlsx(df_compare,"./Result/Compare_Morpheme_Gloss.xlsx")
