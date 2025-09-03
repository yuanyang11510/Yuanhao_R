# -*- coding: utf-8 -*-
#【例4-1】采�?5个类别及对应的值创建单一柱状�?
library(ggplot2)

# 自定义数据集
data <- data.frame(category=c("A","B","C","D","E"),
                   value=c(10,15,7,12,8))
# 创建单一柱状�?
ggplot(data,aes(x=category,y=value)) +
    geom_bar(stat="identity",fill="steelblue") +
    labs(x="Category",y="Value") +
    theme_minimal()				    # 用于设置图表的主题样式为简约风�?

#【例4-2】创建包�?5个类别和4个对应的数值列的分组柱状图
# 自定义一个包含多列数据的数据�?
data <- data.frame(category=c("A","B","C","D","E"),
                   value1=c(10,15,7,12,8),value2=c(6,9,5,8,4),
                   value3=c(3,5,2,4,6),value4=c(9,6,8,3,5))
# 转换数据为长格式
data_long <- tidyr::gather(data,key="variable",value="value",-category)
# 创建堆积柱状�?
ggplot(data_long,aes(x=category,y=value,fill=variable)) +
    geom_bar(stat="identity",position="dodge") +
    labs(x="Category",y="Value") +
    scale_fill_manual(values=c("steelblue","orange","green","purple")) +
    theme_minimal()

#【例4-3】创建包�?5个类别和4个对应的数值列的堆积柱状图
# 续上例，创建堆积柱状�?
ggplot(data_long,aes(x=category,y=value,fill=variable)) +
    geom_bar(stat="identity",position="stack") +
    labs(x="Category",y="Value") +
    scale_fill_manual(values=c("steelblue","orange","green","purple")) +
    theme_minimal()

#【例4-4】创建包�?5个类别和4个对应的数值列的百分比柱状�?
# 续上例，创建堆积柱状�?
ggplot(data_long,aes(x=category,y=value,fill=variable)) +
    geom_bar(stat="identity",position="fill") +
    labs(x="Category",y="Value") +
    scale_fill_manual(values=c("steelblue","orange","green","purple")) +
    theme_minimal()

#【例4-5】创建包�?5个类别和4个对应的数值列的均值柱状图
# 加载数据操作包，用于对数据进行筛选、排序、分组、汇总等操作
library(dplyr)

# 自定义数据集
data <- data.frame(category=c("A","B","C","D","E"),
                   value1=c(10,15,7,12,8),value2=c(6,9,5,8,4),
                   value3=c(3,5,2,4,6),value4=c(9,6,8,3,5))

# 计算每个类别的均值和标准误差
mean_data <- data %>% 
    summarise(across(starts_with("value"),mean))
se_data <- data %>% 
    summarise(across(starts_with("value"),
                     function(x)sd(x)/sqrt(length(x))))

# 转换数据为长格式
mean_se_data <- tidyr::gather(mean_data,key="variable",
                              value="mean_value") %>% 
    left_join(tidyr::gather(se_data,key="variable",value="se_value"),
              by="variable")

# 创建均值柱状图并添加误差棒
ggplot(
    mean_se_data,aes(x=variable,y=mean_value,fill=variable)) +
    geom_bar(stat="identity",width=0.6,color="blue",position="dodge") +
    geom_errorbar(aes(ymin=mean_value-se_value,ymax=mean_value+se_value),
                  width=0.4,color="blue",linewidth=0.8,position="dodge") +
    labs(x="Variable",y="MeanValue") +
    theme_minimal() +
    scale_fill_brewer(palette="Set1"
)

#【例4-6】创建包�?5个类别和5个对应的值及宽度值的不等宽柱状图
# 创建数据�?
data <- data.frame(category=c("A","B","C","D","E"),
                   value=c(10,15,7,12,8),
                   width=c(0.8,0.4,1.0,0.5,0.9))	
# 创建不等宽条形图
ggplot(data,aes(x=category,y=value,fill=category,width=width)) +
    geom_bar(stat="identity") +
    labs(x="Category",y="Value") +
    theme_minimal() +
    theme(legend.position="none",
          axis.title=element_text(size=12,face="bold"),
          panel.grid.major.y=element_line(color="gray80") 
)

#【例4-7】创建条形图示例
# 1) 单一条形�?
data <- data.frame(category=c("A","B","C","D","E"),
                   value=c(10,15,7,12,8))
ggplot(data,aes(x=category,y=value)) +
    geom_bar(stat="identity",fill="steelblue") +
    labs(x="Category",y="Value") +
    theme_minimal() + 
    coord_flip()

# 2）分组条形图
data <- data.frame(category=c("A","B","C","D","E"),
                   value1=c(10,15,7,12,8),value2=c(6,9,5,8,4),
                   value3=c(3,5,2,4,6),value4=c(9,6,8,3,5))
# 转换数据为长格式
data_long <- tidyr::gather(data,key="variable",value="value",-category)
ggplot(data_long,aes(x=category,y=value,fill=variable)) +
    geom_bar(stat="identity",position="dodge") +
    labs(x="Category",y="Value") +
    scale_fill_manual(values=c("steelblue","orange","green","purple")) +
    theme_minimal() +
    coord_flip()

# 3）堆积条形图
ggplot(data_long,aes(x=category,y=value,fill=variable)) +
    geom_bar(stat="identity",position="stack") +
    labs(x="Category",y="Value") +
    scale_fill_manual(values=c("steelblue","orange","green","purple")) +
    theme_minimal() +
    coord_flip()

# 4）百分比条形�?
ggplot(data_long,aes(x=category,y=value,fill=variable)) +
    geom_bar(stat="identity",position="fill") +
    labs(x="Category",y="Value") +
    scale_fill_manual(values=c("steelblue","orange","green","purple")) +
    theme_minimal() +
    coord_flip()

#【例4-8】创建基础棒棒糖图示例
# 创建数据�?
set.seed(10)
data <- data.frame(x=LETTERS[1:26],y=abs(rnorm(26)))
ggplot(data,aes(x=x,y=y)) +
    geom_point(color="red",size=4,alpha=0.8) +
    geom_segment(aes(x=x,xend=x,y=0,yend=y),color="skyblue") +
    # coord_flip() +					# 翻转坐标�?
    theme(panel.grid.major.y=element_blank(),
          panel.border=element_blank(),
          axis.ticks.y=element_blank()) +
    xlab("") +
    ylab("Value of Y")

#【例4-9】利用ggpubr包绘制棒棒糖图示�?
library(ggpubr)

data("mtcars")
dfm <- mtcars
dfm$cyl <- as.factor(dfm$cyl) 				# 将cyl变量转换为因�?
dfm$name <- rownames(dfm)					# 添加名称�?
head(dfm[,c("name","wt","mpg","cyl")])		# 检查数�?

# 计算mpg数据的z分数
dfm$mpg_z <- (dfm$mpg-mean(dfm$mpg))/sd(dfm$mpg)
dfm$mpg_grp <- factor(ifelse(dfm$mpg_z<0,"low","high"),
                      levels=c("low","high"))
head(dfm[,c("name","wt","mpg","mpg_z","mpg_grp","cyl")])	# 检查数�?
ggdotchart(dfm,x="name",y="mpg",
           color="cyl",						# 颜色分组
           palette=c("#00AFBB","#E7B800","#FC4E07"),		# 自定义调色板
           sorting="ascending",				# 按降序对值进行排�?
           add="segments",					# 添加从y=0到点的分�?
           ggtheme=theme_pubr()				# ggplot2主题
)

# 带偏差的棒棒糖图
ggdotchart(dfm,x="name",y="mpg_z",
           color="cyl",
           palette=c("#00AFBB","#E7B800","#FC4E07"),
           sorting="descending",
           add="segments",			#添加从y=0到点的分�?
           add.params=list(color="lightgray",size=2),
           group="cyl",
           dot.size=6,
           label=round(dfm$mpg_z,1),			#将mpg值添加为点标�?
           font.label=list(color="white",size=9,vjust=0.5),
           ggtheme=theme_pubr()) +
    geom_hline(yintercept=0,linetype=2,color="lightgray")

#【例4-10】创建带基线的棒棒糖图示�?
# 创建数据�?
set.seed(10)
data <- data.frame(x=LETTERS[1:26],y=abs(rnorm(26)))

# 绘图
ggplot(data,aes(x=x,y=y)) +
    geom_point(color="orange",size=4,alpha=0.8) +
    geom_segment(aes(x=x,xend=x,y=1,yend=y),color="grey") +
    theme(panel.grid.major.x=element_blank(),
          panel.border=element_blank(),
          axis.ticks.x=element_blank()) +
    xlab("") + ylab("Value of Y")

#【例4-11】创建创建克利夫兰点图示�?
ggplot(data,aes(x=reorder(x,y),y=y)) +
    geom_point(shape=21,size=4,colour="gray60",fill="skyblue") +
    coord_flip() +				
    xlab("") + ylab("Value of Y")

#【例4-12】利用ggpubr包绘制克利夫兰点图示�?
data("mtcars")
dfm <- mtcars
dfm$cyl <- as.factor(dfm$cyl) 			#将cyl变量转换为因�?
dfm$name <- rownames(dfm)					#添加名称�?
head(dfm[,c("name","wt","mpg","cyl")])		#检查数�?

# 计算mpg数据的z分数
dfm$mpg_z <- (dfm$mpg-mean(dfm$mpg))/sd(dfm$mpg)
dfm$mpg_grp <- factor(ifelse(dfm$mpg_z<0,"low","high"),
                      levels=c("low","high"))

ggdotchart(dfm,x="name",y="mpg",
           color="cyl",
           palette=c("#00AFBB","#E7B800","#FC4E07"),
           sorting="descending",
           rotate=TRUE,
           dot.size=2,
           y.text.col=TRUE,
           ggtheme=theme_pubr()) +
    theme_cleveland()

#【例4-13】创建哑铃图示例
set.seed(10)
value1 <- abs(rnorm(26))*2
data <- data.frame(x=LETTERS[1:26],
                   value1=value1,
                   value2=value1+1+rnorm(26,sd=1))
ggplot(data) +
    geom_segment(aes(x=x,xend=x,y=value1,yend=value2),color="grey") +
    geom_point(aes(x=x,y=value1),color=rgb(0.1,0.9,0.5,1),size=3) +
    geom_point(aes(x=x,y=value2),color=rgb(0.9,0.1,0.5,1),size=3) +
    coord_flip() +
    xlab("") +
    ylab("Value of Y")


# 排序哑铃�?: 使用平均值重新排序数�?
data <- data %>% 
    rowwise() %>% 
    mutate(mymean=mean(c(value1,value2))) %>% 
    arrange(mymean) %>% 
    mutate(x=factor(x,x))
ggplot(data) +
    geom_segment(aes(x=x,xend=x,y=value1,yend=value2),color="grey") +
    geom_point(aes(x=x,y=value1),color=rgb(0.1,0.9,0.5,1),size=3) +
    geom_point(aes(x=x,y=value2),color=rgb(0.9,0.1,0.5,1),size=3) +
    coord_flip() +
    xlab("") +
    ylab("Value of Y")

#【例4-14】利用fmsb包绘制雷达图示例
library(fmsb)			# 绘制雷达图的专用�?

set.seed(123)
df <- data.frame(rbind(rep(10,8),rep(0,8),
                       matrix(sample(0:10,8),nrow=1)))
colnames(df) <- paste("Var",1:8)
df2 <- data.frame(rbind(rep(10,8),rep(0,8),
                        matrix(sample(0:10,24,replace=TRUE),nrow=3)))
colnames(df2) <- paste("Var",1:8)

radarchart(df,
           cglty=1,			# 网格线型
           cglcol="gray",	# 网格线颜�?
           cglwd=1,			# 网格的线�?
           pcol=4,			# 线条颜色
           plwd=2,			# 线条宽度
           plty=1)			# 线条线型

# 填充颜色
radarchart(df,cglty=1,cglcol="gray",
           pcol=4,plwd=2,pfcol=rgb(0,0.4,1,0.25))

# 绘制具有多个组的雷达�?
radarchart(df2,
           cglty=1,		# 网格线型
           cglcol="gray",	# 网格线颜�?
           pcol=2:4,		# 线条颜色
           plwd=2,		# 线条宽度
           plty=1)        		# 线条线型

areas <- c(rgb(1,0,0,0.25),
           rgb(0,1,0,0.25),
           rgb(0,0,1,0.25))

# 多个组的雷达图填充颜�?
radarchart(df2,cglty=1,cglcol="gray",pcol=2:4,plwd=2,plty=1,
           pfcol=areas)	# 区域填充�? 
legend("topright",legend=paste("Group",1:3),
       bty="n",pch=20,col=areas,text.col="grey25",pt.cex=2)


#【例4-15】利用ggradar包绘制雷达图示例
library(ggradar)

# 创建数据�?
set.seed(123)
df <- data.frame(matrix(runif(30),ncol=10))
df[,1] <- paste0("G",1:3)
colnames(df) <- c("Group",paste("Var",1:9))

# 绘图
ggradar(df,values.radar=c(0,0.5,1),
        axis.labels=paste0("A",1:9))


ggradar(df,
        background.circle.colour="white",		# 设置背景颜色
        axis.line.colour="gray60",				# 设置线条颜色
        gridline.min.colour="gray60",			# 定义网格线颜�?
        gridline.mid.colour="gray60",
        gridline.max.colour="gray60",
        group.colours=c("#EEA236","#5CB85C","#46B8DA"))


ggradar(df,
        background.circle.colour="white",
        gridline.min.linetype=1,
        gridline.mid.linetype=1,
        gridline.max.linetype=1,
        group.colours=c("#EEA236","#5CB85C","#46B8DA"),
        legend.title="Group",
        legend.position="bottom")

#【例4-16】通过雷达图查看学生哪些科目表现良好或较差
set.seed(123)
data <- as.data.frame(matrix(sample(40:100,10,replace=T),ncol=10))
colnames(data) <- c("math","english","biology","music","R-coding",
                    "chinese","french","physic","statistic","sport")

# 使用fmsb包，须在数据帧中添加两行：每个科目的最大值和最小值，以显示在绘图�?
data <- rbind(rep(100,10),rep(0,10),data)

# 定义雷达�?
par(mar=c(0,0,0,0))
radarchart(data,axistype=1,
           # 定义多边�?
           pcol=rgb(0.2,0.5,0.5,0.9),pfcol=rgb(0.8,0.5,0.5,0.5),plwd=1,
           # 定义网格
           cglcol="grey",cglty=1,axislabcol="grey",
           caxislabels=seq(0,100,25),cglwd=0.8,
           vlcex=0.8)       	# 定义标签

#【例4-17】在同一张图上通过雷达图比较两名学生的成绩差异
set.seed(123)
data <- as.data.frame(matrix(c(sample(40:100,10,replace=T),
                               sample(20:80,10,replace=T)),
                             ncol=10,byrow=TRUE))
colnames(data) <- c("math","english","biology","music","R-coding",
                    "chinese","french","physic","statistic","sport")
data[2,2]=19

# 使用fmsb包，须在数据帧中添加两行：每个科目的最大值和最小值，以显示在绘图�?
data <- rbind(rep(100,10),rep(0,10),data)

# 定义颜色
colors_border=c(rgb(0.2,0.5,0.5,0.9),rgb(0.8,0.2,0.5,0.9))
colors_in=c(rgb(0.2,0.5,0.5,0.4),rgb(0.8,0.2,0.5,0.4))

# 定义雷达�?
radarchart(data,axistype=1,
           pcol=colors_border,pfcol=colors_in,plwd=2,plty=1,# 定义多边�?
           # 定义网格
           cglcol="grey",cglty=1,axislabcol="blue",
           caxislabels=seq(0,100,25),cglwd=1.1,
           vlcex=0.8)       	# 定义标签
# 添加图例
legend(x=0.85,y=1,legend=c("Shirley","Sonia"),bty="n",
       pch=20,col=colors_border,text.col="black",cex=0.9,pt.cex=1.6)

#【例4-18】在同一张图上通过雷达图比较两名学生的成绩差异
library(colormap)
set.seed(123)
data <- as.data.frame(matrix(sample(40:100,60,replace=T),
                             ncol=10,byrow=TRUE))
colnames(data) <- c("math","english","biology","music","R-coding",
                    "chinese","french","physic","statistic","sport")

# 使用fmsb包，须在数据帧中添加两行：每个科目的最大值和最小值，以显示在绘图�?
data <- rbind(rep(100,10),rep(0,10),data)

# 定义颜色
colors_border=colormap(colormap=colormaps$viridis,nshades=6,alpha=1)
colors_in=colormap(colormap=colormaps$viridis,nshades=6,alpha=0.3)

mytitle <- c("Ding","Liu","Yang","Xu","Can","Yao")		# 定义标题
# 分成6个显示部�?
par(mar=rep(0.8,4))
par(mfrow=c(2,3))

# 循环显示6个图�?
for(i in 1:6){
    # 定义雷达�?!
    radarchart(data[c(1,2,i + 2),],axistype=1,
               # 定义多边�?
               pcol=colors_border[i],pfcol=colors_in[i],plwd=1,plty=1,
               # 定义网格
               cglcol="grey",cglty=1,axislabcol="grey",
               caxislabels=seq(0,100,25),cglwd=0.8,
               vlcex=0.8,					# 定义标签
               title=mytitle[i] ) 			# 定义标题
}

#【例4-19】绘制玫瑰图
# 为mtcars数据集添加一列名为car的变量，用于表示车型
mtcars$car=row.names(mtcars)

# 创建ggplot对象p，设置数据和映射关系
p=ggplot(mtcars,aes(x=car,y=mpg,fill=mpg)) +
    geom_bar(binwidth=1,stat='identity') +		# 创建直方�?
    theme_light() + 			# 设置图表主题为浅色背�?
    scale_fill_gradient(low='red',high='white',limits=c(5,40)) +
    # 设置填充颜色的渐变范�?
    theme(axis.title.y=element_text(angle=0)) 	# 设置y轴标题的角度�?0�?

# 设置x轴标签文本的角度和对齐方�?
p + theme(axis.text.x=element_text(angle=45,vjust=1,hjust=1))

p + coord_polar()
p + coord_polar() + aes(x=reorder(car,mpg)) +
    theme(axis.text.x=element_text(angle=-20)) 

#【例4-20】绘制玫瑰图
set.seed(123)
# 随机生成80次风向，并汇集到12个区间内
dir <- cut_interval(runif(80,0,360),n=12)
# 随机生成80次风速，并划分成4种强�?
mag <- cut_interval(rgamma(80,15),4)
sample <- data.frame(dir=dir,mag=mag)

# 将风向映射到x轴，频数映射到y轴，风速大小映射到填充�?
ggplot(sample,aes(x=dir,y=..count..,fill=mag)) +
    # 生成条形图后再转为极坐标形式
    geom_bar() +
    coord_polar()

#【例4-21】绘制玫瑰图示例
library(reshape2)		# 用于数据重塑和转�?

setwd("/Users/lc/Desktop/Rdata")		# 设置工作环境
data=read.csv("Rosechart.csv")

# 将数据从"宽格�?"转换�?"长格�?"，并对部分数据进行类型转�?
data=data[1:12,]				# 保留data数据框的�?12�?
data1=data.frame(t(data))		# 将data数据框进行转�?
data2=data1[2:8,]				# 从转置后的数据框data1中选择了第2到第8�?
colnames(data2)=month.name		# 将data2数据框的列名设置为月份的英文名称
data2$group=row.names(data2)	# 创建名为"group"的新列，将数据框的行名赋给该�?
# 在后续操作中可以将该列作为标识数据的分类或组�?
data3=melt(data2,id="group")	# 将data2数据框从"宽格�?"转换�?"长格�?"
data3$value=as.numeric(data3$value)	# 将data3数据框中的value列转换为数值型

# 绘图
ggplot(data=data3,aes(x=variable,y=value,fill=group)) +
    geom_bar(stat="identity",width=1,colour="black",size=0.1) +
    coord_polar() +
    scale_fill_brewer(palette="Oranges") +
    xlab("") + ylab("") +
    theme_minimal()

#【例4-22】创建基础径向柱状�?
# 加载�?
library(tidyverse)		
library(patchwork)

# 创建数据�?
set.seed(10)
data <- data.frame(
    id=seq(1,60),
    individual=paste("DingM",seq(1,60),sep=""),
    value=sample(seq(10,100),60,replace=T) )

# 绘图
ggplot(data,aes(x=as.factor(id),y=value)) +		# id作为因子变量 
    geom_bar(stat="identity",fill=alpha("orange",1)) +
    coord_polar(start=0) +			# 设置坐标系为极坐�?
    ylim(-100,120) +				# 负值控制内圆的大小，正值调整径向柱状图的大�?
    theme_minimal() +
    theme(axis.text=element_blank(),
          axis.title=element_blank(),
          panel.grid=element_blank(),
          plot.margin=unit(rep(-2,4),"cm"))		# 删除不必要的边际图形


#【例4-23】基于上例的径向柱状图创建带标签的径向柱状图
# 获取每个标签的名称和y位置
label_data <- data
# 设置标签角度
number_of_bar <- nrow(label_data)
angle <- 90-360*(label_data$id-0.5)/number_of_bar
# 字母必须具有条形中心的角度，非极右（1）或极左�?0�?,故减�?0.5
label_data$hjust <- ifelse(angle < -90,1,0)
label_data$angle <- ifelse(angle < -90,angle + 180,angle)
# 绘图
ggplot(data,aes(x=as.factor(id),y=value)) +
    geom_bar(stat="identity",fill=alpha("orange",1)) +
    coord_polar(start=0) +
    ylim(-100,120) +
    theme_minimal() +
    theme(axis.text=element_blank(),
          axis.title=element_blank(),
          panel.grid=element_blank(),
          plot.margin=unit(rep(-1,4),"cm") ) +
    geom_text(data=label_data,
              aes(x=id,y=value + 10,label=individual,hjust=hjust),
              color="black",alpha=1,size=2.5,
              angle=label_data$angle,inherit.aes=FALSE) 


#【例4-24】基于上例的径向柱状图创建带断点的径向柱状图
empty_bar <- 6					# 设置"空白�?"的数�?
# 将线条添加到初始数据集中
to_add <- matrix(NA,empty_bar,ncol(data))
colnames(to_add) <- colnames(data)
data <- rbind(data,to_add)
data$id <- seq(1,nrow(data))

# 获取每个标签的名称和y轴位�?
number_of_bar <- nrow(data)
angle <- 90-360*(data$id-0.5)/number_of_bar
data$hjust <- ifelse(angle < -90,1,0)
data$angle <- ifelse(angle < -90,angle + 180,angle)

# 绘图
ggplot(data,aes(x=as.factor(id),y=value)) +
    geom_bar(stat="identity",fill=alpha("green",1)) +
    ylim(-100,120) +
    theme_minimal() +
    theme(
        axis.text=element_blank(),axis.title=element_blank(),
        panel.grid=element_blank(),plot.margin=unit(rep(-1,4),"cm")) +
    coord_polar(start=0) +
    geom_text(data=data,aes(x=id,y=value+10,label=individual,hjust=hjust),
              color="black",alpha=1,size=2.5,
              angle=data$angle,inherit.aes=FALSE) 


#【例4-25】创建分组径向柱状图
# 创建数据�?
set.seed(10)
data <- data.frame(
    individual=paste("DingM",seq(1,60),sep=""),
    group=c(rep('A',10),rep('B',30),rep('C',14),rep('D',6)),
    value=sample(seq(10,100),60,replace=T))
# 在每个分组末尾设�?"空白�?"的数�?
empty_bar <- 3
to_add <- data.frame(matrix(NA,empty_bar*nlevels(as.factor(data$group)),
                            ncol(data)))
colnames(to_add) <- colnames(data)
to_add$group <- rep(levels(as.factor(data$group)),each=empty_bar)
data <- rbind(data,to_add)
data <- data %>%
    arrange(group)
data$id <- seq(1,nrow(data))

# 获取每个标签的名称和y坐标
lab_data <- data
number_of_bar <- nrow(lab_data)
angle <- 90 - 360*(lab_data$id-0.5)/number_of_bar
lab_data$hjust <- ifelse(angle < -90,1,0)
lab_data$angle <- ifelse(angle < -90,angle + 180,angle)

# 绘图
ggplot(data,aes(x=as.factor(id),y=value,fill=group)) +
    geom_bar(stat="identity",alpha=1) +
    ylim(-100,120) +
    theme_minimal() +
    theme(legend.position="none",
          axis.text=element_blank(),axis.title=element_blank(),
          panel.grid=element_blank(),plot.margin=unit(rep(-1,4),"cm")) +
    coord_polar() +
    geom_text(data=lab_data,aes(x=id,y=value + 10,label=individual,
                                hjust=hjust),color="black",alpha=1,size=2.5,
              angle=lab_data$angle,inherit.aes=FALSE)

#【例4-26】在图表中可以添加一些定制的元素
# 为基线准备一个数据框
base_data <- data %>% 
    group_by(group) %>% 
    summarize(start=min(id),end=max(id)-empty_bar) %>% 
    rowwise() %>% 
    mutate(title=mean(c(start,end)))

# 为网格（刻度）准备一个数据框
grid_data <- base_data
grid_data$end <- grid_data$end[c(nrow(grid_data),1:nrow(grid_data)-1)] + 1
grid_data$start <- grid_data$start-1
grid_data <- grid_data[-1,]

# 绘图
ggplot(data,aes(x=as.factor(id),y=value,fill=group)) +
    geom_bar(aes(x=as.factor(id),y=value,fill=group),stat="identity") +
    # 添加val=100/75/50/25的基线，并放在开始位置以确保条形图在其上方显�?
    geom_segment(data=grid_data,aes(x=end,y=80,xend=start,yend=80),
                 colour="grey",alpha=1,size=0.3,inherit.aes=FALSE) +
    geom_segment(data=grid_data,aes(x=end,y=60,xend=start,yend=60),
                 colour="grey",alpha=1,size=0.3,inherit.aes=FALSE) +
    geom_segment(data=grid_data,aes(x=end,y=40,xend=start,yend=40),
                 colour="grey",alpha=1,size=0.3,inherit.aes=FALSE) +
    geom_segment(data=grid_data,aes(x=end,y=20,xend=start,yend=20),
                 colour="grey",alpha=1,size=0.3,inherit.aes=FALSE) +
    
    # 添加显示每个val=100/75/50/25的数值的文本
    annotate("text",x=rep(max(data$id),4),y=c(20,40,60,80),
             label=c("20","40","60","80"),color="grey",size=3,
             angle=0,fontface="bold",hjust=1) +
    
    geom_bar(aes(x=as.factor(id),y=value,fill=group),
             stat="identity",alpha=1) +
    ylim(-100,120) +
    theme_minimal() +
    theme(legend.position="none",
          axis.text=element_blank(),
          axis.title=element_blank(),
          panel.grid=element_blank(),
          plot.margin=unit(rep(-1,4),"cm")) +
    coord_polar() +
    geom_text(data=lab_data,aes(x=id,y=value+10,label=individual,
                                hjust=hjust),color="black",size=2.5,
              angle=lab_data$angle,inherit.aes=FALSE) +
    
    # 添加基线信息
    geom_segment(data=base_data,aes(x=start,y=-5,xend=end,yend=-5),
                 colour="black",size=0.6,inherit.aes=FALSE) +
    geom_text(data=base_data,aes(x=title,y=-18,label=group),
              hjust=c(1,1,0,0),colour="black",size=4,inherit.aes=FALSE)


#【例4-27】绘制分组堆叠径向柱状图
library(viridis)    		# 用于颜色选择

# 创建数据�?
set.seed(23)
data=data.frame(
    individual=paste("DingM",seq(1,60),sep=""),
    group=c(rep('A',10),rep('B',30),rep('C',14),rep('D',6)),
    value1=sample(seq(10,100),60,replace=T),
    value2=sample(seq(10,100),60,replace=T),
    value3=sample(seq(10,100),60,replace=T))
# 转换整洁格式的数据（长格式）
data=data %>%
    gather(key="observation",value="value",-c(1,2)) 

# 在每组末尾设置要添加的“空柱”数
empty_bar=2
nObsType=nlevels(as.factor(data$observation))
to_add=data.frame(matrix(NA,empty_bar*nlevels(data$group)*nObsType,
                         ncol(data)))
colnames(to_add)=colnames(data)
to_add$group=rep(levels(data$group),each=empty_bar*nObsType)
data=rbind(data,to_add)
data=data %>%
    arrange(group,individual)
data$id=rep(seq(1,nrow(data)/nObsType),each=nObsType)

# 获取每个标签的名称和y 位置
lab_data=data %>%
    group_by(id,individual) %>%
    summarize(tot=sum(value))
number_of_bar=nrow(lab_data)
angle=90 - 360*(lab_data$id-0.5) /number_of_bar
lab_data$hjust <- ifelse(angle < -90,1,0)
lab_data$angle <- ifelse(angle < -90,angle+180,angle)

# 准备基线数据�?
base_data=data %>% 
    group_by(group) %>% 
    summarize(start=min(id),end=max(id) - empty_bar) %>% 
    rowwise() %>% 
    mutate(title=mean(c(start,end)))

# 准备网格（比例）数据�?
grid_data=base_data
grid_data$end=grid_data$end[c(nrow(grid_data),1:nrow(grid_data)-1)]+1
grid_data$start=grid_data$start-1
grid_data=grid_data[-1,]

# 绘图
ggplot(data) + 
    # 添加叠加�?
    geom_bar(aes(x=as.factor(id),y=value,fill=observation),
             stat="identity",alpha=0.5) +
    scale_fill_viridis(discrete=TRUE) +
    geom_segment(data=grid_data,aes(x=end,y=0,xend=start,yend=0),
                 colour="grey",alpha=1,size=0.3,inherit.aes=FALSE) +
    geom_segment(data=grid_data,aes(x=end,y=50,xend=start,yend=50),
                 colour="grey",alpha=1,size=0.3,inherit.aes=FALSE) +
    geom_segment(data=grid_data,aes(x=end,y=100,xend=start,yend=100),
                 colour="grey",alpha=1,size=0.3,inherit.aes=FALSE) +
    geom_segment(data=grid_data,aes(x=end,y=150,xend=start,yend=150),
                 colour="grey",alpha=1,size=0.3,inherit.aes=FALSE) +
    geom_segment(data=grid_data,aes(x=end,y=200,xend=start,yend=200),
                 colour="grey",alpha=1,size=0.3,inherit.aes=FALSE) +
    # 添加显示文本信息
    annotate("text",x=rep(max(data$id),5),y=c(0,50,100,150,200),
             label=c("0","50","100","150","200"),color="grey",
             size=2,angle=0,fontface="bold",hjust=1) +
    ylim(-150,max(lab_data$tot,na.rm=T)) +
    theme_minimal() +
    theme(legend.position="none",
          axis.text=element_blank(),
          axis.title=element_blank(),
          panel.grid=element_blank(),
          plot.margin=unit(rep(-1,4),"cm") 
    ) +
    coord_polar() +
    # 在每个柱的顶部添加标�?
    geom_text(data=lab_data,aes(x=id,y=tot+10,label=individual,hjust=hjust),
              color="black",fontface="bold",alpha=0.6,
              size=3,angle=lab_data$angle,inherit.aes=FALSE) +
    # 添加基线信息
    geom_segment(data=base_data,aes(x=start,y=-5,xend=end,yend=-5),
                 colour="black",alpha=0.8,size=0.6,inherit.aes=FALSE) +
    geom_text(data=base_data,aes(x=title,y=-18,label=group),
              hjust=c(1,1,0,0),colour="black",alpha=0.8,size=4,
              fontface="bold",inherit.aes=FALSE)

#【例4-28】利用wordcloud2包绘制词云图示例
# 加载�? 
library(wordcloud2)				
wordcloud2(data=demoFreq)	
# 创建基础词云�?, 并调整字体大�?
wordcloud2(demoFreq,size=0.5) 	

# 创建带有不同形状的词云图
wordcloud2(demoFreq,size=0.5,shape='pentagon') 	
wordcloud2(demoFreq,size=0.5,shape='star') 		

# 创建带有随机颜色和背景颜色的词云�?
wordcloud2(demoFreq,size=2,color="random-light",
           backgroundColor="grey")					

# 创建带有不同旋转角度的词云图
wordcloud2(demoFreq,size=1,minRotation=-pi/2,
           maxRotation=-pi/2) 						
wordcloud2(demoFreq,size=1,minRotation=-pi/6,
           maxRotation=-pi/6,rotateRatio=1) 		
wordcloud2(demoFreq,size=1,minRotation=-pi/6,
           maxRotation=pi/6,rotateRatio=0.9) 		

# 创建带有自定义颜色的词云�?
wordcloud2(demoFreqC,size=1,color="random-light",
           backgroundColor="grey")					
wordcloud2(demoFreqC,size=1,minRotation=-pi/6,
           maxRotation=-pi/6,rotateRatio=1) 			

# 创建带有自定义颜色向量的词云�?
colorVec=rep(c('orange','blue'),length.out=nrow(demoFreq))
wordcloud2(demoFreq,color=colorVec,fontWeight="bold")		

# 创建根据条件设置颜色的词云图
wordcloud2(demoFreq,color=ifelse(demoFreq[,2] > 20,'orange','skyblue')) 

