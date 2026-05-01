library(tidyverse) # 提供sym()、syms()命令
library(rlang) # 提供data_sym()、data_syms()命令

## 以下总结的内容获得了ChatGPT的帮助

# 两个mutate()环境中的术语:
# 赋值表达式左边（Left-Hand Side，LHS）
# 赋值表达式右边（Right-Hand Side，RHS）

df1 <- data.frame(A = 1:3)
df2 <- data.frame(A = 1:3,B = 3:1)

#* （一）.data[[x]]


#* （一）get()
# （1）get()属于R的基础函数，用于在全局环境中通过字符串格式的变量名（variable name）查找变量（variable）的值（value）。
A <- 999 # 将值999赋值给变量A，变量名为字符串格式的"A"
get("A") # 返回999

# （2）但更复杂的情况是将一个变量名作为值赋值给另一个变量，通过这个变量来查找存储在其中的变量名所对应的变量的值，这种做法的典型代表就是设计函数中的“动态变量名”问题。
x <- "A" # 将变量名"A"作为值赋值给变量x
A <- 999 # 将值999赋值给变量A
get(x) # 返回999，但如果没有A <- 999，则会报错，因为该变量没有值

# 在涉及“动态变量名”的时候，可以在RHS的位置上（对mutate()函数来说）使用.data[[x]]的形式来引用数据框中的列：
df1 %>% mutate(B = .data[[x]]) # 创设一个新列B，将A列的内容赋值给该列
df1 %>% filter(.data[[x]] > 1) # 从数据框中筛选出A列的内容大于1的行
# 但是.data[[x]]无法放在LHS的位置上来为数据框中的列赋值，以下命令会报错：
# df1 %>% mutate(.data[[x]] = 4:6)
# 解决办法是使用!!sym(x)搭配":="来为数据框中的列赋值，见下文（二-3）的介绍。

# （3）在mutate()和filter()当中，存在数据掩码（data mask）机制，创建一个优先于全局环境的局部环境，在该环境中，列名和列内容会分别作为变量和值一一对应，因此不管是否存在A <- 999，mutate()和filter()当中的get(x)都会返回x的值（即"A"）作为列名的列内容。
# 尤其注意没有A <- 999时，get(x)在全局环境中会报错，但在mutate()和filter()环境中可以正常运行，因为mutate()和filter()做了一步相当于A <- 999的操作：将A列的内容（类型是向量）赋值给了A这个变量。
df1 %>% mutate(copy_A = get(x)) # 创设一个新列copy_A，将A列的内容赋值给该列
# get()只能出现在RHS的位置，见下文（二-3）的介绍。
df1 %>% filter(get(x) > 1) # 从数据框中筛选出A列的内容大于1的行
# filter()函数中输入的是一个逻辑值判断表达式，没有LHS和RHS的区分，get(x) > 1也可以写成1 < get(x)，结果相同

# （4）如果要强制在mutate()环境中使用全局环境，可以使用将get()的参数envir设置为.env进行引用
# 如果没有A <- 999，以下命令会报错，因为全局环境中A变量名没有被赋值
# 如果存在A <- 999，则new列会被赋值：999,999,999
df1 %>% mutate(new = get(x, envir = .env))
# 也可以直接引用.env并用双中括号引用动态变量名
df1 %>% mutate(new = .env[[x]])
# 如果使用$引用，则只能引用具体的变量名，不能引用动态变量名
df1 %>% mutate(new = .env$A)

# 在filter()环境中如果使用全局环境，情况有所不同：
# 如果没有A <- 999，以下命令会报错，因为全局环境中A变量名没有被赋值，这和mutate()的情况类似
# 如果存在A <- 999，get(x,envir = .env)就会得到一个数值型的值999，以下命令相当于filter(999 < 1)，也可以写成filter(1 > 999)，逻辑值判断表达式的结果是FALSE，因此筛选结果是一个空的数据框。
df1 %>% filter(get(x,envir = .env) < 1)
# 如果是x2 <- "A2"、A2 <- "B"，以下命令容易被误解为从数据框中筛选出B列大于1的行，但实际上由于get(x2,envir = .env)得到的是字符串"B"，以下命令相当于filter("B" > 1)，逻辑值判断表达式的结果是TRUE，因此筛选结果就是原数据框。
x2 <- "A2"
A2 <- "B"
df2 %>% filter(get(x,envir = .env) > 1)

# （5）与此相关的一个细节是：
# mutate()函数中，LHS位置的用来表示列的列名既可以接受字符串型，也可以接受符号型（symbol），前者是一种数据类型（data type），后者是一种语言对象（language object），RHS位置则只能接受符号型，字符串型的数据会被作为值填充到列中。
df2 %>% mutate("C" = 4:6) # 创设一个新列C，将4、5、6赋值给该列
df2 %>% mutate(C = 4:6) # 结果和上一条命令相同
df2 %>% mutate(C = A) # 创设一个新列C，将A列的内容赋值给该列
df2 %>% mutate(C = "A") # 创设一个新列C，将字符串"A"赋值给该列，而不是将A列的内容赋值给该列

# filter()函数中，如果要表示某一列，必须使用符号型，不能使用字符串型，否则会被当成逻辑值判断表达式中的某一侧的数据来处理。
df2 %>% filter(B > 1) # 从数据框中筛选出B列的内容大于1的行
df2 %>% filter("B" > 1) # 结果是原数据框，因为逻辑值判断表达式的结果是TRUE（字典顺序）

#* （二）sym()函数
# （1）sym()函数会将字符串转换为符号（symbol），符号是待计算（evaluate）的对象，可以通过在外面加上eval()进行计算。
x <- "A"
sym(x) # 返回A（符号）
eval(sym(x)) # 返回999，前提是存在A <- 999，该命令结果和get(x)相同

# （2）需要通过!!来让mutate()和filter()函数引用这些符号对应的列，在mutate()和filter()环境中，!!sym()和get()的结果相同，但两者的运作机制不同：get()是在mutate()和filter()函数已经将列名和列内容配对的基础上，引用列名代表的列内容，而!!sym()是让mutate()和filter()函数引用符号对应的列。
df1 %>% mutate(B = !!sym(x)) # 创设一个新列B，将A列的内容赋值给该列
df1 %>% filter(!!sym(x) > 1) # 从数据框中筛选出A列的内容大于1的行

# （3）mutate()函数中，可以通过LHS位置的!!sym()搭配":="来为数据框中的列赋值。
df1 %>% mutate(!!sym(x) := 3:1) # 将A列的内容替换为3、2、1，该条命令相当于mutate(A = 3:1)
df1 %>% mutate(!!x := 3:1) # sym()可以省略，结果和上一条命令相同，此时!!不发挥作用，!!x相当于"A"，该条命令相当于mutate("A" = 3:1)
# LHS位置的字符串型数据和符号型数据都可以用来表示列名，见前文（一-5）的介绍，因此上述两条命令结果相同。

# 注意一：LHS位置不能使用get()来为数据框中的列赋值，这个时候只能使用!!sym()搭配":="。
# 注意二：filter()函数中!!sym()里的sym()如果省略，结果会不同，原理见前文（一-5）的介绍。
df1 %>% filter(!!sym(x) > 1) # 从数据框中筛选出A列的内容大于1的行
df1 %>% filter(!!x > 1) # 结果是原数据框，因为!!x相当于"A"，以下命令相当于filter("A" > 1)，逻辑值判断表达式的结果是TRUE（字典顺序）

# （4）data_sym()会返回形如.data$symbole的形式，即通过符号来引用当前数据框中的列，这个命令可以在mutate()和filter()环境中通过RHS的!!data_sym()的形式引用数据框中的列，结果和!!sym()相同。
x <- "A"
data_sym(x) # 返回.data$A
df1 %>% mutate(B = !!data_sym(x)) # 创设一个新列B，将A列的内容赋值给该列，结果和使用!!sym()相同
df1 %>% filter(!!data_sym(x) > 1) # 从数据框中筛选出A列的内容大于1的行，结果和使用!!sym()相同
# 但是LHS的!!data_sym()无法搭配":="来为数据框中的列赋值，因为.data$A的形式无法作为列名来引用。

# （5）syms()函数和data_syms()函数相比sym()和data_sym()函数，区别在于最后的数据类型是一个包含了符号或者.data$symbol形式的列表，sym()和data_sym()无法接受多个变量名，但是syms()和data_syms()可以接受多个变量名。
y <- c("A","B")
syms(y) # 返回一个包含了A、B（符号）的列表
data_syms(y) # 返回一个包含了.data$A、.data$B的列表
# 存在和!!sym()、!!data_sym对应的!!!syms()、!!!data_syms的用法，用来将包含符号的列表展开（但不是转换成向量），但是一般不在mutate()环境中使用，下文介绍选择列的相关函数时会介绍它的用法。

#* （三）all_of()函数和any_of()函数
# （1）all_of()和any_of()函数来自tidyselect包，用于从字符串向量中筛选出符合要求的字符串，并通过这些字符串从数据框中选出对应的列，同属这个包的函数还有starts_with()函数、ends_with()函数、contains()函数、matches()函数、num_range()函数等。
df2 %>% select(all_of(x)) # 从数据框的A、B两列中选出A列
df2 %>% select(any_of(y)) # 从数据框的A、B两列中选出A列和B列
df2 %>% mutate(across(all_of(x),~.x + 1)) # 将数据框的A列中的每个元素加1，结果是2、3、4
df2 %>% mutate(C = rowMeans(across(any_of(y)))) # 创设一个新列C，将数据框的A、B两列中的每行的平均值赋值给该列，结果是2、2、2

# 这些函数一般只在select()、across()等选择函数中使用，如果all_of()直接在全局环境中使用会有警告：
    # Warning message:
    # Using `all_of()` outside of a selecting function was deprecated in tidyselect 1.2.0.
    # ℹ See details at <https://tidyselect.r-lib.org/reference/faq-selection-context.html>
    # This warning is displayed once per session.
    # Call `lifecycle::last_lifecycle_warnings()` to see where this warning was generated.
# any_of()直接在全局环境中使用则直接报错：
    # Error:
    #~ ! `any_of()` must be used within a *selecting* function.
    # ℹ See <https://tidyselect.r-lib.org/reference/faq-selection-context.html> for details.
    # Run `rlang::last_trace()` to see where the error occurred.

# 在选择函数中也可以使用.data[[x]]的形式来引用数据框中的列：
df2 %>% select(.data[[x]]) # 从数据框的A、B两列中选出A列
# 但是会警报：
    # Warning message:
    # Use of .data in tidyselect expressions was deprecated in tidyselect 1.2.0.
    # ℹ Please use `all_of(var)` (or `any_of(var)`) instead of `.data[[var]]`
    # This warning is displayed once per session.
    # Call lifecycle::last_lifecycle_warnings() to see where this warning was generated.
# 因此推荐使用all_of()、any_of()函数。

# （2）使用all_of()、any_of()函数选择列时，相当于使用select("A")、select("A","B")，而select()函数当中字符串和符号都可以发挥作用，因此sym()、!!sym()在select()中也能发挥作用，以下命令相当于select(A)。
df2 %>% select(sym(x)) # 结果和select(all_of(x))相同
df2 %>% select(!!sym(x))

#~ !!!syms(y)将包含A、B（符号）的列表展开为A、B（符号），以下命令相当于select(A,B)。
df2 %>% select(!!!syms(y)) # 结果和select(all_of(y))相同

# 以下命令的结果和上一条命令相同，但是会产类似前文all_of()在全局环境中使用时提到的警告，因为!!!data_syms()的结果是将包含.data$A、.data$B的列表展开，该命令相当于select(.data$A,.data$B)，而select()函数推荐使用"A"、"B"而不是.data$A、.data$B来引用列。
df2 %>% select(!!!data_syms(y))

# （3）由于select()函数不像mutate()函数那样存在数据掩码机制，因此get()在select()中仍然会在全局环境中查找变量的值，以下命令会报错。
# df2 %>% select(get(x))
# 细节需要展开讨论：
# （3.1）如果不存在A <- 999，由于全局环境中不存在A变量对应的值，因此get(x)会报错，select(get(x))也就会报错。 
# （3.2）如果存在A <- 999，select(get(x))按照逻辑会选择数据框中列名为"999"的列，但是由于A的值999是数值型，而列名"999"是字符串型，因此即使数据框中存在列名为"999"的列，select(get(x))也会报错。
# （3.3）以下命令唯一可以成立的情况是：数据框中存在列名为"999"的列，并且全局环境中存在z <- "B"、B <- "999"
df3 <- df2 %>% mutate("999" = 4:6)
z <- "B"
B <- "999"
df2 %>% select(get(z))

#* （四）使用环境
# （1）all_of()、any_of()函数用在select()、across()等选择函数当中，用来从数据框中选择列；get()、sym()函数用在mutate()、filter()等函数当中，用来对列进行计算（evaluate）。
# （2）上文（三-2）已经提到在选择函数中使用sym()、!!!syms()可以达到和使用all_of()、any_of()相同的结果，因为选择函数中字符串型数据和符号型数据都可以发挥作用，但这不是常见做法。
# （3）在mutate()、filter()等函数当中使用all_of()、any_of()大多数情况下无法达到和使用get()、!!sym()相同的结果，因为all_of()、any_of()无法通过搭配!!来引用列内容，但是存在一个例外情况：当all_of()搭配!!和":="来为数据框中的列赋值时，all_of()的结果是一个字符串型数据，因此相当于是使用!!搭配":="来为数据框中的列赋值，但这也不是常见做法。
df2 %>% mutate(!!all_of(x) := 4:6) # 该命令相当于mutate(!!x := 4:6)
# （4）在设计函数时，all_of()、any_of()函数在用于选择列时是必须使用的，而get()、sym()、!!sym()函数在RHS的位置上则可以用.data[[x]]的形式替代，在LHS的位置上则只能使用!!sym(x)或者!!x搭配":="来为数据框中的列赋值。

#* （五）rename()函数
# 观察以下命令的结果：
# df1 %>% rename(B = get(x)) # 报错，说明rename()没有数据掩码机制，get(x)会直接返回变量A的值999（如果存在的话）
df1 %>% rename(B = all_of(x)) # 正常运行，将A替换为B
df1 %>% rename(B = sym(x)) # 同上
df1 %>% rename(B = !!sym(x)) # 同上
df1 %>% rename(B = .data[[x]]) # 正常运行，但警报： 
    # Warning message: Use of .data in tidyselect expressions was deprecated in tidyselect 1.2.0. 
    # ℹ Please use all_of(var) (or any_of(var)) instead of .data[[var]] This warning is displayed once per session. 
    # Call lifecycle::last_lifecycle_warnings() to see where this warning was generated. 
# 上述结果的特点和select()函数一致，说明rename()也属于选择函数，因此推荐使用all_of()、any_of()函数。ChatGPT称：“rename() 是 tidyselect + tidy eval 混合机制。”

