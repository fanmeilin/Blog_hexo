---
title: 数据分析笔记--索引操作
tags: [数据分析,python]
categories: [学习笔记,数据分析]
date: 2022-01-19 14:20:19
math: true
---

> 本科实训的时候记录的数据分析的笔记，感觉还挺全面的，部署到博客中，今后对pandas的应用可以方便回顾。
> 本篇主要内容数据分析的索引操作，对Series以及DataFrame的索引操作。:wink:

# 1 索引操作 :calendar:


```python
#索引操作
ser1 = pd.Series(range(10,15),index = list('ABCDE'))
ser2 = pd.Series(range(10,15),index = range(1,6))
# ser2[1:3] #隐式取值 不包含结束位
# ser2[1] #字母情况可以使用下标隐式 数字时默认显示取值
# ser1['A':'C'] #索引取值包含结束位
```


```python
# #不连续时
# ser1[['B','E']]
# #布尔索引
# ser1
# ser1[ser1>12]
```


```python
newdict = {
    'A':11,
    'B':['java','python','go','C++'],
    'C':'addasf'
}
df1 = pd.DataFrame(newdict,index = list('abcd'))
df2 = pd.DataFrame(np.random.rand(4,5),columns=list('ABCDE'),index=list('abcd'))
```

</style>

<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>A</th>
      <th>B</th>
      <th>C</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>a</th>
      <td>11</td>
      <td>java</td>
      <td>addasf</td>
    </tr>
    <tr>
      <th>b</th>
      <td>11</td>
      <td>python</td>
      <td>addasf</td>
    </tr>
    <tr>
      <th>c</th>
      <td>11</td>
      <td>go</td>
      <td>addasf</td>
    </tr>
    <tr>
      <th>d</th>
      <td>11</td>
      <td>C++</td>
      <td>addasf</td>
    </tr>
  </tbody>
</table>
</div>

</style>

<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>A</th>
      <th>B</th>
      <th>C</th>
      <th>D</th>
      <th>E</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>a</th>
      <td>0.093207</td>
      <td>0.557518</td>
      <td>0.333789</td>
      <td>0.695109</td>
      <td>0.206757</td>
    </tr>
    <tr>
      <th>b</th>
      <td>0.412221</td>
      <td>0.318664</td>
      <td>0.335479</td>
      <td>0.279908</td>
      <td>0.185551</td>
    </tr>
    <tr>
      <th>c</th>
      <td>0.609854</td>
      <td>0.506528</td>
      <td>0.934166</td>
      <td>0.709873</td>
      <td>0.914060</td>
    </tr>
    <tr>
      <th>d</th>
      <td>0.728796</td>
      <td>0.538920</td>
      <td>0.153949</td>
      <td>0.497407</td>
      <td>0.894722</td>
    </tr>
  </tbody>
</table>
</div>


```python
#默认不支持连续索引取多列 使用高级索引
#默认不支持索引取不连续多行
#df1['a':'b'] #可以实现但是不推荐
```

# 2 高级索引 :scroll:

## 2.1 loc 标签索引

### 2.1.1 对Series操作


```python
#取连续多行
print(ser1.loc['A':'D'])
#取连续多行
print(ser1.loc[['A','C','E']])
```

```python
#dataframe 取单行
df1.loc['a'] #返回series 与df1.loc['a',:]效果一样
```

###  2.1.2 对dataframe操作

####   2.1.2.1索引取值操作


```python
#data 取单列
df1.loc[:,'A'] #返回series
```


```python
df1.loc['b','B'] #单值
```


```python
#取连续多列
print(df1.loc['a':'c']) #包含结束位 可以省略后面的，：
#取连续多列
print(df1.loc[:,'B':'C']) #包含结束位 逗号分割前为行后为列
```

```python
print(df1.loc[['a','d']])
print(df1.loc[:,['A','C']])
print(df1.loc[['a','d'],['A','C']])
```


####  2.1.2.2布尔索引


```python
df2['a':'c']<0.5
```

</style>

<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>A</th>
      <th>B</th>
      <th>C</th>
      <th>D</th>
      <th>E</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>a</th>
      <td>True</td>
      <td>False</td>
      <td>True</td>
      <td>False</td>
      <td>True</td>
    </tr>
    <tr>
      <th>b</th>
      <td>True</td>
      <td>True</td>
      <td>True</td>
      <td>True</td>
      <td>True</td>
    </tr>
    <tr>
      <th>c</th>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
    </tr>
  </tbody>
</table>
</div>


```python
df2[df2['a':'c']<0.5]
```

</style>

<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>A</th>
      <th>B</th>
      <th>C</th>
      <th>D</th>
      <th>E</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>a</th>
      <td>0.093207</td>
      <td>NaN</td>
      <td>0.333789</td>
      <td>NaN</td>
      <td>0.206757</td>
    </tr>
    <tr>
      <th>b</th>
      <td>0.412221</td>
      <td>0.318664</td>
      <td>0.335479</td>
      <td>0.279908</td>
      <td>0.185551</td>
    </tr>
    <tr>
      <th>c</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>d</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>


## 2.2 iloc位置索引


```python
df2.iloc[1:3,2:4] #不包含结束位
```

</style>

<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>C</th>
      <th>D</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>b</th>
      <td>0.335479</td>
      <td>0.279908</td>
    </tr>
    <tr>
      <th>c</th>
      <td>0.934166</td>
      <td>0.709873</td>
    </tr>
  </tbody>
</table>
</div>

## 2.3 ix 混合索引 基本上不使用 


```python
df2.ix[df2.A<0.5,:'C']
```

</style>

<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>A</th>
      <th>B</th>
      <th>C</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>a</th>
      <td>0.093207</td>
      <td>0.557518</td>
      <td>0.333789</td>
    </tr>
    <tr>
      <th>b</th>
      <td>0.412221</td>
      <td>0.318664</td>
      <td>0.335479</td>
    </tr>
  </tbody>
</table>
</div>

# 3 删除操作 :dart:


```python
#删除指定行数据
print(df1)
df1.drop('a',inplace=True) #axis=0 默认指定行标 inplace指定是否在原始数据上操作
print(df1)
```

```python
#删除指定列数据
print(df1)
temp = df1.drop('B',axis=1) #axis=1 指定列
print(df1)
print(temp)
```

# 4 数据分析实例 :house:

## 4.1 数据基本信息处理

### 4.1.1读取数据

```python
data = pd.read_csv('./data/sndHsPr.csv')
```

![](https://picture.mulindya.com/image-20210112130635768.png)

### 4.1.2 计算总价 加入当前数据

```python
#计算总价 并且将总价加入到当前数据
temp = data.loc[:,['AREA','price']].apply(lambda x:x[0]*x[1],axis=1) 
#将function应用到行或者列
data['sumprice'] = temp
```

**loc选取指定列，使用apply()函数对选取的列及进行处理； axis为0则选取列 ，为1则选取行 ，默认axis为0。**

![](https://picture.mulindya.com/image-20210112131321319.png)

### 4.1.3 将dict转化为中文插入表中

```python
newdict = {'chaoyang':'朝阳','dongcheng':'东城','fengtai':'丰台','haidian':'海淀','shijingshan':'石景山','xicheng':'西城'}
data['newdist'] = data.loc[:,'dist'].map(newdict)
```

使用loc进行选取对应列然后进行map操作，将字典的键转化为对应值，返回series对象

## 4.2 简单绘图展示

```python
data.dist.value_counts().plot(kind='barh')
data.dist.value_counts().plot(kind='pie')
```

value_counts函数可以进行统计不同值的个数

```python
from pylab import mpl
mpl.rcParams['font.sans-serif'] = ['SimHei']
data.newdist.value_counts().plot(kind='pie')
```

**中文显示问题** 修改属性参数'font.sans-serif'为['SimHei']

