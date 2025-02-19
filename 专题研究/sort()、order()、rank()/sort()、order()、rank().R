# 构造一个向量，括号中是对应的下标，方便理解，下文称为【原向量】
a <- c("3(1)","7(2)","4(3)","2(4)","4(5)")
a

# sort函数
a_sort <- sort(a)
a
a_sort
# sort函数最好理解，将【原向量】中的元素按照从小到大的顺序排序，得到的新向量下文称为【sort向量】
# 因此【原向量】中的元素是什么类别，【sort向量】中的元素也是什么类别

# order函数
a_order <- order(a)
a
a_sort
a_order
# order函数输出每个【sort向量】中的元素在【原向量】中的下标，得到的新向量下文称为【order向量】
# 因此不管【原向量】中的元素是什么类别，【order向量】中的元素总是数值
## order函数的结果经常和原向量结合用于原向量的排序

a_order_mechanism <- vector()
for(i in 1:length(a_sort)) {
    a_order_mechanism = append(a_order_mechanism,which(a == a_sort[i]))
}
a_order_mechanism
a_order
# 上述命令模拟了order函数的工作原理

# rank函数
a_rank <- rank(a)
a_rank
a_sort2 <- c("2(1)","3(2)","4(3)","4(4)","7(5)") # 重新标注【sort向量】的元素的下标
a_sort2
a

# rank函数输出每个【原向量】中的元素按照从小到大排列时的【位次】（比如3,7,4,2,4当中，3排第2位，7排第5位）
# 因此不管【原向量】中的元素是什么类别，【rank向量】中的元素总是数值
# 在一部分情况下，rank函数输出的就是每个【原向量】中的元素在【sort向量】中的下标

a_rank_mechanism <- vector()
for(i in 1:length(a)) {
    a_rank_mechanism = append(a_rank_mechanism,which(a_sort == a[i]))
}
a_rank_mechanism
a_rank
# 上述命令模拟了rank函数在一部分情况下的工作原理

#* 但是如果原向量中出现多个相同的值，rank函数默认会在这些相同值的【位次】之间取平均值，并且使这些相同值的【位次】都等于这个值
rank(c(1,2,1,4)) # 两个1在【sort向量】中的下标分别为1和2，rank函数默认取平均值1.5
rank(c(1,2,1,4,1)) # 两个1在【sort向量】中的下标分别为1、2和3，rank函数默认取平均值2
#rfr 可以通过设置ties参数来改变rank函数对于相同值的【位次】的处理，可以参考：https://d.cosx.org/d/6822-6822/3，其默认值为"a"（average）

#todo 在不存在相同值的情况下，或者ties设置为"f"（first）的情况下，对原向量使用奇数次order函数得到的结果都是【order向量】，对原向量使用偶数次order函数得到的结果都是【rank向量】，其中反映出某种数学规律，待研究
order(c(3,7,4,2,4)) # 【order向量】
order(order(c(3,7,4,2,4))) # 【rank】向量
rank(c(3,7,4,2,4),ties="f")
order(order(order(c(3,7,4,2,4)))) # 【order向量】
order(order(order(order(c(3,7,4,2,4))))) # 【rank】向量

rank(c(3,7,4,2,4)) # 不设置ties = "f"的话，【rank】向量就不一定会等于对原向量使用偶数次order函数得到的结果

