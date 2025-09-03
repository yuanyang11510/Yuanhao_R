#【例5-1】二维散点图绘制示例
# 加载包
library(ggplot2)		
# 基础散点图
ggplot(iris,aes(x=Sepal.Length,y=Sepal.Width)) +
    geom_point()

# 调整颜色透明度后的散点图
ggplot(iris,aes(x=Sepal.Length,y=Sepal.Width)) +
    geom_point(color="orange",fill="skyblue",shape=21,
               alpha=0.7,size=2,stroke=1.2)

# 用于主题设置
library(hrbrthemes)		
ggplot(iris,aes(x=Sepal.Length,y=Sepal.Width)) +
    geom_point(color="green",fill="skyblue",shape=22,
               alpha=0.7,size=2,stroke=1) +
    theme_ipsum()				# 简约化主题


#【例5-2】三维散点图绘制示例
ggplot(iris,aes(x=Sepal.Length,y=Sepal.Width,color=Species)) +
    geom_point(size=2)

# 透明度
ggplot(iris,aes(x=Sepal.Length,y=Sepal.Width,alpha=Species)) +
    geom_point(size=2,color="blue") 

# 形状
ggplot(iris,aes(x=Sepal.Length,y=Sepal.Width,shape=Species)) +
    geom_point(size=2,color="orange")

# 尺寸
ggplot(iris,aes(x=Sepal.Length,y=Sepal.Width,size=Species)) +
    geom_point(color="skyblue",alpha=0.7)


#【例5-3】在散点图中进行线性拟合，并给出置信区间
# 创建数据集
set.seed(1234)
data <- data.frame(cond=rep(c("condition_1","condition_2"),each=10),
                   mx=1:100+rnorm(100,sd=8),
                   my=1:100+rnorm(100,sd=12))

# 基础散点图
ggplot(data,aes(x=mx,y=my)) +
    geom_point(color="#15b2a5")

# 线性拟合
ggplot(data,aes(x=mx,y=my)) +
    geom_point(color="#15b2a5") +
    geom_smooth(method=lm,color="red",se=FALSE)

# 线性拟合及置信区间
ggplot(data,aes(x=mx,y=my)) +
    geom_point(color="#15b2a5") +
    geom_smooth(method=lm,color="red",fill="orange",se=TRUE)


#【例5-4】在散点图中标定区域
theme_set(theme_bw())		# 设置为黑白主题
data("midwest",package="ggplot2")
options(scipen=999) 		# 禁用科学计数法显示

# 散点图
ggplot(midwest,aes(x=area,y=poptotal)) +
    geom_point(aes(col=state,size=popdensity)) +
    geom_smooth(method="loess",se=F) +
    xlim(c(0,0.1)) +
    ylim(c(0,500000)) +
    labs(subtitle="Area Vs Population", y="Population", x="Area",
         title="Scatterplot")


library(ggalt)			# 用于在ggplot2基础上添加一些特殊的图形元素或修改坐标轴
options(scipen=999) 	# 设置选项，用于控制数字的科学计数法显示
# 从midwest数据集中选择符合条件的子集
midwest_select <- midwest[midwest$poptotal > 350000 &
                              midwest$poptotal <=500000 &
                              midwest$area > 0.01 &
                              midwest$area < 0.1,]

# 绘图
ggplot(midwest,aes(x=area,y=poptotal)) +
    geom_point(aes(col=state,size=popdensity)) +		# 绘制散点
    geom_smooth(method="loess",se=F) +
    xlim(c(0,0.1)) +
    ylim(c(0,500000)) +	# 绘制平滑线
    geom_encircle(aes(x=area,y=poptotal),
                  data=midwest_select,
                  color="red",
                  size=2,
                  expand=0.08) +						# 绘制圈选区域
    labs(subtitle="Area Vs Population",
         y="Population",x="Area",
         title="Scatterplot+Encircle")


#【例5-5】利用viridis包绘制散点图示例
library(hrbrthemes)			# 用于主题设置
library(viridis)    		# 用于颜色选择
library(tidyverse)

# 加载数据
setwd("/Users/lc/Desktop/Rdata/")		
rm(list=ls())						# 清空工作空间的所有变量
data <- read.table("2_TwoNum.csv",header=T,sep=",") %>% 
    dplyr::select(GrLivArea,SalePrice)

data %>% 
    ggplot(aes(x=GrLivArea,y=SalePrice/1000)) +
    geom_point(color="blue",alpha=0.6) +
    ggtitle("Explains sale price of apartments") +
    theme(plot.title=element_text(size=12)) +
    ylab('Sale price(k$)') +
    xlab('Ground living area')

# 创建数据集
d1 <- data.frame(x=seq(1,100),y=rnorm(100),name="No trend")
d2 <- d1 %>%
    mutate(y=x*10+rnorm(100,sd=60)) %>% 
    mutate(name="Linear relationship")
d3 <- d1 %>%
    mutate(y=x^2+rnorm(100,sd=140)) %>%
    mutate(name="Square")
d4 <- data.frame(x=seq(1,10,0.1),y=sin(seq(1,10,0.1)) +rnorm(91,sd=0.6)) %>%
    mutate(name="Sin")
don <- do.call(rbind,list(d1,d2,d3,d4))

don %>% 
    ggplot(aes(x=x,y=y)) +
    geom_point(color="#69b3a2",alpha=0.8) +
    facet_wrap(~name,scale="free")

#【例5-6】请使用gapminder数据集绘制气泡图
library(gapminder)		# 提供数据集

data <- gapminder %>%
    filter(year=="2007") %>%
    dplyr::select(-year)

# 基础气泡图
ggplot(data,aes(x=gdpPercap,y=lifeExp,size=pop)) +
    geom_point(alpha=0.5)

# 修改气泡大小及颜色
data %>%
    arrange(desc(pop)) %>%				# 对数据集通过pop变量进行排序
    mutate(country=factor(country,country)) %>%
    # 对country变量的因子顺序进行设置
    ggplot(aes(x=gdpPercap,y=lifeExp,size=pop,color=continent)) +
    geom_point(alpha=0.5) +
    scale_size(range=c(0.1,12),name="Population (M)")


#【例5-7】利用viridis包可以设置更加漂亮的调色板，以美化气泡图
library(viridis)    		# 用于颜色选择

# 绘图
data %>%
    arrange(desc(pop)) %>%
    mutate(country=factor(country,country)) %>%
    ggplot(aes(x=gdpPercap,y=lifeExp,size=pop,fill=continent)) +
    geom_point(alpha=0.5,shape=21,color="black") +
    scale_size(range=c(.1,20),name="Population (M)") +
    
    # 美化气泡图  
    scale_fill_viridis(discrete=TRUE,guide=FALSE,option="A") +
    # theme_ipsum() +
    theme(legend.position="bottom") +
    ylab("Life Expectancy") +
    xlab("Gdp per Capita") +
    theme(legend.position="none")

#【例5-8】基础等高线图绘制示例
# 创建数据集
set.seed(123)
df <- data.frame(x=rnorm(200),y=rnorm(200))

# 绘图
ggplot(df,aes(x=x,y=y)) +
    geom_point() +
    geom_density_2d(bins=15,aes(color=..level..)) +
    scale_color_viridis_c()

# 将geom_contour()更改为stat_contour()时，可以对每个层进行着色
ggplot(df,aes(x=x,y=y,fill=..level..)) +
    stat_density_2d(geom="polygon")

ggplot(df,aes(x=x,y=y)) +
    geom_point() +
    geom_density_2d_filled(alpha=0.4) +
    geom_density_2d(colour="blue")

ggplot(df,aes(x=x,y=y)) +
    geom_density_2d_filled() +
    guides(fill=guide_legend(title="Level"))

#【例5-9】绘制等高线图，并将其转换为交互式图形
library(plotly) 		# 用于创建交互式图形
library(reshape2)   	# 用于数据重塑

df <- melt(volcano)

p <- ggplot(df,aes(Var1,Var2,z=value,colour=stat(level))) +
    geom_contour() +
    scale_colour_distiller(palette="YlGn",direction=1)
ggplotly(p)					# 通过ggplotly()函数将图形转换为交互式图形

# 将geom_contour()更改为stat_contour()时，可以对每个层进行着色
p <- ggplot(df,aes(Var1,Var2,z=value)) +
    stat_contour(geom="polygon",aes(fill=stat(level))) +
    scale_fill_distiller(palette="Spectral",direction=-1)
ggplotly(p)

#【例5-10】使用ggtern包创建了一个三元相图
library(ggtern)			# 用于创建三维坐标图
set.seed(1)
# 创建ggtern图
ggtern(data=data.frame(x=runif(100),y=runif(100),z=runif(100)),
       mapping=aes(x,y,z=z)) +
    # 绘制三元密度多边形
    stat_density_tern(geom='polygon',n=400,
                      aes(fill=..level..,alpha=..level..)) +
    geom_point() +
    # 设置填充颜色渐变
    scale_fill_gradient(low="orange",high="green",name="",breaks=1:5,
                        labels=c("low","","","","high")) +
    scale_L_continuous(breaks=0:5/5,labels=0:5/5) +
    scale_R_continuous(breaks=0:5/5,labels=0:5/5) +
    scale_T_continuous(breaks=0:5/5,labels=0:5/5) +
    labs(title="Density/ContourPlot") +
    guides(fill=guide_colorbar(order=1),alpha=guide_none()) +
    theme_rgbg() +
    theme_noarrows() +
    theme(legend.justification=c(0,1),legend.position=c(0,1))


#【例5-11】使用Fragments示例数据通过ggtern包绘制三元相图
data("Fragments")
base=ggtern(Fragments,aes(Qm,Qp,Rf+M,fill=GrainSize,shape=GrainSize)) +
    theme_bw() +
    theme_legend_position('tr') +
    geom_encircle(alpha=0.5,size=1) +
    geom_point() +
    labs(title="Example Plot",subtitle="using geom_encircle")
print(base)

df.vp=data.frame(x=c(.5,1,0,0,1),y=c(.5,1,0,1,0),
                 label=c('Middle','Top Right','Bottom Left',
                         'Top Left','Bottom Right'))
base2=base+
    theme(legend.position='right') +
    geom_mask() +
    geom_text_viewport(data=df.vp,aes(x=x,y=y,label=label,color=label),
                       inherit.aes=FALSE) +
    labs(color="Label",
         subtitle="using geom_text_viewport")
print(base2)

#【例5-12】瀑布图绘制示例
library(waterfalls)		# 用于创建瀑布图
# 创建数据框
group <- LETTERS[1:15]
value <- c(60,157,198,324,350,331,276,-89
           -164,-101,-266,-239,-149,-95,161,53)
df <- data.frame(x=group,y=value)
waterfall(df)

# 利用calc_total=TRUE计算数值总和并展现在图中
waterfall(df,rect_width=0.4,calc_total=TRUE)		# 调整矩形的宽度
waterfall(df,draw_lines=FALSE,calc_total=TRUE)		# 删除矩形之间的连线
waterfall(df,linetype=1,calc_total=TRUE)			# 保持矩形之间的直线

# 设置fill_colours参数自定义颜色
waterfall(df,fill_by_sign=FALSE,fill_colours=1:15)

#【例5-13】利用ggplot2绘制火山图示例
# 读取数据
df <- read.table(file="Volcano plot data results.txt",
                 sep="\t",header=T,check.names=FALSE)
# 绘图
ggplot(df,aes(log2FoldChange,-log10(pvalue))) +
    geom_point(alpha=0.6,size=2)		

# 数据分类
df$group <- as.factor(ifelse(
    df$pvalue < 0.05 & abs(df$log2FoldChange)>=0.8,
    ifelse(df$log2FoldChange>=0.8,'up','down'),'NS'))
# 绘图
p <- ggplot(df,aes(log2FoldChange,-log10(pvalue))) +
    geom_point(aes(color=group),alpha=0.6,size=2) +
    scale_color_manual(values=c('#E94234','skyblue','#269846'))	# 设置颜色
p

# 添加竖直及垂直辅助线
p1 <- p+geom_vline(xintercept=c(-0.8,0.8),lty=3,color='black',lwd=0.5) +
    geom_hline(yintercept=-log10(0.05),lty=3,color='black',lwd=0.5)
p1

# 设置主题
p2 <- p1+ 
    theme_bw() +
    theme(legend.title=element_blank(),panel.grid=element_blank()) +
    labs(title="volcanoplot",x='log2foldchange',y='-log10pvalue')
p2


#【例5-14】使用ggvolcano函数绘制普通火山图示例
library(ggVolcano)			# 用于创建火山图
library(patchwork)  		# 用于组合多个图形

# 采用自带数据deg_data
data(deg_data)
# 使用add_regulate函数将一个'regulate'列添加到差异表达基因结果数据框中
data <- add_regulate(deg_data,log2FC_name="log2FoldChange",
                     fdr_name="padj",log2FC=1,fdr=0.05)
# 绘制火山图
ggvolcano(data,x="log2FoldChange",y="padj",
          label="row",label_number=10,output=FALSE)

# 更改填充和颜色：
p1 <- ggvolcano(data,x="log2FoldChange",y="padj",
                fills=c("#E94234","#b4b4d8","#269846"),
                colors=c("#E94234","#b4b4d8","#269846"),
                label="row",label_number=10,output=FALSE)

p2 <- ggvolcano(data,x="log2FoldChange",y="padj",
                label="row",label_number=10,output=FALSE) +
    ggsci::scale_color_aaas() +
    ggsci::scale_fill_aaas()
p1|p2


#【例5-15】使用ggvolcano函数绘制渐变颜色火山图示例
library(RColorBrewer)
# 绘制渐变颜色火山图
gradual_volcano(deg_data,x="log2FoldChange",y="padj",
                label="row",label_number=10,output=FALSE)
# 更改填充和颜色：
p1 <- gradual_volcano(data,x="log2FoldChange",y="padj",
                      fills=brewer.pal(5,"RdYlBu"),
                      colors=brewer.pal(8,"RdYlBu"),
                      label="row",label_number=10,output=FALSE)

p2 <- gradual_volcano(data,x="log2FoldChange",y="padj",
                      label="row",label_number=10,output=FALSE) +
    ggsci::scale_color_gsea() +
    ggsci::scale_fill_gsea()
p1|p2

#【例5-16】使用term_volcano函数绘制GO术语火山图示例
data("term_data")

# 绘制GO术语火山图
term_volcano(deg_data,term_data,
             x="log2FoldChange",y="padj",
             label="row",label_number=10,output=FALSE)

# 更改填充和颜色：
deg_point_fill <- brewer.pal(5,"RdYlBu")
names(deg_point_fill) <- unique(term_data$term)

term_volcano(data,term_data,
             x="log2FoldChange",y="padj",
             normal_point_color="#75aadb",
             deg_point_fill=deg_point_fill,
             deg_point_color="grey",
             legend_background_fill="#deeffc",
             label="row",label_number=10,output=FALSE)

