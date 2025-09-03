#【例10-1】折线图绘制示例1
# 加载包
library(ggplot2)		
library(hrbrthemes)		# 用于主题设置

# 创建数据集
set.seed(123) 			# 设置随机数种子
xValue <- 1:20
yValue <- cumsum(rnorm(20))
data <- data.frame(xValue,yValue)

# 绘制折线图1
ggplot(data,aes(x=xValue,y=yValue)) +
    geom_line(color="red")

# 绘制折线图2, 虚线
ggplot(data,aes(x=xValue,y=yValue)) +
    geom_line(color="blue",size=0.6,alpha=0.9,linetype=2) +
    ggtitle("Plot_Djb")

#【例10-2】折线图绘制示例2
# 加载包
library(dplyr)			# 用于数据转换
library(plotly) 		# 用于创建交互式图形

# 从文件中读取数据
setwd("/Users/lc/Desktop/Rdata")		# 设置工作环境
data <- read.table("TwoNumOrdered.csv",header=TRUE)
data$date <- as.Date(data$date)

# 绘制折线图
data %>%
    ggplot(aes(x=date,y=value)) +
    geom_line(color="#69b3a2") +
    ylim(0,22000) +
    annotate(geom="text",x=as.Date("2017-01-01"),y=20089,
             label="Bitcoin price reached 20k $") +
    annotate(geom="point",x=as.Date("2017-12-17"),y=20089,
             size=10,shape=21,fill="transparent") +
    geom_hline(yintercept=5000,color="orange",size=0.5)


#【例10-3】折线图绘制示例3
# 加载包
library(babynames)		# 提供数据集
library(viridis) 		# 用于颜色选择

# 从数据集中筛选数据
don <- babynames %>% 
    filter(name %in% c("Ashley","Patricia","Helen")) %>%
    filter(sex == "F")

# 绘制折线图
don %>%
    ggplot(aes(x=year,y=n,group=name,color=name)) +
    geom_line() +
    scale_color_viridis(discrete=TRUE) +
    ggtitle("Popularity of names in the 30 years") +
    ylab("Number of babies born")

#【例10-4】利用自创数据绘制基础面积图
# 加载包
library(ggplot2)		# 用于数据可视化
library(dplyr)			# 用于数据转换
library(tidyr)			# 用于数据整理
library(splines)		# 用于数据差值

# 数据准备
set.seed(1234)			# 设定随机种
df <- data.frame(var=LETTERS[1:12],		
                 id=1:12,
                 a=runif(12),b=runif(12),c=runif(12),		# 随机数
                 stringsAsFactors=F)						# 不转换为因子

# 转换为长数据形式
df1 <- df %>%
    gather("item",value,-1:-2) %>% 
    bind_cols(data.frame(item_id=rep(1:3,each=12)))

# 绘制面积图
ggplot(df1,aes(id,value)) +
    geom_area(aes(fill=item),position=position_dodge(width=0),alpha=0.5) +	# 定义位置函数
    labs(title="Area Chart",fill="") +
    scale_x_continuous(breaks=1:12,labels=LETTERS[1:12])

# 分面的面积图
ggplot(df1,aes(id,value)) +
    geom_area(aes(fill=item),position="stack",alpha=0.5) +
    labs(title="Area Chart",fill="") +
    scale_x_continuous(breaks=1:10,labels=LETTERS[1:10]) +
    facet_grid(item~.) +
    theme(legend.position="none")			# 取消显示图例


#【例10-5】采用上面自创的数据集绘制堆积面积图
# 堆积面积图
ggplot(df1,aes(id,value)) +
    geom_area(aes(fill=item),alpha=0.5) +
    labs(title="Area Chart") +
    scale_x_continuous(breaks=1:12,labels=LETTERS[1:12])

#【例10-6】采用上面自创的数据集绘制百分比堆积面积图
# 百分比堆积面积图
ggplot(df1,aes(id,value)) +
    geom_area(aes(fill=item),position="fill",alpha=0.5) +
    labs(title="Area Chart",fill="") +
    scale_x_continuous(breaks=1:12,labels=LETTERS[1:12])

#【例10-7】绘制面积图示例
# 加载包
library(ggplot2)			# 用于数据可视化
library(lubridate)			# 用于日期时间数据处理
library(RColorBrewer)		# 用于颜色选择

# psavet为个人储蓄率，uempmed为失业持续时间中位数（单位：周）
dat <- economics[,c("date","psavert","uempmed")]
dat <- dat[lubridate::year(dat$date) %in% c(2000:2014),]

# 绘图
ggplot(dat,aes(x=date)) +
    geom_area(aes(y=uempmed+psavert,fill="psavert")) +  	# 注意先后顺序
    geom_area(aes(y=uempmed,fill="uempmed")) +
    theme_bw() +
    theme(legend.title=element_blank()) +
    scale_fill_brewer(palette="Paired") +
    labs(title='Area Chart of Returns Percentage',
         subtitle='Source: FRED Economic Research') +
    ylab("Returns%") +
    xlab('Year')

#【例10-8】通过地平线图展示不同运动和休闲活动在一天中不同时间的活动强度
# 加载包
library(tidyverse)			# 用于数据处理和绘图
library(ggthemes) 			# 用于图形主题
library(ggHoriPlot)			# 用于绘制堆积面积图

utils::data(sports_time) 	# 加载示例数据集

# 绘图
sports_time %>%
    ggplot() +
    # origin 指定地平线图中的起点位置, horizonscale 用于控制分层面积图的水平缩放比例
    geom_horizon(aes(time/60,p), origin='min',horizonscale=4) +
    # 按照活动类型进行分面，每个活动类型一列
    facet_wrap(~activity,ncol=1,strip.position='right') +
    # 设置填充颜色调色板，采用 'Peach' 调色板，并反转颜色
    scale_fill_hcl(palette='Peach',reverse=T) +
    # 使用 ggthemes 包中的 'theme_few' 主题
    theme_few() +
    theme( 									# 设置图形主题
        panel.spacing.y=unit(0,"lines"),		# y轴间距
        strip.text.y=element_text(angle=0),		# y轴文本角度
        legend.position='none',					# 隐藏图例
        axis.text.y=element_blank(),			# 隐藏y轴文本
        axis.title.y=element_blank(),			# 隐藏y轴标题
        axis.ticks.y=element_blank(),			# 隐藏y轴刻度线
        panel.border=element_blank()  			# 隐藏面板边框
    ) +
    # 设置 x 轴标签和刻度线
    scale_x_continuous(
        name='Time',							# x轴标题
        breaks=seq(from=3,to=27,by=3),		# 设置x轴刻度线
        # 格式化刻度标签
        labels=function(x) {sprintf("%02d:00",as.integer(x %% 24))} 
    ) +
    ggtitle('Peak time of day for sports and leisure')		# 图形标题

#【例10-9】通过地平线图展示不同亚洲国家/地区在2020年的每100,000人口中的COVID-19累积病例数的趋势
utils::data(COVID) 			#加载示例数据 COVID

# 绘图
COVID %>%  
    ggplot() +
    # 添加堆积面积图层，x 轴表示日期，y 轴表示COVID-19累积病例数（每100,000人口）
    geom_horizon(aes(date_mine,y),origin='min',horizonscale=4) +
    # 设置填充颜色调色板，采用 'BluGrn' 调色板，并反转颜色
    scale_fill_hcl(palette='BluGrn',reverse=T) +
    # 根据国家/地区进行分面，每个国家/地区占据一列
    facet_grid(countriesAndTerritories~.) +
    theme_few() +  			# 使用'theme_few'主题
    # 设置图形主题
    theme( panel.spacing.y=unit(0,"lines"),		# y轴间距
           strip.text.y=element_text(size=7,angle=0,hjust=0),
           legend.position='none',					# 隐藏图例
           axis.text.y=element_blank(),			# 隐藏y轴文本
           axis.title.y=element_blank(),			# 隐藏y轴标题
           axis.ticks.y=element_blank(),			# 隐藏y轴刻度线
           panel.border=element_blank()  			# 隐藏面板边框
    ) +
    # 设置 x 轴的日期格式和标签
    scale_x_date(expand=c(0,0),date_breaks="1 month",date_labels="%b") +
    # 设置图形标题和 x 轴标签
    ggtitle('Cumulative number for 14 days of COVID-19 cases per 100,000',
            'in Asia,2020') +
    xlab('Date')									# x 轴标签

#【例10-10】通过地平线图展示哥本哈根（Copenhagen）从1995年到2019年的平均每日温度趋势，并标识出异常值
utils::data(climate_CPH) 		# 加载示例数据集climate_CPH

# 计算异常值的切割点
cutpoints <- climate_CPH  %>% 
    mutate( outlier=between(AvgTemperature,
                            quantile(AvgTemperature,0.25,na.rm=T)-
                                1.5*IQR(AvgTemperature,na.rm=T),
                            quantile(AvgTemperature,0.75,na.rm=T) +
                                1.5*IQR(AvgTemperature,na.rm=T))) %>% 
    filter(outlier)
# 计算起始点和缩放比例
ori <- sum(range(cutpoints$AvgTemperature))/2
sca <- seq(range(cutpoints$AvgTemperature)[1],
           range(cutpoints$AvgTemperature)[2],length.out=7)[-4]

# 绘图
climate_CPH %>%
    ggplot() +
    geom_horizon(aes(date_mine,AvgTemperature,fill=..Cutpoints..),
                 origin=ori,horizonscale=sca) +
    
    # 设置填充颜色调色板，采用 'RdBu' 调色板，并反转颜色
    scale_fill_hcl(palette='RdBu',reverse=T) +
    facet_grid(Year~.) +				# 根据年份进行分面，每年占据一行
    theme_few() +						# 使用ggthemes包中的'theme_few'主题
    
    # 设置图形主题
    theme( panel.spacing.y=unit(0,"lines"),
           strip.text.y=element_text(size=7,angle=0,hjust=0),
           axis.text.y=element_blank(),
           axis.title.y=element_blank(),
           axis.ticks.y=element_blank(),
           panel.border=element_blank()) +  
    # 设置 x 轴的日期格式和标签
    scale_x_date(expand=c(0,0),date_breaks="1 month",date_labels="%b") +
    # 设置 x 轴标签和图形标题
    xlab('Date') +
    ggtitle('Average daily temperature in Copenhagen',
            'from 1995 to 2019')

#【例10-11】螺旋图
# 创建一个数据框 sample，包含日期、天数、温度等信息
sample <- data.frame(
    date=seq.Date(from=as.Date("1993-01-01"),
                  to=as.Date("1996-12-31"),by=1),
    day_num=1:1461, 				# 天数，从1到1461
    temp=rnorm(1461,10,2)			# 随机生成的温度数据，平均值为10，标准差为2
)

# 使用 ggplot2 创建可视化图形
ggplot(sample,aes(day_num %% 365,0.05 * day_num + temp / 2,
                  height=temp,fill=temp)) + 
    geom_tile() +					# 添加螺旋图层，用颜色表示温度
    # 设置 y 轴的坐标范围，下限为 -20，上限不限制（NA）
    scale_y_continuous(limits=c(-20,NA)) +
    
    # 设置x轴坐标刻度，每月的第30天为主要刻度
    scale_x_continuous(breaks=30 * 0:11,minor_breaks=NULL,
                       labels=month.abb) + 
    coord_polar() + 				# 将坐标系转换为极坐标
    scale_fill_viridis_c() + 		# 设置填充颜色的调色板，使用 viridis 颜色
    theme_minimal()  				# 使用最小化的主题

#【例10-12】创建一个复杂的螺旋图，用于可视化数据中某一变量的时间趋势
# 加载包
library(spiralize) 			# 用于绘制螺旋图
library(lubridate) 			# 用于日期时间数据处理
library(ComplexHeatmap) 	# 用于创建复杂的热图
library(circlize)			# 用于绘制环形图

# 加载数据
df=readRDS(system.file("extdata","ggplot2_downloads.rds",
                       package="spiralize"))

# 计算时间跨度，年度平均值等
day_diff=as.double(df$date[nrow(df)] - df$date[1],"days")
year_mean=tapply(df$count,lubridate::year(df$date),
                 function(x) mean(x[x > 0]))

# 计算差异值，并修正离群值
df$diff=log2(df$count/year_mean[as.character(lubridate::year(df$date))])
df$diff[is.infinite(df$diff)]=0
q=quantile(abs(df$diff),0.99)
df$diff[df$diff > q]=q
df$diff[df$diff < -q]=-q

# 初始化螺旋图
spiral_initialize_by_time(xlim=range(df[,1]),padding=unit(2,"cm"))

# 创建螺旋图轨道和绘制螺旋图
spiral_track(height=0.8)
spiral_horizon(df$date,df$diff,use_bars=TRUE)

# 在螺旋图中添加时间段的高亮
spiral_highlight("start","2015-12-31",type="line",
                 gp=gpar(col=2))
spiral_highlight("2016-01-01","2016-12-31",type="line",
                 gp=gpar(col=3))
spiral_highlight("2017-01-01","2017-12-31",type="line",
                 gp=gpar(col=4))
spiral_highlight("2018-01-01","2018-12-31",type="line",
                 gp=gpar(col=5))
spiral_highlight("2019-01-01","2019-12-31",type="line",
                 gp=gpar(col=6))
spiral_highlight("2020-01-01","2020-12-31",type="line",
                 gp=gpar(col=7))
spiral_highlight("2021-01-01","end", type="line",
                 gp=gpar(col=8))

# 在螺旋图中添加月份标签
s=current_spiral()
d=seq(15,360,by=30) %% 360
for(i in seq_along(d)) {
    foo=polar_to_cartesian(d[i]/180*pi,(s$max_radius + 1)*1.05)
    grid.text(month.name[i],x=foo[1,1],y=foo[1,2],
              default.unit="native",
              rot=ifelse(d[i] > 0 & d[i] < 180,d[i] - 90,d[i] + 90),
              gp=gpar(fontsize=10))}

# 创建图例
lgd=packLegend(
    Legend(title="Difference to\nyearly average",
           at=c("higher","lower"),
           legend_gp=gpar(fill=c("#D73027","#313695"))),
    Legend(title="Year",type="lines",at=2015:2021,
           legend_gp=gpar(col=2:8)))

# 在图形中绘制图例
draw(lgd,x=unit(1,"npc") + unit(10,"mm"),just="left")


#【例10-13】利用螺旋图对中枢神经系统肿瘤进行分类展示
# 从外部RDS文件加载数据
df=readRDS(system.file("extdata","CNS_tumour_classification.rds",
                       package="spiralize"))
n=nrow(df)	# 获取数据行数
# 初始化螺旋图
spiral_initialize(xlim=c(0,n),scale_by="curve_length")

# 创建第一个螺旋图轨道并绘制矩形
spiral_track(height=0.4)
spiral_rect(1:n - 1,0,1:n,1,gp=gpar(fill=df$meth_col,col=NA))

# 创建第二个螺旋图轨道并绘制另一个矩形
spiral_track(height=0.4)
spiral_rect(1:n - 1,0,1:n,1,gp=gpar(fill=df$tumor_col,col=NA))

# 使用分段的文本标签标记螺旋图
r1=rle(as.vector(df$tumor_type))	# 获取tumor_type列的分段信息

# 逐个分段添加文本标签
for(i in seq_along(r1$lengths)) {
    # 计算文本标签的位置
    label_x=(sum(r1$lengths[seq_len(i-1)]) + sum(r1$lengths[seq_len(i)]))/2
    # 添加曲线内部的文本标签
    spiral_text(label_x,0.5,r1$values[i],
                facing="curved_inside",nice_facing=TRUE)}

# 增加螺旋图的图例
# 定义一个函数，将数据按分段绘制到螺旋图中
spiral_rle=function(x,col,labels=FALSE) {
    x=as.vector(x)	# 将输入数据转换为向量，以处理因子类型的数据
    r1=rle(x)	# 计算输入数据的分段信息
    for(i in seq_along(r1$lengths)) {
        # 绘制每个分段的矩形，使用给定的颜色
        spiral_rect(sum(r1$lengths[seq_len(i-1)]),0,
                    sum(r1$lengths[seq_len(i)]),1,
                    gp=gpar(fill=col[r1$values[i]],col=NA))}
    if(labels) {
        for(i in seq_along(r1$lengths)) {
            # 如果需要，添加文本标签到每个分段的中间
            spiral_text( 
                (sum(r1$lengths[seq_len(i-1)]) + sum(r1$lengths[seq_len(i)]))/2,
                0.5,r1$values[i],facing="curved_inside",nice_facing=TRUE)}
    }
}

# 初始化螺旋图
spiral_initialize(xlim=c(0,n),scale_by="curve_length",
                  vp_param=list(x=unit(0,"npc"),just="left"))

# 创建第一个螺旋图轨道并绘制meth_class的分段
spiral_track(height=0.4)
meth_col=structure(names=unique(df$meth_class),unique(df$meth_col))
spiral_rle(df$meth_class,col=meth_col)

# 创建第二个螺旋图轨道并绘制tumor_type的分段和标签
spiral_track(height=0.4)
tumor_col=structure(names=unique(as.vector(df$tumor_type)),
                    unique(df$tumor_col))
spiral_rle(df$tumor_type,col=tumor_col,labels=TRUE)

# 创建图例列表，每个肿瘤类型对应一个图例
lgd_list=tapply(1:nrow(df),df$tumor_type,function(ind) {
    Legend(title=df$tumor_type[ind][1],at=unique(df$meth_class[ind]),
           legend_gp=gpar(fill=unique(df$meth_col[ind])))
})

# 设置max_height以适应整个图像的高度，以便自动排列图例
lgd=packLegend(list=lgd_list,max_height=unit(7,"inch"))
# 在左侧绘制图例
draw(lgd,x=unit(1,"npc") + unit(2,"mm"),just="left")

#【例10-14】利用calendR包创建日历图示例
# 加载包
library(calendR)			# 用于绘制日历图

# 创建数据
set.seed(1234)      			# 设置随机数种子
data <- rnorm(366)  		# 生成一个包含366个随机数的数据向量

# 创建日历图1
calendR(
    year=2024,				# 指定要创建的年份为2024年的日历
    special.days=data,		# 使用随机数据作为特殊日期的标记
    gradient=TRUE,			# 使用渐变效果
    low.col="#FFFFED",      # 正常日期的颜色
    special.col="#FF0000"  	# 特殊日期的颜色
)

# 创建日历图2
calendR(
    year=2024,	# 指定要创建的年份为2024年的日历
    start="M",	# 设置每周的第一天为M（Monday），可选值有S（Sunday）和M（Monday）
    special.days="weekend",	    # 选择特殊日期，"weekend"表示周末将被标记为特殊日期
    special.col="lightblue",	# 特殊日期的颜色设置为浅蓝色
    low.col="white"			
)

# 创建一个包含图例的日历
# 创建一个与一年中的天数相同长度的 NA 向量
events <- rep(NA,366)

# 设置对应的事件
events[40:45] <- "Trip"			# 第40天到第45天标记为"Trip"
events[213:240] <- "Holidays"	# 第213天到第240天标记为"Holidays"
events[252] <- "Birthday" 		# 第252天标记为"Birthday"
events[359] <- "Christmas"		# 第359天标记为"Christmas" 

calendR(
  year=2024,  					# 指定要创建的年份为2025年的日历
  special.days=events,			# 使用上面设置的事件向量作为特殊日期
  special.col=c("pink","lightblue",			# 设置事件的颜色
                  "lightgreen","lightsalmon"),
  legend.pos="right" 			# 将图例放在日历的右侧
)



