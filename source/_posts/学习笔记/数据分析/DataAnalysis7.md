---
title: 数据分析笔记--逻辑回归
tags: [数据分析,python,逻辑回归]
categories: [学习笔记,数据分析]
date: 2022-01-19 17:12:19
math: true
---

> 本科实训的时候记录的数据分析的笔记，感觉还挺全面的，部署到博客中，今后对数据分析的应用可以方便回顾。:no_mouth:

> 本篇主要内容是逻辑回归，虽然名字称作回归，但是这个是针对分类的算法哦！标记星号:star:

# 1 分类算法--逻辑回归

因变量常为二分类变量，他的自变量既可以是分类变量又可以是连续变量，逻辑回归也可以做多分类哈！也就是使用逻辑回归看这个变量是否被选中，然后再投票就好啦，或者使用softmax也是可以哒。

> 这里有两种方法使得逻辑回归能进行多分类任务：
>
> 一、将多分类任务拆解成多个二分类任务，利用逻辑回归分类器进行投票求解；
>
> 二、对传统的逻辑回归模型进行改造，使之变为 softmax 回归模型进行多分类任务求解

## 1.1 特点

能够将输入的特征数据来转化为0，1这两类的概率

## 1.2 本质

通过特征值和目标值的**线性方程**，计算出结果后，通过`sigmoid`映射函数，将连续型数值转换到0-1区间内，一般情况下，LR算法用于二分类问题；

## 1.3 映射函数

![](https://picture.mulindya.com/image-20210125104950928.png)

# 2 案例分析

分类变量相关分析 ：列联表分析和卡方检验，连续自变量和二分类因变量的独立性可以用双样本t检验；

## 2.1 预处理操作和分析

**卡方检验（二分类变量关系）**

![](https://picture.mulindya.com/image-20210125094325832.png)

### 2.1.1 删除空值的行

```python 
data = data.dropna(axis=0,how='any')
```

```python 
Signature: data.dropna(axis=0, how='any', thresh=None, subset=None, inplace=False)
Docstring:
Remove missing values.

See the :ref:`User Guide <missing_data>` for more on which values are
considered missing, and how to work with missing data.
how : {'any', 'all'}, default 'any'
    Determine if row or column is removed from DataFrame, when we have
    at least one NA or all NA.

    * 'any' : If any NA values are present, drop that row or column.
    * 'all' : If all values are NA, drop that row or column.
```

### 2.1.2 分析相关关系

曾经破产与是否违约是否存在相关关系

```python 
pd.crosstab(data.bankruptcy_ind,data.bad_ind,margins=True)
```

| bankruptcy_ind\ bad_ind |    0 |    1 |  All |
| ----------------------: | ---: | ---: | ---: |
|                       N | 3076 |  719 | 3795 |
|                       Y |  243 |   67 |  310 |
|                     All | 3319 |  786 | 4105 |

### 2.1.3 列联表

列联表（contingency table）是观测数据按两个或者更多变量分类时列出的观测表；

```python 
def func1(x):
    '当前函数是实现两个变量的列联表'
    #print(x)
    return x/float(x[-1])
```

```python  
cross_tab.apply(func1,axis=1)
```

### 2.1.4卡方检验

卡方检验就是统计样本的实际观测值与理论推断值之间的偏离程度;
实际观测值与理论推断值之间的偏离程度就决定卡方值的大小;
如果卡方值越大，二者偏差程度越大；反之，二者偏差越小；若两个值完全相等时;
卡方值就为0，表明理论值完全符合。注意：卡方检验针对分类变量。

```python 
#两个变量卡方检验
stats.chi2_contingency(cross_tab.iloc[:2,:2])
```

```
(1.1500371741720943,
 0.28354136789919926,
 1,
 array([[3068.35688185,  726.64311815],
        [ 250.64311815,   59.35688185]]))
```

p值为0.28 说明破产是否违约没有显著相关

## 2.2 回归分析

### 2.2.1 数据集切割

在训练模型之前， 需要对数据进行拆分 ，暂时将数据分为训练集和测试集；

训练集用来进行模型的训练 7 8（占比最大，过小会欠拟合）
测试集用来评估模型的优劣 3 2

```python 
#选取80%的数据作为训练集数据 使用简单随机抽样
train_data = data.sample(frac=0.8,random_state=2021) #数据按比例切分
#测试样本
test_data = data[~data.index.isin(train_data.index)]
```

### 2.2.2 模型训练

**在进行模型训练的过程中 与线性回归类似 但是指定使用广义线性回归 并且指定使用logit变换对数据进行处理 **

```python 
model = sfa.glm('bad_ind~fico_score',data = train_data,family=sa.families.Binomial(sa.families.links.logit)).fit()
```

![](https://picture.mulindya.com/image-20210125112627183.png)

即为 -0.0147*fico_score+8.5519

### 2.2.3 向前法参数选择

```python
#向前法
def forward_select(data,label): #data:数据 response:目标值
    #todo 获取当前数据当前不重复变量
    params = set(data.columns)
    
    #将需要保留的变量进行存储
    selected = []
    
    #将目标值移除当前变量列表
    params.remove(label)
    current_score = float('inf')
    best_new_score = float('inf')
    
    #进行筛选
    while params:
        aic_param = []
        for param in params:
            #前y 后x,并且多变量用加号连接,+[],相当于在数组中添加元素
            formula = "{}~{}".format(label,'+'.join(selected+[param]))
            print('-------------->formula',formula)
            
            #建立模型 拿到aic
            aic = sfa.glm(formula,data = data,family=sa.families.Binomial(sa.families.links.logit)).fit().aic
            aic_param.append((aic,param)) #元组装包
        #得到分数最小的AIC
        aic_param.sort(reverse=True)
        best_new_score,best_param = aic_param.pop()#列表的最末位
        
        #与当前得分比较
        if current_score>best_new_score:
            params.remove(best_param)
            selected.append(best_param)
            current_score = best_new_score
            print('------------*************>当前current_score',current_score)
        else:
            print("over")
            break
    print("#################################################")
    print("获取到符合条件的变量进行展示")
    print(selected)
        
    #拼接真正的formula
    fin_formula = '{}~{}'.format(label,'+'.join(selected))
    # 进行线性模型的训练
    model = sfa.glm(fin_formula,data = data,family=sa.families.Binomial(sa.families.links.logit)).fit()
    return model
```

```python 
lavels_list = ['bad_ind','fico_score','bankruptcy_ind','age_oldest_tr','ltv','tot_income','veh_mileage','used_ind']
data_select = train_data[lavels_list]
forward_select(data=data_select,label='bad_ind')
```

```python 
#################################################
获取到符合条件的变量进行展示
['fico_score', 'ltv', 'age_oldest_tr', 'bankruptcy_ind']
```



