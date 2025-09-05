# 下述例子基本都受ChatGPT的启发，部分代码和注释由ChatGPT提供或者由VS Code内部AI智能补全，不再明确标注
options(width = 128) # 控制VS Code中R终端的显示宽度

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
# 条形图/柱状图（bar plot）用于展示分类数据的频数或比例
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
m_bar <- m_assoc
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
# 箱线图（box plot）用于展示数据的分布情况，显示中位数、四分位数、异常值等信息
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
r_box1 <- rnorm(20, mean = 5)
r_box2 <- rnorm(20, mean = 7)
r_box3 <- rnorm(20, mean = 6)
boxplot(
    r_box1,r_box2,r_box3,
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

## 四、cdplot()函数
# 条件密度图（Conditional Density Plot）
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

## （五）contour()函数
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

## 六、coplot()函数
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

## 七、curve()函数




