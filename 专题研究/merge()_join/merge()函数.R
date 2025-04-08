# 来源：https://cloud.tencent.com/developer/article/2031980

# merge()函数语法
#* merge(x, y, 
#* by = intersect(names(x), names(y)), 
#* by.x = by, by.y = by, 
#* all = FALSE, all.x = all, all.y = all, 
#* sort = TRUE, 
#* suffixes = c(".x",".y"), 
#* incomparables = NULL, ...)

# 语法说明
#* x,y 要合并的两个数据集 
#* by 用于连接两个数据集的列，intersect(a,b)指向量a,b的交集，names(x)指提取数据集x的列名 
#* by = intersect(names(x), names(y)) 是获取数据集x，y的列名后，提取其公共列名，作为两个数据集的连接列，当有多个公共列时，需用下标指出公共列，如names(x)[1]，指定x数据集的第1列作为公共列 
#* 也可以直接写为 by = ‘公共列名’ ，前提是两个数据集中都有该列名，并且大小写完全一致，R语言区分大小写
#* by.x，by.y：指定依据哪些列合并数据框，默认值为相同列名的列
#* all，all.x，all.y：指定x和y的【行】是否应该全在输出文件（默认为FALSE）
## sort：by指定的列（即公共列）是否要排序（默认为TRUE） 注：这一点在下文的【实际应用部分】会讨论
#* suffixes：指定除by外相同列名的后缀
#* incomparables：指定by中哪些单元不进行合并

# 创建表格w
w1 <- data.frame(name = c('A','B','A','A','C','D'), 
school = c('s1','s2','s1','s1','s1','s3'), 
class = c(10, 5, 4, 11, 1, 8), 
English = c(85, 50, 90 ,90, 12, 96))
w1

# 创建表格q
q1 <- data.frame(name = c('A','B','C','F'), 
school = c('s3','s2','s1','s2'), 
class = c(5, 5, 1,3), 
maths = c(80,89,55,90), 
English = c(88, 89, 32, 89))
q1

# 查看两张表格的维度
dim(w);dim(q)

# 查看两张表格的列名称
names(w);names(q)

# （一）inner匹配模式
# 只需指出连接列/连接列组（以下若无需要，统称“连接列”）即可，结果只显示两张表格连接列中均有的行
#* 该模式首先是在两种表格（以下分别成为x表和y表）之间按照连接列中的【不重复数据】取交集，例如x表的连接列中的数据包括"A,A,B,B,C,E"，其不重复数据是"A,B,C,E"，y表的连接列中的数据包括"A,B,C,C,D"，其不重复数据是"A,B,C,D"，两张表格连接列中的不重复数据的交集是"A,B,C"，因此最终得到的表格的连接列中的【不重复数据】就包括"A,B,C"
#* 接下来需要讨论数据匹配的细节，对每一个在两张表格的连接列之间对应的【不重复数据】而言，都存在四种对应关系：（1）一对一，即x表和y表的连接列中都只存在一个该数据；（2）一对多，即x表的连接列中只存在一个该数据，而y表的连接列中存在n（n > 1）个该数据；（3）多对一，即x表的连接列中存在m（m > 1）个该数据，而y表的连接列中只存在一个该数据；（4）多对多，即x表的连接列中存在m（m > 1）个该数据，y表的连接列中存在n（n > 1）个该数据。在第（1）中情况中，只需将两张表格的连接列中相对应的这一对数据对应起来即可；在第（2）种情况中，会将x表中的该数据复制n份，分别对应y表中的n个该数据；在第（3）种情况中，会将y表中的该数据复制m份，分别对应x表中的m个该数据；在第（4）种情况中，会将x表中的每一个该数据分别去对应y表中的每一个该数据，最后一共得到mn对数据
## 经过上述讨论，可以发现，不管两张表格谁在前谁在后，最终得到的表的的连接列的元素内容是不变的，顺序的不同可能会导致两点不同：一是如果设置了sort=FALSE，则最终连接列的元素顺序与x表的连接列中的不重复数据首次出现的顺序一致（关于顺序的讨论，见下文【实际应用】部分）；二是其余列的先后次序，x表的其余列会排在y表的其余列的前面
#* 两张表格一般存在公共列名，但这并非必须：应用inner匹配模式真正重要的前提是两张表格至少存在一条【公共列】，或者更确切点说，至少存在一个【公共数据】，而非至少存在一个【公共列名】

# （甲）两张表格存在公共列名
# （1）直接使用by参数指定连接列的名称
# （1.1）指定一个连接列（name列）
merge(w1,q1,by="name")
# （1.2）指定两个连接列（name列和school列）
merge(w1,q1,by=c("name","school"))
# （1.3）指定三个连接列（name列、school列和class列）
merge(w1,q1,by=c("name","school","class"))
# （1.4）指定四个连接列（name列、school列、class列和English列）
merge(w1,q1,by=c("name","school","class","English"))
#* 可以发现随着连接列的增加，表格的数据【可能】会变少甚至变为0：这是因为连接列越多，相同的连接列组【可能】会越少

# （2）使用intersect函数提取公共列名，搭配by参数指定连接列
intersect_w1_q1 <- intersect(names(w1),names(q1)) # w和q共存在4个公共列名，intersect函数表示取交集
# （2.1）指定一个连接列（name列）
merge(w1,q1,by=intersect_w1_q1[1])
# （2.2）指定两个连接列（name列和school列）
merge(w1,q1,by=intersect_w1_q1[c(1,2)])
# （2.3）指定三个连接列（name列、school列和class列）
merge(w1,q1,by=intersect_w1_q1[c(1,2,3)])
# （2.4）指定四个连接列（name列、school列、class列和English列）
merge(w1,q1,by=intersect_w1_q1)
#* 情况和（1）相同

# （3）使用by.x、by.y参数指定连接列在两张表格中各自对应的列名，此时要求by.x和by.y参数各自指定的列名是一一对应的，即各自的数量是相等的
# （3.1）指定一个连接列（name列）
merge(w1,q1,by.x="name",by.y="name")
# （3.2）指定两个连接列（name列和school列）
merge(w1,q1,by.x=c("name","school"),by.y=c("name","school"))
# （3.3）指定三个连接列（name列、school列和class列）
merge(w1,q1,by.x=c("name","school","class"),by.y=c("name","school","class"))
# （3.4）指定四个连接列（name列、school列、class列和English列）
merge(w1,q1,by.x=c("name","school","class","English"),by.y=c("name","school","class","English"))
# 情况和（1）（2）相同

#* 以上三种方式得到的结果相同，可以发现，在两张表格存在公共列名时，直接使用by参数指定连接列是最方便的做法
#* 连接列（组）置于合并后的表格的开头；对于其他没有被指定为连接列的公共列名，合并后的表格会在这部分公共列名后加上x，y表示数据来源，“.x”表示来源于w，“.y”表示来源于q 
#* 在（1.1）、（2.1）、（3.1）中，w中的D行（第6行）不显示，q中的F行（第4行）不显示，只显示公共的A、B、C行（w的第1--5行和q的第1--3行），并且用q数据集的A行（第1行）匹配了w数据集所有的A行（第1、3、4行）

# （乙）两张表格不存在公共列名
w2 <- w1
names(w2) <- c("name_1","school_1","class_1","English_1")
q2 <- q1
names(q2) <- c("name_2","school_2","class_2","maths","English_2")

# （1）此时无法直接使用by参数，因为使用by参数的前提是两张表格存在【公共列名】

# （2）此时无法使用intersect函数，因为其结果不包含任何数据

# （3）使用by.x、by.y参数时，会以by.x参数指定的列名作为合并后表格的列名
# （3.1）指定一个连接列（name_1列）
merge(w2,q2,by.x="name_1",by.y="name_2")
# （3.2）指定两个连接列（name_1列和school_1列）
merge(w2,q2,by.x=c("name_1","school_1"),by.y=c("name_2","school_2"))
# （3.3）指定三个连接列（name列、school列和class列）
merge(w2,q2,by.x=c("name_1","school_1","class_1"),by.y=c("name_2","school_2","class_2"))
# （3.4）指定四个连接列（name列、school列、class列和English列）
merge(w2,q2,by.x=c("name_1","school_1","class_1","English_1"),by.y=c("name_2","school_2","class_2","English_2"))
#* 结果显示，合并后的表格不再显示name_2列、school_2列、class_2列、English_2列，但是这些列在相应的情况下确实参与了和name_1列、school_1列、class_1列、English_1列的合并

## 总结一下，当两张表格存在公共列名时，使用by参数直接指定连接列是最方便的做法，当两张表格不存在公共列名时，只能分别使用by.x参数和by.y参数指定连接列

# （二）outer匹配模式
# 设置all=TRUE参数，但是不指定连接列，表中原来没有的数据置为空
#* 该模式是在两张表格之间取并集，outer匹配模式的作用原理决定了其不需要指定连接列
# “all=TRUE”表示选取w, q数据集的所有行，“sort=TRUE”表示按连接列进行排序，默认升序
#* 由于sort参数默认为TRUE，因此可以略去，下同
merge(w1,q1,all=TRUE,sort=TRUE)

## 至此可以得出一个结论：inner匹配模式和outer匹配模式可以看作是相互冲突的：如果设置了连接列，就不宜再设置all=TRUE参数，如果设置了all=TRUE参数，就不宜再设置连接列

# （三）left匹配模式
# （1）左连接，设置all.x=TRUE，且未指定连接列
#* 和outer匹配模式相比，这种情况只是在两张表格取并集的基础上，将数据限制在x表格的所有行上
merge(w1,q1,all.x=TRUE,sort=TRUE)

# （2）设置all.x=TRUE，且指定连接列（name列）
#* 和inner匹配模式相比，这种情况只是在两张表格【按照连接列】取交集的基础上，再加上x表格中在连接列中存在、而y表格在连接列中不存在的行
merge(w1,q1,by='name',all.x=TRUE,sort=TRUE)
## 可以发现，纯数字列中的缺失值两边没有尖括号（NA），而包含字符串的列中的缺失值两边有尖括号（<NA>）

# （四）right匹配模式 
# （1）右连接：设置all.y=TRUE，且未指定连接列
#* 和outer匹配模式相比，这种情况只是在两张表格取并集的基础上，将数据限制在y表格的所有行上
merge(w1,q1,all.y=TRUE)

# （2）设置all.y=TRUE，且指定连接列（name列）
#* 和inner匹配模式相比，这种情况只是在两张表格【按照连接列】取交集的基础上，再加上y表格中在连接列中存在、而x表格在连接列中不存在的行
merge(w1,q1,by='name',all.y=TRUE,sort=TRUE)

# 实际应用：实现excel中vlookup函数的功能
# 例一：
dt1 <- data.frame(a=c("A","B","C","D"),b=c(1,2,3,4),c=c("甲","乙","丙","丁"))
dt1

dt2 <- data.frame(a=c("B","C","A","F","A","C","E"))
dt2

# 用dt1匹配dt2
merge(dt2,dt1,sort=FALSE) # inner匹配
merge(dt2,dt1,all.x=TRUE,sort=FALSE) # left匹配
# 由于此处dt1和dt2的公共列只有一条a列，因此在merge函数中可以不写出来

## 关于sort参数
# 在一开始的【函数语法】部分就已经提到，merge函数的sort参数控制的是【by指定的列（即公共列）是否要排序】，但是经检验会发现，即使将其设置为FALSE，最终表格中的公共列顺序和初始表格相比也可能会发生变化：最终表格中的公共列中所有相同的数据会被排列在一起，sort参数控制的仅仅是非重复值的排列顺序，比如上述例子中，dt2中a列（也是公共列）的数据顺序是："B,C,A,F,A,C,E"，其中非重复值一共有5个："A,B,C,E,F"，如果设置sort为默认指TRUE，则最终得到的表格中公共列的数据顺序是："A,A,B,C,C,E,F"，如果设置sort为FALSE，则最终得到的表格中公共列的数据顺序是："B,C,C,A,F,E"，也就是说，sort设置为FALSE的情况下，会按照每个非重复值第一次出现的位置来确定顺序
#* 如果不想要公共列的数据顺序被打乱，可以设置一条辅助列来帮助将公共列的数据还原回一开始的顺序
dt2_1 <- cbind(AssistCol = c(1:nrow(dt2)),dt2) 
dt2_1

dt2_2 <- merge(dt2_1,dt1)
dt2_2
dt2_3 <- dt2_2[order(dt2_2$AssistCol),]
dt2_3
select(dt2_3,a,b,c)

# 例二：
dt3 <- data.frame(a=c("A","B","C","D"),b=c(1,2,3,4),c=c("甲","乙","丙","丁"))
dt3

dt4 <- data.frame(a=c("B","C","A","F","A","C","E"),b=c(2,1,1,3,4,2,2))
dt4

merge(dt4,dt3,by="a",sort=FALSE)
merge(dt4,dt3,by="b",sort=FALSE)
merge(dt4,dt3,by=c("a","b"),sort=FALSE)
merge(dt4,dt3,sort=FALSE)
# 以上inner匹配，选取的连接列不同
## 还可以注意到最后两条命令的结果相同，说明如果不明确写出连接列，则默认连接列是所有的公共列
merge(dt4,dt3,by="a",all.x=TRUE,sort=FALSE)
merge(dt4,dt3,by="b",all.x=TRUE,sort=FALSE)
merge(dt4,dt3,by=c("a","b"),all.x=TRUE,sort=FALSE)
merge(dt4,dt3,all.x=TRUE,sort=FALSE)
# 以上left匹配，选取的连接列不同