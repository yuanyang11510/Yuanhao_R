# c()、append()、cat()、paste()、paste0()

# 一、c()函数
# c()函数中的"c"应当是来自"combine"的缩写
# 功能：输出一个由多个元素构成的向量
    x.c <- c(1,2,3)
    x.c

# 二、append()函数
# 功能：在原向量中加入新元素并输出新向量
#rfr c()函数也可以发挥类似的功能，但是c()函数加入的新元素只能放在原向量的尾部，而append()函数可以通过设置after参数将新元素插入原向量当中的指定位置，参考：https://stackoverflow.com/questions/16144683/difference-between-c-and-append
    x.c.1 <- c(x.c,4)
    x.c.1
    x.append.1 <- append(x.c,4) #结果和c()函数相同
    x.append.2 <- append(x.c,0,0) #将数值0加到原向量的开头
    x.append.3 <- append(x.c,2.5,2) #将数值2.5加到原向量中2和3之间
    x.append.1
    x.append.2
    x.append.3 #可以发现，当加入数值2.5之后，原来不带小数点的整数数值都带上了小数部分".0"    

# 三、cat()函数
# cat()函数中的"cat"应当是来自"concatenate"的缩写
# 作用：将多个元素合并成一个元素并输出，返回值为NULL
    cat(1,2,3) #默认分隔符号是一个空格，即" "
    cat("a","b","c",sep = "") #可以通过设置sep参数来修改分隔符号
    cat("a","b","c",sep = "_")

    #? 在VS Code中，cat()函数的结果会吞掉头两个字符，并在第三个字符周围出现一个方框，不知原因为何

# 和c()函数相比，c()函数只是将多个元素放置到同一个向量之中，元素和元素之间仍然是相互独立的，而cat()函数则会将多个元素合并成同一个元素
    c(1,2,3) #输出一个包含三个元素的向量
    cat(1,2,3) #将原来的三个元素合并成一个元素并输出，也就是一个只包含了一个元素的向量

    # 顺便可以讨论一下print()函数、cat()函数（以上两者都属于输出函数）、return()语句三者的区别
    #rfr 参考：https://cloud.tencent.com/developer/article/1674178、https://stackoverflow.com/questions/35773027/difference-of-print-and-return-in-r、https://blog.csdn.net/weixin_44115606/article/details/107433271
    # print()函数输出（也叫打印）一个值并返回这个值
    # cat()函数输出一个值，这一点和print()函数相同，但返回值为NULL，因此如果将该命令的结果赋值给一个变量，这个变量输出的永远都是NULL值，如果想要赋值，需要使用paste(0)函数（见下文）
    # return()语句通常出现在自定义的函数当中，返回一个值，并且结束函数的运行，但并不会输出这个值
    
    print(1)
    x.print <- print(1)
    x.print #输出1

    x.cat <- cat(1,2,3)
    x.cat #输出NULL

    return(1) #结果报错
    func1 <- function(){
        x = 1
        return(x) #返回x的值，但不会输出
    }
    func1() #这一步其实是输出函数中返回的x的值

# 四、paste()函数和paste0()函数
# 功能：将多个向量统一转换为字符串向量后，再将每一个字符串向量中的元素按照一一对应的方式连接起来，最后输出一个包含一个或者多个元素的字符串向量
#* 注意paste()函数和paste0()函数的连接方式，并不是像cat()函数那样将多个向量首尾相连，而是将每一个向量的元素按照一一对应的关系分别连接
    v1 <- c(1,2,3)
    v2 <- c("a","b","c")
    v1 #数值向量
    v2 #字符串向量
    x.paste.1 <- paste(v1,v2) #将"1"和"a"、"2"和"b"、"3"和"c"分别相连（数值1、2、3首先被转换成了字符串"1"、"2"、"3"），默认分隔符号是一个空格，即" "
    x.paste.2 <- paste(v1,v2,sep = "") #可以通过设置sep参数修改分隔符号
    x.paste.2.1 <- paste(v1,v2,sep = "_")
    x.paste0 <- paste0(v1,v2) #将"1"和"a"、"2"和"b"、"3"和"c"分别相连，没有分隔符号，即""，并且无法通过设置sep参数进行调整
    x.paste.1
    x.paste.2
    x.paste.2.1
    x.paste0

#rfr 但是，当paste()函数连接的多个向量简化成两个简单元素的时候，其结果和cat()函数是相同的，唯一的区别是paste()函数和paste0()函数也和print()函数一样，最后会返回相应的值，因此可以将结果赋值给变量，而cat()函数不可以，参考：https://cloud.tencent.com/developer/article/1674178
    x.paste.3 <- paste("hello","world")
    x.paste.3
    cat("hello","world")

# paste()函数和paste0()函数还有一个collapse参数，其作用是在将多个向量中的元素一对一相连之后，如果得到了多个新元素，则将这些新元素最后一次性合并到同一个元素之中，通过collapse参数可以设置最后这次合并时的分隔符号
    x.paste.1 #没有collapse参数，得到将原向量中的元素一对一相连后的三个新元素
    x.paste.4 <- paste(v1,v2,collapse = " ") #设置collapse参数为一个空格，将上述三个新元素最后一次性合并到同一个元素之中
    x.paste.4.1 <- paste(v1,v2,collapse = "_") #修改collapse参数
    x.paste.4
    x.paste.4.1

# 五、余论
# 可以发现，在cat()函数和paste()函数、paste0()函数中都出现了sep参数，表示将元素相连时的元素间距，而c()函数和append()函数则没有这一参数，这是由于前两类函数都涉及元素间的连接，即多个元素合并为一个元素，自然需要明确合并之后原来的两个元素之间的分隔符号，而后两类函数仅仅涉及多个元素的并置、新元素的添加，而不会发生元素之间的合并，自然不存在设置元素间距的问题
#* 另外，paste()函数和paste0()函数还多出一个collapse参数，其实质和sep参数没有区别，都是用来调整元素合并之后元素间的分隔符号，但由于paste()函数和paste0()函数定义的元素连接要分两步进行，即先进行不同向量元素之间一一对应的连接，再进行第一步得到的不同新元素之间的连接，第一步是必选的，第二步是可选的，因此只好为第二步中的分隔符号另外设置一个叫做collapse的参数，以与第一步中的sep参数相区别

## 再论cat函数和paste(0)函数的一个区别
# 上文已经提到，cat函数可以使用sep参数将输入的元素用指定的字符串作为分隔符进行连接，但是结果只能输出到控制台，而无法赋值给变量，因为其返回值会变为NULL。这个时候可以使用paste(0)函数来实现赋值的功能，paste(0)函数在【进行第一次连接】的元素只有一个【包含了多个元素的向量】时，使用collapse参数（注意不是sep参数）可以达到和cat函数一样的效果，并且结果可以赋值给变量
a <- cat("a","b","c",sep = "|") # 输出"a|b|c""到控制台，但是变量a被赋值为NULL
a <- paste(c("a","b","c"),collapse = "|") # 赋值"a|b|c"给变量a
a


