#【例8-1】利用igraph包绘制节点链接图示例
# 加载包
library(igraph)			# 用于处理网络图
library(networkD3)		# 用于绘制交互式网络图

# 创建一个名为 "Zachary" 的Karate Club网络
karate <- make_graph("Zachary")

# 使用Walktrap算法对网络进行社区检测
wc <- cluster_walktrap(karate)
members <- membership(wc)  			# 获取每个节点所属的社区成员标签

# 将图转换为适合networkD3的对象
karate_d3 <- igraph_to_networkD3(karate,group=members)

# 创建导向网络图
forceNetwork(Links=karate_d3$links,Nodes=karate_d3$nodes,
             Source='source',Target='target',
             NodeID='name',Group='group')

# 创建数据：生成一个20x20的0-1矩阵作为网络的邻接矩阵
data <- matrix(sample(0:1,400,replace=TRUE,prob=c(0.8,0.2)),nrow=20)
network <- graph_from_adjacency_matrix(data,mode='undirected',diag=FALSE)

# 使用不同的布局方法绘制图，将绘图区域分为2行2列，每个图占一个区域
par(mfrow=c(2,2),mar=c(1,1,1,1))

plot(network,layout=layout.sphere,main="sphere")	#使用sphere布局绘制图
plot(network,layout=layout.circle,main="circle")	#使用circle布局绘制图
plot(network,layout=layout.random,main="random")	#使用random布局绘制图
plot(network,layout=layout.fruchterman.reingold,
     main="fruchterman.reingold")		#使用fruchterman.reingold布局绘制图

#【例8-2】利用networkD3包绘制节点链接图示例
# 创建数据集
src <- c("A","A","A","A","B","B","C","C","D")
target <- c("B","C","D","J","E","F","G","H","I")
networkData <- data.frame(src,target)
# 绘图
simpleNetwork(networkData,fontSize=12)

# 加载数据集
data(MisLinks)
data(MisNodes)
# 绘图
forceNetwork(Links=MisLinks,Nodes=MisNodes,
             Source="source",Target="target",
             Value="value",NodeID="name",
             Group="group",opacity=0.8)

#【例8-3】利用ggplot2包绘制节点链接图示例
library(GGally)			# 用于多变量数据可视化
library(network)		# 用于创建和分析复杂网络
library(sna)			# 用于分析复杂网络

# 创建一个包含10个节点的随机图
net=rgraph(10,mode="graph",tprob=0.5)	# 生成随机图
net=network(net,directed=FALSE) 			# 将随机图转换为网络对象

# 为网络中的节点指定名称，节点名称使用字母a到j表示
network.vertex.names(net)=letters[1:10]			# 给网络中的节点分配名称
# 绘制节点大小为6，交替使用两种颜色来着色节点的网络图
ggnet2(net,size=6,color=rep(c("tomato","steelblue"),5))


#【例8-4】利用ggplot2包绘制节点链接图示例
library(tidyverse)   	# 数据处理和可视化
library(igraph)     		# 用于处理和分析图形数据
library(ggraph)     		# 用于绘制图形
library(colormap)   	# 生成颜色调色板
library(wesanderson)	# 提供精美的颜色调色板
library(reshape2)   	# 用于数据重塑

# 设置工作目录
setwd("/Users/lc/Desktop/Rdata")		# 设置工作环境
# 读取数据集
dataUU <- read.csv("AdjacencyUndirectedUnweighted.csv",
                   header=TRUE,check.names=FALSE)
# 将邻接矩阵数据转换为长格式
connect <- dataUU %>% 
    gather(key="to",value="value",-1) %>% 
    mutate(to=gsub("\\."," ",to)) %>% 		# 替换to列中的点号为空格
    na.omit()
# 计算每个人的连接数
c(as.character(connect$from),as.character(connect$to)) %>% 
    as.tibble() %>%
    group_by(value) %>% 
    summarize(n=n()) -> vertices

colnames(vertices) <- c("name","n")		# 重命名列名

# 创建一个igraph图形对象
mygraph <- graph_from_data_frame(connect,vertices=vertices,directed=FALSE)
com <- walktrap.community(mygraph) 		# 使用walktrap算法查找社区

# 重新排序数据集并创建图形
vertices <- vertices %>% 
    mutate(group=com$membership) %>%			# 根据社区分配
    mutate(group=as.numeric(factor(
        group,levels=sort(summary(as.factor(group)),
                          index.return=TRUE,decreasing=TRUE)$ix,
        order=TRUE))) %>%						# 对社区进行重新排序
    filter(group < 10) %>%					# 仅保留前10个社区
    arrange(group,desc(n)) %>%				# 按社区和连接数降序排列
    mutate(name=factor(name,name))

# 仅保留连接中包含在vertices中的人员
connect <- connect %>% 
    filter(from %in% vertices$name) %>% 
    filter(to %in% vertices$name) %>% 
    left_join(vertices,by=c('from'='name'))

# 创建一个新的igraph图形对象
mygraph <- graph_from_data_frame(connect,vertices=vertices,
                                 directed=FALSE)

# 准备颜色调色板
mycolor <- wes_palette("Darjeeling1",max(vertices$group),
                       type="continuous")
mycolor <- sample(mycolor,length(mycolor))		# 打乱颜色顺序
# 使用 ggraph 绘制图形
ggraph(mygraph,layout='nicely') +				# ①
    # 添加边的可视化属性
    geom_edge_link(edge_colour="black",edge_alpha=0.2,edge_width=0.3) +
    # 添加节点的可视化属性
    geom_node_point(aes(size=n,fill=as.factor(group)),shape=21,
                    color='black',alpha=0.9) +
    scale_size_continuous(range=c(0.5,10)) +			# 设置节点大小的连续范围
    scale_fill_manual(values=mycolor) +				# 手动设置节点填充颜色
    # 添加节点文本标签，仅对连接数大于20的节点添加标签
    geom_node_text(aes(label=ifelse(n > 20,as.character(name),"")),
                   size=3,color="black") +
    expand_limits(x=c(-1.2,1.2),y=c(-1.2,1.2)) +		# 设置图形的坐标范围
    theme_minimal() +									# 使用最小化的主题设置
    # 隐藏图例
    theme(legend.position="none",panel.grid=element_blank(),
          axis.line=element_blank(),axis.ticks=element_blank(),
          axis.text=element_blank(),axis.title=element_blank() )

#【例8-5】简单弧线图的绘制示例
# 创建数据框
# 定义一个包含节点之间连接关系的数据框
library(patchwork)

links=data.frame(source=c("A","A","A","A","B","A","B","B","A"),
                 target=c("B","C","D","F","E","A","B","C","D"))

# 将数据框转换为 igraph 图形对象
mygraph <- graph_from_data_frame(links)

# 创建常规网络图
p1 <- ggraph(mygraph) + 
    # 设置边的样式
    geom_edge_link(edge_colour="black",edge_alpha=0.3,edge_width=0.2) + 
    geom_node_point( color="#69b3a2",size=5) +	# 设置节点的样式
    # 添加节点标签
    geom_node_text( aes(label=name),repel=TRUE,size=8,color="#69b3a2") + 
    theme_void() +								# 使用 void 主题，无背景
    theme(legend.position="none",					# 不显示图例
          plot.margin=unit(rep(2,8),"cm"))  			# 设置图形的边距
p1

# 绘图
p2 <-  ggraph(mygraph,layout="linear") + 
    # 设置边的样式
    geom_edge_arc(edge_colour="black",edge_alpha=0.3,edge_width=0.2) + 
    geom_node_point( color="#69b3a2",size=5) +		# 设置节点的样式
    geom_node_text( aes(label=name),repel=FALSE,size=8,
                    color="#69b3a2",nudge_y=-0.1) +		# 添加节点标签
    theme_void() +									# 使用void主题，无背景
    theme(legend.position="none",						# 不显示图例
          plot.margin=unit(rep(2,8),"cm") )			# 设置图形的边距
p2												# 将两个图形组合在一起


#【例8-6】试通过弧线连接图展示某研究人员的合作网络
# 加载数据
dataUU <- read.table("13_AdjacencyUndirectedUnweighted.csv",
                     header=TRUE) 		# 读取数据文件

# 转换邻接矩阵为长格式
connect <- dataUU %>%
    gather(key="to",value="value",-1) %>%
    mutate(to=gsub("\\."," ",to)) %>%
    na.omit()

# 计算每个人的连接数
c(as.character(connect$from),as.character(connect$to)) %>%
    as_tibble() %>%
    group_by(value) %>%
    summarize(n=n()) -> coauth
colnames(coauth) <- c("name","n")

# 创建igraph图对象
mygraph <- graph_from_data_frame(connect,vertices=coauth,directed=FALSE)

# 使用Walktrap算法找到社区
com <- walktrap.community(mygraph)

# 重新排序数据集并构建图
coauth <- coauth %>%
    mutate(grp=com$membership) %>%
    arrange(grp) %>%
    mutate(name=factor(name,name))

# 仅保留前 15 个社区
coauth <- coauth %>% filter(grp < 16)

# 仅保留这些人在边缘中
connect <- connect %>%
    filter(from %in% coauth$name) %>%
    filter(to %in% coauth$name)

# 再次创建 igraph 图对象
mygraph <- graph_from_data_frame(connect,vertices=coauth,directed=FALSE)

# 准备一组颜色以用于节点
mycolor <- colormap(colormap=colormaps$viridis,nshades=max(coauth$grp))
mycolor <- sample(mycolor,length(mycolor))

# 绘制网络图
ggraph(mygraph,layout="linear") + 
    geom_edge_arc(edge_colour="black",edge_alpha=0.2,
                  edge_width=0.3,fold=TRUE) +
    geom_node_point(aes(size=n,color=as.factor(grp),fill=grp),alpha=0.5) +
    scale_size_continuous(range=c(0.5,8)) +
    scale_color_manual(values=mycolor) +
    geom_node_text(aes(label=name),angle=65,hjust=1,
                   nudge_y=-1.1,size=2.3) +
    theme_void() +
    theme(legend.position="none",plot.margin=unit(c(0,0,0.4,0),"null"),
          panel.spacing=unit(c(0,0,3.4,0),"null") ) +
    expand_limits(x=c(-1.2,1.2),y=c(-5.6,1.2))

#【例8-7】利用自带数据集highschool，通过蜂巢图展示某高中学生的社交网络
library("igraph")
library('ggraph')
library('tidygraph')
library('HiveR')   		# 用于创建蜂巢图
library("grid")

# 从高中数据集创建图对象
graph <- graph_from_data_frame(highschool)

# 为图的每个节点添加朋友数量属性
V(graph)$friends <- degree(graph,mode='in')
# 将朋友数量分为 'few','medium' 和 'many' 三个类别
V(graph)$friends <- ifelse(V(graph)$friends < 5,'few',
                           ifelse(V(graph)$friends >= 15,'many','medium'))

# 创建蜂巢图
ggraph(graph,'hive',axis=friends,sort.by='degree') +
    geom_edge_hive(aes(colour=factor(year))) +
    geom_axis_hive(aes(colour=friends),size=3,label=FALSE) +
    coord_fixed()

# 使用 tidygraph 包操作图
graph <- as_tbl_graph(highschool) %>% 
    mutate(degree=centrality_degree())

graph <- graph %>% 
    mutate(friends=ifelse(
        centrality_degree(mode='in') < 5,'few',
        ifelse(centrality_degree(mode='in') >= 15,'many','medium')
    ))

# 创建蜂巢图
ggraph(graph,'hive',axis=friends,sort.by=degree) + 
    geom_edge_hive(aes(colour=factor(year))) + 
    geom_axis_hive(aes(colour=friends),size=3,label=FALSE) + 
    coord_fixed()

# 添加按年份分面的蜂巢图
ggraph(graph,'hive',axis=friends,sort.by=degree) + 
    geom_edge_hive(aes(colour=factor(year))) + 
    geom_axis_hive(aes(colour=friends),size=3,label=FALSE) + 
    coord_fixed() +
    facet_edges(~year)				# 添加年份分面

#【例8-8】使用circlize包绘制基本和弦图示例1
library(circlize)			#用于绘制和弦图

set.seed(123)				# 设置随机种子
m <- matrix(sample(15,15),5,3)	# 创建 5x3 的矩阵，元素为随机抽取的整数

# 为矩阵的行列命名
rownames(m) <- paste0("Row",1:5)
colnames(m) <- paste0("Col",1:3)

chordDiagram(m)			# 绘制初始的和弦图

circos.clear()			# 清除之前的和弦图布局参数
# 定义颜色映射
colors <- c(Col1="lightgrey",Col2="grey",
            Col3="darkgrey",Row1="#FF410D",
            Row2="#6EE2FF",Row3="#F7C530",
            Row4="#95CC5E",Row5="#D0DFE6")

# 自定义颜色
chordDiagram(m,grid.col=colors)
circos.clear()

# 设置透明度
chordDiagram(m,grid.col=colors,transparency=0.2)
circos.clear()

# 定义更多颜色
colors <- c(Col1="red",Col2="green",
            Col3="blue",Row1="#FF410D",
            Row2="#6EE2FF",Row3="#F7C530",
            Row4="#95CC5E",Row5="#D0DFE6")

# 定义更多颜色
chordDiagram(m,grid.col=colors,col=hcl.colors(15))
circos.clear()

# 使用色阶绘制和弦图
cols <- colorRamp2(range(m),c("#E5FFFF","#003FFF"))
chordDiagram(m,grid.col=colors,col=cols)
circos.clear()

# 使用指定颜色和透明度的色阶
cols <- hcl.colors(15,"Temps")
# 在和弦图中使用指定颜色和透明度的色阶
chordDiagram(m,col=cols,transparency=0.1,
             link.lwd=1,# 线宽
             link.lty=1,# 线型
             link.border=1)	# 边框颜色
circos.clear()

# 使用指定颜色和透明度的色阶以及自定义边框颜色
cols <- hcl.colors(15,"Geyser")
mb <- matrix("black",nrow=1,ncol=ncol(m))
rownames(mb) <- rownames(m)[3]	# 选择第三行
colnames(mb) <- colnames(m)

# 在和弦图中使用指定颜色和透明度的色阶，并设置边框颜色
chordDiagram(m,col=cols,transparency=0.1,
             link.lwd=2,link.lty=2,link.border=mb) 
circos.clear()


#【例8-9】使用circlize包绘制和弦图显示从一个国家迁移到另一个国家的人数
# 加载包
library(circlize)		# 用于绘制和弦图
library(viridis)    		# 用于颜色选择
library(reshape2)   	# 用于数据重塑

# 从文件中读取数据
data <- read.table("13_AdjacencyDirectedWeighted.csv",
                   header=TRUE,check.name=FALSE)

# 在数据框中添加source列，将行名作为源节点
data$source <- rownames(data)

# 将数据框从宽格式转换为长格式，便于绘图
data_long <- melt(data,id.vars='source',variable.name='target')

head(data_long) 			# 输出数据的前几行，以检查数据格式，输出略

# 图形设置
circos.clear()				# 清空之前的图形设置
circos.par(
    start.degree=90,gap.degree=4,
    track.margin=c(-0.1,0.1),
    points.overflow.warning=FALSE)		# 设置Circos图的参数
par(mar=rep(0,4))						# 设置绘图区域的边距

# 定义配色方案
mycolor <- viridis(10,alpha=1,begin=0,end=1,option="D")
mycolor <- mycolor[sample(1:10)]		# 从颜色序列中随机选择颜色

# 绘制带箭头的Chord图
chordDiagram(x=data_long,grid.col=mycolor,
             transparency=0.25,annotationTrackHeight=c(0.1,0.05),
             diffHeight=-0.04,link.arr.type="big.arrow")

# 绘制带箭头和高度差异的Chord图
chordDiagram(x=data_long,grid.col=mycolor,
             transparency=0.25,directional=1,
             direction.type=c("arrows","diffHeight"),
             diffHeight =-0.04,annotationTrack="grid",
             annotationTrackHeight=c(0.05,0.1),
             link.arr.type="big.arrow",link.sort=TRUE,
             link.largest.ontop=TRUE)

# 在扇区中添加标签和刻度
circos.trackPlotRegion(track.index=1,bg.border=NA,
                    panel.fun=function(x,y) {
                            xlim=get.cell.meta.data("xlim")
                            sector.index=get.cell.meta.data("sector.index")
                            circos.text( x=mean(xlim),y=3.2,
                                         labels=sector.index,
                                         facing="bending",cex=0.8)
                            circos.axis(h="top",major.at=seq(
                                from=0,to=xlim[2],
                                by=ifelse(test=xlim[2] > 10,yes=2,no=1)),
                                minor.ticks=1,major.tick.percentage=0.5,
                                labels.niceFacing=FALSE) 
                        })

#【例8-10】创建一个包含层次结构的图形，并绘制连接节点的捆绑线
# 加载包
library(ggraph)			# 用于绘制图形
library(igraph)			# 用于处理图形数据
library(tidyverse)		# 用于数据操作和可视化

# 创建一个数据框，表示个体的层次结构
set.seed(1234)	# 设置随机数种子以确保结果可重现
d1 <- data.frame(from="origin",to=paste("group",seq(1,10),sep=""))
d2 <- data.frame(from=rep(d1$to,each=10),
                 to=paste("subgroup",seq(1,100),sep="_"))
hierarchy <- rbind(d1,d2)

# 创建一个包含个体之间连接的数据框
all_leaves <- paste("subgroup",seq(1,100),sep="_")
connect <- rbind( 
    data.frame(from=sample(all_leaves,100,replace=TRUE),
               to=sample(all_leaves,100,replace=TRUE)),
    data.frame(from=sample(head(all_leaves),30,replace=TRUE),
               to=sample(tail(all_leaves),30,replace=TRUE)),
    data.frame(from=sample(all_leaves[25:30],30,replace=TRUE),
               to=sample(all_leaves[55:60],30,replace=TRUE)),
    data.frame(from=sample(all_leaves[75:80],30,replace=TRUE),
               to=sample(all_leaves[55:60],30,replace=TRUE)) 
)
connect$value <- runif(nrow(connect))

# 创建一个包含层次结构中每个对象的数据框
vertices  <-  data.frame(
    name=unique(c(as.character(hierarchy$from),
                  as.character(hierarchy$to))),
    value=runif(111) ) 

# 添加一个列，其中包含每个名称的组信息
vertices$group  <-  hierarchy$from[match(vertices$name,hierarchy$to)]

# 创建一个图对象
mygraph <- graph_from_data_frame(hierarchy,vertices=vertices)

# 连接对象必须引用叶子节点的ID
from  <-  match(connect$from,vertices$name)
to  <-  match(connect$to,vertices$name)

# 基本图形
ggraph(mygraph,layout='dendrogram',circular=TRUE) + 
    geom_conn_bundle(data=get_con(from=from,to=to),
                     alpha=0.2,colour="skyblue",tension=0.5) + 
    geom_node_point(aes(filter=leaf,
                        x=x * 1.05,y=y * 1.05)) +	# 绘制叶子节点的点
    theme_void()	# 设置图的背景

# 修改张力参数 tension
# 创建一个基本的图形对象，它包含了节点的位置信息
p <- ggraph(mygraph,layout='dendrogram',circular=TRUE) + 
    geom_node_point(aes(filter=leaf,x=x * 1.05,y=y * 1.05)) +
    theme_void()

# 在基本图形上尝试不同的捆绑线参数，可以设置为0.1、0.5、1等，观察可视化效果
# 张力为 0.1
p + geom_conn_bundle(data=get_con(from=from,to=to),
                     alpha=0.2,colour="skyblue",width=0.9,tension=0.1) 
# 张力为1
p + geom_conn_bundle(data=get_con(from=from,to=to),
                     alpha=0.2,colour="skyblue",width=0.9,tension=1)


# 设置颜色
p + geom_conn_bundle(data=get_con(from=from,to=to),
                     aes(colour=value,alpha=value)) 

# 使用 'value' 列设置颜色，并使用颜色渐变从白色到红色
p + geom_conn_bundle(data=get_con(from=from,to=to),
                     aes(colour=value)) +
    scale_edge_color_continuous(low="white",high="red") 

# 使用 'value' 列设置颜色，并使用调色板"BuPu"
p + geom_conn_bundle(data=get_con(from=from,to=to),
                     aes(colour=value)) +
    scale_edge_colour_distiller(palette="BuPu") 

# 根据索引设置颜色，即不同连接线的颜色不同，同时设置宽度和透明度
p + geom_conn_bundle(data=get_con(from=from,to=to),
                     width=1,alpha=0.2,aes(colour=..index..)) +
    scale_edge_colour_distiller(palette="RdPu") +
    theme(legend.position="none")				# 不显示图例

# 创建基本图形 p，包含捆绑线和颜色映射
p=ggraph(mygraph,layout='dendrogram',circular=TRUE) + 
    geom_conn_bundle(data=get_con(from=from,to=to),
                     width=1,alpha=0.2,aes(colour=..index..)) +
    scale_edge_colour_distiller(palette="RdPu") +
    theme_void() +	# 设置为无背景
    theme(legend.position="none")			# 不显示图例

# 添加叶节点的点
# 在基本图形 p 上添加叶节点的点，设置颜色和透明度
p + geom_node_point(aes(filter=leaf,x=x * 1.05,y=y * 1.05),
                    colour="skyblue",alpha=0.3,size=3)

# 在基本图形 p上添加叶节点的点，根据 group 列设置颜色
library(RColorBrewer)
p + geom_node_point(aes(filter=leaf,x=x * 1.05,y=y * 1.05,
                        colour=group),size=3) +
    scale_colour_manual(values=rep(brewer.pal(9,"Paired"),30))

# 在基本图形p上添加叶节点的点，根据'group'列设置颜色、大小和透明度
p + 
    geom_node_point(aes(filter=leaf,x=x * 1.05,y=y * 1.05,
                        colour=group,size=value,alpha=0.2)) +
    scale_colour_manual(values=rep(brewer.pal(9,"Paired"),30)) +
    scale_size_continuous(range=c(0.1,10))	# 设置点的大小范围

#【例8-11】创建一个包含层次结构的图形，并绘制带标签的边绑定图
# 加载包
library(ggraph)  		# 用于绘制图形
library(igraph) 		# 用于处理和分析图形数据
library(tidyverse)		# 用于数据处理和绘图
library(RColorBrewer)
# 创建一个给定个体分层结构的数据框
set.seed(1234)
d1 <- data.frame(from="origin",
                 to=paste("group",seq(1,10),sep=""))
d2 <- data.frame(from=rep(d1$to,each=10),
                 to=paste("subgroup",seq(1,100),sep="_"))
edges <- rbind(d1,d2)

# 创建一个包含叶子节点之间连接的数据框
all_leaves <- paste("subgroup",seq(1,100),sep="_")
connect <- rbind(
    data.frame(from=sample(all_leaves,100,replace=TRUE),
               to=sample(all_leaves,100,replace=TRUE)),
    data.frame(from=sample(head(all_leaves),30,replace=TRUE),
               to=sample(tail(all_leaves),30,replace=TRUE)),
    data.frame(from=sample(all_leaves[25:30],30,replace=TRUE),
               to=sample(all_leaves[55:60],30,replace=TRUE)),
    data.frame(from=sample(all_leaves[75:80],30,replace=TRUE),
               to=sample(all_leaves[55:60],30,replace=TRUE))
)
connect$value <- runif(nrow(connect))

# 创建一个包含个体分层结构的数据框
vertices <- data.frame(
    name=unique(c(as.character(edges$from),as.character(edges$to))),
    value=runif(111)
)

# 添加一个 'group' 列，用于后续的颜色映射
vertices$group <- edges$from[match(vertices$name,edges$to)]

# 计算叶子节点的 id、角度、水平对齐和翻转角度
vertices$id <- NA
myleaves <- which(is.na(match(vertices$name,edges$from)))
nleaves <- length(myleaves)
vertices$id[myleaves] <- seq(1:nleaves)
vertices$angle <- 90 - 360 * vertices$id / nleaves
vertices$hjust <- ifelse(vertices$angle < -90,1,0)
vertices$angle <- ifelse(vertices$angle < -90,vertices$angle + 180,
                         vertices$angle)

# 创建 igraph 图对象
mygraph <- igraph::graph_from_data_frame(edges,vertices=vertices)

# 连接对象必须引用叶子节点的 id
from <- match(connect$from,vertices$name)
to <- match(connect$to,vertices$name)

# 创建基本图形，包括节点、连接线和文本标签，如图8 26（a）所示
ggraph(mygraph,layout='dendrogram',circular=TRUE) +
    geom_node_point(aes(filter=leaf,x=x * 1.05,y=y * 1.05)) +
    geom_conn_bundle(data=get_con(from=from,to=to),
                     alpha=0.2,colour="skyblue",width=0.9) +
    geom_node_text(aes(x=x * 1.1,y=y * 1.1,filter=leaf,
                       label=name,angle=angle,hjust=hjust),
                   size=1.5,alpha=1) +
    theme_void() +
    theme(legend.position="none",plot.margin=unit(c(0,0,0,0),"cm"),) +
    expand_limits(x=c(-1.2,1.2),y=c(-1.2,1.2))

# 创建基本图形，包括节点、连接线、文本标签、颜色映射和大小映射，如图8 26（b）所示
ggraph(mygraph,layout='dendrogram',circular=TRUE) +
    geom_conn_bundle(data=get_con(from=from,to=to),alpha=0.2,
                     width=0.9,aes(colour=..index..)) +
    scale_edge_colour_distiller(palette="RdPu") +
    geom_node_text(aes(x=x * 1.15,y=y * 1.15,filter=leaf,
                       label=name,angle=angle,hjust=hjust,
                       colour=group),size=2,alpha=1) +
    geom_node_point(aes(filter=leaf,x=x * 1.07,y=y * 1.07,
                        colour=group,size=value,alpha=0.2)) +
    scale_colour_manual(values=rep(brewer.pal(9,"Paired"),30)) +
    scale_size_continuous(range=c(0.1,10)) +
    theme_void() +
    theme(legend.position="none",plot.margin=unit(c(0,0,0,0),"cm"),) +
    expand_limits(x=c(-1.3,1.3),y=c(-1.3,1.3))

