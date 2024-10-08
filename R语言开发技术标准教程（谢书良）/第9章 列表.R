# 第9章 列表
# 列表（list）是一种具有很大弹性的特殊对象的集合，虽然它的元素也是由序号（下标）区分，但是各个元素的类型可以是任意对象，例如，向量、矩阵、因子、数据框等。不同元素不必是同一数据类型，例如，字符、字符串或者数值。元素本身可以是其他复杂的数据类型，甚至列表的一个元素也可以是列表。

    # 9.1 列表的构建
            Lst <- list("Fred","Mary",3,c(1,4,7))
            Lst

            Lst <- list(name = "Fred",wife = "Mary",children = 3,child.ages = c(1,4,7))
            Lst

    # 9.2 列表的引用
        # 1. 用“[[]]”符号取得对象元素的内容
            Lst[[1]] #列表中的第一个元素，即名为"name"的向量中的值，即字符串"Fred"
            Lst[[4]][2] #列表中的第四个元素，即名为"child.ages"的向量中的第二个元素，即数值4
            #* 注意，使用“[[]]”符号时，无法取得多个元素，即形如[[1:2]]的用法是不允许的，结果显而易见，这将取得多个不同的值，但是这些值并没有存储在一个新的列表当中，想象一下如果将[[1:2]]命令和赋值命令同时使用，就意味着将不同的值赋值给同一个变量，这显然是不可接受的

        # 2. 用“[]”符号取得对象元素的内容
            Lst[1] #列表中的第一个元素组成的单行列表，因此仍然保留元素名"name"
            Lst[4] #列表中的第四个元素组成的单行列表，因此仍然保留元素名"child.ages"

            Lst[1:2] #列表中的第一个元素和第二个元素组成的多行列表
            Lst[3:4] #列表中的第三个元素和第四个元素组成的多行列表
            #* 可见,使用“[]”符号时，可以取得多个元素，即形如[1:2]的用法时允许的，因为多个元素仍然存储在一个新的列表当中

        # 3. 用元素的名字取得对象元素的内容
            Lst[["child.ages"]] #结果得到一个元素
            Lst[[name]] #结果会报错
            Lst[[c("children","child.ages")]] #结果会报错

            Lst["child.ages"] #结果得到一个元素组成的单行列表
            Lst[child.ages] #结果会报错
            Lst[c("children","child.ages")] #结果得到多个元素组成的多行列表
            
            #* 可以发现：（1）除了书中所说的可以通过“[[]]”符号搭配元素名称来索引元素，“[]”符号也可以完成这步操作；（2）无论是“[[]]”符号还是“[]”符号，其中的元素名称都需要用引号括起来；（3）“[[]]”符号和“[]”符号搭配元素名称的区别同这两者搭配下标时的区别一样，前者只能索引一个元素，且得到的是元素本身，后者可以索引多个元素（注意要用c()函数连接起来），且得到的是元素组成的新列表

        # 4. 用“$”符号取得对象元素的内容
            Lst$name
            Lst$child.ages
            Lst$"name"
            #* 使用“$”符号加上需要索引的元素的名称时，元素名称两边不需要加上引号，但是加上引号也不会报错，结果没有变化

    # 9.3 列表的修改
            Lst$child.ages <- c(2,5,8) 
            Lst[["child.ages"]]
            # 先从原列表中索引出相应的元素，然后向该元素赋予新的值，即可改变原列表中该元素的内容
            Lst$income <- c(6800,5600)
            Lst[["income"]]
            # 也可以从原列表中索引一个不存在的元素，然后向该元素赋值，实际就是在原列表中增加一个新的元素
            Lst

            Lst[["other"]] <- "X"
            Lst

            Lst[[6]] <- "Y"
            Lst

            Lst[6] <- "Z"
            Lst
            #* 上述提到的索引方式都可以和赋值命令搭配使用，用来在原列表中修改已有元素的内容，或者增加新元素，尤其要注意此时“[[]]”符号和“[]”符号都能完成这一操作，尽管从逻辑上来说，“[[]]”符号要优于“[]”符号，因为在原列表中修改元素内容或者增加元素，都是在元素的层面上完成的

            Lst[[7]] <- "W"
            Lst
            #* 可以发现，如果使用的索引方式是通过下标，那么通过这种方式在原列表中增加的新元素就不会有自己的行名称，而是默认用该下标表示

            Lst[[6]] <- NULL
            Lst
            #* 如果要删除列表的某一行，将该行赋予空置（NULL）即可


    # 9.4 处理列表的函数
        # 1. 用names()函数获得以及修改列表对象元素的名称
            names(Lst) # 由于有一个元素没有设置名称，因此其名称是引号括起的空白字符串

            names(Lst)[1] <- "tname"
            Lst
            #* 其实此处[1]也可以替换成[[1]]，结果不会发生变化，可以参见文件“在names()、dimnames()函数中使用[i]、[[i]]”，不过从逻辑上来说，[1]要优于[[1]]，因为前者的索引结果是一个原列表中的元素构成的单行列表，后者的索引结果是原列表中的一个元素，既然要修改原列表中元素的名称，自然是在列表的层面上修改更加合理

            names(Lst)!="children"
            Lst[names(Lst)!="children"]
            Lst[c(TRUE,TRUE,FALSE,TRUE,TRUE,TRUE)]
            #* 可以发现，符号“[]”中除了可以放置下标、元素名称来索引元素外，也可以放置逻辑值来索引元素，TRUE对应的是选出相应的元素，FALSE对应的是不选出相应的元素，并且第三种情况只有在搭配“[]”符号时才有其实用价值，因为“[]”符号中可以放置多个逻辑值（需要用c()函数连接起来），并且数量需要等于元素的个数，而这在“[[]]”符号中是行不通的

            Lst[-3]
            #* 通过在“[]”符号中放置负数，取消选出原列表中第三个元素，即选出除了第三个元素之外的所有元素，显然，负数一般只能搭配“[]”符号使用，而不能搭配“[[]]”函数使用，因为负数往往意味着选出除了某个/某些元素之外的其他元素，而这是“[[]]”符号无法完成的，当然，有一种情况除外，那就是原列表只有两个元素，此时使用负数排除一个元素，则可以顺利选出另一个元素，如下所示：
            lst.test <- list(1,2)
            lst.test
            lst.test[[-1]]

        # 2. 用str()函数获得列表的结构和内容
            str(Lst)

        # 3. 用length()函数获得列表对象元素的个数
            length(Lst)

        # 4. 用c()函数合并列表
            Lst1 <- list(Heights = c(130,145,167),Weights = c(23,28,35))
            Lst1

            ZLst <- c(Lst,Lst1)
            ZLst

            ZLst.1 <- c(ZLst,c(1,3,5),matrix(1:4,2))
            ZLst.1
            #! 可以发现，多个列表可以通过c()函数连接在一起，同时，也可以将列表和向量、矩阵等对象连接在一起，不过不建议这样做，因为得到的结果会比较奇怪，以向量为例，结果并不会将整个向量作为新的一个元素加到原列表当中，而是将向量中的每一个元素都单独作为一个新的元素加到原列表当中，因此，最好是将列表和列表通过c()函数合并，而不要将列表和其他类型的对象合并
