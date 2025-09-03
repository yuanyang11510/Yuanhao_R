#【例11-1】利用heatmaply包绘制热图示例
library(ggplot2)		# 用于数据可视化
library(plotly) 		# 用于创建交互式图形
library(viridis) 		# 提供不同颜色调色板
library(heatmaply) 		# 用于创建交互式热图

# 从CSV文件中读取数据
setwd("/Users/lc/Desktop/Rdata")		# 设置工作环境
rm(list=ls())						# 清空工作空间的所有变量
data <- read.table("13_AdjacencyDirectedWeighted.csv",header=TRUE)

# 短名称（用于热图的标签）
colnames(data) <- c("Africa","EastAsia","Europe","LatinAme.",
                    "NorthAme.","Oceania","SouthAsia","SouthEastAsia",
                    "SovietUnion","West.Asia")
# 设置短行名（与列名相同，因为这是一个对称矩阵）
rownames(data) <- colnames(data)

# 创建交互式热力图
heatmaply(data,            		# 使用的数据集
          dendrogram="none", 	# 不绘制树状图
          xlab="",         		# X轴标签为空
          ylab="",          		# Y轴标签为空
          main="",         		# 图的标题为空
          scale="column",   		# 按列缩放数据
          margins=c(60,100,40,20),		# 调整图的边距
          grid_color="white", 			# 网格线颜色为白色
          grid_width=0.00001,			# 网格线宽度
          titleX=FALSE,					# 不显示X轴标题
          hide_colorbar=TRUE,			# 隐藏颜色条
          branches_lwd=0.1,				# 设置树枝线的宽度
          label_names=c("From","To:","Value"),			# 标签名称
          fontsize_row=7,				# 行标签字体大小
          fontsize_col=7,				# 列标签字体大小
          labCol=colnames(data),		# 列标签
          labRow=rownames(data),			# 行标签
          heatmap_layers=theme(axis.line=element_blank())	# 隐藏坐标轴线
)

#【例11-2】利用ggplot2包绘制热图示例
library(RColorBrewer)	# 用于配色方案
library(ggplot2)		# 用于数据可视化
library(reshape2)  		# 用于数据重塑

# 从CSV文件中读取数据，第一行作为列名
df <- read.csv("AdjacencyDirectedWeighted.csv",
               header=TRUE,stringsAsFactors=FALSE)

# 计算每列的总和，以确定排序顺序
df_sum <- apply(df[,2:ncol(df)],2,sum)
order <- sort(df_sum,index.return=TRUE,decreasing=FALSE)

# 对数据进行重塑，以便用于绘图
df_melt <- melt(df,id.vars='Region')
colnames(df_melt) <- c("from","to","value")

# 处理"to"列的标签，去除句点并重新排序
df_melt$to <- gsub("\\."," ",df_melt$to)
df_melt$to <- factor(df_melt$to,levels=df$Region[order$ix],order=TRUE)

# 创建热力图
ggplot(df_melt,aes(x=from,y=to,fill=value,label=value)) +
    geom_tile(colour="blue") +			# 添加热图的矩形块，并设置边框颜色为蓝色
    coord_equal() +						# 保持坐标轴纵横比
    scale_fill_gradientn(colors=brewer.pal(9,'YlGnBu')) +	# 配色方案
    xlab('FROM') +						# X轴标签
    ylab('TO') +							# Y轴标签
    # 设置图形的主题，包括X轴文本旋转和颜色设置
    theme(
        axis.text.x=element_text(
            angle=30,hjust=1,colour='black'),		# X轴文本旋转
        axis.text.y=element_text(
            angle=0,hjust=1,colour='black')		# Y轴文本
    )


#【例11-3】利用ComplexHeatmap包绘制热图示例
library(devtools)
library(ComplexHeatmap)
library(circlize)

set.seed(123)    								# 设置随机数种子
# 定义矩阵的维度
nr1=4; nr2=8; nr3=6; nr=nr1 + nr2 + nr3
nc1=6; nc2=8; nc3=10; nc=nc1 + nc2 + nc3

# 生成三个子矩阵，每个子矩阵内的值服从正态分布
mat=cbind(
    rbind(
        matrix(rnorm(nr1 * nc1,mean=1,sd=0.5),nr=nr1),
        matrix(rnorm(nr2 * nc1,mean=0,sd=0.5),nr=nr2),
        matrix(rnorm(nr3 * nc1,mean=0,sd=0.5),nr=nr3) ),
    rbind(
        matrix(rnorm(nr1 * nc2,mean=0,sd=0.5),nr=nr1),
        matrix(rnorm(nr2 * nc2,mean=1,sd=0.5),nr=nr2),
        matrix(rnorm(nr3 * nc2,mean=0,sd=0.5),nr=nr3) ),
    rbind(
        matrix(rnorm(nr1 * nc3,mean=0.5,sd=0.5),nr=nr1),
        matrix(rnorm(nr2 * nc3,mean=0.5,sd=0.5),nr=nr2),
        matrix(rnorm(nr3 * nc3,mean=1,sd=0.5),nr=nr3) ) )

mat=mat[sample(nr,nr),sample(nc,nc)] 		# 随机打乱矩阵的行和列顺序

# 设置行和列的名称
rownames(mat)=paste0("Row",seq_len(nr))
colnames(mat)=paste0("Col",seq_len(nc))

Heatmap(mat) 									# 创建热图并显示
# 使用colorRamp2函数创建一个颜色渐变函数
col_fun=colorRamp2(c(-2,0,2),c("green","white","blue"))
col_fun(seq(-3,3)) 							# 对矩阵进行颜色着色
Heatmap(mat,name="mat",col=col_fun) 		# 创建带有自定义颜色的热图并显示


# 在每个单元格上添加文本标签
small_mat=mat[1:9,1:9] 	# 创建一个小型子矩阵，选取mat中的前9行和前9列
# 创建一个自定义颜色渐变函数col_fun
col_fun=colorRamp2(c(-2,0,2),c("green","white","red"))

# 创建热图
Heatmap(small_mat,     		# 数据矩阵
        name="mat",     		# 热图名称
        col=col_fun,    		# 使用自定义颜色渐变函数
        cell_fun=function(j,i,x,y,width,height,fill) {
            # 自定义函数，用于在每个单元格上添加文本标签
            grid.text(sprintf("%.1f",small_mat[i,j]),
                      x,y,gp=gpar(fontsize=10)) } )

#【例11-4】使用R基础包graphics中的函数pairs()描述如何生成散点图矩阵
pairs(iris[,1:4],pch=19)

# 设置颜色
my_cols <- c("#00AFBB","#E7B800","#FC4E07")  
pairs(iris[,1:4],pch=19,cex=0.5,
      col=my_cols[iris$Species],lower.panel=NULL)

# 面板上添加相关性：文本的大小与相关性成比例
# 相关性部分
panel.cor <- function(x,y) {
    usr <- par("usr") 				# 保存当前绘图区域的坐标范围
    on.exit(par(usr)) 				# 在函数执行完成后，恢复之前的绘图区域设置
    par(usr=c(0,1,0,1))				# 设置新的绘图区域坐标范围（整个图的范围）
    r <- round(cor(x,y),digits=2)	# 计算x和y的相关性系数，保留两位小数
    txt <- paste0("R=",r)			# 构建显示相关性系数的文本
    cex.cor <- 0.8/strwidth(txt)	# 计算文本字体大小，使其适应绘图区域
    text(0.5,0.5,txt,cex=cex.cor * r)		# 在中心位置绘制相关性系数文本
}

# 自定义函数用于在散点矩阵图的上部三角区域绘制散点图
upper.panel <- function(x,y) {
    points(x,y,pch=19,col=my_cols[iris$Species])	# 绘制散点图，根据物种着色
}

# 绘制散点矩阵图
pairs(iris[,1:4],       				# 选择Iris数据集的前四列作为变量
      lower.panel=panel.cor,			# 在下部绘制相关性系数
      upper.panel=upper.panel		# 在上部绘制散点图
)

#【例11-5】psych包中的pairs.panels函数也可用于创建矩阵的散点图
library(psych)
pairs.panels(iris[,-5],
             method="pearson",# correlation method
             hist.col="#00AFBB",
             density=TRUE,# show density plots
             ellipses=TRUE	# show correlation ellipses 
)

#【例11-6】利用GGally包中的ggpairs()函数创建矩阵散点图
library(GGally)			# 用于多变量数据可视化
ggpairs(iris)			# 创建矩阵散点图

# 分组后，会根据每一个类别分别给出变量之间的相关系数相关
ggpairs(data=iris,
        columns=c("Sepal.Length","Sepal.Width",
                  "Petal.Length","Petal.Width"),
        aes(color=Species,alpha=0.7))

# 设置上半部分展示相关系数，大小为4；下半部分为散点添加拟合线；对角线处去除密度分布图
ggpairs(data=iris,
        columns=c("Sepal.Length","Sepal.Width",
                  "Petal.Length","Petal.Width"),
        aes(color=Species,alpha=0.7),
        upper=list(continuous=wrap("cor"),size=4),
        lower=list(continuous="smooth"),
        diag=list(continuous="blankDiag"))

# 分类变量的相关绘制
ggpairs(iris[3:5],
        aes(color=Species,alpha=0.5),
        upper=list(combo="facetdensity"))

ggpairs(iris[3:5],
        aes(color=Species,alpha=0.5),
        upper=list(combo="facetdensity"),
        lower=list(combo="barDiag"))

#【例11-7】利用ggally包绘制平行坐标图
library(GGally)			# 用于多变量数据可视化
data <- iris
ggparcoord(data,columns=1:4,groupColumn=5)

library(hrbrthemes)		# 用于主题设置
library(viridis)        # 用于颜色选择

data <- iris
ggparcoord(data,columns=1:4,groupColumn=5,order="anyClass",
           showPoints=TRUE,title="Parallel Coordinate Plot",alphaLines=0.3) +
    scale_color_viridis(discrete=TRUE) +
    theme(plot.title=element_text(size=10))


# scale 参数进行归一化处理, globalminmax 表示不进行缩放
ggparcoord(data,columns=1:4,groupColumn=5,order="anyClass",
           scale="globalminmax",
           showPoints=TRUE,
           title="No scaling",
           alphaLines=0.3) +
    scale_color_viridis(discrete=TRUE) +
    theme(legend.position="none",plot.title=element_text(size=13)) +
    xlab("")

# uniminmax 表示标准化为最小值是0, 最大值是1
ggparcoord(data,columns=1:4,groupColumn=5,order="anyClass",
           scale="uniminmax",
           showPoints=TRUE,
           title="Standardize to Min=0 and Max=1",
           alphaLines=0.3  ) +
    scale_color_viridis(discrete=TRUE) +
    theme(legend.position="none",plot.title=element_text(size=13)) +
    xlab("")

# std 表示单变量归一化
ggparcoord(data,columns=1:4,groupColumn=5,order="anyClass",
           scale="std",
           showPoints=TRUE,
           title="Normalize univariately",
           alphaLines=0.3) +
    scale_color_viridis(discrete=TRUE) +
    theme(legend.position="none",plot.title=element_text(size=13)) +
    xlab("")

# center表示归一化并居中变量
ggparcoord(data,columns=1:4,groupColumn=5,order="anyClass",
           scale="center",
           showPoints=TRUE,title="Standardize and center variables",
           alphaLines=0.3) +
    scale_color_viridis(discrete=TRUE) +
    theme(legend.position="none",plot.title=element_text(size=13)) +
    xlab("")

