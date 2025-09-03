# 【例1-1】在控制台输入
3+8

3+8+34+98+		 # 此处的"+"表示后续还有输入
34+45+56+45-
34-42

# 【例1-2】查看已安装的包
library()
.packages(all.available=TRUE)	# 在命令窗口列出包的名称

# 【例1-3】安装 ggplot2 和 gplots 两个包
install.packages("ggplot2")				# 安装ggplot2包，安装一次即可
install.packages(c("ggplot2","gplots"))	# 同时安装ggplot2、ggraph两个包

# 【例1-4】将 ggplot2 和 gplots 两个包将加载到 R 中
library(ggplot2)				# 加载 ggplot2 包
library(gplots)					# 加载 gplots 包

# 【例1-5】R语言对象
c("海鸥","麻雀","鸽子","海燕")  # 包含4个元素的字符型向量
c(5)						    # 只有1个元素的数值型向量，或者直接输入数字5
list(c("海鸥","麻雀","鸽子"),c(5),"I'm Chinese.")		# 包含3个元素的列表
function(x,y)                   # 函数
{					
    (x^2+y)
}
new.env()						# 环境

# 【例1-6】赋值方法
x1 <- 6				            # 将数值赋给x
x1

x2 <- c("海鸥","麻雀","鸽子","海燕")		# 将字符型向量赋给x
x2

y1 <- y2 <- y3 <- 6		        # 同时将一个值赋给多个变量
y1
y2
y3

6 -> x4				            # 将数值赋给x
x4

z <- c(68,61,82,66,72,44,66,57)		# 将数值向量赋给z
mean(z)				# 计算平均数
sum(z) 				# 求和

# 【例1-7】数据类型应用
Name <- c('Jeff','Tom','Mary')
class(Name)				# 使用 class 函数识别数据类型

Birthday <- c('1985-6-18','1992-4-11','1986-12-8')
class(Birthday) 	    # 数据类型识别

Income <- c(16000,8500,12500)
class(Income) 		    # 数据类型识别

is.character(x=Name)
is.integer(x=c(160,85,125))
is.numeric(x=c(160,85,125))

library(lubridate)				        # 加载包
Score <- as.integer(x=c(160,85,125))	# 类型强制转换
Score								    # 返回向量中的元素
class(Score)						    # 类型识别
Birthday <- as.Date(Birthday) 	        # 类型强制转换
Birthday
class(Birthday) 					    # 类型识别

# 【例1-8】手动输入向量示例。将3个客户的姓名、性别、出生日期和收入保存到各自的变量中
Name <- c('Jeff','Tom','Mary')
Gender <- c('男','男','女')
Birthday <- c('1985-6-18','1992-4-11','1986-12-8')
Income <- c(16000,8500,12500)

# 【例1-9】序列生成法输入向量
X1 <- 1:8; X2 <- 1:-8
X1
X2
X3 <- seq(from=1,to=8) 			    # 创建从1到8，默认步长为1的序列
X3 
X4 <- seq(from=1,to=8,by=2)		    # 创建从1到8，步长为2的序列
X4
X5 <- seq(from=1,to=8,length=2)	    # 创建从1到8，长度为2的序列
X5
X6 <- seq(from=1,by=8,length=2) 	# 创建起点为1，步长为8，长度为2的序列
X6

# 【例1-10】通过重复生成法录入公司2020~2022年各季度的销售额
Year <- rep(x=2020:2022,each=4) 		# 生成2020~2022年的年份信息
Quarter <- rep(x=1:4,times=3) 			# 生成第1~4季度的季度信息
Sales <- c(9.6,8.2,11.1,12.9,13.4,16.2,20.6,31.8,30.6,35.4,39.6,29.5)   # 手动输入销售额信息
DF <- data.frame(Year,Quarter,Sales) 	# 将三个变量组装为数据框对象
View(DF) 								# 预览数据


# 【例1-11】向量子集的提取
X <- 1:12
names(X) <- c('A','B','C','D','E','F','G','H','I','J','K','L')
X

X[5:8]				# 通过正整数提取向量子集
X[c(6,6,8)] 		# 通过正整数提取向量子集
X[-c(6,8)]			# 通过负整数提取不包含响应元素的向量子集
Y <- c(rep(TRUE,3),rep(FALSE,2))			# 创建逻辑向量
Y
X[Y]			    # 通过逻辑向量提取向量子集


# 【例1-12】创建矩阵与数组
X <- matrix(5:16,nrow=3,ncol=4)
X

XX <- t(X)				# 矩阵转置
XX

Y <- array(letters[1:16],dim=c(2,4,2))
Y

# 【例1-13】矩阵子集的提取
Mat <- matrix(1:24,ncol=6)		# 创建4×6的矩阵
Mat

Mat[3,] 					# 取出第3行的数据
Mat[,2] 					# 取出第2列的数据
Mat[,5]                     # 取出第5列的数据
Mat[3,4] 					# 取出第3行第4列的数据
Mat[2:3,2:5] 				# 取出2~3行，2~5列的数据
Mat[1:dim(Mat)[1]%%2==1,1:dim(Mat)[2]%%2==0]		# 取出奇数行偶数列的数据

# 【例1-14】数据框创建示例——手动构造学生信息的向量
ID <- 1:6
Name <- c('Jeff','Tom','Mary','Mike','Mike','Kris')
Gender <- c('Male','Male','Female','Male','Male','Female')
Birthday <- c('1995-6-18','1995-4-11','1996-2-8','1995-8-11','1996-1-23','1995-12-19')
Height <- c(177,182,168,179,173,165)
Weight <- c(65.3,74.2,57.8,70.4,68.9,55.4)
Stu_info <- data.frame(ID,Name,Birthday,Gender,Height,Weight)
View(Stu_info) 				# 数据预览

head(Stu_info,2)		# 只显示数据的前2行,不指定值时，默认显示前6行
tail(Stu_info,2)        # 只显示数据的后2行,不指定值时，默认显示后6行
str(Stu_info) 		    # 查看Stu_info的数据结构

class(Stu_info)			# 使用class()函数可以查看数据框的类型
nrow(Stu_info) 			# 查看数据框的行数
ncol(Stu_info) 			# 查看数据框的列数
dim(Stu_info) 			# 查看数据框的行数和列数

Stu_info$Height			# 指定身高Height（列）
Stu_info[,5]			# 同上
Stu_info[,5 : 6]		# 通过下标指定身高Height及体重Weight
Stu_info[,c(5,6)]		# 同上
Stu_info[5,]			# 指定第5行的数据
Stu_info[c(2,4),]		# 指定第2行、第4行的数据

# 【例1-15】创建包含常数、字符型向量、矩阵和数据框4个元素的列表
# 创建列表元素的对象
Constant <- 20
Vector <- c('本科','本科','硕士','本科','博士')
Mat <- matrix(data=1:9,ncol=3)
DF <- data.frame(ID=1:5,Age=c(22,23,26,23,28),
                 Gender=c('女','男','男','女','男'),
                 Income=c(10500,9800,18000,14000,26000)
)
# 构造列表
List_object <- list(A=Constant,B=Vector,Mat,D=DF)		
List_object

# 【例1-16】利用上例中创建列表 List_object 演示列表的索引，检查返回列表中元素的数据结构
Return_A <- List_object[1]		# 中括号索引
class(Return_A)

Return_B <- List_object[[2]] 		# 双中括号索引
class(Return_B)

Return_C <- List_object[[3]] 		# 双中括号索引
class(Return_C)

Return_D <- List_object$D			# 过美元符号索引
class(Return_D)

# 【例1-17】将向量编码为因子
va <- c("优","良","中","差")    # 创建向量va
va

fac1 <- factor(va)				# 将向量a编码为因子
fac1

as.numeric(fac1) 				# 将因子a转换为数值

fac2 <- factor(va,ordered=TRUE,levels=va)	# 将向量va编码为有序因子
fac2

as.numeric(fac2) 						    # 将因子a转换为数值

# 【例1-18】文件读取
TableA <- read.csv("/Users/lc/Desktop/Rdata/d_table.csv")              # 读取含有标题的csv格式数据
TableB <- read.csv("/Users/lc/Desktop/Rdata/d_table.csv",header=FALSE) # 读取不含有标题的csv格式数据

library(xlsx)
TableC <- read.xlsx("/Users/lc/Desktop/Rdata/d_table.xlsx", sheetIndex = 1)        # 读取 Excel 格式数据
TableC

# 【例1-19】文件保存
dN_table <- read.csv("/Users/lc/Desktop/Rdata/d_table.csv")             # 读取含有标题的csv格式数据
write.csv(dN_table, file="/Users/lc/Desktop/Rdata/d_table_v2.csv")      # 将数据保存为csv格式，并存放在指定路径中
save(dN_table, file="/Users/lc/Desktop/Rdata/d_table_v2.RData")         # 将数据保存为R格式，并存放在指定路径中

# 【例1-20】产生随机数
rnorm(6)			# 产生6个标准正态分布随机数
set.seed(9)		    # 设定随机数种子
rnorm(8,25,2)		# 产生8个均值为25、标准差为2的正态分布随机数
runif(6,0,2)		# 在0~20之间产生6个均匀分布随机数

# 【例1-21】随机抽样
set.seed(10)			    # 设定随机数种子
N <- rnorm(100,6,2)			# 产生100个均值为6、标准差为2的正态分布随机数
n1 <- sample(N,size=8)		# 无放回随机抽取8个数据
n1

# 【例1-22】获取帮助信息
help(lda, package='MASS') 	    # 直接查询某个函数的帮助文档
help.search('geom_bar')			# 加从所有的已下载包中搜寻geom_bar函数
RSiteSearch('Neural Network')	# 在线搜索包含关键词的帮助文档
help(Titanic)					# 查看泰坦尼克号的数据详细信息
example(t.test)					# 运行函数t.test的示例







