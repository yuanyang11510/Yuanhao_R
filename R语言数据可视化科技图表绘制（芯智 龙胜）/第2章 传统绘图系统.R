# 下述例子基本都受ChatGPT的启发，部分代码和注释由ChatGPT提供或者由VS Code内部AI智能补全，不再明确标注
options(width = 128) # 控制VS Code中R终端的显示宽度

## 目录
## 一、plot()函数
## 二、assocplot()函数
## 三、barplot()函数
## 四、boxplot()函数
## 五、cdplot()函数
## 六、contour()函数
## 七、coplot()函数
## 八、curve()函数
## 九、dotchart()函数
## 十、fourfoldplot()函数
## 十一、hist()函数
## 十二、image()函数
## 十三、matplot()函数
## 十四、mosaicplot()函数


## 一、plot()函数
x_plot <- -5:5
y_plot <- x_plot^2

# （1）一般参数
plot(
    x_plot,y_plot,
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
    lwd = 2, # 线宽（line width），默认值为1
)

# （2）type参数
plot(x_plot,y_plot,type = "p") # 散点图（默认）
plot(x_plot,y_plot,type = "l") # 折线图
plot(x_plot,y_plot,type = "b") # 散点+折线图（线不穿过点）
plot(x_plot,y_plot,type = "o") # 散点+折线图（线穿过点）
plot(x_plot,y_plot,type = "c") # 散点（不画出）+折线图
plot(x_plot,y_plot,type = "s") # 阶梯线图（先横后纵）
plot(x_plot,y_plot,type = "S") # 阶梯线图（先纵后横）
plot(x_plot,y_plot,type = "h") # 直方图

# （3）pch参数（plotting character）
# 0-18: S-compatible vector symbols
plot(x_plot,y_plot,pch = 0) # 方块
plot(x_plot,y_plot,pch = 1) # 空心圆(默认)
plot(x_plot,y_plot,pch = 2) # 空心三角
# 19-25: further R vector symbols
plot(x_plot,y_plot,pch = 19)
plot(x_plot,y_plot,pch = 20)
# 21-25: can be colored and filled with different colors
plot(x_plot,y_plot,pch = 21)
plot(
    x_plot,y_plot,
    pch = 21,
    col = "red", # 边框颜色
    bg = "black" # 填充颜色
)
# 26-31: unused (and ignored)
# 32-127: ASCII characters
plot(x_plot,y_plot,pch = 32) # 空格
plot(x_plot,y_plot,pch = 33) # 感叹号
plot(x_plot,y_plot,pch = 34) # 双引号

# （4）las参数（label axis style？）
plot(x_plot,y_plot,las = 0) # x轴文字水平，y轴文字逆时针90度（默认）
plot(x_plot,y_plot,las = 1) # x轴、y轴文字均水平
plot(x_plot,y_plot,las = 2) # x轴文字逆时针90度，y轴文字水平
plot(x_plot,y_plot,las = 3) # x轴、y轴文字均逆时针90度

# （5）asp参数（y/x aspect ratio）
x_plot2 <- -5:5
y_plot2 <- x_plot2
plot(x_plot2,y_plot2,type = "l",asp = .5) # 比较平缓
plot(x_plot2,y_plot2,type = "l",asp = 1) # 真实比例
plot(x_plot2,y_plot2,type = "l",asp = 2) # 比较陡峭

# （6）log参数（要求值为正数，因为0和负数无法取对数）
#* 以log = "x"为例，并不是将x轴数据取（自然）对数，而是将x轴刻度按对数比例显示：ln(1)=0, ln(2)=0.693, ln(3)=1.099, ln(4)=1.386, ..., ln(10)=2.303，所以刻度看起来会向左压缩（靠近x=1的点间距大，靠近x=10的点间距小）
plot(1:10,1:10,log = "x") # x轴对数刻度
plot(1:10,1:10,log = "y") # y轴对数刻度
plot(1:10,1:10,log = "xy") # xy轴对数刻度

# （7）panel.first/last参数

# （7.1）panel.first参数
# 原书解释：“设置【绘制坐标轴】之后，在进行任何【绘图】之前要计算的表达式”
plot(
    x_plot,y_plot,type = "l",
    panel.first = grid() # 在画点之前先画网格
)

# （7.2）panel.last参数
# 原书解释：“【绘制图形】后，在【添加轴、标题和图框】前要计算的表达式”
plot(
    x_plot,y_plot,
    panel.last = abline(h = 15, col = "red") # 在主图形之后画一条水平线
)

# （7.3）两者结合
plot(
    x_plot,y_plot,
    panel.first = grid(), # 先画灰色网格，再画点
    panel.last = abline(lm(y_plot ~ x_plot), col = "blue") # 最后画回归直线
)

# panel.first = 在主图形之前画东西（适合背景元素，比如网格）
# panel.last = 在主图形之后画东西（适合覆盖主图的线、标记等）

## 二、assocplot()函数
# 关联图（association plot）用于可视化分类变量之间的关系，通常用于展示列联表（contingency table）数据
#* assocplot()要求数据是整数（频数）
m_assoc <- matrix(c(11,23,41,56,23,78,34,68,99),3,dimnames = list(c("a","b","c"),c("A","B","C")))
m_assoc
assocplot(
    m_assoc,
    col = c("red","green"), # 正负相关颜色
    space = .2, # 矩形间距
    main = "关联图示例",
    xlab = "类别X",
    ylab = "类别Y"
)

#* 注意：assocplot()函数的最后一个参数后面不能有","号，否则会报错，这种表现和plot()函数不同，前一类型还包括下文的boxplot()函数，后一类型还包括下文的barplot()函数，这和这些函数的底层实现有关，简单而言，plot()函数、barplot()函数的参数定义是以",..."结尾的，因此允许最后一个参数后面带","号，而assocplot()函数、boxplot()函数的参数不是以",..."结尾的，而是以一个具体的参数结尾的，因此不允许最后一个参数后面带","号

## 三、barplot()函数
# 条形图/柱状图（bar chart/graph）用于展示分类数据的频数或比例
# 向量
v_bar <- c(5, 10, 7)
v_bar

# （1）horiz参数
barplot(v_bar,horiz = TRUE) # 横向显示

# （2）space参数
barplot(v_bar,space = .5) # 条形间距（向量模式下默认值为.2，矩阵模式下默认值为c(0,1)）

# （3）width参数
barplot(
    v_bar,
    xlim = c(0,2),
    width = .5, # 条形宽度，默认值为1
    #* 文档原文：“Specifying a single value will have no visible effect unless xlim is specified.”所以设置单个数值需要配合xlim参数使用
)
barplot(
    v_bar,
    width = c(.5,1,1.5), # 同时设置每个条形的宽度可以不用设置xlim参数
)

# （4）col参数
barplot(v_bar,col = c("red","yellow","blue")) # 每个条形一种颜色

# 矩阵
m_bar <- matrix(c(11,23,41,56,23,78,34,68,99),3,dimnames = list(c("a","b","c"),c("A","B","C")))
m_bar
barplot(m_bar)

# （5）beside参数
barplot(m_bar,beside = TRUE) # 并排显示

# （6）其他参数
barplot(
    m_bar,
    main = "矩阵数据的条形图",
    xlab = "x标签",
    ylab = "y标签",
    col = c("red","yellow","blue"), # 矩阵的每一行同属一种颜色
    border = "green", # 边框颜色（默认值为par("fg")，foreground“前景色”，即黑色），FALSE/NA表示无边框颜色，如果有条纹，TRUE/NULL表示和对应条纹颜色相同，否则等于默认值，即黑色）
    density = 20, # 条纹密度
    angle = 30, # 条纹角度（默认值为45）
    # axisnames = FALSE, # 不显示条形名称
    names.arg = c("A","B","C"), # 矩阵的每一列同属一个条形，以列名称作为条形名称
    #* 如果提前设置了列名称：colnames(m2) <- c("A","B","C")，这一参数可以省略
    legend.text = c("a","b","c"), # 图例（颜色+行名称）
    #* 如果提前设置了行名称：rownames(m2) <- c("a","b","c")，需要设置legend.text = TRUE才能生效
    axis.lty = 1, # 轴线类型（line type），条形图中默认不画出x轴（默认值为0，之后取值从1-6为一个循环，1为实线，也可以输入"solid"，之后依次为2虚线"dashed"、3点线"dotted"、4点划线"dotdash"、5长划线"longdash"、6双划线"twodash"，7又是实线）
    offset = -10, # 条形图底部起始位置偏移量（默认值为0，正值向上偏移，负值向下偏移）
)

## 四、boxplot()函数
# 箱线图（box plot/box-and-whisker plot）用于展示数据的分布情况，显示中位数、四分位数、异常值等信息
x_box <- c(-10,-1,0,1,2,7,15)
quantile(x_box)
summary(x_box)
# 中位数/第二四分位点：1
# 第一四分位点：-0.5
# 第三四分位点：4.5
# 四分位距IQR（interquantile range）：4.5-(-0.5) = 5
# 下方离群值（outlier）临界点：-0.5-1.5*IQR = -8
# 上方离群值（outlier）临界点：4.5+1.5*IQR = 13

# 有的学者会将离群值中进一步划分为适度离群值（mild outlier）和极端离群值（extreme outlier），一般规定适度离群值临界点为比第一四分位数小1.5*IQR或者比第三四分位数大1.5*IQR的值，极端离群值临界点为比第一四分位数小3*IQR或者比第三四分位数大3*IQR的值，因此此处如果按此规定，适度离群值的范围是[-15.5,-8)和(13,19.5]，极端离群值的范围是(-∞,-15.5)和(19.5,+∞)

#* 中位数、四分位点等值可以通过quantile()函数或者summary()函数计算出来，这两个函数当中有一个参数type（1-9，默认值为7），控制了计算各个统计量的方式，比较复杂，此处不再赘述，一般参照默认模式的计算结果即可

boxplot(x_box)
# 因此中位数是1，箱体范围是[-0.5,4.5]，[-8,-7.5)和(4.5,13]范围内存在的值构成箱线图的“胡须”（whisker），以各自范围内的最小值或者最大值作为“胡须”的末端，离群值的范围是(-∞,-8)和(13,+∞)，以散点的形式显示

# （1）range参数
boxplot(
    x_box,
    range = 2 # range控制的就是IQR的倍数，默认值为1.5
)
#* 此处将range从1.5提高到2后，离群值的范围就变为了(-∞,-10.5)和(14.5,+∞)，-10就不再是离群值，而成为了“胡须”的下端，15仍然是离群值，所以仍然显示为散点

# （2）notch参数
set.seed(123)
v_box1 <- rnorm(20, mean = 5)
v_box2 <- rnorm(20, mean = 7)
v_box3 <- rnorm(20, mean = 6)
boxplot(
    v_box1,v_box2,v_box3,
    names = c("A", "B", "C"),
    main = "三组数据的箱线图",
    col = c("skyblue", "pink", "lightgreen"),
    notch = TRUE # 显示缺口
)
#* “缺口”的上下边界标示了中位数的置信区间（95%），其公式为：
#* 上界 = 中位数 + 1.58 * IQR / sqrt(n)
#* 下界 = 中位数 - 1.58 * IQR / sqrt(n)
#* 其中1.58是经验系数，可以使缺口大约覆盖95%的中位数置信区间，n是样本量，可以发现，​样本量越大，缺口（置信区间）越窄，中位数的估计越精确，如果观察到两组数据的缺口没有重合部分，则说明这两组数据的中位数很可能不同

# （3）outline参数
boxplot(x_box)
boxplot(
    x_box,
    outline = FALSE # 不显示离群值
)

# （4）width、varwidth参数
x_box2 <- c(-20,-10,-5,-3,-2,1,2,5,6,7,10,12,15,20,30,50)
boxplot(
    x_box,x_box2,
    # width = c(1,1), # 存在多个箱体时，控制箱体宽度的相对比例
    varwidth = TRUE # 根据箱体宽度和样本量的平方根成比例（样本量越大，箱体越宽）
)

# （5）horizontal参数
boxplot(
    len ~ supp, 
    data = ToothGrowth,
    main = "不同补充剂的牙齿增长",
    xlab = "补充剂类型", ylab = "牙齿长度",
    col = c("orange", "cyan"),
    horizontal = TRUE # 水平显示
)

## 五、cdplot()函数
# 条件密度图（conditional density plot）
# 它的主要作用：
# 显示类别型变量在连续型变量的不同值下的条件概率分布
# 帮助判断连续变量是否能区分不同的类别
# 在cdplot()中，连续变量x的条件概率是通过核密度估计（Kernel Density Estimation, KDE）来平滑计算的

# 两个类别
mtcars_cd <- mtcars
# 将mpg大于20与否作为分类变量
mtcars_cd$mpg_high <- factor(mtcars_cd$mpg > 20) # y轴的类别（此处共两个类别：TRUE和FALSE）
# 条件密度图
cdplot(mpg_high ~ wt, data = mtcars_cd)

# （1）weights参数
# 为每一个x值赋予相应的权重
set.seed(123)
w_cd <- runif(nrow(mtcars_cd),.5,1.5)
w_cd
cdplot(mpg_high ~ wt, data = mtcars_cd,weights = w_cd)

# （2）bw参数（bandwidth）
# 默认值为"nrd0"（Normal Reference Distribution(version 0)），目的是保持图像的【平滑】，bw值越小，图像越陡峭，bw值越大，图像越平缓
cdplot(mpg_high ~ wt, data = mtcars_cd,bw = .1)
cdplot(mpg_high ~ wt, data = mtcars_cd,bw = .3)
cdplot(mpg_high ~ wt, data = mtcars_cd,bw = .5)
cdplot(mpg_high ~ wt, data = mtcars_cd,bw = 1)
cdplot(mpg_high ~ wt, data = mtcars_cd,bw = 2)

# 三个类别
set.seed(123)
x_cd <- rnorm(30)
x_cd
f_cd <- factor(sample(c("A","B","C"),length(x_cd),replace = TRUE))
f_cd

# （3）ylevels参数
cdplot(f_cd ~ x_cd)
cdplot(
    f_cd ~ x_cd,
    ylevels = c("C","B","A"), # 调整因子水平的顺序（因子水平名称）
)
cdplot(
    f_cd ~ x_cd,
    ylevels = c(3,2,1), # 调整因子水平的顺序（序号）
)

# （4）yaxlabels参数
cdplot(f_cd ~ x_cd)
cdplot(
    f_cd ~ x_cd,
    yaxlabels = c("第一类","第二类","第三类"), # 改变因子水平的名称
)
#* yaxlabels参数中因子水平名称的顺序是按照因子水平的默认顺序排列的，如果要同时调整因子水平的顺序（ylevels），则注意相应的因子水平名称的顺序也要改变
cdplot(
    f_cd ~ x_cd,
    ylevels = c(3,2,1),
)
cdplot(
    f_cd ~ x_cd,
    ylevels = c("C","B","A"), # 改变因子水平的顺序
    yaxlabels = c("第三类","第二类","第一类"), # 因子水平名称的排列顺序也相应改变
)

#? 当类别存在三个及三个以上时，ylevels不列出所有的因子水平，也可以画出条件密度图但暂时没有弄清楚此时没有列出的类别将如何处理
cdplot(f_cd ~ x_cd)
cdplot(f_cd ~ x_cd,ylevels = c("A","B"))

## 六、contour()函数
# 等高线图（contour plot）
contour(volcano)

x_contour <- seq(-3, 3, length = 50)
y_contour <- seq(-2, 2, length = 50)
z_contour <- outer(x_contour, y_contour, function(x_contour, y_contour) x_contour^2 + y_contour^2)

contour(
    x_contour, y_contour, z_contour,
    col = "blue", # 等高线颜色
    # drawlabel = F, # 是否画出高度标签
    levels = c(1,1.5,2,3.5,4,5.5,7,8,10,12,14,15.5,16,18), # 高度标签内容
    nlevels = 15, # 等高线数量（默认值为10）
    lty = 2, # 等高线类型
    labcex = 2, # 高度标签字体大小
)       
#* levels参数的默认值为pretty(zlim, nlevels)，pretty()函数的作用是根据zlim的最大值和最小值以及nlevels的值，使得自动生成的高度标签内容看起来比较【齐整】，所以往往是整数，如果通过levels参数手动设置高度标签内容，则nlevels参数会被忽略

## 七、coplot()函数
# 条件散点图（conditioning plot）
# 当我们想要研究两个变量之间的关系，但这个关系可能受到第三个（甚至第四个）变量的影响，就可以用coplot()来画图
# （1）一般参数
coplot(
    mpg ~ hp | wt * drat,data = mtcars, # 如果要显示两种影响变量，用"*"号连接
    panel = panel.smooth, # 控制每个小图的绘制方式（默认值为points，还可以选择lines，表示画折线，也可以输入自定义的绘制函数）
    number = c(4,3), # 将影响变量划分为几个连续区间（默认值为6）
    overlap = c(.3,.6), # 相邻区间是否重合（默认值为0.5，可以取任何小于1的数，当数值为0或者负数时，相邻区间会出现间隔）
    xlab = c("x轴标签","上方条件条标签"),
    ylab = c("y轴标签","右侧条件条标签"),
)

# （2）两种性质的条件条
coplot(Ozone ~ Solar.R | Month,data = airquality)
#* 由于月份其实是离散的变量，并且数据集中实际上只有5个月份，所以此处R将其当作连续变量来处理，并且由于number默认值为6，因此最终会看到6个相邻的区间，其实是没有意义的
coplot(
    Ozone ~ Solar.R | Month,data = airquality,
    number = 5 # 通过将number参数设置为5来显示5个不同的区间
)
#* 这种做法虽然显示了5个不同的区间，但实际上本质上依然是将月份作为连续变量来处理，依然是没有意义的
coplot(
    Ozone ~ Solar.R | factor(Month),data = airquality, # 通过直接将Month一列因子化来显示5个不同的区间
)
#* 这种做法将月份因子化，划分为5个离散的因子水平，结果才有意义

# bar.bg参数的默认值是：bar.bg = c(num = gray(0.8), fac = gray(0.95))，意为当条件变量是数值型（numeric）时，条件条的背景颜色用gray(0.8)，当条件变量是因子型（factor）时，条件条的背景颜色用gray(0.95)，因此可以看见上述三种情况中，前两种情况的条件条背景颜色相同，和第三种情况的条件条背景颜色不同

## 八、curve()函数
# 用来绘制函数曲线。它的核心思想是：给它一个数学函数，它会帮你在给定区间内自动取点、计算函数值并画出平滑曲线
curve(x^2,from = -3,to = 3)
#* 注意数据来源必须是“表达式”（expression），而不能是“公式”（formula），但可以是“函数”（function）

# （1）n参数
curve(x^2,from = -3,to = 3,n = 5)
curve(x^2,from = -3,to = 3,n = 10)
curve(x^2,from = -3,to = 3,n = 50)
curve(x^2,from = -3,to = 3,n = 101) # 默认值
curve(x^2,from = -3,to = 3,n = 200)
#* 和plot()函数相比，curve()函数不需要提前指定x和y的取值，而plot()函数强制要求提前指定x和y的取值，这是因为curve()函数会提前规定一个x的取值数量（默认值为101），本质上，curve()函数画出的其实也是【折线图】，只不过默认取的x值的数量比较多，看起来像是【平滑】的线条一样

# （2）xname参数
curve(a^2,from = -3,to = 3,xname = "a") # 改变x轴的变量名称
#* 注意此时表达式当中的变量名称也要相应改变

## 九、dotchart()函数
# 点图（dot chart）分为两种，一种用来表示离散值的分布，类似直方图（histogram）的作用，R中通过带状图函数stripchart()来绘制，另一种是此处的Cleveland dot chart/plot，用来展示范畴类变量，可以看作是条形图（bar chart）或者饼图（pie chart）的替代
# 向量（无分组）
v_dot <- c(25, 40, 15, 30) # x轴刻度的来源
names(v_dot) <- c("A", "B", "C", "D") # y轴标签的来源（方法一：为向量元素命名）
dotchart(
    v_dot, # x轴刻度、y轴标签
    main = "简单点图",
)

# 向量（分组）
v_dot2 <- c(25, 40, 15, 30, 35, 20) # x轴刻度的来源
v_label_dot <- c("A", "B", "C", "D", "E", "F") # y轴标签的来源（方法二：用另一个向量表示）
v_group_dot <- factor(c("G1", "G1", "G1", "G2", "G1", "G2")) # y轴分组的来源
v_mean_dot <- tapply(v_dot2,v_group_dot,mean) # 分组代表值的来源（常常取平均数或者中位数,tapply()函数给出一个带元素名称的向量）

dotchart(
    v_dot2, # x轴刻度
    labels = v_label_dot, # y轴标签（可以通过命名数据向量名称替代）
    color = c("blue","darkgreen"), # 点和对应y轴标签的颜色
    groups = v_group_dot, # y轴分组
    gdata = v_mean_dot, # 分组代表值
    gcolor = "red", # y轴分组颜色
    main = "分组点图"
)
#* color参数可以设置任意多的颜色，如果颜色数少于数据数，会循环自身使得颜色数与数据数相同。这种情况虽然不会报错，但是对于可视化效果没有什么意义，除非是为每一个数据设置了一个单独的颜色，更常见的做法见下文

dotchart(
    v_dot2,
    labels = v_label_dot,
    color = c("blue","darkgreen")[as.numeric(v_group_dot)],
    groups = v_group_dot,
    gdata = v_mean_dot,
    gcolor = "red",
    main = "分组点图"
)
#* 为颜色向量加上索引[as.numeric(group_dot)]，索引由因子数值化而来，这样可以保证同一分组内的数据带有相同的颜色

# 矩阵
m_dot <- matrix(c(25, 40, 15, 30, 35, 20), ncol = 2)
rownames(m_dot) <- c("A", "B", "C") # 行名对应y轴标签（之后不再需要设置labels参数）
colnames(m_dot) <- c("组1", "组2") # 列名对应y轴分组（之后不再需要设置groups参数）
m_dot
m_f_dot <- rep(1:nrow(m_dot),ncol(m_dot)) # 为矩阵创设因子水平
m_median_dot <- apply(m_dot,2,median) # 计算分组代表值

dotchart(
    m_dot,
    color = c("blue", "darkgreen")[m_f_dot],
    pch = 19, # 控制数据点的样式
    gdata = m_median_dot,
    gpch = 19, # 控制分组点的样式
    gcolor = "red",
    main = "多系列点图"
)

## 十、fourfoldplot()函数
# 四分图（fourfold display）
# 数据必须是一个2*2的矩阵、数据框，或者包含数个2*2矩阵的数组
# 2*2的矩阵
m_fourfold <- matrix(
    c(12, 5, 7, 15),
    nrow = 2,
    byrow = TRUE,
    dimnames = list(
        Treatment = c("Drug", "Placebo"),
        Outcome = c("Improved", "Not Improved")
    )
)
fourfoldplot(m_fourfold)

# color参数
# 前一个颜色标注数量更少的对角线区域，后一个颜色标注数量更多的对角线区域
fourfoldplot(m_fourfold,color = c("red","blue"))

# conf.level参数
# 控制各变量的置信区间范围，影响置信环（confidence ring）的大小
fourfoldplot(m_fourfold,conf.level = 0)
fourfoldplot(m_fourfold,conf.level = .5)
fourfoldplot(m_fourfold,conf.level = .95) # 默认值

# 2*2*3的数组
ary_fourfold <- array(
    c(12, 5, 7, 15, 8, 2, 20, 10,1,2,3,4),
    dim = c(2, 2, 3),
    dimnames = list(
        Treatment = c("Drug", "Placebo"),
        Outcome   = c("Improved", "Not Improved"),
        Group     = c("Young", "Old","abc")
    )
)
ary_fourfold
fourfoldplot(ary_fourfold)

# 2*2*2的数组
ary_fourfold <- array(
    c(12, 5, 7, 15, 8, 12, 20, 10,1,2,3,4,1,2,3,4,1,2,3,4),
    dim = c(2, 2, 5),
    dimnames = list(
        Treatment = c("Drug", "Placebo"),
        Outcome   = c("Improved", "Not Improved"),
        Group     = c("Young", "Old","abc","abc","abc")
    )
)
ary_fourfold
fourfoldplot(ary_fourfold)

## 十一、hist()函数
# 直方图（histogram）
v_hist <- rnorm(200)
break_hist <- seq(min(v_hist),max(v_hist),length.out = 10)
break_hist
hist(v_hist)
h_hist <- hist(v_hist)
h_hist
h_hist$breaks # hist() 不仅绘图，还会返回一个包含直方图信息的对象（一个列表），包括：breaks（分段边界）、counts（各段频数）、density（各段密度）、mids（各段中点）、xname（变量名）

# （1）breaks参数
# 控制数据的分段数
hist(v_hist,breaks = break_hist) # 用向量表示各个节点，10个节点分成9段
#* 以下两种方法，R会自动调整最终的分段数，以保证图像的美观
hist(v_hist,breaks = 4) # 直接指出分段数（实际有6段）
hist(v_hist,breaks = "Sturges") # 默认值，选用R内置的公式计算分段数，还可以选择"Scott"、"FD"（Freedman–Diaconis rule）等

# （2）freq和probability参数
hist(v_hist,freq = TRUE) # 默认值，y轴表示频数
hist(v_hist,probability = TRUE) # 等效于freq = FALSE，y轴表示密度，面积总和为1

# （3）labels参数
# 控制每一段的标签显示（默认值为FALSE）
hist(v_hist,labels = TRUE)

# （4）right参数和include.lowest参数
hist(c(1,3,5),breaks = c(1,3,5),labels = TRUE,right = TRUE) # 默认值，表示分段区间左开右闭
#* 此时include.lowest参数默认为TRUE，因此位于最左侧节点的0也被包括进来
hist(c(1,3,5),breaks = c(1,3,5),labels = TRUE,right = FALSE) # 表示分段区间左闭右开
#* 此时include.lowest参数的实际含义变为“include.highest”，即位于最右侧节点的5也被包括进来
hist(c(1,3,5),breaks = c(1,3,5),right = TRUE,labels = TRUE,include.lowest = FALSE) # 结果报错
hist(c(1,3,5),breaks = c(1,3,5),right = FALSE,labels = TRUE,include.lowest = FALSE) # 结果报错
#* 通过上面两个例子可以发现，设置include.lowest = FALSE不是为了排除最值，而是为了能够在最值刚好落在左右端点上时提供报错信息，提醒人工处理（有的时候，人们不希望【最值被强行归入区间】这种极端情况出现）

## 十二、image()函数
# heat map（热图）/raster image（栅格图）

# 构造一个网格
x_image <- seq(-pi, pi, length = 50)
y_image <- seq(-pi, pi, length = 50)
m_image <- outer(x_image, y_image, function(x, y) cos(x) + sin(y)) # 数据来源（一个矩阵）

# 绘制
# （1）一般参数
image(
    # x = seq(0,1,length.out =50), # x轴刻度（）
    y = seq(-1000,1000,length.out =51), # y轴刻度（可以省略）
    #* x、y是两个向量，长度分别等于矩阵的行数（或者行数+1）和列数（或者列数+1），当x = 矩阵行数+1时，表示分段边界，当x = 矩阵行数时，表示分段中点，y同理
    z = m_image, # 数值矩阵
    col = topo.colors(50), # col参数中可以使用一系列的颜色生成函数（hcl.colors、hcl.colors、heat.colors、terrain.colors、topo.colors、cm.colors、gray.colors等）
    xlab = "X", ylab = "Y",
    main = "cos(x) + sin(y)"
)

# （2）矩阵内容也可以是逻辑值
m_image3 <- matrix(rep(c(TRUE,FALSE),6),3)
image(m_image3, col = heat.colors(6))

# （3）结果呈现的效果是将原来的矩阵逆时针旋转90度后的排列格局
m_image4_1 <- matrix(c(0,0,1)) # 3*1的矩阵
m_image4_2 <- matrix(c(0,0,1),1) # 1*3的矩阵
m_image4_3 <- matrix(c(0,1,1,0),2) # 2*2的矩阵
image(m_image4_1)
image(m_image4_2)
image(m_image4_3)

# （4）breaks参数
# 控制矩阵当中数据的分段断点（一段对应一种颜色）
m_image2 <- matrix(seq(0, 1, length = 100), nrow = 10)
image(m_image2) # 既不设置颜色数，也不设置断点
image(m_image2, col = heat.colors(5)) # 设置颜色数，但不设置断点
#* 默认情况下，R会让每一个颜色统摄的数据数尽量平衡，更多细节见下一节
breaks_image <- c(-0.5, 0.1, 0.3, 0.6, 0.9, 1.5) # 手动设置断点
image(m_image2, col = heat.colors(5), breaks = breaks_image)
#* breaks参数包含一系列断点，总数应该比颜色数多一个
breaks_image2 <- seq(0.1, 0.9, length = 6) # 均匀设置断点，但只取到0.1和0.9之间
breaks_image2
image(m_image2, col = heat.colors(5), breaks = breaks_image2)
#* 0-0.1和0.9-1的两段区间内的数据不上色

# （5）颜色和数据的对应
m_image5 <- matrix(c(0,1,2,3,4,5))
# 数据和颜色一一对应
image(m_image5,col = c("red","orange","yellow","green","cyan","blue"))
# 数据数少于颜色数
image(m_image5,col = c("red","orange","yellow","green","cyan","blue","purple")) # 绿色没有用到
# 数据数多于颜色数
image(m_image5,col = c("red","orange","yellow","green","cyan")) # 红色用了两次
image(m_image5,col = c("red","orange","yellow","green")) # 红色、绿色各用了两次
image(m_image5,col = c("red","orange","yellow")) # 三种颜色各用了两次
image(m_image5,col = c("red","orange")) # 两种颜色各用了三次
#* 颜色和数据（升序排列）的对应关系是：第一个颜色和第一个数据对应，最后一个颜色和最后一个数据对应，两侧颜色和数据向中间靠拢对应，如果数据数少于颜色数，则多余的颜色不画出，如果数据数多于颜色数，情况比较复杂，但可以发现两个原则：（1）每种颜色的使用次数尽可能接近（由上一节的内容可知，这是由于R默认会使每个颜色统摄的数据数尽量平衡）；（2）优先重复使用两侧的颜色，对称的一对颜色中，优先重复使用左侧的颜色

## 十三、matplot()函数
# 利用一个矩阵（“mat(ries)”）的每一列数据一次性画出（“plot”）所有的函数图像

# 准备一个矩阵
v_mat <- c(seq(0,1,length.out = 10),seq(1,10,length.out = 50))
m_mat <- cbind(
  v_mat, # 正比例函数
  v_mat^2, # 二次函数
  sqrt(v_mat), # 平方根
  1/v_mat, # 反比例函数
  log(v_mat), # 对数函数
  exp(v_mat), # 指数函数
  sin(v_mat), # 正弦函数
  cos(v_mat) # 余弦函数
)
colnames(m_mat) <- c("x","x^2","sqrt(x)","1/x","log(x)","e^x","sin(x)","cos(x)")
# 绘制
matplot(
    v_mat, m_mat,
    type = "o",pch = 20, col = 1:8,
    main = "matplot示例",
    xlab = "X", ylab = "Y",
    xlim =c(0,10),ylim = c(-3,10),
    lty = 1, # 默认值为1:6，循环使用（具体内容参看“三、barplot()函数”一节）
    lend = 3 # 控制线头（line end）样式（0="round"（默认值），1="butt"，2="squre"，3又是"butt"，4又是"square"，以此类推，不能取负值）
)
# 取图形坐标范围
usr_mat <- par("usr") # c(xmin, xmax, ymin, ymax)
# 画x轴箭头
arrows(
    x0 = usr_mat[1], y0 = 0, # 起点
    x1 = usr_mat[2], y1 = 0, # 终点
    length = 0.1, # 箭头顶端线段长度
    angle = 20, # 箭头顶端角度
    code = 2,  # 箭头画在终点（1=起点，2=终点，3=两端）
)
# 画y轴箭头
arrows(
    x0 = 0, y0 = usr_mat[3], # 起点
    x1 = 0, y1 = usr_mat[4], # 终点
    length = 0.1, # 箭头顶端线段长度
    angle = 20, # 箭头顶端角度
    code = 2,  # 箭头画在终点（1=起点，2=终点，3=两端）
)
# 在箭头旁边加文字
text(
    x = usr_mat[2] - 0.3, y = 0.5, # 参照点
    labels = "x", # 文字内容
    adj = 0, # 相对参照点的对齐方式（0=左对齐/底部对齐，0.5=居中对齐，1=右对齐/顶部对齐，实际上可以是任何值，取决于追求的实际效果）
    #* 也可以表示成一个向量(horiz,vert)，分别表示水平和垂直方向上的对齐方式
)
text(
    x = 0.2, y = usr_mat[4] - 0.5, 
    labels = "y", 
    pos = 4, # 相对参照点的位置（1=下，2=左，3=上，4=右）
    offset = .1, # 伸缩距离
    #* pos参数常常搭配offset参数使用,相当于adj参数的作用,使用adj参数后,offset参数的影响可以忽略不计
)
# 在曲线旁边加标签
text(v_mat[58], m_mat[58,1], expression(y == x), pos = 1, offset = 1,cex = 1.5)
text(v_mat[22], m_mat[22,2], expression(y == x^2), pos = 4, cex = 1.5)
text(v_mat[58], m_mat[58,3], expression(y == sqrt(x)), pos = 3, cex = 1.5)
text(v_mat[2], m_mat[2,4], expression(y == frac(1,x)), pos = 4, cex = 1.5)
text(v_mat[55], m_mat[55,5], expression(y == paste("ln(",x,")")), pos = 1, offset = .1,cex = 1.5)
text(v_mat[18], m_mat[18,6], expression(y == e^x), pos = 1,cex = 1.5)
text(v_mat[38], m_mat[38,7], expression(y == sin(x)), pos = 1,cex = 1.5)
text(v_mat[50], m_mat[50,8], expression(y == cos(x)), pos = 1,cex = 1.5)

## 十四、mosaicplot()函数
# 马赛克图（mosaic plot）

# 二维矩阵
m_mosaic <- matrix(c(30, 10, 20, 40), nrow=2, dimnames = list(Gender = c("Male", "Female"), Preference = c("Yes", "No")))
m_mosaic
mosaicplot(m_mosaic)
#* 图像呈现的格局和原矩阵的转置矩阵相同

# （1）shade参数
mosaicplot(m_mosaic,shade = TRUE) # 默认值为FALSE，TRUE等同于c(2,4)，表示以-4, -2, 0, 2, 4作为标准化残差的四个分割点
mosaicplot(m_mosaic,shade = c(1,2,3,4,5)) # 最多可以选择5个整数

# （2）color参数
mosaicplot(m_mosaic,color = TRUE) # 当shade = FALSE时，color = TRUE才能发挥作用，默认使用灰色
mosaicplot(m_mosaic,color = c("red","blue")) # 可以自定义颜色
#* 同一颜色表示同一行

# （3）off参数
# 控制马赛克块之间的距离
mosaicplot(m_mosaic,off = c(5,5))
mosaicplot(m_mosaic,off = 5) # 如果给的数值数少于维度数，会循环扩展至维度数，因此此处效果等同于上一条命令
mosaicplot(m_mosaic,off = c(5,10))

# （4）sort参数
# 控制切割维度的先后顺序（1=行，2=列，3=第三维...）
# 先将所有数据的总和视为一个整体
mosaicplot(m_mosaic,sort = c(1,2)) # 先依据行切割，再依据列切割（默认值）
mosaicplot(m_mosaic,sort = c(2,1)) # 先依据列切割，再依据行切割
#* 要注意sort控制的是切割的对象，所谓的“行”“列”指的是原矩阵的行、列，切割对象的先后不影响矩阵的转置

# （5）dir参数
# 控制【最后呈现效果】中的切割方向（v=垂直切割，h=水平切割）
mosaicplot(m_mosaic,dir = c("v","h")) # 默认值，矩阵转置
mosaicplot(m_mosaic,dir = c("v")) # 如果设置的字符数少于维度数，会交替扩展至维度数，因此此处效果等同于上一条命令
mosaicplot(m_mosaic,dir = c("v","v")) # 矩阵转置
mosaicplot(m_mosaic,dir = c("h","h")) # 矩阵不转置
mosaicplot(m_mosaic,dir = c("h","v")) # 矩阵不转置
mosaicplot(m_mosaic,sort = c(2,1),dir = c("h","v")) # 矩阵不转置
#* 可以发现，为了达到dir参数设置的效果，该参数搭配sort参数可能会阻止矩阵的转置

# 三维数组
m_mosaic2 <- array(c(20,30,40,30,40,10,30,60,10,15,10,5), dim=c(2,2,3), dimnames=list(Gender=c("M","F"), Preference=c("Yes","No"), Age=c("Young","Old","Other")))
m_mosaic2
mosaicplot(m_mosaic2)

mosaicplot(m_mosaic2, shade = TRUE)
mosaicplot(m_mosaic2, color = TRUE)
mosaicplot(m_mosaic2,color = c("red","yellow","blue"))
#* 同一个颜色表示同一个原矩阵的元素
#// 当维数达到三维时,图像呈现的分布原理如下：（1）先将所有第三维度上的矩阵转置；（2）想象第一个转置矩阵的每一个元素的位置都确定了一个新矩形的位置；（3）由于每一个转置矩阵的元素都构成一一对应的关系，因此接下来只需要将剩余的每一个转置矩阵和第一个转置矩阵的对应元素按照从左到右的顺序放置在第一个转置矩阵的每一个元素的右侧即可
#// 不难发现，新矩阵的个数就是原行数*原列数
#* 上述旧注释部分暗含sort = c(1,2,3)的逻辑：以第一个转置矩阵的元素分布格局为基础，等同于先依据行和列分割数据，只是这依然没有明确是先依据行分割还是先依据列分割

# 四维数组
m_mosaic3 <- array(c(20,30,40,30,40,10,30,60,10,15,10,5,1:12), dim=c(2,2,3,2), dimnames=list(Gender=c("M","F"), Preference=c("Yes","No"), Age=c("Young","Old","Other"),A=c("A","B")))
m_mosaic3

mosaicplot(m_mosaic3, shade = TRUE)
mosaicplot(m_mosaic3, color = TRUE)
mosaicplot(m_mosaic3,color = c("red","yellow","blue","green")) # 即使颜色数等于维度数，也只用前两个颜色
#* 此时只用前两个颜色来区分四维的不同序数来源的数据（此处是A和B）
#// 当维数达到四维时，图像呈现的分布原理可以类比三维的情况
#// 将上述三种情况放在一起看，就可以更清楚地看出分布原理：想象先是一维的横向排列的向量，升格到二维矩阵时，在向量的每一个元素【下方】添加新的元素（实际是矩阵相比向量多出的列数据），升格到三维数组时，又在每一个元素【右侧】添加新的元素（实际是三维数组相比矩阵多出的数据），升格到四维数组时，又在每一个元素【下方】添加新的元素（实际是四维数组相比三维数组多出的数据），以此类推，不断在原有数据的【下方】或者【右侧】添加新数据








