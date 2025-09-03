#【例6-1】利用ggplot2绘制直方图示例
# 加载包
library(ggplot2)	
# 创建数据集
set.seed(1234)
wdata <- data.frame(sex=factor(rep(c("F","M"),each=200)),
                    weight=c(rnorm(200,50),rnorm(200,55)))

# 绘图
ggplot(wdata,aes(x=weight,fill=sex,color=sex)) +
    geom_histogram(binwidth=.25,alpha=0.5) +
    # 直方图底部添加边缘轴虚图
    geom_rug() +
    scale_fill_manual(values=c("#00AFBB","#E7B800")) +
    scale_color_manual(values=c("#00AFBB","#E7B800")) +
    labs(x="Weight",y="Count")

#【例6-2】利用ggpubr绘制直方图示例
library(ggpubr)			

# 创建数据集
set.seed(1234)
wdata=data.frame(sex=factor(rep(c("F","M"),each=200)),
                 weight=c(rnorm(200,50),rnorm(200,55)))

# 绘图
gghistogram(wdata,x="weight",bins=30,
            add="mean",rug=TRUE,
            color="sex",fill="sex",
            palette=c("#00AFBB","#E7B800"))


#【例6-3】利用ggplot2绘制核密度图示例
# 创建数据集
set.seed(1234)
wdata=data.frame(sex=factor(rep(c("F","M"),each=200)),
                 weight=c(rnorm(200,55),rnorm(200,58)))

# 绘图
ggplot(wdata,aes(x=weight,color=sex,fill=sex)) +
    geom_density(alpha=0.5) +
    geom_rug() +
    scale_fill_manual(values=c("#00AFBB","#E7B800")) +
    scale_color_manual(values=c("#00AFBB","#E7B800"))

library(hrbrthemes)		# 用于主题设置
# 数值数据
set.seed(9)
data <- data.frame(var1=rnorm(500),var2=rnorm(500,mean=1.5))

# 绘图
ggplot(data,aes(x=x)) +
    # 上部
    geom_density(aes(x=var1,y=..density..),fill="green") +
    geom_label(aes(x=5,y=0.25,label="Var1"),color="green") +
    # 下部
    geom_density(aes(x=var2,y=-..density..),fill="orange") +
    geom_label(aes(x=5,y=-0.25,label="Var2"),color="orange") +
    xlab("Value of x")

#【例6-4】利用ggpubr绘制核密度图示例
# 创建数据集
set.seed(1234)
wdata=data.frame(sex=factor(rep(c("F","M"),each=200)),
                 weight=c(rnorm(200,55),rnorm(200,58)))

# 绘图
ggdensity(wdata,x="weight",
          add="mean",rug=TRUE,
          color="sex",fill="sex",
          palette=c("#00AFBB","#E7B800"))


#【例6-5】绘制箱线图
library(tidyverse)			# 用于数据处理和绘图
library(viridis)    		# 用于颜色选择
library(plotly) 			# 用于创建交互式图形

# 创建数据集
set.seed(123)
data <- data.frame(name=c(rep("A",500),rep("B",500),rep("C",500),
                          rep("D",20),rep('E',100)),
                   value=c(rnorm(500,10,5),rnorm(500,13,8),rnorm(500,18,2),
                           rnorm(20,25,4),rnorm(100,12,10)))

# 绘图
data %>% 
    ggplot(aes(x=name,y=value,fill=name)) +
    geom_boxplot() +
    scale_fill_viridis(discrete=TRUE) +
    theme(legend.position="none",plot.title=element_text(size=11)) +
    ggtitle("A Msleading boxplot") +
    xlab("")

# 添加扰动点
data %>% 
    ggplot(aes(x=name,y=value,fill=name)) +
    geom_boxplot() +
    scale_fill_viridis(discrete=TRUE) +
    geom_jitter(color="skyblue",size=0.7,alpha=0.5) +
    theme(legend.position="none",plot.title=element_text(size=11)) +
    ggtitle("Boxplot with jitter") +
    xlab("")

#【例6-6】利用ggpubr绘制箱线图示例
# 加载数据集
data("ToothGrowth")
df <- ToothGrowth

# 绘制带散点的箱线图
p <- ggboxplot(df,x="dose",y="len",
               color="dose",palette=c("#00AFBB","#E7B800","#FC4E07"),
               add="jitter",shape="dose")
p

# 指定所需的比较组
djb_com <- list(c("0.5","1"),c("1","2"),c("0.5","2"))
# 绘图
# 添加均值比较后的P值
p + stat_compare_means(comparisons=djb_com) +		#添加成对比较p值
    stat_compare_means(label.y=50)					#添加全局p值


#【例6-7】通过自行创建的数据集绘制小提琴图
# 创建数据集
set.seed(123)
data <- data.frame(name=c(rep("A",500),rep("B",500),rep("C",500),
                          rep("D",20),rep('E',100)),
                   value=c(rnorm(500,10,5),rnorm(500,13,8),rnorm(500,18,2),
                           rnorm(20,25,4),rnorm(100,12,10)))
# 绘图
ggplot(data,aes(x=name,y=value,fill=name)) +
    geom_violin()

# 计算不同name分组的样本量
sample_size=data %>%
    group_by(name) %>%
    summarize(num=n())

# 小提琴图和箱线图的组合
data %>% 
    left_join(sample_size) %>% 
    mutate(myaxis=paste0(name,"\n","n=",num)) %>% 
    ggplot(aes(x=myaxis,y=value,fill=name)) +
    geom_violin(width=1.4) +					# 绘制小提琴图
    geom_boxplot(width=0.1,color="grey",alpha=0.2) +	# 在小提琴图基础上添加箱线图
    scale_fill_viridis(discrete=TRUE) +
    theme(legend.position="none",plot.title=element_text(size=11)) +
    ggtitle("Boxplot with jitter") +
    xlab("")

# 自定义函数%||%，用于返回两个输入中非空的那个值
"%||%" <- function(a,b)
{if (!is.null(a)) a else b}

# 自定义函数geom_flat_violin，用于创建一个绘制半边的小提琴图的新图层
geom_flat_violin <- function(mapping=NULL,data=NULL,stat="ydensity",
                             position="dodge",trim=TRUE,scale="area",
                             show.legend=NA,inherit.aes=TRUE,...)
{
    layer(data=data,mapping=mapping,stat=stat,
          geom=GeomFlatViolin,position=position,
          show.legend=show.legend,inherit.aes=inherit.aes,
          params=list(trim=trim,scale=scale,...))
}

# 统计变换
GeomFlatViolin <- 
    ggproto("GeomFlatViolin",Geom,
            setup_data=function(data,params){
                data$width <- data$width %||%
                    params$width %||% (resolution(data$x,FALSE)*0.9)
                # ymin、ymax、xmin、xmax为每个组定义边界矩形
                data %>%
                    group_by(group) %>%
                    mutate(ymin=min(y),ymax=max(y),xmin=x,xmax=x+width/2)
            },
            draw_group=function(data,panel_scales,coord){
                # ＃找到路线的起点
                data <- transform(data,xminv=x,
                                  xmaxv=x+violinwidth*(xmax-x))
                # 确保正确排序以绘制轮廓
                newdata <- rbind(plyr::arrange(transform(data,x=xminv),y),
                                 plyr::arrange(transform(data,x=xmaxv),-y))
                # 将第一个点和最后一个点设置为相同
                newdata <- rbind(newdata,newdata[1,])
                ggplot2:::ggname("geom_flat_violin",
                                 GeomPolygon$draw_panel(newdata,panel_scales,coord))
            },
            draw_key=draw_key_polygon,
            default_aes=aes(weight=1,colour="grey20",fill="white",size=0.5,
                            alpha=NA,linetype="solid"),
            required_aes=c("x","y")
    )
data %>%
    sample_frac(0.4) %>%		# sample_frac函数对数据集进行抽样，抽样的比例为40%
    ggplot(aes(x=name,y=value,fill=name)) +		# 绘制半边的小提琴图
    geom_flat_violin(scale="count",trim=FALSE,width=2) +
    scale_fill_viridis(discrete=TRUE) +
    geom_dotplot(binaxis="y",dotsize=0.8,stackdir="down",	# 添加点
                 binwidth=0.3,position=position_nudge(-0.025)) +
    theme(legend.position="none") + 
    ylab("value")

#【例6-8】绘制小提琴图示例
library(dplyr)			# 用于数据转换
library(tidyr)			# 用于数据整理
library(forcats)		# 用于因子操作

# 加载数据集
setwd("/Users/lc/Desktop/Rdata")		# 设置工作环境
data <- read.table("probly.csv",header=TRUE,sep=",")

# 调整数据格式
data <- data %>% 
    gather(key="text",value="value") %>%
    mutate(text=gsub("\\."," ",text)) %>%
    mutate(value=round(as.numeric(value),0)) %>%
    filter(text %in% c("Almost Certainly","Very Good Chance",
                       "We Believe","Likely","About Even","Little Chance",
                       "Chances Are Slight","Almost No Chance"))

# 绘图
p <- data %>%
    mutate(text=fct_reorder(text,value)) %>% 		# 对数据重新排序
    ggplot(aes(x=text,y=value,fill=text,color=text)) +
    geom_violin(width=2.1,size=0.2) +
    scale_fill_viridis(discrete=TRUE) +
    scale_color_viridis(discrete=TRUE) +
    # theme_ipsum() +
    theme(legend.position="none") +
    coord_flip() +	# 反转坐标轴
    xlab("") +
    ylab("Assigned Probability(%)")
p

#【例6-9】利用ggpubr绘制小提琴图示例
# 加载数据集
data("ToothGrowth")
df <- ToothGrowth
head(df,4)			#输出略
# 指定所需的比较组
djb_com <- list(c("0.5","1"),c("1","2"),c("0.5","2"))
# 绘图
ggviolin(df,x="dose",y="len",fill="dose",
         palette=c("#00AFBB","#E7B800","#FC4E07"),
         add="boxplot",add.params=list(fill="white")) +
    stat_compare_means(comparisons= djb_com,
                       label="p.signif") +# 添加显著性水平
    stat_compare_means(label.y=50)				# 添加全局p值


#【例6-10】利用ggplot2绘制金字塔图示例
library(RColorBrewer)			# 用于颜色调色板
# 从CSV文件中读取数据
dat <- read.csv("email_campaign_funnel.csv")

# 绘图
ggplot(dat,aes(x=Stage,y=Users)) +
    geom_bar(stat="identity",aes(fill=Gender)) +
    scale_fill_brewer(palette='Set1') +
    theme_bw() +
    coord_flip()

# 修改数据格式
dat$Group <- paste(dat$Stage,dat$Gender,sep="_")
dat <- arrange(dat,dat$Gender,dat$Stage)		# 先按Gender排列再按Stage排列
dat$Group <- factor(dat$Group,levels=rev(unique(dat$Group)))
labelname <- rep(rev(unique(dat$Stage)),2)

ggplot(dat,aes(x=Group,y=Users)) +
    geom_bar(stat="identity",aes(fill=Gender)) +
    scale_fill_brewer(palette='Set1') +
    scale_x_discrete(labels=labelname) +
    theme_bw() +
    xlab("") +
    coord_flip()

# 创建一个带有自定义颜色调色板的堆叠条形图
color_palette <- colorRampPalette(brewer.pal(10,"Paired"))(18)
ggplot(dat,aes(x=Gender,y=Users)) +
    geom_bar(stat="identity",aes(fill=Stage)) +
    scale_fill_manual(values=color_palette) +
    theme_bw() +
    theme(legend.position=c("bottom"),
          legend.margin=margin(1,0,1,0)) +
    xlab("") +
    coord_flip()

#【例6-11】利用plotrix绘制金字塔图示例
library(plotrix)			# 用于绘制图形

# 构建示例数据
xy.pop <- c(3.2,3.5,3.6,3.6,3.5,3.5,3.9,3.7,3.9,3.5,
            3.2,2.8,2.2,1.8,1.5,1.3,0.7,0.4)
xx.pop <- c(3.2,3.4,3.5,3.5,3.5,3.7,4,3.8,3.9,3.6,3.2,
            2.5,2,1.7,1.5,1.3,1,0.8)
agelabels <- c("0-4","5-9","10-14","15-19","20-24","25-29","30-34",
               "35-39","40-44","45-49","50-54","55-59","60-64",
               "65-69","70-74","75-79","80-44","85+")
mcol <- color.gradient(c(0,0,0.5,1),c(0,0,0.5,1),c(1,1,0.5,1),18)
fcol <- color.gradient(c(1,1,0.5,1),c(0.5,0.5,0.5,1),c(0.5,0.5,0.5,1),18)

# 使用pyramid.plot函数绘制人口金字塔图
par(mar=pyramid.plot(xy.pop,xx.pop,labels=agelabels,
                     main="Population Pyramid",
                     lxcol=mcol,rxcol=fcol,
                     gap=0.5,show.values=TRUE))

#【例6-12】利用DescTools绘制金字塔图示例1
library(DescTools)		# 用于描述性统计和数据处理

# 构建示例数据
d.sda <- data.frame(
    kt_x=c("ZH","BL","ZG","SG","LU","AR","SO","GL","SZ",
           "NW","TG","UR","AI","OW","GR","BE","SH","AG",
           "BS","FR","GE","JU","NE","TI","VD","VS"),
    apo_n=c(18,16,13,11,9,12,11,8,9,8,11,9,7,9,24,19,
            19,20,43,27,41,31,37,62,38,39),
    sda_n=c(235,209,200,169,166,164,162,146,128,127,
            125,121,121,110,48,34,33,0,0,0,0,0,0,0,0,0)
)

# 使用PlotPyramid函数绘制金字塔图
PlotPyramid(lx=d.sda[,"apo_n"],rx=d.sda[,"sda_n"],ylab=d.sda$kt_x,
            col=c("lightslategray","orange2"),
            border=NA,ylab.x=0,xlim=c(-110,250),gapwidth=NULL,
            cex.lab=0.8,cex.axis=0.8,xaxt=TRUE,
            lxlab="Drugstores",rxlab="General practitioners",
            main="Density of general practitioners and drugstores",
            space=0.5,args.grid=list(lty=1))

#【例6-13】利用DescTools绘制金字塔图示例2
op <- par(mfrow=c(1,3))
m.pop <- c(3.2,3.5,3.6,3.6,3.5,3.5,3.9,3.7,3.9,3.5,
           3.2,2.8,2.2,1.8,1.5,1.3,0.7,0.4)
f.pop <- c(3.2,3.4,3.5,3.5,3.5,3.7,4,3.8,3.9,3.6,3.2,
           2.5,2,1.7,1.5,1.3,1,0.8)
age <- c("0-4","5-9","10-14","15-19","20-24","25-29",
         "30-34","35-39","40-44","45-49","50-54",
         "55-59","60-64","65-69","70-74","75-79","80-44","85+")

# 左侧图
PlotPyramid(m.pop,f.pop,
            ylab=age,space=0,
            col=c("cornflowerblue","indianred"),
            main="Age distribution",
            lxlab="male",rxlab="female")
# 中间图
PlotPyramid(m.pop,f.pop,
            ylab=age,space=1,
            col=c("blue","red"),
            xlim=c(-5,5),
            main="Age distribution",
            lxlab="male",rxlab="female",
            gapwidth=0,ylab.x=-5)
# 右侧图
PlotPyramid(c(1,3,5,8,5,2,1,0),c(2,4,8,10,7,4,2,1),
            ylab=LETTERS[1:8],space=0.3,
            col=rep(rainbow(8),each=2),
            xlim=c(-10,10),args.grid=NA,
            cex.names=1.5,adj=1,
            lxlab="Group A",rxlab="Group B",
            gapwidth=1,ylab.x=-8,xaxt="n")
par(op)

#【例6-14】基于Diamonds（钻石）数据集展示脊线图的绘制
library(ggridges)		# 用于绘制脊线图
# 绘图
ggplot(diamonds,aes(x=price,y=cut,fill=cut)) +
    geom_density_ridges() +				# 创建脊线图
    theme(legend.position="none")		# 隐藏图例

#【例6-15】不同展示方式的脊线图绘制示例
# 加载数据集
data <- read.table("probly.csv",header=TRUE,sep=",")

# 数据预处理
data <- data %>% 
    gather(key="text",value="value") %>% 
    mutate(text=gsub("\\."," ",text)) %>% 
    mutate(value=round(as.numeric(value),0)) %>% 
    filter(text %in% c("Almost Certainly","Very Good Chance",
                       "We Believe","Likely","About Even","Little Chance",
                       "Chances Are Slight","Almost No Chance"))

# 对数据进行重新排序
data %>% 
    mutate(text=fct_reorder(text,value)) %>% 
    # 创建可视化图表
    ggplot(aes(y=text,x=value,fill=text)) +
    geom_density_ridges(alpha=0.6,bandwidth=4) +
    scale_fill_viridis(discrete=TRUE) +
    scale_color_viridis(discrete=TRUE) +
    theme(legend.position="none",
          panel.spacing=unit(0.1,"lines"),
          strip.text.x=element_text(size=8)) +
    xlab("") +
    ylab("Assigned Probability(%)")


# 通过直方图的形式展示
data %>% 
    mutate(text=fct_reorder(text,value)) %>% 
    ggplot(aes(y=text,x=value,fill=text)) +
    geom_density_ridges(alpha=0.6,stat="binline",bins=20) +
    scale_fill_viridis(discrete=TRUE) +
    scale_color_viridis(discrete=TRUE) +
    # theme_ipsum() +
    theme(legend.position="none",
          panel.spacing=unit(0.1,"lines"),
          strip.text.x=element_text(size=8)) +
    xlab("") +
    ylab("Assigned Probability(%)")


# 根据数值变量（而不是类别变量）来设置颜色
ggplot(lincoln_weather,aes(x=`Mean Temperature [F]`,
                           y=`Month`,fill=stat(x))) +
    geom_density_ridges_gradient(scale=3,rel_min_height=0.01) +
    scale_fill_viridis(name="Temp. [F]",option="C") +
    labs(title='Temperatures in Lincoln NE') +
    theme(legend.position="none",
          panel.spacing=unit(0.1,"lines"),
          strip.text.x=element_text(size=8))

#【例6-16】利用corrgram包绘制点阵示例
library(knitr) 			# 用于绘制相关性矩阵图
# 设置knitr选项，指定图形在文档中的对齐方式、宽度和高度
opts_chunk$set(fig.align="center",fig.width=6,fig.height=6)
options(width=90)

library(corrgram)		# 用于创建相关性矩阵图
head(baseball)			# 输出略
round(cor(baseball[,5:14],use="pair"),2)
# 计算数据集中一组特定变量之间的相关性,输出略

# 创建一个包含要分析的变量名称的向量
vars2 <- c("Assists","Atbat","Errors","Hits","Homer","logSal",
           "Putouts","RBI","Runs","Walks","Years")
# 绘图
corrgram(
    baseball[,vars2],     			# 选择数据框 baseball 中的特定变量
    order=TRUE,           			# 重新排列变量以更好地可视化相关性结构
    main="Baseball data PC2/PC1 order",		# 设置图的标题
    lower.panel=panel.shade,		# 在下半部分使用阴影表示相关性强度
    upper.panel=panel.pie,		# 在上半部分使用饼图表示相关性方向
    diag.panel=panel.minmax,		# 在对角线上使用最小和最大值的文本表示变量范围
    text.panel=panel.txt    		# 在文本面板中显示相关性系数的数值
)

# 另一种显示数据的方法
corrgram(
    baseball[,vars2],    			# 选择数据框baseball中的特定变量
    order=TRUE,                		# 按照主成分分析（PCA）的顺序重新排列变量
    main="Baseball correlation ellipses",	# 设置图的标题
    panel=panel.ellipse,      		# 使用椭圆表示相关性
    text.panel=panel.txt,      		# 在文本面板中显示相关性系数的数值
    diag.panel=panel.minmax     		# 在对角线上使用最小和最大值的文本表示变量范围
)

# 利用 auto.csv 数据集绘制点阵图
corrgram(
    auto,                				# 使用数据框auto
    order=TRUE,        					# 按照主成分分析（PCA）的顺序重新排列变量
    main="Auto data (PC order)", 		# 设置图的标题
    lower.panel=corrgram::panel.ellipse,		# 在下半部分使用椭圆表示相关性
    upper.panel=panel.bar,      		# 在上半部分使用柱状图表示相关性
    diag.panel=panel.minmax,			# 在对角线上使用最小和最大值的文本表示变量范围
    col.regions=colorRampPalette(c("darkgoldenrod4","burlywood1",
                                   "darkkhaki","darkgreen"))		# 自定义颜色调色板
)

# 利用 iris.csv 数据集绘制点阵图
corrgram(
    iris,              					# 使用鸢尾花数据集iris
    main="Iris data with example panel functions",		# 设置图的标题
    lower.panel=panel.pts,			# 在下半部分使用点图表示相关性
    upper.panel=panel.conf,    		# 在上半部分使用置信度区间表示相关性
    diag.panel=panel.density    		# 在对角线上使用密度图表示变量分布
)

