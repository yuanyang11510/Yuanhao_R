#【例2-1】利用R自带数据集mtcars练习使用plot()函数绘制图形，其中wt为车重，disp为排量
# 按2行3列排列
par(mfrow=c(2,3)) 		
# 使用mtcars数据集按重量（wt）排序
mtcars <- mtcars[order(mtcars$wt),]
# 绘制散点图（type='p'），颜色使用rainbow(6)生成的6种颜色
plot(mtcars$wt,mtcars$disp,type='p',main="type='p'",col=rainbow(6))
# 绘制线图（type='l'）
plot(mtcars$wt,mtcars$disp,type='l',main="type='l'",col=rainbow(6))
# 绘制点线图（type='o'），结合了散点图和线图
plot(mtcars$wt,mtcars$disp,type='o',main="type='o'",col=rainbow(6))
# 绘制箱线图（type='b'）
plot(mtcars$wt,mtcars$disp,type='b',main="type='b'",col=rainbow(6))
# 绘制阶梯图（type='s'）
plot(mtcars$wt,mtcars$disp,type='s',main="type='s'",col=rainbow(6))
# 绘制直方图（type='h'）
plot(mtcars$wt,mtcars$disp,type='h',main="type='h'",col=rainbow(6))

# 按2行3列排列
par(mfrow=c(2,3))	
# 绘制实心圆点（pch=1）
plot(mtcars$wt,mtcars$disp,pch=1,main="pch=1",col=rainbow(6))
# 绘制十字点（pch=3）
plot(mtcars$wt,mtcars$disp,pch=3,main="pch=3",col=rainbow(6))
# 绘制实心菱形点（pch=5）
plot(mtcars$wt,mtcars$disp,pch=5,main="pch=5",col=rainbow(6))
# 绘制十字菱形点（pch=7）
plot(mtcars$wt,mtcars$disp,pch=7,main="pch=7",col=rainbow(6))
# 绘制实心三角形点（pch=9）
plot(mtcars$wt,mtcars$disp,pch=9,main="pch=9",col=rainbow(6))
# 绘制十字三角形点（pch=11）
plot(mtcars$wt,mtcars$disp,pch=11,main="pch=11",col=rainbow(6))


#【例2-2】练习使用高级绘图函数绘制图形（使用自带的空气质量数据airquality）
par(mfrow=c(1,3))	
aq <- airquality
# 绘制直方图，如图2-3（a）所示
hist(aq$Wind,xlab="wind",main="Hist in wind")
# 绘制箱线图，如图2-3（b）所示
boxplot(Wind~Month,aq,xlab="Month",main="Box in wind~month")
# 绘制散点图，如图2-3（c）所示
plot(aq$Wind,aq$Temp,xlab='wind',ylab='temp',main='wind and temp')


#【例2-3】利用with()函数绘图
aq <- airquality
# type=n代表是先不绘制图像
plot(aq$Wind,aq$Temp,xlab='wind',ylab='temp',main='Wind and Temp',pch=1,type='n')				
with(subset(aq,Month==5),points(Wind,Temp,col='red'))		# 5月数据为红色点
with(subset(aq,Month==6),points(Wind,Temp,col='green'))	    # 6月数据为绿色点
with(subset(aq,Month==7),points(Wind,Temp,col='orange'))	# 7月数据为橘色点
with(subset(aq,Month %in% c(8,9,10)),points(Wind,Temp,col='blue'))


#【例2-4】利用legend()函数添加图例
leg.txt <- c("a one","a two")		# 创建一个包含两个文本元素的向量，作为图例标签
par(mfrow=c(2,2))		# 设置图形布局为2x2，即创建一个包含4个子图的图形窗口
for(ll in c("","x","y","xy")) {
    plot(2:10,log=ll,main=paste0("log='",ll,"'"))
    abline(1,1)					# 在当前子图中添加一条斜率为1的参考线
    lines(2:3,3:4,col=2)		# 在当前子图中添加一条颜色为2的折线
    points(2,2,col=3)			# 在当前子图中添加一个颜色为3的点
    rect(2,3,3,2,col=4)			# 在当前子图中添加一个矩形，颜色为4
    # 在当前子图中添加两个文本标签，用于注释绘制的图形元素,位于(3,2)、(3,3)处
    text(c(3,3),2:3,c("rect(2,3,3,2,col=4)",
                      "text(c(3,3),2:3,\"c(rect(...)\")"),adj=c(0,0.3))
    # 在当前子图中添加一个图例，包括两个标签（从leg.txt中获取），分别使用颜色2和3
    legend(list(x=2,y=8),legend=leg.txt,col=2:3,pch=1:2,lty=1)#,trace=TRUE)
}


#【例2-5】利用axis()函数修改坐标轴
plot(1:7,rnorm(7),type="s",xaxt="n",frame.plot=FALSE,col="red")

plot(1:7,rnorm(7),type="s",xaxt="n",frame.plot=FALSE,col="red")
axis(1,1:7,LETTERS[1:7],col.axis="blue")

plot(1:7,rnorm(7),type="s",xaxt="n",frame.plot=FALSE,col="red")
axis(4,col="violet",col.axis="darkviolet",lwd=2)

plot(1:7,rnorm(7),type="s",xaxt="n",frame.plot=FALSE,col="red")
axis(3,col="green",lty=2,lwd=0.5)

#【例2-6】图形参数控制示例
x <- 1:50
y <- cos(pi/10*x)
# 使用par函数设置图形参数
par(mfrow=c(2,3),			    # 创建2行3列的图形布局
    mai=c(0.5,0.5,0.2,0.1),	    # 设置边距，上、下、左、右
    cex=0.8,					# 设置全局文本大小
    cex.axis=0.6,				# 设置坐标轴标签文本大小
    cex.lab=0.7,				# 设置轴标题文本大小
    mgp=c(2,1,0),				# 设置刻度线标签的位置
    cex.main=0.8    		    # 设置主标题文本大小
)
# 绘制第一个图形（type="p"）：修改主标题的颜色和字体-黑体
plot(x,y,type="p",font.main=2,main="type=a",col.main="red")
# 绘制第二个图形（type="b")：修改坐标轴、标签、标题字体为斜体
plot(x,y,type="b",pch=21,font.axis=3,font.lab=3,bg="lightgreen", main="type=b",font.main=3)
# 绘制第三个图形（type="o"）: 修改坐标轴标签方向
plot(x,y,type="o",las=3,pch=0,fg="blue",col.lab="blue", main="type=o",font.main=1)
# 绘制第四个图形（type="l"）: 修改直线类型、线条宽度
plot(x,y,type="l",lty=2,col="blue",lwd=2,bty="l",main="type=l")
# 绘制第五个图形（type="s"）：修改颜色和主标题的字体-黑色斜体
plot(x,y,type="s",col="grey20",main="type=s",font.main=4)
# 绘制第六个图形（type="h"）：修改坐标轴颜色、线条宽度
plot(x,y,type="h",col="red",lwd=2,col.axis="red",main="type=h")


#【例2-7】颜色控制示例
aq <- airquality
# 图形参数
par(mfrow=c(1,2),mai=c(0.1,0.1,0.2,0.2),cex=0.8,cex.axis=0.7,cex.lab=0.8,mgp=c(2,1,0),cex.main=0.8)
# 绘制直方图，循环使用两种颜色
hist(aq$Wind,xlab="wind",col=c("red","green"),main="Hist in wind")
# 绘制直方图，重复使用颜色2-7
hist(aq$Wind,xlab="wind",col=2:7,main="Hist in wind")


#【例2-8】使用R颜色集合函数示例
set.seed(9)
x <- c(2,6,1,4,8,2,5) 
a <- c('A','B','C','D','E','F','G')
par(mfrow=c(2,3),mai=c(0.3,0.3,0.2,0.1),cex=0.7,mgp=c(1,1,0),cex.axis=0.7,cex.main=0.8)
# 使用灰度（取值在0~100）渐变颜色集合
barplot (x,names=a,col=gray.colors(10),main="col=gray.colors()")
# 颜色顺序为红色、橙色、黄色、绿色、蓝色、靛蓝色、紫色
barplot(x,names=a,col=rainbow(10),main="col=rainbow()")
# 由红色经橙色到白色变化
barplot(x,names=a,col=heat.colors(10),main="col=heat.colors()") 
# 由绿色经棕色到白色变化
barplot (x,names=a,col=terrain.colors(10),main="col=terrain.colors()") 
# 由蓝色经棕色到白色变化
barplot (x,names=a,col=topo.colors(10),main="col=topo.colors()")
# 由浅蓝色经白色到紫色变化
barplot(x,names=a,col=cm.colors(10),main="col=cm.colors()")

#【例2-9】绘图页面分割应用示例
par(mfrow=c(2,2),mai=c(0.5,0.5,0.3,0.1),cex=0.7,mgp=c(2,1,0),cex.axis=0.8,cex.main=0.8)
set.seed(9)					# 生成随机数种子
pa <- rnorm(100)			# 生成100个标准正态分布随机数
pb <- rexp(100)				# 生成100个指数分布随机数
plot(pa,pb,col=sample(c("green","red","blue"),100,replace=TRUE),main="散点图")
boxplot(pa,pb,pa,pb,pa,col=3:7,main="箱线图")
hist(pa,col="orange1",ylab="pf",main="直方图")
barplot(runif(6,10,100),col=2:7,main="条形图")

#【例2-10】页面布局应用示例
set.seed(9)
x <- rnorm(100)
y <- rexp(100)
layout(matrix(c(1,2,3,4,5,5,6,7,8),3,3,byrow=TRUE),widths=c(2:1),heights=c(1:1))
par(mai=c(0.3,0.3,0.2,0.1),cex.main=0.9)
barplot(runif(8,1,8),col=2:7,main="条形图")
smoothScatter(iris$Sepal.Length,iris$Sepal.Width,nbin=100,main="平滑散点图")
qqnorm(y,col=1:8,pch=10,xlab="",ylab="",main="Q-Q图")
plot(x,y,pch=19,col=c(1,2,4),xlab="",ylab="",main="散点图")
plot(rnorm(16),rnorm(16),cex=(y+2),col=2:4,lwd=2,xlab="",ylab="",main="气泡图")
plot(density(y),col=4,lwd=1,xlab="",ylab="",main="核密度图");
polygon(density(y),col="gold",border="orange")
hist(rnorm(1000),col=3,xlab="",ylab="",main="直方图")
boxplot(x,col=2,main="箱线图")
#【例2-11】页面布局应用示例
# 设置随机数种子，以确保结果可重复
set.seed(16)		
# 生成两组包含100个值的随机数据x和y，这些值受限于范围在-3到3之间
x <- pmin(3,pmax(-3,stats::rnorm(100)))
y <- pmin(3,pmax(-3,stats::rnorm(100)))
# 计算x和y的直方图，将其存储在xhist和yhist中，并指定了直方图的分组边界
xhist <- hist(x,breaks=seq(-3,3,0.5),plot=FALSE)
yhist <- hist(y,breaks=seq(-3,3,0.5),plot=FALSE)
# 获取直方图中的最大计数值
top <- max(c(xhist$counts,yhist$counts)) 
# 指定x和y轴的范围
xrange <- c(-3,3)
yrange <- c(-3,3)
# 创建自定义的图形布局
nf <- layout(matrix(c(2,0,1,3),2,2,byrow=TRUE),c(3,1),c(1,3),TRUE)
# 显示图形布局
layout.show(nf)						
# 设置绘图参数，包括边距
par(mar=c(3,3,1,1)) 				
# 绘制散点图
plot(x,y,xlim=xrange,ylim=yrange,xlab="",ylab="",col=rainbow(10))
# 设置绘图参数，包括边距
par(mar=c(0,3,1,1)) 					
# 绘制x轴的直方图
barplot(xhist$counts,axes=FALSE,ylim=c(0,top),space=0,col=rainbow(10))
# 设置绘图参数，包括边距
par(mar=c(3,0,1,1))                     
# 绘制y轴的直方图，水平放置
barplot(yhist$counts,axes=FALSE,xlim=c(0,top),space=0,horiz=TRUE,col=rainbow(10))
# 重置绘图参数为默认值
# par(def.par)

#【例2-12】同时打开多个绘图窗口示例
# 设置随机数种子，以确保结果可重复
library(showtext)
showtext_auto()  

set.seed(9)
# 生成100个随机数据点
x <- rnorm(100) 	
# 创建一个新的绘图窗口
dev.new()	
# 绘制核密度图，使用density函数计算核密度估计
plot(density(x),col=4,lwd=1,xlab="",ylab="",main="核密度图")
# 填充核密度曲线下面的区域，以创建带阴影的核密度图
polygon(density(x),col="gold",border="orange")
# 创建另一个新的绘图窗口
dev.new()			
# 绘制直方图
hist(x,col=3,xlab="",ylab="",main="直方图")

