#【例9-1】使用R语言中的pie函数绘制饼图
# 加载包
library(RColorBrewer)		# 使用颜色调色板包

Prop <- c(3,7,9,1,1.5) 		# 创建数据
pie(Prop) 					# 绘制默认的饼图

tip=c("Djb_A","Djb_B","Djb_C","Djb_D","Djb_E")		# 定义标签
pie(Prop,labels=tip)		

# 将"edge"设置较低的值，图形从圆形变为具有边缘的形状
pie(Prop,labels=tip,edges=10)		

# 利用density参数添加斜线，通过 "angle"控制线的角度
pie(Prop,labels=tip,density=10,angle=c(20,90,30,10,0))

myPalette <- brewer.pal(5,"Set2") 
# 使用 col 设置颜色
pie(Prop,labels=tip,border="white",col=myPalette)


#【例9-2】使用ggplot2库绘制饼图，并对标签的位置进行了调整
# 加载包
library(ggplot2)		# 用于数据可视化
library(dplyr)			# 用于数据处理

# 创建数据
data <- data.frame(
    group=LETTERS[1:5],		# 组的标识，使用前五个字母
    value=c(13,7,9,21,2)		# 组的值
)

# 基本的饼图
ggplot(data,aes(x="",y=value,fill=group)) +
    geom_bar(stat="identity",width=1,color="white") +
    coord_polar("y",start=0) +
    theme_void()				# 移除背景、网格和数值标签

# 计算标签的位置
data <- data %>% 
    arrange(desc(group)) %>%						# 按照组标识降序排列数据
    mutate(prop=value / sum(data$value) * 100) %>%	# 计算每组的百分比
    mutate(ypos=cumsum(prop) - 0.5 * prop)			# 计算标签的纵坐标位置

# 基本的饼图
ggplot(data,aes(x="",y=prop,fill=group)) +
    geom_bar(stat="identity",width=1,color="white") +
    coord_polar("y",start=0) +
    theme_void() +
    theme(legend.position="none") +					# 不显示图例
    
    geom_text(aes(y=ypos,label=group),color="white",size=6) +	# 添加标签
    scale_fill_brewer(palette="Set1")					# 设置填充颜色的调色板

#【例9-3】以随机数据为基础创建一系列散点饼图，并在图中添加了饼图和图例
# 加载包
library(scatterpie)			# 用于在散点图上绘制饼图

# 生成随机数据
set.seed(1)					# 设置随机种子，用于生成随机数据的一致性
long <- rnorm(50,sd=100)	# 随机生成50个均值为0，标准差为100的数据
lat <- rnorm(50,sd=50)		# 随机生成50个均值为0，标准差为50的数据
d <- data.frame(long=long,lat=lat)		# 创建一个包含long和lat列的数据框

# 保留指定范围内的数据点
d <- with(d,d[abs(long) < 150 & abs(lat) < 70,])
n <- nrow(d)				# 获取数据框的行数（数据点个数）
# 为数据框添加一个表示区域的因子变量
d$region <- factor(1:n)

# 生成随机数并添加到数据框中
d$A <- abs(rnorm(n,sd=1))
d$B <- abs(rnorm(n,sd=2))
d$C <- abs(rnorm(n,sd=3))
d$D <- abs(rnorm(n,sd=4))

# 修改第一行的部分数据，将第一行的第4至第7列值乘以3
d[1,4:7] <- d[1,4:7] * 3

# 创建散点饼图
ggplot() + 
    geom_scatterpie(aes(x=long,y=lat,group=region),data=d,
                    cols=LETTERS[1:4]) +
    coord_equal()

# 添加半径信息并创建散点饼图
d$radius <- 6 * abs(rnorm(n))
p <- ggplot() + 
    geom_scatterpie(aes(x=long,y=lat,group=region,r=radius),
                    data=d,cols=LETTERS[1:4],color=NA) +
    coord_equal()

# 在图中添加散点饼图的图例
p + geom_scatterpie_legend(d$radius,x=-140,y=-70)

#【例9-4】利用waffle包绘制华夫图示例
library(waffle)			# 用于绘制华夫图

x <- c(G1=30,G2=25,G3=20,G4=5) 		# 创建数据向量 x，表示不同组的数量
waffle(x,rows=8)					# 绘制华夫图，通过设置 rows 参数指定图形的行数

# 创建数据框 df，包含组的标识和对应的值
df <- data.frame(group=LETTERS[1:3],value=c(25,20,35))

# 使用 ggplot 绘制华夫图
ggplot(df,aes(fill=group,values=value)) +
    geom_waffle(n_rows=8,size=0.33,colour="white",na.rm=TRUE) +
    scale_fill_manual(name=NULL,
                      values=c("#BA182A","#FF8288","#FFD1DD"),
                      labels=c("A","B","C")) +
    coord_equal() +		# 保持 x 和 y 轴的单位刻度一致
    theme_void()			# 使用无背景和网格的主题

# 利用waffle包绘制华夫图，展示了不同年龄组的支出分布
# 创建一个包含不同年龄组支出的向量
expenses <- c(`Infants: <1(16467) `=16467,`Children: <11(30098) `=30098,
              `Teens: 12-17(20354)`=20354,`Adults:18+(12456) `=12456,
              `Elderly: 65+(12456) `=12456)

# 使用 waffle 包绘制华夫图，展示年龄组支出情况
waffle(expenses/1000,rows=5,size=0.6,
       colors=c("#44D2AC","#E48B8B","#B67093","#3A9ABD","#CFE252"),
       title="Age Groups bifurcation",		# 图标题
       xlab="1 square=1000 persons")		# x轴标签

# 准备数据，对钻石数据集进行处理，计算不同切割方式的数量和比例
prep_dat <- diamonds %>% 
    count(cut) %>%
    mutate(tot=sum(n),prop=round((n / tot) * 100))

# 使用 ggplot 绘制华夫图，展示不同切割方式的比例
prep_dat %>%
    ggplot(aes(fill=cut,values=prop)) +
    geom_waffle(na.rm=TRUE)

# 使用 ggplot 绘制华夫图，设置图形属性和样式
prep_dat %>%
    ggplot(aes(fill=cut,values=prop)) +
    geom_waffle(n_rows=10,size=0.4,color="white",
                na.rm=TRUE) +			# 设置行数、大小和颜色
    coord_equal() +					# 保持 x 和 y 轴的单位刻度一致
    theme_minimal() +					# 使用最小化的主题
    theme_enhance_waffle() +			# 加强华夫图的主题
    theme(legend.title=element_blank()) +			# 隐藏图例标题
    labs(title="Proportion of Diamond Cuts")		# 设置图的标题

#【例9-5】绘制分面的华夫图，展示每年不同状态的风暴数量
# 加载包
library(ggthemes) 		# 用于图形主题

# 使用storms数据集，筛选出年份大于等于2010年的数据，并统计每年每个状态的数量
storms %>% 
    filter(year >= 2010) %>% 
    count(year,status) -> storms_df

# 使用ggplot绘制华夫图
ggplot(storms_df,aes(fill=status,values=n)) +
    geom_waffle(color="white",size=.25,n_rows=10,
                flip=TRUE,na.rm=TRUE) +					# 绘制华夫图
    # 使用facet_wrap进行分面，按年份分面
    facet_wrap(~year,nrow=1,strip.position="bottom") + 
    scale_x_discrete() +								# 调整x轴的离散标签
    scale_y_continuous(labels=function(x) x * 10,	# 调整y轴刻度标签
                       expand=c(0,0)) +  				# 调整y轴范围
    ggthemes::scale_fill_tableau(name=NULL) +  		# 使用ggthemes的颜色调色板
    coord_equal() +	# 使用等轴比例坐标
    labs(title="Faceted Waffle Bar Chart",subtitle="{dplyr} storms data",
         x="Year",y="Count" ) +
    # 使用theme_minimal主题
    theme_minimal(base_family="Roboto Condensed") + 
    # 调整主题设置
    theme(panel.grid=element_blank(),axis.ticks.y=element_line()) + 
    guides(fill=guide_legend(reverse=TRUE)) 			# 调整图例设置

#【例9-6】创建了一个用于展示分段数据的马赛克图
library(ggmosaic) 			# 用于绘制马赛克图
library(tidyverse)

df <- data.frame(
    segment=LETTERS[1:4],			# 不同的分段
    segpct=c(40,30,20,10),		# 每个分段的百分比
    Alpha=c(60,40,30,25),			# Alpha 类别的数值
    Beta=c(25,30,30,25),			# Beta 类别的数值
    Gamma=c(10,20,20,25),			# Gamma 类别的数值
    Delta=c(5,10,20,25)  			# Delta 类别的数值
)

# 转换数据为 "long" 格式以进行绘图
df_long <- gather(df,key="greek_letter",value="pct",
                  -c("segment","segpct")) %>% 
    mutate(greek_letter=factor(
        greek_letter,levels=c("Alpha","Beta","Gamma","Delta")),
        weight=(segpct * pct)/10000			# 计算权重
    )

# 绘制马赛克图
ggplot(df_long) +
    geom_mosaic(aes(x=product(greek_letter,segment),
                    fill=greek_letter,weight=weight))	# 设置x轴、填充颜色和权重

#【例9-7】利用自带的flights数据集展示马赛克图的绘制
library(tidyverse)		# 综合性数据处理和绘图
library(ggmosaic)		# 用于绘制马赛克图

# 绘制第一个马赛克图：单变量的马赛克图
ggplot(data=fly) +
    geom_mosaic(aes(x=product(rude_to_recline),fill=rude_to_recline)) + 
    labs(title='f(rude_to_recline)')

# 绘制第二个马赛克图：条件概率的马赛克图
ggplot(data=fly) +
    geom_mosaic(aes(x=product(do_you_recline,rude_to_recline),
                    fill=do_you_recline)) + 
    labs(title='f(do_you_recline | rude_to_recline) f(rude_to_recline)')

# 绘制第三个马赛克图：带条件的马赛克图
ggplot(data=fly) +
    geom_mosaic(aes(x=product(do_you_recline),fill=do_you_recline,
                    conds=product(rude_to_recline))) +
    labs(title='f(do_you_recline | rude_to_recline)')

# 绘制第四个马赛克图：带分割线的马赛克图
ggplot(data=fly) +
    geom_mosaic(aes(x=product(do_you_recline),fill=do_you_recline),
                divider="vspine") +
    labs(title='f(do_you_recline | rude_to_recline)') + 
    facet_grid(~rude_to_recline) +		# 使用 facet 对图进行分面展示
    theme(aspect.ratio=3,					# 设置图形的宽高比
          axis.text.x=element_blank(),
          axis.ticks.x=element_blank())

# 在同一图中展示 order1 和 order2 的马赛克图
library(patchwork)  	# 用于组合多个图形

# 创建两个绘图对象 order1 和 order2
order1 <- ggplot(data=fly) +
    geom_mosaic(aes(x=product(do_you_recline,rude_to_recline),
                    fill=do_you_recline)) 

order2 <- ggplot(data=fly) +
    geom_mosaic(aes(x=product(rude_to_recline,do_you_recline),
                    fill=do_you_recline)) 
order1 + order2
