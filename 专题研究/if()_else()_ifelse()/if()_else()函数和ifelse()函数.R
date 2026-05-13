# if()/else()函数和ifelse()函数

## 关于ifelse()函数和if_else()函数的区别，见文件“匿名函数和管道符.R”。

# 一、ifelse()函数可以实现向量化，而if()函数和else()函数不可以
    # 定义一个包含ifelse()函数的函数
    func.ifelse.1 <- function(x)
    {
        ifelse(x > 0, "> 0", 
        ifelse(x < 0, 
        "< 0", 
        "= 0"))
    }

    # 定义一个包含if()函数和else()函数的函数
    func.if.else <- function(x) 
    {
        if(x > 0)
        {
            print("> 0")
        }
        else if(x < 0)
        { 
            print("< 0")
        }
        else 
        {
            print("= 0")
        } 
    }
    vec <- c(-2:2)
    matr <- matrix(-2:1,2)
    ary <- array(-6:11,c(3,2,2))
    dt <- data.frame(a=-1:1,b=1:-1)
    vec
    matr
    ary
    dt

    # 测试ifelse()函数应用于向量/矩阵/数组/数据框
    func.ifelse.1(2) #应用于单个元素
    func.ifelse.1(vec) #应用于向量
    func.ifelse.1(matr) #应用于矩阵
    func.ifelse.1(ary) #应用于数组
    func.ifelse.1(dt) #应用于数据框
    #* 可以发现，ifelse()函数应用于向量/矩阵/数组/数据框（但不能是列表）的每一个元素并返回新的元素，最后输出这些新的元素组成的新的向量/矩阵/数组/数据框

    # 测试if()函数和else()函数应用于向量/矩阵/数组/数据框
    func.if.else(2) #应用于单个元素
    func.if.else(vec) #应用于向量
    func.if.else(matr) #应用于矩阵
    func.if.else(ary) #应用于数组
    func.if.else(dt) #结果报错
    #* 以上命令只有第一条应用于单个元素的情况下输出正确结果，其他情况都会报错，原因是if()函数和else()函数无法应用于包含多个元素的对象

    # ifelse()函数应用于数据框有时会输出一个列表
    ifelse(vec >= 0, vec, "< 0")
    ifelse(matr >= 0, matr, "< 0")
    ifelse(ary >= 0, ary, "< 0")
    # 以上三条命令，输出的仍然是新的向量/矩阵/数组
    ifelse(dt >= 0, dt, "< 0")
    #? 这条命令输出的却是一个列表，而不是新的数据框，其输出步骤如下：从第一列开始自上而下的每一个数据应用ifelse()函数，每一个数据应用ifelse()函数后的结果构成列表的一个元素，因此原数据框中有6个数据，对应列表的6个元素，其中，第1个数据和第6个数据的值是-1，因此ifelse()函数输出"< 0"，中间的四个数据都大于等于0，ifelse()函数输出的是该数据所在列数据组成的向量，为何此处ifelse应用于数据框和应用于其他三类对象得到的结果不同，暂时还不清楚

# 二、以上ifelse()函数应用于向量/矩阵/数组/数据框时都只包含一个参数，如果包含两个以上的参数，则应用于向量等对象时需要另外定义
    # 定义一个包含ifelse()函数并且拥有两个参数的函数
    func.ifelse.2 <- function(x,y)
    {
        ifelse(x > y,
        return("x > y"),
        ifelse(x < y,
        return("x < y"),
        return("x = y")))
    }
    func.ifelse.2(2,3) #对两个参数赋值，输出正确结果
    func.ifelse.2(c(2,3),c(3,2),c(3,3)) #结果报错，因为输入的参数和定义的参数形式不符
    
    # 重新定义一个专门应用于向量的函数
    func.ifelse.3 <- function(...)
    {
        lst <- list(...)
        len <- length(lst)
        results <- c()
        for(i in 1:len)
        {
            if(length(lst[[i]]) !=2 | !is.numeric(lst[[i]]) ) #保证函数只应用于包含两个数值元素的向量
            {
                results <- c(results,"Not numeric pair.")
            }
            else 
            {
                result <- func.ifelse.2(lst[[i]][1],lst[[i]][2]) #需要提前定义一个拥有两个参数的函数
                results <- c(results,result)
            }
        }
        return(results)
    }
    func.ifelse.3(2,3) #只有单个数值元素
    func.ifelse.3(c(1,2,3)) #向量元素数量不等于两个
    func.ifelse.3(c("a","b")) #向量元素为字符串
    func.ifelse.3(c(2,3),c(3,2),c(3,3)) #有多个长度为2的数值向量
    func.ifelse.3(c(3,2),2,c(1,2,3),c(3,3),c("a","b"),c(2,3)) #多种情况的元素混合






