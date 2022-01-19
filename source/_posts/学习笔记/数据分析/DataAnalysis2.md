---
title: 数据分析笔记--数据分析
tags: [数据分析,python,绘图]
categories: [学习笔记,数据分析]
date: 2022-01-19 15:41:19
math: true
---

> 本科实训的时候记录的数据分析的笔记，感觉还挺全面的，部署到博客中，今后对数据分析的应用可以方便回顾。

> 本篇主要内容是数据分析，包括单纯的描述性分析和报表分析，这里主要讲解了单连续变量描述统计量的描述性分析以及报表分析。可以参考本篇的图表绘制方法哦！ :space_invader:
# 1 描述性分析 :tophat:

1. 单分类变量描述频数，例如：value_counts()描述分类变量 柱形图
2.  单连续变量描述统计量（均值，中位数，四分位数，总和等），例如：聚合函数agg（）描述价格变量 直方图
3. 分类变量与分类变量描述频数，例如：交叉表crosstab()描述各地区与是否学区房 交叉表——堆叠柱状图
4. 单分类变量与单连续变量描述连续变量统计值，例如，分组groupby()描述各地区的房价分布
5.  双分类变量与连续变量描述连续变量统计值，透视表pivot_table()描述各地区房价与地域，学区房的关系

## 1.1 单变量描述 

这里主要讲解单连续变量描述统计量。

###  基本的数据描述

- 平均值  

  ```python
  data.loc[:,'price'].mean()
  or
  data.price.mean()
  ```

- 中位数

  ```python
  data.price.median()
  ```

- 标准差

  ```python
  data.price.std()
  ```

- 方差

  ```	python
  data.price.var()
  ```

- 使用聚合函数

  ```python
  data.price.agg(['mean','median','std','var'])
  ```

##  1.2 绘制图分析

​	绘制直方图

```python
data.price.hist(bins=20) 
```

![](https://picture.mulindya.com/image-20210113100910142.png)

```python
data.price.skew() #大于0为右偏 小于0是左偏
#0.6794935869486859
```

###  1.2.1 偏度（Skewness）

Definition:是描述数据分布形态的统计量，其描述的是某总体取值分布的**对称性**，简单来说就是数据的不对称程度。。

偏度是三阶中心距计算出来的。
（1）Skewness = 0 ，分布形态与正态分布偏度相同。
（2）Skewness > 0 ，正偏差数值较大，为正偏或右偏。长尾巴拖在右边，数据右端有较多的极端值。
（3）Skewness < 0 ，负偏差数值较大，为负偏或左偏。长尾巴拖在左边，数据左端有较多的极端值。
（4）数值的绝对值越大，表明数据分布越不对称，偏斜程度大。
计算公式：
$$
Skewness=E[((x-E(x))/(\sqrt{D(x)}))^3]
$$

$$
| Skewness|越大，分布形态偏移程度越大。
$$

![](https://picture.mulindya.com/image-20210113101410092.png)

### 1.2.2 峰度（Kurtosis）

Definition:偏度是描述某变量所有取值分布形态陡缓程度的统计量，简单来说就是数据分布顶的**尖锐程度**。
峰度是四阶标准矩计算出来的。
（1）Kurtosis=0 与正态分布的陡缓程度相同。
（2）Kurtosis>0 比正态分布的高峰更加陡峭——尖顶峰
（3）Kurtosis<0 比正态分布的高峰来得平台——平顶峰
计算公式：
$$
Kurtosis=E[ ( (x-E(x))/ (\sqrt(D(x))) )^4 ]-3
$$

### 1.2.3 分位数

  其中0.25 和0.75 为四分位数，0.5是均值

```python
data.price.quantile([0.25,0.5,0.75]) 
```

**注意点**：四分位 忽略NA值

# 2  报表分析 :crown:

报表展示数据主要信息 ；分为维度指标（分类指标） 和度量指标 （连续变量）；仅包含维度指标的报表为频次表（单个分类变量）和交叉表（两个和两个以上分类变量）。包含维度和度量两类指标的报表称之为汇总表 度量指标总是以某个统计量的形式出现，最常见的是均值，总和，频次。

## 2.1 表分析

### 2.1.1交叉表

分析两个分类变量的联合分布情况 提供每个单元格频次,百分比和边沿分布。

```python
subway_school = pd.crosstab(data.subway,data.school)
```

| subway\school |    0 |    1 |
| ------------: | ---: | ---: |
|             0 | 2378 |  413 |
|             1 | 8919 | 4500 |

**绘图：**

```python
subway_school.plot(kind='bar')
```

横轴默认为subway（行）

![](https://picture.mulindya.com/image-20210113123315967.png)

进一步分析：

```python
subway_school.sum(1)是axis为1的条件下的和（对列相加）
```

```
subway
0     2791
1    13419
dtype: int64
```

***div函数***： sum的axis为1，在使用div函数时div函数中的axis应该取0，也就是对应的行中的数据占此行总数的比例


```python
Signature: subway_school.div(other, axis='columns', level=None, fill_value=None)
Docstring:
Floating division of dataframe and other, element-wise (binary operator `truediv`).

Equivalent to ``dataframe / other``, but with support to substitute a fill_value for
missing data in one of the inputs.
```

实例代码：

```python
subway_school_per = subway_school.div(subway_school.sum(1),axis=0) #百分比
subway_school_per.plot(kind='bar',stacked=True)
```

![](https://picture.mulindya.com/image-20210113124417643.png)

### 2.1.2 分类汇总

#### 2.1.2.1 使用groupby分析

**注意点：**groupbby分析返回的是对象

- 通过dist对price分组 在分组中求均值

  ```python
  data.price.groupby(data.dist).mean()
  ```

  ```
  dist
  chaoyang       52800.624651
  dongcheng      71883.595041
  fengtai        42500.904309
  haidian        68757.602261
  shijingshan    40286.889574
  xicheng        85674.778545
  Name: price, dtype: float64
  ```

- 绘图

  ```python
  data.price.groupby(data.dist).mean().plot(kind='bar')
  ```

  ![](https://picture.mulindya.com/image-20210113110942085.png)

- 排序

  ```python
  data.price.groupby(data.dist).mean().sort_values(ascending=False)
  ```

  sort_values:是对数值进行排序，ascending默认是True，也就是按升序排序；

- 排序后绘图

  

  ```python
  data.price.groupby(data.dist).mean().sort_values(ascending=False).plot(kind='bar')
  ```

![](https://picture.mulindya.com/image-20210113110957663.png)

- 归并函数结果

  ```python
  data.price.groupby(data.dist).agg(['mean','max','min','std']) 
  ```

  |        dist |         mean |    max |   min |          std |
  | ----------: | -----------: | -----: | ----: | -----------: |
  |    chaoyang | 52800.624651 | 124800 | 23011 | 13305.691821 |
  |   dongcheng | 71883.595041 | 149254 | 20089 | 18368.096658 |
  |     fengtai | 42500.904309 |  87838 | 18348 |  8888.588815 |
  |     haidian | 68757.602261 | 135105 | 25568 | 17128.956039 |
  | shijingshan | 40286.889574 | 100000 | 18854 | 10389.217354 |
  |     xicheng | 85674.778545 | 149871 | 21918 | 19964.458991 |



#### 2.1.2.2 箱型图

![](https://picture.mulindya.com/image-20210113105256801.png)

IQR： 内分位距，为上四分位数-下四分位数

上边缘是上1.5倍IQR，等于上四分位+1.5*IQR

下边缘是下1.5倍IQR，等于下四分位-1.5*IQR

*凡是超过上边缘，越过下边缘为异常值，不一定是错误值*

**代码实现：**

```python
import seaborn as sns
sns.boxplot(x='dist',y='price',data=data) #箱形图 变量分布和异常值信息
```

![](https://picture.mulindya.com/image-20210113110145360.png)

### 2.1.3 汇总表

#### 2.1.3.1 透视表

```python
data.pivot_table(values='price',index='dist',columns='school',aggfunc=np.mean)
```

使用index和columns指定行列，values是统计的对象，aggfunc是聚合函数--使用的是numpy的mean函数，也就是展现的是price的平均值；

| dist\ school |            0 |            1 |
| -----------: | -----------: | -----------: |
|     chaoyang | 51588.511689 | 57403.405360 |
|    dongcheng | 66276.887931 | 78514.900392 |
|      fengtai | 42291.003505 | 48871.617021 |
|      haidian | 61385.803653 | 76911.258297 |
|  shijingshan | 40353.883878 | 33107.333333 |
|      xicheng | 76989.369511 | 92468.873623 |

##### 2.1.3.1.1**绘制直方图**

```python
data.pivot_table(values='price',index='dist',columns='school',aggfunc=np.mean).plot(kind='bar')
```

![](https://picture.mulindya.com/image-20210113112824144.png)

##### 2.1.3.1.2**绘制散点图**

分析两个连续变量 分析area是否影响price

```python
data.plot.scatter(x='AREA',y='price')
#分析两个连续变量 分析area是否影响price
```

![](https://picture.mulindya.com/image-20210113121653569.png)

##### 2.1.3.1.3**绘制双轴图**

```python
fig = plt.figure() #画布
ax1 = fig.add_subplot(111) #1行1列 的第一个
ax1.plot(x,gdp_list,'g-')
ax1.set_xlim(2000,2018)
ax2 = ax1.twinx()
ax2.plot(x,gdpcr,'b-')
```

![](https://picture.mulindya.com/image-20210113121558625.png)

## 2.2  合并操作

### 2.2.1 merge操作

```python
pd.merge(df3,df4)
pd.merge(df3,df4,on='key')
```

![](https://picture.mulindya.com/image-20210113124935656.png)

### 2.2.2 concat操作

```python
pd.concat([df3,df4]) #进行堆叠
pd.concat([df3,df4],axis=1)
```

![](https://picture.mulindya.com/image-20210113124828815.png)



![](https://picture.mulindya.com/image-20210113124919494.png)