---
title: 数据分析笔记--线性回归
tags: [数据分析,python,线性回归]
categories: [学习笔记,数据分析]
date: 2022-01-19 16:41:19
math: true
---

> 本科实训的时候记录的数据分析的笔记，感觉还挺全面的，部署到博客中，今后对数据分析的应用可以方便回顾。:no_mouth:

> 本篇主要内容是线性回归，灰常重点，也很基础的内容，概念不难理解，主要可以关注多元线性回归中的变量筛选。还有实例代码和操作流程！标记星号:star:

# 线性回归 :snowman:

# 1 简单线性模型 :page_with_curl:

## 1.1 简单线性回归

表达形式：

![](https://picture.mulindya.com/image-20210120114327110.png)

只有一个自变量和一个因变量 评估自变量在解释因变量变异或者表现时的显著性；在给定自变量的情况下预测因变量，扰动项又可以称之为随机误差，服从均值为0的正态分布；

## 1.2 线性回归拟合线

![](https://picture.mulindya.com/image-20210120115645575.png)

简单线性回归原理就是拟合一条直线，使得实际值与预测值的差值平方和最小，当这个距离最小时，这条直线就是最好的回归拟合线

实际值和预测值的差值就是残差

线性回归的宗旨：使得残差平方最小化；

# 2 多元线性回归 :card_index:

![](https://picture.mulindya.com/image-20210121113429295.png)

在多元线性回归中，x1和x2都有明显的线性相关关系并且x1和x2无线性相关关系；

```python 
model2 = ols('avg_exp~Age+Income+dist_home_val+dist_avg_income',data=exp).fit()
```

|                   |                  |                     |          |
| ----------------: | ---------------: | ------------------- | -------- |
|    Dep. Variable: |          avg_exp | R-squared:          | 0.542    |
|            Model: |              OLS | Adj. R-squared:     | 0.513    |
|           Method: |    Least Squares | F-statistic:        | 19.20    |
|             Date: | Thu, 21 Jan 2021 | Prob (F-statistic): | 1.82e-10 |
|             Time: |         11:45:07 | Log-Likelihood:     | -498.59  |
| No. Observations: |               70 | AIC:                | 1007.    |
|     Df Residuals: |               65 | BIC:                | 1018.    |
|         Df Model: |                4 |                     |          |
|  Covariance Type: |        nonrobust |                     |          |

**注**：R-squared:用于评价模型解释力度 但是收到自变量个数和观测个数的影响；Prob (F-statistic):接近于0 说明当前回归模型是有意义的

# 3 多元线性回归变量筛选 :bar_chart:

向前法 向后法 逐步法
这三种方法 赤池信息准则

## 3.1 方法：向前法 向后法 逐步法

这三种方法进入或者提出变量一个准则是AIC （赤池信息准则）也就是最小信息准则；AIC指标（赤池信息准则）是常用的利用趋势估计预测模型的指标之一；

## 3.2 AIC

在一般的情况下，AIC可以表示为： $AIC=2k-2ln(L)$

其中：k是参数的数量，L是似然函数。

假设条件是模型的**误差服从独立正态分布。**

让n为观察数，SSR(SUM SQAURE OF RESIDUE)为**残差平方和**，那么AIC变为： $AIC=2k+nln(SSR/n)$；

增加自由参数的数目提高了拟合的优良性，AIC鼓励数据拟合的优良性但是尽量避免出现过度拟合(Overfitting)的情况。**所以优先考虑的模型应是AIC值最小的那一个。**假设在n个模型中做出选择，可一次算出n个模型的AIC值，并找出最小AIC值相对应的模型作为选择对象。

即：AIC越小说明模型效果越好，越简洁；类似的准则还有BIC ,P值；

> BIC 和AIC
>
> 1、简介
>
> BIC= Bayesian Information Criterions，贝叶斯信息准则。
>
> 2、表达式
>
> BIC=ln(n)k-2ln(L)
>
> - L是似然函数
> - n是样本大小
> - K是参数数量
>
> 3、总结
>
> 1、共性
>
> 构造这些统计量所遵循的统计思想是一致的，就是在考虑拟合残差的同事，依自变量个数施加“惩罚”。
>
> 2、不同点
>
> - BIC的惩罚项比AIC大，考虑了样本个数，样本数量多，可以防止模型精度过高造成的模型复杂度过高。
> - AIC和BIC前半部分是一样的，BIC考虑了样本数量，样本数量过多时，可有效防止模型精度过高造成的模型复杂度过高。

### 3.2.1 向前回归法

1. 先将第一个变量代入回归方程，并且进行F检验和t检验，计算残差平方和，记为s1，如果通过检验，保留当前的变量；
2. 然后引入第二个变量，重新构建一个新的估计方差，并且进行F检验和t检验，计算残差平方和，记为s2；

### 3.2.2 向后回归法

   自变量全部放入模型，进行F检验和t检验；

### 3.2.3 逐步回归法

  自变量全部放入模型，进行F检验和t检验；

## 3.3 使用向前回归法筛选代码

将待筛选的自变量选出最好的组合：首先从一个变量选取最小的aic，然后再添加变量进行组合，在选取最小的aic直到aic大于当前选择参数所得的aic；

```python 
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
            aic = ols(formula=formula,data=data).fit().aic
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
    model = ols(formula=fin_formula,data=data).fit()
    return model
```

formula前y后x,并且多变量用加号连接,数组+[],相当于在数组中添加元素；

aic_param.pop()列表的最末位弹出，因此是降序排序；

```
-------------->formula avg_exp~dist_avg_income
-------------->formula avg_exp~Age
-------------->formula avg_exp~Income
-------------->formula avg_exp~dist_home_val
------------*************>当前current_score 1007.6801413968115
-------------->formula avg_exp~dist_avg_income+Age
-------------->formula avg_exp~dist_avg_income+Income
-------------->formula avg_exp~dist_avg_income+dist_home_val
------------*************>当前current_score 1005.4969816306302
-------------->formula avg_exp~dist_avg_income+Income+Age
-------------->formula avg_exp~dist_avg_income+Income+dist_home_val
------------*************>当前current_score 1005.2487355956046
-------------->formula avg_exp~dist_avg_income+Income+dist_home_val+Age
over
#################################################
获取到符合条件的变量进行展示
['dist_avg_income', 'Income', 'dist_home_val']
```

# 线性回归实例 :ledger:

对`creditcard_exp`客户价值分析，使用线性回归拟合模型来进行预测。:memo:

# 1数据处理

## 1.1 读取数据（空格处理）

```python
data  = pd.read_csv('./data/creditcard_exp.csv',skipinitialspace=True) 
```

```python
skipinitialspace : boolean, default False
    Skip spaces after delimiter.
```

**注**：使用skipinitialspace=True将空格设置为空值；

## 1.2 选取数据用来建模

取出非空数据 并且取出2到后面列

```python 
exp = data[data['avg_exp'].notnull()].iloc[:,2:].drop('age2',axis=1) 
```

**注**：notnull可以选取非空数据，返回的是bool变量；iloc选择行列；drop可以删除指定行列；

## 1.3 线性相关性分析

corr函数： 使用pandas中的corr函数可以分析相关系数

```python 
Signature: exp.corr(method='pearson', min_periods=1)
Docstring:
Compute pairwise correlation of columns, excluding NA/null values

Parameters
----------
method : {'pearson', 'kendall', 'spearman'}
    * pearson : standard correlation coefficient
    * kendall : Kendall Tau correlation coefficient
    * spearman : Spearman rank correlation
min_periods : int, optional
    Minimum number of observations required per pair of columns
    to have a valid result. Currently only available for pearson
    and spearman correlation

Returns
-------
y : DataFrame
```

```python 
exp[['Income','avg_exp','Age','dist_home_val']].corr(method='pearson')
```

|        Income |  avg_exp |      Age | dist_home_val |          |
| ------------: | -------: | -------: | ------------: | -------- |
|        Income | 1.000000 | 0.674011 |      0.369129 | 0.249153 |
|       avg_exp | 0.674011 | 1.000000 |      0.258478 | 0.319499 |
|           Age | 0.369129 | 0.258478 |      1.000000 | 0.109323 |
| dist_home_val | 0.249153 | 0.319499 |      0.109323 | 1.000000 |

**注**：经过线性相关性分析 可以得到Income和avg_exp有较大相关性

> 相关性系数（pearson、spearman、kendall，pointbiserialr）
>
> 用途：
>
> 检查两个变量之间变化趋势的方向以及程度，值范围-1到+1，0表示两个变量不相关，正值表示正相关，负值表示负相关，值越大相关性越强。
>
> - 计算积距pearson相关系数，连续性变量才可采用;
>
> - 计算Spearman秩相关系数，适合于定序变量或不满足正态分布假设的等间隔数据; 
>
> - 计算Kendall秩相关系数，适合于定序变量或不满足正态分布假设的等间隔数据。
>   

# 2 模型拟合

## 2.1 构建最小二乘法的线性模型

```
from statsmodels.formula.api import ols
model1 = ols('avg_exp~Income',data=exp).fit()
```

![](https://picture.mulindya.com/image-20210121113456600.png)

## 2.2 构建预测值和残差的表

```python
pd.DataFrame([model1.predict(exp),model1.resid],index=['预测值','残差']).T
```

|      |      预测值 |        残差 |
| ---: | ----------: | ----------: |
|    0 | 1825.141904 | -608.111904 |
|    1 | 1806.803136 | -555.303136 |
|    3 | 1379.274813 | -522.704813 |
|    4 | 1568.506658 | -246.676658 |
|    5 | 1238.281793 | -422.251793 |
|    6 | 1402.035798 | -250.885798 |
|    7 | 1413.088901 | -179.318901 |
|    8 | 1168.156652 | -365.636652 |
|    9 | 1849.935644 |  317.834356 |
|   10 | 1060.684535 | -406.104535 |

## 2.3 进行预测

```
model1.predict(new_exp)
```

```
2     1078.969552
11     756.465245
13     736.919530
19     687.077955
20     666.554953
21     658.736667
24     648.963809
28     633.327237
```

