#【例7-1】基础旭日图绘制示例
library(plotly) 		# 用于创建交互式图形
library(dplyr)			# 用于数据转换

# 定义数据集
labels <- c("Andy","John","Megan","Tom","Naomi","Matt","Florence",
            "Harry","Sam")				# 定义所有级别各类的标签
parents <- c("","Andy","Andy","Megan","Megan","Andy","Andy",
             "Florence","Andy")			# 定义所有级别各类的父级，与上一一对应
values <- c(20,34,25,20,8,15,15,9,9) 	# 定义各分类的值（一一对应）

# 作图
p1 <- plot_ly(type="sunburst",			# 指定图表类型为sunburst
              labels=labels,parents=parents,values=values)
p1

# 定义标签（名称）、父节点和值的向量
labels=c("Eve","Cain","Seth","Enos","Noam",
         "Abel","Awan","Enoch","Azura")
parents=c("","Eve","Eve","Seth","Seth","Eve","Eve","Awan","Eve")
values=c(65,14,12,10,2,6,6,4,4)

# 使用plot_ly创建一个sunburst图形
# branchvalues 为 total时，子级的值之和不能超过父级的值
p2 <- plot_ly(labels=labels,parents=parents,values=values,
              type='sunburst',branchvalues='total') 
p2

#【例7-2】具有重复标签的旭日图绘制示例
# 定义id，每个层级的唯一标识
ids=c("North America","Europe","Australia",
      "NorthAmerica-Football","Soccer","North America-Rugby",
      "Europe-Football","Rugby","Europe-AmericanFootball",
      "Australia-Football","Association","Australian Rules",
      "Austtralia-American Football","Australia-Rugby",
      "Rugby League","Rugby Union")
# 定义标签，即显示在图形中的文本，使用<br>进行换行（HTML语法）
labels=c("North<br>America","Europe","Australia","Football",
         "Soccer","Rugby","Football","Rugby",
         "American<br>Football","Football","Association",
         "Australian<br>Rules","American<br>Football",
         "Rugby","Rugby<br>League","Rugby<br>Union")
# 定义父级，表示每个层级的父层级
parents=c("","","","North America","North America",
          "North America","Europe","Europe","Europe",
          "Australia","Australia-Football","Australia-Football",
          "Australia-Football","Australia-Football",
          "Australia-Rugby","Australia-Rugby")
df <- data.frame(ids=ids,labels=labels,parents=parents,
                 stringsAsFactors=FALSE)
# 绘图
p3 <- plot_ly(df,ids=~ids,labels=~labels,parents=~parents,type='sunburst')
p3

#【例7-3】调整扇区内文本方向示例
# 加载数据
setwd("/Users/lc/Desktop/Rdata")		# 设置工作环境
df=read.csv('coffee-flavors.csv')

# 绘图
p4 <- plot_ly()
p4 <- p4 %>%
    add_trace(
        type='sunburst',ids=df$ids,labels=df$labels,
        parents=df$parents,
        maxdepth=2,							# 设置最大深度为2，也就是最多只展示两级
        insidetextorientation='radial') 	# 控制扇区内文本方向，此处为径向
p4

#【例7-4】使用domain属性和布局grid属性创建旭日图子图示例
# 加载数据
d1 <- read.csv('coffee-flavors.csv')
d2 <- read.csv('sunburst-coffee-flavors-complete.csv')
p5 <- plot_ly() 
p5 <- p5 %>% 
    # 添加轨迹，相当于ggplot2的图层geom，这里定义子图1
    add_trace(ids=d1$ids,labels=d1$labels,parents=d1$parents,
              type='sunburst',			# 定义轨迹的类型：sunburst
              maxdepth=2,
              domain=list(column=0)	# 子图1放在第1列（plotly以0开始计数）
    )
p5 <- p5 %>% 
    # 子图2
    add_trace(ids=d2$ids,labels=d2$labels,parents=d2$parents,
              type='sunburst',
              maxdepth=3,
              domain=list(column=1)	# 子图放在第2列
    ) 
p5 <- p5 %>% 
    layout(							# 定义样式
        grid=list(columns=2,rows=1),	# 网格：2列1行
        margin=list(l=0,r=0,b=0,t=0),
        # 颜色
        sunburstcolorway=c("#636efa","#EF553B","#00cc96","#ab63fa","#19d3f3",
                           "#E763fa","#FECB52","#FFA15A","#FF6692","#B6E880"),
        extendsunburstcolors=TRUE)
p5

#【例7-5】简单树状图的绘制示例
library(ggraph)     		# 用于绘制图形
library(igraph)     		# 用于处理和分析图形数据
library(tidyverse)		# 用于数据处理和绘图
library(patchwork)  	# 用于组合多个图形
theme_set(theme_void())			# 设置图形主题

# 加载数据集（边列表）
d1 <- data.frame(from="origin",to=paste("group",seq(1,7),sep=""))
d2 <- data.frame(from=rep(d1$to,each=7),
                 to=paste("subgroup",seq(1,49),sep="_"))
edges <- rbind(d1,d2)

# 添加第二个数据帧，其中包含每个节点的信息
name <- unique(c(as.character(edges$from),as.character(edges$to)))
vertices <- data.frame(
    name=name,
    group=c(rep(NA,8),rep(paste("group",seq(1,7),sep=""),each=7)),
    cluster=sample(letters[1:4],length(name),replace=T),
    value=sample(seq(10,30),length(name),replace=T)
)

#创建图形对象
mygraph <- graph_from_data_frame(edges,vertices=vertices)

#绘图
p1 <- ggraph(mygraph,layout='dendrogram',circular=FALSE) +
    geom_edge_diagonal()
p2 <- ggraph(mygraph,layout='dendrogram',circular=TRUE) +
    geom_edge_diagonal()
p1+p2

p3 <- ggraph(mygraph,layout='dendrogram') +
    geom_edge_diagonal() +
    geom_node_text(aes(label=name,filter=leaf,color=group),
                   angle=90,hjust=1,nudge_y=-0.05) +
    geom_node_point(aes(filter=leaf,size=value,color=group),
                    alpha=0.6) +
    ylim(-.6,NA) +
    theme(legend.position="none")
p3

#【例7-6】利用dendextend包绘制树状图示例
library(dendextend)			# 用于处理和可视化树状图

# 查看数据集的前几行
head(mtcars)

# 使用mpg、cyl和disp三个变量进行聚类分析
mtcars %>% 
    select(mpg,cyl,disp) %>%		# 选择指定的三个变量
    dist() %>%					# 计算数据间的距离矩阵
    hclust() %>%					# 对距离矩阵进行层次聚类
    as.dendrogram() -> dend		# 转换成树状图对象，存储在dend中

# 绘制树状图
par(mar=c(7,3,1,1))				# 调整绘图参数，增加底部边距以完整显示标签
plot(dend)

# 根据聚类结果为不同的聚类分配颜色
par(mar=c(1,1,1,7))
dend %>%
    # 设置叶节点的颜色
    set("labels_col",value=c("skyblue","orange","grey"),k=3) %>% 
    # 设置分支的颜色
    set("branches_k_color",value=c("skyblue","orange","grey"),k=3) %>% 
    plot(horiz=TRUE,axes=FALSE)		#绘制水平树状图
abline(v=350,lty=2)					#在x=350处添加虚线

# 用矩形突出显示一个聚类
par(mar=c(9,1,1,1))
dend %>%
    # 设置叶节点的颜色
    set("labels_col",value=c("skyblue","orange","grey"),k=3) %>%
    # 设置分支的颜色
    set("branches_k_color",value=c("skyblue","orange","grey"),k=3) %>%
    plot(axes=FALSE)								# 绘制树状图，不绘制坐标轴
rect.dendrogram( dend,k=3,lty=5,lwd=0,x=1,
                 col=rgb(0.1,0.2,0.4,0.1) )		# 绘制矩形突出显示

# 使用两种不同的聚类方法创建两个树状图
# 使用 "average" 方法对 USArrests 数据集进行层次聚类
d1 <- USArrests %>% dist() %>% 
    hclust(method="average") %>% 
    as.dendrogram()
# 使用 "complete" 方法对 USArrests 数据集进行层次聚类
d2 <- USArrests %>%
    dist() %>% 
    hclust(method="complete") %>% 
    as.dendrogram()

# 自定义这些树状图，并将它们放入一个列表中
dl <- dendlist(
    d1 %>% 
        # 设置叶节点颜色
        set("labels_col",value=c("skyblue","orange","grey"),k=3) %>% 
        # 设置分支线类型
        set("branches_lty",1) %>%
        # 设置分支颜色
        set("branches_k_color",value=c("skyblue","orange","grey"),k=3),
    d2 %>% 
        # 设置叶节点颜色
        set("labels_col",value=c("skyblue","orange","grey"),k=3) %>% 
        # 设置分支线类型
        set("branches_lty",1) %>% 
        # 设置分支颜色
        set("branches_k_color",value=c("skyblue","orange","grey"),k=3) 
)

# 将两个树状图绘制在一起
tanglegram(dl,	
           common_subtrees_color_lines=FALSE,	# 不对共同子树进行着色
           highlight_distinct_edges=TRUE,		# 高亮显示不同的边
           highlight_branches_lwd=FALSE,			# 不加粗高亮显示的分支
           margin_inner=7,						# 内边距
           lwd=2									# 线宽
) 

#【例7-7】环形树状图的绘制示例
# 创建数据框d1，给出层次结构的主要组
d1=data.frame(from="origin",to=paste("group",seq(1,10),sep=""))
# 创建数据框d2，给出层次结构中的子组
d2=data.frame(from=rep(d1$to,each=10),
              to=paste("subgroup",seq(1,100),sep="_"))
edges=rbind(d1,d2)			#合并成一个边缘数据框

# 创建顶点数据框vertices，对应层次结构中的对象
vertices=data.frame(
    name=unique(c(as.character(edges$from),as.character(edges$to))),
    value=runif(111))
# 从边缘数据中匹配每个对象的所属组，并添加到顶点数据框
vertices$group=edges$from[match(vertices$name,edges$to)]

#添加标签信息到顶点数据框
vertices$id=NA
myleaves=which(is.na(match(vertices$name,edges$from)))
nleaves=length(myleaves)
vertices$id[myleaves]=seq(1:nleaves)
vertices$angle=90-360*vertices$id/nleaves

# 计算标签对齐方式：左对齐或右对齐
vertices$hjust<-ifelse(vertices$angle < -90,1,0)
# 调整角度，确保标签朝上
vertices$angle<-ifelse(vertices$angle < -90,
                       vertices$angle+180,vertices$angle)
# 使用边缘和顶点数据创建图形对象mygraph
mygraph <- graph_from_data_frame(edges,vertices=vertices)

# 绘图，以树状结构布局，且呈环形
ggraph(mygraph,layout='dendrogram',circular=TRUE) +
    geom_edge_diagonal(colour="grey") +
    scale_edge_colour_distiller(palette="RdPu") +
    geom_node_text(aes(x=x*1.15,y=y*1.15,filter=leaf,label=name,angle=angle,
                       hjust=hjust,colour=group),size=2.7,alpha=1) +
    geom_node_point(aes(filter=leaf,x=x*1.07,y=y*1.07,
                        colour=group,size=value,alpha=0.2)) +
    scale_colour_manual(values=rep(brewer.pal(9,"Paired"),30)) +
    scale_size_continuous(range=c(0.1,10)) +
    theme_void() +
    theme(legend.position="none",
          plot.margin=unit(c(0,0,0,0),"cm"),) +
    expand_limits(x=c(-1.3,1.3),y=c(-1.3,1.3))

#【例7-8】简单桑基图的绘制示例
# 加载包
library(networkD3)

# 构建具有数据流强度的数据集
links <- data.frame(
    source=c("Gdjb_A","Gdjb_A","Gdjb_B","Gdjb_C","Gdjb_C","Gdjb_E"),
    target=c("Gdjb_C","Gdjb_D","Gdjb_E","Gdjb_F","Gdjb_G","Gdjb_H"),
    value=c(2,3,2,3,1,3))

# 创建节点数据框
nodes <- data.frame(
    name=c(as.character(links$source),
           as.character(links$target)) %>%
        unique())

# 由于networkD3需要使用id连接，因此需要重新格式化
links$IDsource <- match(links$source,nodes$name)-1 
links$IDtarget <- match(links$target,nodes$name)-1

# 建立网络
sankeyNetwork(Links=links,Nodes=nodes,fontSize=12,
              Source="IDsource",Target="IDtarget",
              Value="value",NodeID="name",
              sinksRight=FALSE)

# 准备色标,为每个节点指定特定的颜色
my_color <- 'd3.scaleOrdinal().domain(["Gdjb_A","Gdjb_B","Gdjb_C","Gdjb_D",
"Gdjb_E","Gdjb_F","group_G","group_H"])
.range(["blue","blue" ,"blue","red","red","yellow","purple","purple"])'

# 用colorScale参数调用色标
sankeyNetwork(Links=links,Nodes=nodes,fontSize=12,
              Source="IDsource",Target="IDtarget",
              Value="value",NodeID="name",
              sinksRight=FALSE,colourScale=my_color)

#【例7-9】利用networkD3包的sankeyNetwork函数将JSON数据展示为桑基图
# 加载数据
URL <- "energy.json"				# 定义数据的URL路径
Energy <- jsonlite::fromJSON(URL)	# 使用jsonlite包并从JSON文件中加载数据

sankeyNetwork(Links = Energy$links,	# 链接数据
              Nodes = Energy$nodes,		# 节点数据
              Source = "source",			# 源节点列名
              Target = "target",			# 目标节点列名
              Value = "value", 			# 链接的值列名
              NodeID = "name",			# 节点的唯一标识列名
              units = "TWh", 				# 数据单位
              fontSize = 12, 				# 节点文字大小
              nodeWidth = 30)				# 节点宽度

#【例7-10】通过桑基图显示从一个国家（左）迁移到另一国家（右）的人数
# 加载包
library(kableExtra)
library(circlize)    		

# 加载数据
data <- read.table("13_AdjacencyDirectedWeighted.csv",header=TRUE)

# 显示数据的前三行
data %>%
    head(3) %>%
    select(1:3) %>%
    kable() %>%
    kable_styling(bootstrap_options="striped",full_width=F)

# 为数据设置短名称
colnames(data) <- c("Africa","EastAsia","Europe","LatinAme.",
                    "NorthAme.","Oceania","SouthAsia","SouthEastAsia",
                    "SovietUnion","West.Asia")
# 设置数据的行名
rownames(data) <- colnames(data)

# 转换数据为长格式，以便进行网络可视化
data_long <- data %>%
    rownames_to_column %>%
    gather(key='key',value='value',-rowname) %>%
    filter(value > 0)

# 为长数据设置列名
colnames(data_long) <- c("source","target","value")
# 修改 target 列的值，增加空格
data_long$target <- paste(data_long$target," ",sep="")

# 从数据流中创建一个节点数据框，列出流中涉及的每个实体
nodes <- data.frame(name=c(as.character(data_long$source),
                           as.character(data_long$target)) %>%
                        unique())

# 对于networkD3，必须使用id提供连接，而不使用实名，因此需要重新格式化
data_long$IDsource=match(data_long$source,nodes$name)-1 
data_long$IDtarget=match(data_long$target,nodes$name)-1

# 编制色标
ColourScal='d3.scaleOrdinal().range(["#FDE725FF","#B4DE2CFF",
"#6DCD59FF","#35B779FF","#1F9E89FF","#26828EFF","#31688EFF",
"#3E4A89FF","#482878FF","#440154FF"])'

# 建立桑基图
sankeyNetwork(Links=data_long,Nodes=nodes,
              Source="IDsource",Target="IDtarget",
              Value="value",NodeID="name",
              sinksRight=FALSE,colourScale=ColourScal,
              nodeWidth=40,fontSize=13,nodePadding=10)

#【例7-11】矩形树状图创建示例
# 加载包
library(treemapify)  	# 用于绘制树图

# 创建数据框
df<- data.frame(Fruits=c("Banana","Apple","Melon","Plums",
                         "Pineapple","Orange","Apricot","Grapes"),
                Season=c("All Time","Winter","Summer","All Time",
                         "Winter","Summer","All Time","All Time"),
                sales=c(25,22,15,5,18,20,3,9))

# 绘图
ggplot(df,aes(area=sales,fill=sales)) +
    treemapify::geom_treemap()

# 添加标签
ggplot(df,aes(area=sales,fill=Fruits,label=Fruits)) +
    geom_treemap(layout="squarified") +	#使用"squarified"布局
    geom_treemap_text(place="centre",size=12) + 		# 添加标签文本并居中显示
    labs(title="Customized Tree Plot")				# 设置图形标题

# 修改颜色
ggplot(df,aes(area=sales,fill=Season,
                       label=Fruits,subgroup=Season)) +
    geom_treemap(layout="squarified") +
    geom_treemap_text(place="centre",size=12) +
    labs(title="SubGrouped Tree Plot")

#【例7-12】绘制树状图
# 绘图
ggplot(G20,aes(area=gdp_mil_usd,fill=hdi)) +		
    geom_treemap()		# 添加矩形树图的几何对象

# 添加标签
ggplot(G20,aes(area=gdp_mil_usd,fill=hdi,label=country)) +
    geom_treemap() +
    geom_treemap_text(fontface="italic",colour="white",place="centre",grow=TRUE)

# 添加边框
ggplot(G20,aes(area=gdp_mil_usd,fill=hdi,label=country,
               subgroup=region)) +
    geom_treemap() +
    geom_treemap_subgroup_border() +
    geom_treemap_subgroup_text(place="centre",grow=T,alpha=0.5,colour=
                                   "black",fontface="italic",min.size=0) +
    geom_treemap_text(colour="white",place="topleft",reflow=T)

# 修改颜色
ggplot(G20,aes(area=gdp_mil_usd,fill=region,
               label=country,subgroup=region)) +
    geom_treemap() +
    geom_treemap_text(grow=T,reflow=T,colour="black") +
    facet_wrap(~ hemisphere) +
    scale_fill_brewer(palette="Set1") +
    theme(legend.position="bottom") +
    labs(title="The G-20 major economies by hemisphere",
         caption="The area of each tile represents the country's GDP as a
      proportion of all countries in that hemisphere",
      fill="Region")

#【例7-13】利用packcircles绘制圆堆积图示例一
library(packcircles)	# 用于创建圆堆积图

# 创建数据集，包含组名和对应的值
data <- data.frame(group=paste("Djb",letters[1:20]),
                   value=sample(seq(1,100),20))

# 生成圆形布局，根据值的大小进行圆的布局
packing <- circleProgressiveLayout(data$value,sizetype='area')
packing$radius <- 0.95 * packing$radius	# 调整圆的半径
data <- cbind(data,packing)	# 将圆形布局信息加入数据集
dat.gg <- circleLayoutVertices(packing,npoints=50)	#生成用于绘图的坐标数据

# 使用ggplot绘制图形
ggplot() + 
    geom_polygon(data=dat.gg,aes(x,y,group=id,fill=id),
                 colour="black",alpha=0.6) +	# 绘制填充的多边形
    scale_fill_viridis() +	# 使用viridis颜色映射
    geom_text(data=data,aes(x,y,size=value,label=group),
              color="black") +	# 绘制文字标签
    theme_void() +	# 使用无背景的主题
    theme(legend.position="none") +	# 隐藏图例
    coord_equal()	# 使用等轴比例坐标

#【例7-14】利用packcircles绘制圆堆积图示例二
# 创建数据集
library(ggiraph)		# 用于创建交互式图形

data <- data.frame(
    group=paste("Group_",sample(letters,70,replace=T),
                sample(letters,70,replace=T),
                sample(letters,70,replace=T),sep=""),
    value=sample(seq(1,70),70))

# 添加为每个气泡显示文本的列
data$text <- paste("name:",data$group,"\n","value:",
                   data$value,"\n","Youcanaddastoryhere!")

# 生成布局
packing <- circleProgressiveLayout(data$value,sizetype='area')
data <- cbind(data,packing)
dat.gg <- circleLayoutVertices(packing,npoints=50)

# 绘图
p <- ggplot() +
    geom_polygon_interactive(data=dat.gg,aes(
        x,y,group=id,fill=id,tooltip=data$text[id],data_id=id),
        colour="black",alpha=0.6) +
    scale_fill_viridis() +
    geom_text(data=data,aes(x,y,label=gsub("Group_","",group)),
              size=2,color="black") +
    theme_void() +
    theme(legend.position="none",plot.margin=unit(c(0,0,0,0),"cm")) +
    coord_equal()

# 转换为交互式
girafe(ggobj=p,width_svg=7,height_svg=7)

#【例7-15】利用ggraph绘制圆堆积图示例
edges <- flare$edges			# 数据集flare一个给出层次结构的数据框
vertices <- flare$vertices		# 关联一个提供了数据集每个节点信息的数据集

# 使用igraph包创建图形对象
mygraph <- graph_from_data_frame(edges,vertices=vertices )
# 绘图
ggraph(mygraph,layout='circlepack') +
    geom_node_circle() +
    theme_void()

# 颜色取决于深度
p <- ggraph(mygraph,layout='circlepack',weight=size) +
    geom_node_circle(aes(fill=depth)) +
    theme_void() +
    theme(legend.position="FALSE")

# 调整颜色板:viridis
p1 <- p+scale_fill_viridis()
#调整颜色板:colorBrewer
p2 <- p + scale_fill_distiller(palette="RdPu")
p1+p2

# 创建数据集的子集（删除其中1个级别）
edges <- flare$edges %>% 
    filter(to %in% from) %>% 
    droplevels()
vertices <- flare$vertices %>% 
    filter(name %in% c(edges$from,edges$to)) %>% 
    droplevels()
vertices$size <- runif(nrow(vertices))

# 重新创建图形对象
mygraph <- graph_from_data_frame(edges,vertices=vertices)

# 绘图1
p3 <- ggraph(mygraph,layout='circlepack',weight=size) +
    geom_node_circle(aes(fill=depth)) +
    geom_node_text(aes(label=shortName,filter=leaf,fill=depth,size=size)) +
    theme_void() +
    theme(legend.position="FALSE") +
    scale_fill_viridis()
# 绘图2
p4 <- ggraph(mygraph,layout='circlepack',weight=size) +
    geom_node_circle(aes(fill=depth)) +
    geom_node_label(aes(label=shortName,filter=leaf,size=size)) +
    theme_void() +
    theme(legend.position="FALSE") +
    scale_fill_viridis()
p3+p4


