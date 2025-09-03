#【例3-1】绘制直方图与箱线图
library(ggplot2)					# 加载ggplot2
data(singer, package = "lattice")   # 加载lattice包下的singer数据集
ggplot(singer, aes(x = height)) +
    geom_histogram()				# 绘制直方图
ggplot(singer, aes(x = voice.part, y = height)) +	    
    geom_boxplot()		            # 绘制箱线图
ggplot(singer,aes(voice.part, height, color = voice.part)) +	
    geom_boxplot()			# 绘制以颜色区分的箱线图
ggplot(singer,aes(voice.part, height, fill=voice.part, color = voice.part)) +
    geom_boxplot()			# 绘制以颜色区分的填充箱线图

#【例3-2】mpg数据集
View(mpg)						# 查看数据
ggplot(data = mpg,aes(x = displ, y = hwy)) +
    geom_point()
ggplot(mpg, aes(displ, hwy, shape = drv, colour = class)) +
    geom_point()
ggplot(mpg, aes(displ, hwy, colour = class)) +
    geom_point(shape = 4, size = 3)
ggplot(mpg, aes(displ, hwy, colour = class)) +
    geom_point(shape = 21,size = 3,fill = "gray")

#【例3-3】通过直方图的绘制学习统计变换
set.seed(8)
dfa <- data.frame(x = rpois(16,6))	# 输入dfa$x可查看数据
barplot(dfa$x)						
ggplot(dfa, aes(x)) +
    geom_bar()						

#【例3-4】统计变换应用示例
set.seed(12)
df <- data.frame(x = rnorm(150))
ggplot(df, aes(x)) +
    geom_density() +
    stat_function(fun = dnorm, colour = "red")

#【例3-5】坐标系统应用示例
library(patchwork)		
p0 <- ggplot(mtcars,aes(disp,wt)) +
    geom_point() +
    geom_smooth()

# 修改X轴显示范围
p11 <- p0 + scale_x_continuous(limits=c(325,500))
# 限制X轴的范围
p12 <- p0 + coord_cartesian(xlim=c(325,500))
# expand 默认TRUE表示在坐标轴两侧留出间隙, 以确保数据和轴不会重叠
p13 <- p0 + coord_cartesian(xlim=c(325,500),expand=FALSE)

p0 + p11 + p12 + p13

# 【例3-6】坐标系统应用示例2
p1 <- ggplot(mpg,aes(displ,cty)) +
    geom_point() +
    geom_smooth()

p2 <- ggplot(mpg,aes(cty,displ)) +	
    geom_point() +
    geom_smooth()				

# 翻转输出
p3 <- ggplot(mpg,aes(displ,cty)) +
    geom_point() +
    geom_smooth() +
    coord_flip()				

p1 + p2 + p3

#【例3-7】极坐标系绘制示例
pie <- ggplot(mtcars,aes(x=factor(1),fill=factor(cyl))) +
    geom_bar(width=1)
pic01 <- pie+coord_polar(theta="y")

cxc <- ggplot(mtcars,aes(x=factor(cyl),fill=factor(cyl))) +
    geom_bar(width=1,colour="black")
pic02 <- cxc+coord_polar()

pic01 + pic02

#【例3-8】利用mpg数据集展示图形分面的应用
p <- ggplot(mpg,aes(displ,hwy,color=class)) +
    geom_point()
# 使用vars()函数提供面处理变量，使用nrow和ncol控制行数和列数
p + facet_wrap(vars(class),nrow=3)

# 使用labeller选项控制标签的显示方式
ggplot(mpg,aes(displ,hwy,color=class)) +
    geom_point() +
    facet_wrap(vars(cyl,drv),labeller="label_both")

p <- ggplot(mpg,aes(displ,cty,color=class)) +
    geom_point()
p + facet_grid(vars(drv),vars(cyl))

mt <- ggplot(mtcars,aes(mpg,wt,colour=factor(cyl))) +
    geom_point()
# 各个子图坐标刻度自由变化
mt + facet_grid(vars(cyl),scales="free")

#【例3-9】标度函数应用实例1
df <- data.frame(x=c("a","b","c","d"),y=c(2,6,1,4))

p11 <- ggplot(df,aes(x,y,fill=x)) +
    geom_bar(stat="identity") +
    labs(x=NULL,y=NULL) +
    theme(legend.position="none")					# 默认设置

# h 表示色相(H)的取值范围，c为饱和度(C)
p12 <- p11 + scale_fill_hue(h=c(100,255),c=20)		# 使用颜色标度函数
p11 + p12

#【例3-10】标度函数应用实例2
# 直接调用RColorBrewer工具包的调色板
p21 <- p11 +
    scale_fill_brewer(type="qual",palette="Set2")
p22 <- p11 +
    scale_fill_brewer(palette="OrRd")
p21 + p22

#【例3-11】标度函数应用实例3
# 灰度配色, start、end为灰度的起始、终止值
p31 <- p11 +
    scale_fill_grey()
p32 <- p11 +
    scale_fill_grey(start=0,end=0.5)
p31 + p32

#【例3-12】标度函数应用实例4
# 直接把颜色序列手动赋值给对应的参数
p41 <- p11 +
    scale_fill_manual(values=c("red","blue","darkgreen","orange"))
p42 <- p11 +
    scale_fill_manual(values=c("green","tomato","orange","blue"))
p41 + p42

#【例3-13】标度函数应用实例5
# 映射变量本身就是颜色编码
df <- data.frame(x=c("sienna1","sienna4","hotpink1","hotpink4"),
                 y=c(5,3,1,7))
p0 <- ggplot(df,aes(x,y,fill=x)) +			# 默认
    geom_bar(stat="identity") +
    labs(x=NULL,y=NULL) +
    theme(legend.position="none")

p1 <- p0 + scale_fill_identity()			# 使用颜色标度函数
p0 + p1

#【例3-14】标度函数应用实例6
set.seed(1)
df <- data.frame(x=1:25,y=rnorm(25))
p11 <- ggplot(df,aes(x,y,color=y)) +						# 默认
    geom_point(size=2) +
    labs(x=NULL,y=NULL)

# low、high 分别指定连续变量最小值和最大值对应的颜色
p12 <- p11 +
    scale_color_gradient(low="blue",high="red")		# 使用颜色标度函数
p11 + p12

#【例3-15】标度函数应用实例7
# 连续型变量中包含具有特殊意义的中间值
p21 <- p11 +
    scale_color_gradient2(low="blue",mid="green",high="red")
# 连续型变量中包含多个中间值时
p22 <- p11 +
    scale_color_gradientn(colors=c("blue","green","yellow","red"),
                          breaks=c(-Inf,-1,1,Inf))
p21 + p22

# 【例3-16】标度函数应用实例8
P31 <- p11 +
    scale_color_steps(low="blue",high="red")
p32 <- p11 +
    scale_color_steps(low="blue",high="red",breaks=c(-Inf,-1,1,Inf))
p31 + p32

#【例3-17】坐标标度函数应用实例1
p11 <- ggplot(mtcars,aes(factor(cyl),fill=factor(cyl))) +
    geom_bar()

# 通过 name、breaks、labels参数调整了x轴的名称、刻度位置、刻度标签
# breaks 确定坐标轴刻度位置，limits 对应于基础绘图系统中的 xlim、ylim 参数
p12 <- p11+
    scale_x_discrete(name="cyl",breaks=c("4","8"),
                     labels=c("No.4","No.8"))

# 通过limits参数限定变量的取值范围，范围外的样本会被从绘图数据中剔除
p13 <- p11+
    scale_x_discrete(name="cyl",limits=c("4","8"))
p11 + p12 + p13

p21 <- p11 +
    scale_x_discrete(expand=c(0,0))		    # 调整坐标轴两侧的空隙为0
p22 <- p11 +
    scale_x_discrete(position="top")		# 调整坐标轴轴标题位置

p21 + p22

#【例3-18】坐标标度函数应用实例2
p31 <- ggplot(mtcars,aes(mpg,drat,colour=factor(cyl))) +
    geom_point()
p32 <- p31 + 
    scale_x_continuous(limits=c(15,30),breaks=seq(15,30,3))
p33 <- p31 + 
    scale_x_continuous(limits=c(15,30),n.breaks=4)
p34 <- p31 + 
    scale_x_continuous(limits=c(15,30),n.breaks=4,labels=LETTERS[1:4])
(p31 + p32)/(p33 + p34)

p41 <- p31 + scale_x_continuous(trans="reverse")
p42 <- p31 + scale_x_continuous(trans="log10")
p43 <- p31 + scale_x_reverse()
p44 <- p31 + scale_x_log10()
(p41 + p42)/(p43 + p44)

#【例3-19】坐标标度函数应用实例3
# 将对应的连续变量分割成若干段
p51 <- ggplot(mtcars,aes(mpg,drat,colour=factor(cyl))) +
    geom_point() +
    scale_x_binned(n.breaks=5,show.limits=T)
p52 <- ggplot(mtcars,aes(mpg,fill=factor(cyl))) +
    geom_bar() +
    scale_x_binned(n.breaks=5)
p51 + p52


















#【例3-20】theme()函数应用实例
p1 <- ggplot(mtcars,aes(wt,mpg,colour=factor(cyl))) +
    geom_point() +
    labs(title="Fuele conomy declines as weight increases")
p11 <- p1 +
    theme(panel.border=element_rect(linetype="dashed",fill=NA))
#  设置x轴和y轴刻度线的长度
p12 <- p1 + theme(
    axis.ticks.length.y=unit(.25,"cm"),
    axis.ticks.length.x=unit(-.25,"cm"),
    axis.text.x=element_text(margin=margin(t=.3,unit="cm")))
p1/p11/p12

p2 <- ggplot(mtcars,aes(wt,mpg)) +
    # 添加散点，根据cyl和vs进行着色和形状区分
    geom_point(aes(colour=factor(cyl),shape=factor(vs))) +
    # 设置x轴和y轴标签
    labs(x="Weight(1000lbs)",y="Fueleconomy(mpg)",
         # 设置颜色和形状图例标签
         colour="Cylinders",shape="Transmission")
p21 <- p2 + theme(legend.position="bottom")		# 调整图例位置
p2/p21

#【例3-21】主题应用实例
# 载入数据
data(diamonds)
set.seed(1234)
diamond <- diamonds[sample(nrow(diamonds),2000),]

# 绘制初始图形
p0 <- ggplot(data=diamond) +
    geom_point(aes(x=carat,y=price,colour=color,shape=cut)) +
    labs(title="Learning ggplot2 Visualization",
         subtitle="Parameter Learning",
         caption="Explanatory Note")
p0

# 设置title的尺寸、颜色、线高、位置
p0 + theme(plot.title=element_text(
    size=16,
    face="bold",
    color="blue",				# 颜色
    hjust=0.5,				# 调整位置，正中间
    lineheight=1.2)
)

p0 + theme_bw() +
    labs(subtitle="Change theme_bw")








# geom_text 添加注释
p11 <- ggplot(mtcars,aes(x=wt,y=mpg,col=vs)) +
    geom_point() + theme_bw() +
    theme(legend.position="none",
          axis.text=element_text(size=15),
          axis.title=element_text(size=18))
# hjust、vjust 设置文本对齐方式, vjust = 1 向下对齐, hjust = "outward" 向外对齐
p12 <- p11 +
    geom_text(aes(label=vs,vjust=1,hjust="outward"))
p11 + p12


# geom_label 添加注释
# 创建 p21，基于 p11 添加带标签的散点
p21 <- p11 +
    geom_label(aes(label=vs),nudge_x=0.25)
# 创建 p22，基于 p11 添加带标签的散点，并调整标签的位置、内边距、半径和大小
p22 <- p11 +
    geom_label(aes(label=vs),nudge_x=0.15,
               label.padding=unit(0.1,"lines"),
               label.r=unit(0.05,"lines"),label.size=0.1)
p21 + p22

# annotate 添加注释
p <- ggplot(mtcars,aes(x=wt,y=mpg,colour=factor(cyl))) +
    geom_point() 
# 创建带有文本注释的新图形对象p11，添加文本"Sometext"在坐标(2:5,25)处
p11 <- p +
    annotate("text",x=2:5,y=25,label="Sometext")
# 创建带有矩形注释的新图形对象p12，矩形边界由(xmin,xmax,ymin,ymax)确定，透明度为0.2
p12 <- p +
    annotate("rect",xmin=3,xmax=4.2,ymin=12,ymax=21,alpha=.2)
# 创建带有文本注释的新图形对象p13，在坐标(2:3,20:21)处添加标签"mylabel"和"label2" 
p13 <- p +
    annotate("text",x=2:3,y=20:21,label=c("mylabel","label2"))
# 创建带有数学表达式的文本注释的新图形对象p14，文本为"italic(R)^2==0.75"
# parse=TRUE表示解释数学表达式
p14 <- p +
    annotate("text",x=4,y=25,label="italic(R)^2==0.75",parse=TRUE)

# 将p11和p12两个图形对象相加，然后除以p13和p14两个图形对象相加，得到最终的图形
(p11 + p12)/(p13 + p14)


# annotation_custom
g <- ggplot(mtcars,aes(x=factor(cyl))) +
    geom_bar() +
    theme_bw() +
    scale_x_discrete(name="cyl") 
g <- ggplotGrob(g)				# 封装
p + annotation_custom(g,xmin=3.5,xmax=5.5,ymin=20,ymax=35)

# annotation_logticks
p <- ggplot(msleep,aes(bodywt,brainwt,colour=factor(vore))) +
    geom_point(na.rm=TRUE) +
    scale_x_log10(
        breaks=scales::trans_breaks("log10",function(x)10^x),
        labels=scales::trans_format("log10",scales::math_format(10^.x))) +
    scale_y_log10(
        breaks=scales::trans_breaks("log10",function(x)10^x),
        labels=scales::trans_format("log10",scales::math_format(10^.x))) +
    theme_bw()
p1 <- p + annotation_logticks(sides="trbl")	# 为所有轴均添加对数刻度
p2 <- p + annotation_logticks(short=unit(.5,"mm"),
                              mid=unit(3,"mm"),long=unit(4,"mm"))	# 调整刻度线尺寸
p1/p2








#【例3-22】使用patchwork包实现页面布局实例
p1 <- ggplot(mpg) +
    geom_point(aes(x=displ,y=hwy,colour=class))
p2 <- ggplot(mpg) +
    geom_bar(aes(x=as.character(year),fill=drv),position="dodge") +
    labs(x="year")
p3 <- ggplot(mpg) +
    geom_density(aes(x=hwy,fill=drv),colour=NA) +
    facet_grid(rows=vars(drv))
p4 <- ggplot(mpg) +
    stat_summary(aes(x=drv,y=hwy,fill=drv),geom="col",fun.data=mean_se)
p1 + p2 + p3 + p4

p3 | (p1 / (p2 | p4))    			# 嵌套布局

p1 / p2 - p3

p1 + p2 + p3 + plot_layout(ncol=2)


#【例3-23】使用gridExtra包实现布局页面
library(gridExtra)
p11 <- ggplot(mtcars,aes(mpg,drat,colour=factor(cyl))) +
    geom_point() +
    scale_x_binned(n.breaks=5,show.limits=T)
p12 <- ggplot(mtcars,aes(mpg,fill=factor(cyl))) +
    geom_bar() +
    scale_x_binned(n.breaks=5)
grid.arrange(p11, p12, ncol=2, newpage = TRUE)
grid.arrange(p11 ,p12, p11,  ncol=2, nrow=2, layout_matrix=rbind(c(1,1),c(2,3)))


# 保存图片
ggplot(mtcars,aes(mpg,wt)) +
    geom_point()
ggsave("mtcars.pdf",width=4,height=4)			# 默认保存最后一幅图形
ggsave("mtcars.pdf",width=20,height=20,units="cm")

