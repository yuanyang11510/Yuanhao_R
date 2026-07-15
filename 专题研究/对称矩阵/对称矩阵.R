# 以下生成对称矩阵的各种做法获得了ChatGPT的帮助。
library(tidyverse)

# 构造一个数据框，以该数据框为基础生成对称矩阵，矩阵内容为每一对字母对应数值的差的绝对值。
#* 最后生成的对称矩阵中的数据对应此处数据框中的B列，行名和列名对称，对应此处数据框中的A列。
tbl <- tibble(
    A = c("c","a","b"),
    B = c(1,3,2)
)

# （一）生成对称矩阵
# 方法一：使用outer()函数
outer(
    tbl$B,tbl$B,
    FUN = function(x,y) {
        absolute = abs(x-y)
        return(absolute)
    }
) %>% 
    `colnames<-`(tbl$A) %>% 
    as_tibble() %>% 
    mutate(ID = colnames(.),.before = everything()) # 巧妙利用rownames和colnames的对称性添加ID列

# outer()函数的X参数和Y参数一般输入的是简单的向量，但是也可以输入列表，这个时候要注意FUN参数的函数需要保证对这些列表参数实现向量化操作。
tbl_list <- tibble(
    A = 1:2,
    B = list(c("a","b"),c("c","d"))
)

outer(
    tbl_list$B,tbl_list$B,
    FUN = function (x,y) {
        # 用map2()函数对列表参数实现向量化操作
        map2(
            x,y,
            function (x,y) {
                append(x,y) %>% 
                unlist() %>% 
                str_c(collapse = ",")
            }
        )
    }
)

# 方法二：使用cross_join()函数搭配pivot_wider()函数
#* 我们将这种方法下通过cross_join()函数生成的笛卡尔积数据框中除去数据之外的内容相同的两列为rownames列和colnames列，对应最后生成的对称矩阵的行名和列名，方便后续讨论。
cross_join(tbl,tbl) %>% 
    mutate(absolute = abs(B.x-B.y),.keep = "unused") %>% 
    pivot_wider(
        names_from = A.y,
        values_from = absolute
    ) %>% 
    rename(ID = A.x)

# 方法三：ChatGPT提到可以使用combn()函数避免对称性导致的重复（比如"a-c"和"c-a"），但这会导致无法选出对应对角线位置的数据（比如"a-a"），因此需要另外补充这部分数据，但这比较麻烦，因此这种方法不推荐。
# 以下命令不包含对称矩阵对角线位置的数据
bind_cols(
    combn(tbl$A,2) %>% t(),
    combn(tbl$B,2) %>% t(),
    .name_repair = ~c("Rownames","Colnames","RowData","ColData")
) %>% 
    mutate(absolute = abs(RowData-ColData),.keep = "unused") %>% 
    pivot_wider(
        names_from = Colnames,
        values_from = absolute
    )

# （二）保留对角线及上/下三角
# 方法一：矩阵或者数据框搭配lower.tri()/upper.tri()函数
#* 这种做法要求使用lower.tri()/upper.tri()函数时，矩阵或者数据框是只包含数据的方块矩阵（方阵）。
outer(
    tbl$B,tbl$B,
    FUN = function(x,y) {
        absolute = abs(x-y)
        return(absolute)
    }
) %>% 
    replace(upper.tri(.), NA) %>% # 保留对角线及下三角
    `colnames<-`(tbl$A) %>% 
    as_tibble() %>% 
    mutate(ID = colnames(.),.before = everything())

cross_join(tbl,tbl) %>% 
    mutate(absolute = abs(B.x-B.y),.keep = "unused") %>% 
    pivot_wider(
        names_from = A.y,
        values_from = absolute
    ) %>% 
    rename(ID = A.x) %>%
    #* 做法一
    # column_to_rownames("ID") %>% # 会把tibble转换为data.frame，因为tibble不接受rownames列
    # replace(upper.tri(.), NA) %>% # 保留对角线及下三角
    # rownames_to_column("ID") %>% # 使用rownames_to_column()函数将rownames列还原回来
    # as_tibble() # 将data.frame转换回tibble
    #* 做法二
    select(-ID) %>% # 暂时删去rownames列，使数据框成为方块矩阵
    replace(upper.tri(.), NA) %>% # 保留对角线及下三角
    mutate(ID = colnames(.),.before = everything()) # 将rownames列添加回来

# 方法二：如果使用cross_join()函数搭配pivot_wider()函数，在生成笛卡尔积后筛选出可以构成上/下三角位置的数据
#* 这种做法要求rownames列/colnames列中的数据按照单向的顺序排列，默认的两种顺序是数值顺序"3 > 2 > 1"和字典顺序"a < b < c"，但是实践中的数据往往不是按照这种默认顺序先后排列的，因此最稳妥的做法是提前定义顺序，方法是通过设置factor()函数的参数ordered = TRUE，让rownames列和colnames列成为有序因子。
# 如果不提前定义顺序，以下命令的结果无法达到目的
cross_join(tbl,tbl) %>% 
    filter(A.x <= A.y) %>% # 不提前定义顺序就筛选数据
    mutate(absolute = abs(B.x-B.y),.keep = "unused") %>% 
    pivot_wider(
        names_from = A.y,
        values_from = absolute
    ) %>% 
    rename(ID = A.x)

# 以下命令可以达到目的
cross_join(tbl,tbl) %>% 
    mutate(
        across(c(A.x,A.y),
        ~factor(.,levels = unique(A.x),ordered = TRUE)) # 提前定义顺序，注意此处不是按照默认的词典顺序排序，而是让数据按照在rownames列/colnames列中实际出现的顺序排序，默认顺序是从小到大，因此可以将其视同数值"1 < 2 < 3 < ..."
    ) %>% 
    filter(A.x >= A.y) %>% # 提前定义从小到大的顺序后筛选数据，"rownames列数据 >= colnames列数据"可以筛选出构成对角线及下三角位置的数据
    mutate(absolute = abs(B.x-B.y),.keep = "unused") %>% 
    pivot_wider(
        names_from = A.y,
        values_from = absolute
    ) %>% 
    rename(ID = A.x)

# 方法三：ChatGPT提供了一种方法，本质上和方法二相同，只是避免了提前为rownames列/colnames列数据定义顺序，而是直接根据这些数据对应的行号进行筛选，是一种比较巧妙的方法。
cross_join(
    tbl %>% rownames_to_column("RowNum"),
    tbl %>% rownames_to_column("RowNum")
) %>% 
    filter(RowNum.x >= RowNum.y) %>% # 直接根据rownames列/colnames列数据对应的行号进行筛选
    select(-c(RowNum.x,RowNum.y)) %>% # 删除行号列
    mutate(absolute = abs(B.x-B.y),.keep = "unused") %>% 
    pivot_wider(
        names_from = A.y,
        values_from = absolute
    ) %>% 
    rename(ID = A.x)

# （三）dist()函数
# dist()函数专门用来生成距离矩阵，输入的数据是一个只包含数值的矩阵或者数据框，每行代表一个测量对象，每列代表一个维度，最后得到的距离矩阵默认保留下三角，不保留对角线。
tbl_dist <- tibble(
    ID = letters[1:6],
    X = c(1,3,2,5,4,6),
    Y = c(2,4,3,6,5,7)
) %>% 
    column_to_rownames("ID") # 将ID列转换为rownames列，使数据框成为只包含数值的矩阵，这会使tibble转换为data.frame，但是这样可以使rownames列中的数据被dist()函数保留到距离矩阵的rownames和colnames中
tbl_dist
dist(tbl_dist) # 默认距离公式为欧几里得距离
dist(tbl_dist,diag = TRUE) # 保留对角线
dist(tbl_dist,upper = TRUE) # 保留上三角，下三角仍然保留
dist(tbl_dist,method = "manhattan") # 曼哈顿距离

