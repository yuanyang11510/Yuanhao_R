# 下述例子如果不明确指出，皆改编自ChatGPT

# plot函数asp参数
x1 <- 1:10
y1 <- x1
plot(x1,y1,type = "l",asp = .5) # 比较平缓
plot(x1,y1,type = "l",asp = 1) # 真实比例
plot(x1,y1,type = "l",asp = 2) # 比较陡峭

# plot函数panel.first/last参数
x2 <- 1:10
y2 <- x2^2

# panel.first参数
# 原书解释：“设置【绘制坐标轴】之后，在进行任何【绘图】之前要计算的表达式”
plot(
    x2,y2,type = "l",
    panel.first = grid() # 在画点之前先画网格
)

# panel.last参数
# 原书解释：“【绘制图形】后，在【添加轴、标题和图框】前要计算的表达式”
plot(
    x2,y2,
    panel.last = abline(h = 50, col = "red") # 在主图形之后画一条水平线
)

# 两者结合
plot(
    x2,y2,
    panel.first = grid(), # 先画灰色网格
    # 再画点
    panel.last = abline(lm(y2 ~ x2), col = "blue") # 最后画回归直线
)

# panel.first = 在主图形之前画东西（适合背景元素，比如网格）
# panel.last = 在主图形之后画东西（适合覆盖主图的线、标记等）


