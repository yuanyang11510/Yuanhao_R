# 来源：https://blog.csdn.net/m0_45047077/article/details/123284541

name <- c("a","b","a","a","c","c")
num1 <- 1:6
num2 <- c(1,2,1,3,4,5)
dt1 <- data.frame(name = name, number = num1) # 这里的name是有重复的，number没有重复
dt2 <- data.frame(name = name, number = num2) # 这里的name和number都有重复，而且第1行和第3行的内容完全相同
dt1
dt2

# （一）去除重复数据
# 这里的重复，是指两行数据完全相同，也就是说dt1整体来说是没有重复的，只有name有重复。用基础包中的unique()函数可以做到去除完全重复的数据，所有的行只会出现一次
unique(dt1)
# 也可以使用tidyverse包中的distinct函数
distinct(dt1)
#* 可以发现，由于dt1中不存在重复的【行】，因此这两个函数给出的结果和原表格相比没有变化

# 但是如果将unique函数的对象换成其中的name列，重复值（a、c）就会被去除
unique(dt1$name)
# distinct(dt1$name) #! 注意，distinct函数必须应用于一个数据框，因此这一命令会报错

# 如果将上述步骤应用于存在【重复行】的dt2，重复行会被去除
unique(dt2)
distinct(dt2)

# （二）选出重复数据（将第一次出现的数据和此后再次出现的数据分开）
# duplicated()函数返回的是和原数据长度相同的一组逻辑值，于是，可以用来判断和选择数据。找出有重复的，找出没有重复的都可以做到
name
duplicated(dt1$name)
#* 可以发现，duplicated函数会将第一次出现的数据标为FALSE，此后再次出现的相同数据会被标为TRUE
# 有重复的数据
dt1[duplicated(dt1$name) == T,]
# 没有重复的数据
dt1[duplicated(dt1$name) == F,]

# 这个函数的好处是可以将第一次出现和数据和此后再次出现的数据完全分开，互不重叠
## 但是反过来看，它的弊端就是只会选择出第二次及其以后出现的数据，比如此处a在原数据中出现了三次，第一次上出现的a，它认为是没有重复的，这样，如果我们的需求不是【将第一次出现的数据和此后再次出现的数据分开】，而是【选出所有出现次数超过一次的数据】（这个其实才是“选出重复数据”最一般的含义），duplicated函数就无法发挥作用了

# （三）选出重复数据（选出所有出现次数超过一次的数据）
duplicate_name <- dt1 %>% 
    group_by(name) %>% 
    # group_by函数将原表格dt1的指定列进行分组，去除重复值（类似unique函数/distinct函数发挥的作用），在此基础上应用的函数只会作用于分组列中的各个对象
    summarise(freq = n()) %>% 
    # summarise函数一般和group_by函数搭配使用，会在原表格的基础上生成一个新的表格，第一列是通过group_by函数得到的分组列，第二列是指定函数应用于分组列对象的结果
    # n()函数给出相应对象出现的次数，只在summarise函数、mutate函数等环境中生效
    # 以此处为例，至此得到一个新表格，第一列是dt1的name列去除重复值后的结果（暂时称为“分组值”），第二列是这些分组值在原来的name列中出现的次数
    filter(freq > 1) 
    # 过滤出出现次数大于1的分组值
duplicate_name # dt1中的出现次超过一次的数据以及其出现的次数

duplicate_data <- dt1[dt1$name %in% duplicate_name$name,]
duplicate_data

# 如果想要选出重复行，只需要将group_by函数的分组依据设置为所有的列即可
#* 但是注意，group_by函数的分组依据只接受不带引号的列名称，即不接受字符串，如果需要使用字符串格式的元素作为分组依据，可以使用group_by_at函数，这么做的好处是可以和colnames函数搭配使用（colnames函数的结果是字符串），当然，两者结合的用法可以用更简单的group_by_all函数替换
dt2_duplicated <- dt2 %>% 
    group_by_all() %>% 
    filter(n() > 1) %>% 
    ungroup()
dt2_duplicated
