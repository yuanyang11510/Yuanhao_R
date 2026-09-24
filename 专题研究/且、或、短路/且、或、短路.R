# 官方文档将"&"、"|"称为“shorter forms”，将"&&"、"||"称为“longer forms”，ChatGPT将"&&"和"||"的特性称为“短路 (short circuit)”。

#* "&&"的左边如果为FALSE，则右边的条件不会再计算
FALSE && NULL # 返回FALSE
# "&&"的左边如果为TRUE，则右边的条件会计算
TRUE && NULL # 报错：Error in TRUE && NULL : invalid 'y' type in 'x && y'

# "||"的左边如果为FALSE，则右边的条件会计算
FALSE || NULL # 报错：Error in FALSE || NULL : invalid 'y' type in 'x || y'
#* "||"的左边如果为TRUE，则右边的条件不会再计算
TRUE || NULL # 返回TRUE

# "&"的左边不管是TRUE还是FALSE，右边的条件仍然会计算
FALSE & NULL # 返回零长度向量logical(0)
TRUE & NULL # 返回零长度向量logical(0)

# "|"的左边不管是TRUE还是FALSE，右边的条件仍然会计算
FALSE | NULL # 返回零长度向量logical(0)
TRUE | NULL # 返回零长度向量logical(0)

## 下面看一个实践中的具体的例子（文件"(0) Functions.R"）：
if (!exists(df_name) || is.null(get(df_name))) {
    lst_file_name_fail = append(lst_file_name_fail,file_name)
    next
}
# 注意此处前后两个条件存在依存关系：右边条件命令的执行依赖于左边条件为假（存在该变量），此时应该使用“||”而不是“|”。此处在左边的条件为真（不存在该变量）时，将直接执行该分支代码体的命令，而不再会执行右边的条件命令，如果使用“|”，就会导致报错：左边条件为真（不存在该变量），右边条件命令缺少前提而无法运行。

