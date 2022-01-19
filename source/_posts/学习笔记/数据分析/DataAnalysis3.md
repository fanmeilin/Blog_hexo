---
title: 数据分析笔记--数据查询和表相关操作
tags: [数据分析,python]
categories: [学习笔记,数据分析]
date: 2022-01-19 15:53:19
math: true
---

> 本科实训的时候记录的数据分析的笔记，感觉还挺全面的，部署到博客中，今后对数据分析的应用可以方便回顾。

> 本篇主要内容是数据查询以及表的各种操作，包括单条件查询，多条件查询，连续查询，不连续查询，还可以使用正则表达式查询。:wink:还有一些表的操作，内连接，外连接，合并，排序，分类汇总。很干货了呀~

# 1 数据查询

*表：*

|      |   name | score | group |
| ---: | -----: | ----: | ----: |
|    0 | zhang1 |    61 |     1 |
|    1 | zhang2 |    85 |     1 |
|    2 | zhang3 |    47 |     1 |
|    3 | zhang4 |    99 |     2 |
|    4 | zhang5 |   100 |     3 |
|    5 | zhang6 |    75 |     1 |

## 1.1 单条件查询

查询分数大于80的同学姓名

```python
df1[df1.score>80].name
```

## 1.2 多条件查询

### 1.2.1 使用位运算

查询分数大于90或者分组为2的列表

```python
df1[(df1.score>90) | (df1.group==2)]
```

查询分数大于60并且分组为1的列表

```python
df1[(df1.score>60) & (df1.group==1)] 
```

**注意点** 在条件筛选时要使用&|~ 进行位运算 

<font color=purple>不可以用and关键字 只能用&符号 &|~;&指的是位运算，Python中的逻辑操作符为 and  or  not，and指的是逻辑运算。所以在选择结构中表示 与 用 and。或用 or。这里要用位运算符。</font>

### 1.2.1 query

```python
df1.query('score>88')
```

```python
Signature: df1.query(expr, inplace=False, **kwargs)
Docstring:
Query the columns of a frame with a boolean expression.
```

**注意点**：条件是用字符串表达；并且直接引用score。

## 1.3 其他查询

### 1.3.1连续查询

使用**between**函数；

```python
df1[df1.score.between(70,85,inclusive=False)] 
```

|      |   name | score | group |
| ---: | -----: | ----: | ----: |
|    5 | zhang6 |    75 |     1 |

```python
Signature: df1.score.between(left, right, inclusive=True)
Docstring:
Return boolean Series equivalent to left <= series <= right
```

between函数默认包含边界

### 1.3.2 不连续查询

使用**isin**函数；

```python
df1[df1.name.isin(['zhang3','zhang5'])]
```

```python
Signature: df1.name.isin(values)
Docstring:
Check whether `values` are contained in Series.
Return a boolean Series showing whether each element in the Series
matches an element in the passed sequence of `values` exactly.
```

**注意点**：values : *set or list-like* 内部的参数必须是一个集合形式；

### 1.3.3 正则表达式

使用正则表达式进行字符串匹配；

```python
df1[df1.name.str.contains('zhang+')] 
```

```python 
Signature: df1.name.str.contains(pat, case=True, flags=0, na=nan, regex=True)
Docstring:
Test if pattern or regex is contained within a string of a Series or Index.

Return boolean Series or Index based on whether a given pattern or regex is
contained within a string of a Series or Index.
```

**注意点**：#转化为str再进行匹配

# 2 数据连接

![](https://picture.mulindya.com/image-20210114103553639.png)

## 2.1 内连接

**取两表中的交集** ，有数据损失；

```python 
Signature: df1.merge(right, how='inner', on=None, left_on=None, right_on=None, left_index=False, right_index=False, sort=False, suffixes=('_x', '_y'), copy=True, indicator=False, validate=None)
Docstring:
Merge DataFrame objects by performing a database-style join operation by
columns or indexes.
```

how: 连接方式；

on:  公共字段

```
df1.merge(df2,how="inner",on='id')

df1.merge(df2,how='inner',left_on='id',right_on='id') 
```

**注意点**： *公共字段在两表中名字不一致时使用*left_on,right_on

## 2.2 外连接

### 2.2.1 左连接

通过公共字段 保留左表信息 右在左缺失数据全部以nan填充；

```
df1.merge(df2,how='left',on='id')
```

|   id | coll_x | coll_y |      |
| ---: | -----: | -----: | ---- |
|    0 |      1 |      a | NaN  |
|    1 |      2 |      b | NaN  |
|    2 |      3 |      c | e    |

```
df2.merge(df1,how='left',on='id')
```

|      |   id | coll_x | coll_y |
| ---: | ---: | -----: | -----: |
|    0 |    4 |      d |    NaN |
|    1 |    3 |      e |      c |

左连接是以左表为主表，所以，数据展示是以左表为主，因此与调用对象有关。

### 2.2.2 右连接

```python
df1.merge(df2,how='right',on='id')
```

|      |   id | coll_x | coll_y |
| ---: | ---: | -----: | -----: |
|    0 |    3 |      c |      e |
|    1 |    4 |    NaN |      d |

### 2.2.3 全连接

```python
df1.merge(df2,how='outer',on='id')
```

|   id | coll_x | coll_y |      |
| ---: | -----: | -----: | ---- |
|    0 |      1 |      a | NaN  |
|    1 |      2 |      b | NaN  |
|    2 |      3 |      c | e    |
|    3 |      4 |    NaN | d    |

## 2.3 行索引连接

### 2.3.1 横向合并

pd的concat函数：

```python 
Signature: pd.concat(objs, axis=0, join='outer', join_axes=None, ignore_index=False, keys=None, levels=None, names=None, verify_integrity=False, sort=None, copy=True)
Docstring:
Concatenate pandas objects along a particular axis with optional set logic
along the other axes.
```

默认axis为0，是对行进行堆叠；**横向合并要改为1**

join()函数；

```python 
Signature: df3.join(other, on=None, how='left', lsuffix='', rsuffix='', sort=False)
Docstring:
Join columns with other DataFrame either on index or on a key
column. Efficiently Join multiple DataFrame objects by index at once by
passing a list.
```

如果是join函数在使用是合并对象的列不可重复

```python
pd.concat([df3,df4],axis=1) 
或者
df3.join(df4)
```

|      |  key | col1 |   id | col2 |
| ---: | ---: | ---: | ---: | ---: |
|    1 |    1 |    a |    1 |   aa |
|    2 |    2 |    b |    3 |   cc |
|    3 |    3 |    c |    2 |   bb |

### 2.3.2 纵向合并

```python
pd.concat([df5,df6],keys=['A','B'])
pd.concat([df5,df6],ignore_index=True)
```

合并完成之后 注意重复数据 删除重复数据 可以使用drop_duplicates()

```python
pd.concat([df5,df6],ignore_index=True).drop_duplicates()
```

## 2.4 排序

sort_values()函数：按值排序

```python
Signature: df1.sort_values(by, axis=0, ascending=True, inplace=False, kind='quicksort', na_position='last')
Docstring:
Sort by the values along either axis
```

```python
df1.sort_values(['group','score'])
```


|      |   name | score | group |
| ---: | -----: | ----: | ----- |
|    0 | zhang1 |  61.0 | 1     |
|    1 | zhang2 |  85.0 | 1     |
|    2 | zhang3 |  90.0 | 1     |
|    5 | zhang6 |   NaN | 1     |
|    3 | zhang4 |  87.0 | 2     |
|    4 | zhang5 | 100.0 | 3     |

# 3 分类汇总

## 3.1 分类

|      | chinese | class | grade | math |  name |
| ---: | ------: | ----: | ----: | ---: | ----: |
|    0 |      88 |     1 |     1 | 98.0 |   Bob |
|    1 |      78 |     1 |     1 | 78.0 | Lindy |
|    2 |      86 |     1 |     1 | 87.0 |  Mark |
|    3 |      56 |     2 |     2 | 77.0 |  Miki |
|    4 |      77 |     1 |     2 | 77.0 | Sully |

### 3.1.1 按照年级和班级 对成绩求均值

```python
data.groupby(['grade','class'])[['math']].mean()
```

|       |  math |           |
| ----: | ----: | --------: |
| grade | class |           |
|     1 |     1 | 87.666667 |
|     2 |     1 | 77.000000 |
|     2 |     2 | 77.000000 |

### 3.1.2 按照年级汇总数学语文 均值

```python
data.groupby(['grade'])[['math','chinese']].mean()
```

| grade |      math |   chinese |
| ----: | --------: | --------: |
|     1 | 87.666667 | 84.000000 |
|     2 | 77.000000 | 62.333333 |

**注意点：**首先对data表进行groupby，然后在返回的对象中选取列，用***列表封装***选取；

## 3.2  汇总

使用agg聚合进行显示均值，最值，中位数，标准差，平均绝对偏差，计数，偏差；

```
data.groupby(['grade'])[['math','chinese']].agg(['mean','max','min','median','std','mad','count','skew'])
```
