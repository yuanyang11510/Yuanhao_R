# 下述例子基本都受ChatGPT的启发，部分代码和注释由ChatGPT提供或者由VS Code内部AI智能补全，不再明确标注

## 一、plot()函数
x1 <- -5:5
y1 <- x1^2

# （1）一般参数
plot(
    x1,y1,
    xlim = c(-10,10), # x轴范围
    ylim = c(-5,20), # y轴范围
    # frame.plot = FALSE, # 不显示图框
    # axes = FALSE, # 不显示坐标轴刻度（以及图框）
    # xaxt = "n", # 不显示x轴刻度
    # yaxt = "n", # 不显示y轴刻度
    # ann = FALSE, # 不显示标题和轴标签（annotate）
    main = "主标题",
    sub = "副标题",
    xlab = "X轴标签",
    ylab = "Y轴标签",
    #* cex（character expansion）参数表示文字大小的缩放倍数，默认值为1
    cex.main = 3, # 主标题文字大小
    cex.sub = 2, # 副标题文字大小
    cex.axis = 1.5, # 轴刻度文字大小（x轴、y轴同时控制）
    cex.lab = 1.5, # 轴标签文字大小（x轴、y轴同时控制）

)

# （2）type参数
plot(x1,y1,type = "p") # 散点图（默认）
plot(x1,y1,type = "l") # 折线图
plot(x1,y1,type = "b") # 散点+折线图（线不穿过点）
plot(x1,y1,type = "o") # 散点+折线图（线穿过点）
plot(x1,y1,type = "c") # 散点（不画出）+折线图
plot(x1,y1,type = "s") # 阶梯线图（先横后纵）
plot(x1,y1,type = "S") # 阶梯线图（先纵后横）
plot(x1,y1,type = "h") # 直方图

# （3）pch参数（plotting character）
# 0-18: S-compatible vector symbols
plot(x1,y1,pch = 0) # 方块
plot(x1,y1,pch = 1) # 空心圆(默认)
plot(x1,y1,pch = 2) # 空心三角
# 19-25: further R vector symbols
plot(x1,y1,pch = 19)
plot(x1,y1,pch = 20)
# 21-25: can be colored and filled with different colors
plot(x1,y1,pch = 21)
plot(
    x1,y1,
    pch = 21,
    col = "red", # 边框颜色
    bg = "black" # 填充颜色
)
# 26-31: unused (and ignored)
# 32-127: ASCII characters
plot(x1,y1,pch = 32) # 空格
plot(x1,y1,pch = 33) # 感叹号
plot(x1,y1,pch = 34) # 双引号

# （4）las参数（label axis style？）
plot(x1,y1,las = 0) # x轴文字水平，y轴文字逆时针90度（默认）
plot(x1,y1,las = 1) # x轴、y轴文字均水平
plot(x1,y1,las = 2) # x轴文字逆时针90度，y轴文字水平
plot(x1,y1,las = 3) # x轴、y轴文字均逆时针90度

# （5）asp参数（y/x aspect ratio）
x2 <- -5:5
y2 <- x2
plot(x2,y2,type = "l",asp = .5) # 比较平缓
plot(x2,y2,type = "l",asp = 1) # 真实比例
plot(x2,y2,type = "l",asp = 2) # 比较陡峭

# （6）log参数（要求值为正数，因为0和负数无法取对数）
#* 以log = "x"为例，并不是将x轴数据取（自然）对数，而是将x轴刻度按对数比例显示：ln(1)=0, ln(2)=0.693, ln(3)=1.099, ln(4)=1.386, ..., ln(10)=2.303，所以刻度看起来会向左压缩（靠近x=1的点间距大，靠近x=10的点间距小）
plot(1:10,1:10,log = "x") # x轴对数刻度
plot(1:10,1:10,log = "y") # y轴对数刻度
plot(1:10,1:10,log = "xy") # xy轴对数刻度

# （7）panel.first/last参数

# （7.1）panel.first参数
# 原书解释：“设置【绘制坐标轴】之后，在进行任何【绘图】之前要计算的表达式”
plot(
    x1,y1,type = "l",
    panel.first = grid() # 在画点之前先画网格
)

# （7.2）panel.last参数
# 原书解释：“【绘制图形】后，在【添加轴、标题和图框】前要计算的表达式”
plot(
    x1,y1,
    panel.last = abline(h = 50, col = "red") # 在主图形之后画一条水平线
)

# （7.3）两者结合
plot(
    x1,y1,
    panel.first = grid(), # 先画灰色网格，再画点
    panel.last = abline(lm(y1 ~ x1), col = "blue") # 最后画回归直线
)

# panel.first = 在主图形之前画东西（适合背景元素，比如网格）
# panel.last = 在主图形之后画东西（适合覆盖主图的线、标记等）

## 二、assocplot()函数
# 关联图（association plot）用于可视化分类变量之间的关系，通常用于展示列联表（contingency table）数据
#* assocplot()要求数据是整数（频数）
m1 <- matrix(c(11,23,41,56,23,78,34,68,99),3,dimnames = list(c("a","b","c"),c("A","B","C")))
m1
assocplot(
    m1,
    col = c("red","green"), # 正负相关颜色
    space = .2, # 矩形间距
    main = "关联图示例",
    xlab = "类别X",
    ylab = "类别Y"
)

## 三、barplot()函数
# 条形图/柱状图（bar plot）用于展示分类数据的频数或比例
# （1）向量
v1 <- c(5, 10, 7)
v1

# horiz参数
barplot(v1,horiz = TRUE) # 横向显示

# space参数
barplot(v1,space = .5) # 条形间距（向量模式下默认值为.2，矩阵模式下默认值为c(0,1)）

# col参数
barplot(v1,col = c("red","yellow","blue")) # 每个条形一种颜色

# width参数
barplot(
    v1,
    xlim = c(0,2),
    width = .5, # 条形宽度，默认值为1
    #* 文档原文：“Specifying a single value will have no visible effect unless xlim is specified.”所以设置单个数值需要配合xlim参数使用
)
barplot(
    v1,
    width = c(.5,1,1.5), # 同时设置每个条形的宽度可以不用设置xlim参数
)

# （2）矩阵
m1
barplot(m1)

# beside参数
barplot(m1,beside = TRUE) # 并排显示

# 其他参数
barplot(
    m1,
    main = "矩阵数据的条形图",
    xlab = "x标签",
    ylab = "y标签",
    col = c("red","yellow","blue"), # 矩阵的每一行同属一种颜色
    border = "green", # 边框颜色（默认值为par("fg")，foreground“前景色”，即黑色），FALSE/NA表示无边框颜色，如果有条纹，TRUE/NULL表示和对应条纹颜色相同，否则等于默认值，即黑色）
    density = 20, # 条纹密度
    angle = 30, # 条纹角度（默认值为45）
    # axisnames = FALSE, # 不显示条形名称
    names.arg = c("A","B","C"), # 矩阵的每一列同属一个条形，以列名称作为条形名称
    #* 这一步骤相当于先运行：colnames(m2) <- c("A","B","C")
    legend.text = c("a","b","c"), # 图例（颜色+行名称）
    #* 注意如果提前设置了行名称：rownames(m2) <- c("a","b","c")，需要设置legend.text = TRUE才能生效
    axis.lty = 1, # 轴线类型（line type），条形图中默认不画出x轴（默认值为0，之后取值从1-6为一个循环，1为实线，也可以输入"solid"，之后依次为2虚线"dashed"、3点线"dotted"、4点划线"dotdash"、5长划线"longdash"、6双划线"twodash"，7又是实线）
    offset = -10, # 条形图底部起始位置偏移量（默认值为0，正值向上偏移，负值向下偏移）
)






