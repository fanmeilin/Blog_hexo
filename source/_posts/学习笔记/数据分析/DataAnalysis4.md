---
title: 数据分析笔记--数据清理
tags: [数据分析,python]
categories: [学习笔记,数据分析]
date: 2022-01-19 16:10:19
math: true
---

> 本科实训的时候记录的数据分析的笔记，感觉还挺全面的，部署到博客中，今后对数据分析的应用可以方便回顾。

> 本篇主要内容是数据清洗，包括重复值处理，缺失值处理，噪声值处理。还有pandas中拆分和堆叠的函数，赋值和条件赋值的方法。:wink:

# 1 拆分与堆叠 :telephone_receiver:

|      |   id |   type | money |
| ---: | ---: | -----: | ----: |
|    0 | 1001 | normal |  2000 |
|    1 | 1110 |    spe |   300 |
|    2 | 1002 | normal |  1000 |
|    3 | 1002 |    spe |  3500 |
|    4 | 1003 |    spe |  4500 |
|    5 | 1003 |    spe | 10000 |

## 1.1 拆分

`pivot_table函数：`

```python
Signature: pd.pivot_table(data, values=None, index=None, columns=None, aggfunc='mean', fill_value=None, margins=False, dropna=True, margins_name='All')
Docstring:
Create a spreadsheet-style pivot table as a DataFrame. The levels in
the pivot table will be stored in MultiIndex objects (hierarchical
indexes) on the index and columns of the result DataFrame
```

data：等待拆分的表

index：标识列

columns：取值是新变量的变量名

values：等待拆分的列

**注意点**：默认 汇总函数是均值 如果存在缺失用nan填充 

```python
pd.pivot_table(data,index='id',columns='type',values='money') 
```

| type | normal |    spe |
| ---: | -----: | -----: |
|   id |        |        |
| 1001 | 2000.0 |    NaN |
| 1002 | 1000.0 | 3500.0 |
| 1003 |    NaN | 7250.0 |
| 1110 |    NaN |  300.0 |

## 1.2 堆叠

堆叠是拆分的反操作

使用`pd.melt()`函数：

```python
Signature: pd.melt(frame, id_vars=None, value_vars=None, var_name=None, value_name='value', col_level=None)
Docstring:
"Unpivots" a DataFrame from wide format to long format, optionally
leaving identifier variables set.
```

id_vars：标识变量；

value_vars：表示指定进行堆叠的列；

var_name: 原数据列堆叠后的取名；

value_name：原数据元素队列后取名；

```python
pd.melt(data2,id_vars='id',value_name='money',var_name='Type',value_vars=['normal','spe'])
```

|      |   id |   Type | money |
| ---: | ---: | -----: | ----: |
|    0 | 1001 | normal |  2000 |
|    1 | 1002 | normal |  1000 |
|    2 | 1003 | normal |     0 |
|    3 | 1110 | normal |     0 |

# 2 赋值与条件赋值  :loudspeaker:

## sample案例分析

sample数据：

|      | chinese | class | grade | math |  name |
| ---: | ------: | ----: | ----: | ---: | ----: |
|    0 |      88 |     1 |     1 | 98.0 |   Bob |
|    1 |      78 |     1 |     1 | 78.0 | Lindy |
|    2 |      86 |     1 |     1 | 87.0 |  Mark |
|    3 |      56 |     2 |     2 | 77.0 |  Miki |
|    4 |      77 |     1 |     2 | 77.0 | Sully |
|    5 |      54 |     2 |     2 |  NaN |  Rose |

## 2.1 replace函数

```python
Signature: data.math.replace(to_replace=None, value=None, inplace=False, limit=None, regex=False, method='pad')
Docstring:
Replace values given in `to_replace` with `value`.

Values of the Series are replaced with other values dynamically.
This differs from updating with ``.loc`` or ``.iloc``, which require
you to specify a location to update with some value.
```

替换数学成绩的98为空值

```python
data.math.replace(98,np.nan)
```

替换多个值 使用字典嵌套指定

```python
data.replace({
    'math':{98:np.nan},
    'name':{'Bob':'Jim'}
},inplace=True)
```

|      | chinese | class | grade | math |  name | class_n |
| ---: | ------: | ----: | ----: | ---: | ----: | ------: |
|    0 |      88 |     1 |     1 |  NaN |   Jim |  class1 |
|    1 |      78 |     1 |     1 | 78.0 | Lindy |  class1 |
|    2 |      86 |     1 |     1 | 87.0 |  Mark |  class1 |
|    3 |      56 |     2 |     2 | 77.0 |  Miki |  class2 |
|    4 |      77 |     1 |     2 | 77.0 | Sully |  class1 |
|    5 |      54 |     2 |     2 |  NaN |  Rose |  class2 |

## 2.2 apply函数

```python
Signature: data.apply(func, axis=0, broadcast=None, raw=False, reduce=None, result_type=None, args=(), **kwds)
Docstring:
Apply a function along an axis of the DataFrame.

Objects passed to the function are Series objects whose index is
either the DataFrame's index (``axis=0``) or the DataFrame's columns
(``axis=1``). By default (``result_type=None``), the final return type
is inferred from the return type of the applied function. Otherwise,
it depends on the `result_type` argument.

Series objects ：是传入参数对象
```

会自动传参func，axis=0 是传参整列 axis=1是传参整行 返回series

```python
def func1(p1):
    if(p1['class']==1): 
        return "class1"
    elif p1['class']==2:
        return "class2"
data.apply(func1,axis=1) #自动传参       
```

```
0    class1
1    class1
2    class1
3    class2
4    class1
5    class2
dtype: object
```

可以使用`data.assign函数`进行指定赋值

`assign函数`赋值不在原始数据上操作

```python
data = data.assign(class_n = data.apply(func1,axis=1))  
#Assign new columns to a DataFrame, 
#returning a new object(a copy) with the new columns added to the original ones.
```

## 2.3 使用loc进行条件赋值

```python
data.loc[data.grade==1,'grade_n'] = 'grade1' #在原始数据上修改
data.loc[data.grade==2,'grade_n'] = 'grade2' #直接条件查询进行条件复制
```

# 3 数据清洗 :bulb:

|      |   id |   name | score |
| ---: | ---: | -----: | ----: |
|    0 |    1 | zhang1 |  80.0 |
|    1 |    1 | zhang1 |  80.0 |
|    2 |    1 | zhang2 |  64.0 |
|    3 |    3 | zhang3 |  70.0 |
|    4 |    4 | zhang4 |  89.0 |
|    5 |    5 | zhang5 |   NaN |

## 3.1 重复数处理

```python
data2.duplicated()
```

重复数一般是直接清除重复数，使用duplicated方法可以找到重复的数据项。

```python
data2[data2.duplicated()]
```

|   id | name |  score |      |
| ---: | ---: | -----: | ---- |
|    1 |    1 | zhang1 | 80.0 |

## 3.2 缺失值处理

|         | 连续变量       | 分类变量                       | 补充说明                                                     |
| ------- | -------------- | ------------------------------ | ------------------------------------------------------------ |
| 小于20% | 均值或者中位数 | 不需要填补，单算一类或众数填补 |                                                              |
| 20%-80% | 均值或者中位数 | 不需要填补，单算一类或众数填补 | 填补方式与20%类似，但是每个缺失值变量可以设置一个指示哑变量，参与后续建模 |
| 大于80% |                |                                | 每个有缺失值的变量生成一个指示哑变量，参与后续建模，不再使用原始变量 |

**缺失值为20%-80%时：**

![](https://picture.mulindya.com/image-20210115110534941.png)

### 3.2.1 统计空值所各个列的比例

```python
data.apply(lambda x:sum(x.isnull())/x.size)
```

可以对Series进行sum操作 ；

这里布尔类型就会返回True的个数；

### 3.2.2 填充

fillna（）：

```python
Signature: data.math.fillna(value=None, method=None, axis=None, inplace=False, limit=None, downcast=None, **kwargs)
Docstring:
Fill NA/NaN values using the specified method
```

#### 3.2.2.1 均值填充

```python
data.math.fillna(data.math.mean())
```

```
0    98.0
1    78.0
2    87.0
3    77.0
4    77.0
5    83.4
Name: math, dtype: float64
```

#### 3.2.2.1 中位数填充

```python
data.math.fillna(data.math.median())
```

```python
0    98.0
1    78.0
2    87.0
3    77.0
4    77.0
5    78.0
Name: math, dtype: float64
```

### 3.2.3 缺失值指示变量

```
data.math.isnull().apply(int)
```

.apply(int)对相应的布尔 返回0，1

```
0    0
1    0
2    0
3    0
4    0
5    1
Name: math, dtype: int64
```

## 3.3 噪声值处理

> 这里简要介绍，在最后的实战中可以看到详细的噪声处理的具体函数和方法。

噪声值：数据中有一个和多个与其他数值相差较大的值，异常值，离群值；

### 3.3.1 处理方法

单变量： 盖帽法，分箱法；

多变量：聚类法；

### 3.3.2 盖帽法

将连续型变量均值上下三倍标准差范围外数据替换为均值上下三倍标准差；

# 数据清洗实战 :clipboard:

# 处理脏数据 

## 1. 0值处理

```
<class 'pandas.core.frame.DataFrame'>
RangeIndex: 9686 entries, 0 to 9685
Data columns (total 14 columns):
ID              9686 non-null int64
Suc_flag        9686 non-null int64
ARPU            4843 non-null float64
PromCnt12       9686 non-null int64
PromCnt36       9686 non-null int64
PromCntMsg12    9686 non-null int64
PromCntMsg36    9686 non-null int64
Class           9686 non-null int64
Age             7279 non-null float64
Gender          9686 non-null object
HomeOwner       9686 non-null object
AvgARPU         9686 non-null float64
AvgHomeValue    9686 non-null int64
AvgIncome       9686 non-null int64
dtypes: float64(3), int64(9), object(2)
memory usage: 1.0+ MB
```

![image-20210118114510765](C:\Users\86137\AppData\Roaming\Typora\typora-user-images\image-20210118114510765.png)

在AvgHomeValue，AvgIncome中的0值替换为缺失值

```python 
data['AvgHomeValue'] = data['AvgHomeValue'].replace({0:np.NaN})
data['AvgIncome'] = data['AvgIncome'].replace({0:np.NaN})
```

## 2. 标记重复数据

```python 
data['dup'] = data.duplicated() 
data_dup = data[data['dup']==True]
print(data_dup)
data_undup = data[data['dup']==False]
```

## 3. 缺失值填充

```python 
mean = data['Age'].mean(skipna=True)
data['newage'] = data['Age'].fillna(mean)
mean = data['AvgIncome'].mean(skipna=True)
data['newAvgIncome_flag'] = data['AvgIncome'].isnull()
data['newAvgIncome'] = data['AvgIncome'].fillna(mean)
```

## 4. 噪声处理

### 4.1 计算出百分位数

**填充之后的数据进行噪声处理**

```python 
q1 = data['newage'].quantile(0.01)
q99 = data['newage'].quantile(0.99)
```

### 4.2 盖帽法处理噪声

```python 
def func(floor,qmax): 
    def f(x):
        if x<floor:
            x = floor
        elif x>qmax:
            x = qmax
        return x
    return f
```

 处理噪声

```python
func1 = func(q1,q99)
data['newage'] = data['newage'].map(func1) 
```

*使用map函数处理噪声，将百分之1以下的数据替换为q1,将百分之99以上的数据替换为q99；*

```
count    9686.000000
mean       49.624685
std         5.835803
min        31.000000
25%        47.000000
50%        49.567386
75%        54.000000
max        60.000000
Name: newage, dtype: float64
```

### 4.3 分箱法处理噪声

```python 
# 噪声处理 分箱法
data['newage_qcut'] = pd.qcut(data['newage'],4)
```

|      |    newage |    newage_qcut |
| ---: | --------: | -------------: |
|    0 | 57.000000 |   (54.0, 60.0] |
|    1 | 55.000000 |   (54.0, 60.0] |
|    2 | 57.000000 |   (54.0, 60.0] |
|    3 | 52.000000 | (49.567, 54.0] |
|    4 | 49.567386 | (47.0, 49.567] |

