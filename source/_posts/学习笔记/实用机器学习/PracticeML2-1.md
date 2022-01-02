---
title: PracticeML第二章房价实例笔记
date: 2022-01-02 15:45:41
tags: [李沐,机器学习]
categories: [学习笔记，机器学习]
---

> 斯坦福2021秋季的实用机器学习上线啦~ :wink: 跟着沐神复习机器学习冲冲冲！ 记录一下笔记和重点，不一定很全哦~，只是记录自我感觉的重点。

> 本篇笔记主要是实例分析，还有一些小知识点
>
> 1. 字符串前加f，r，b，u
> 2. | & 和 or and

# 房价数据分析实例

使用`numpy，pandas，matplotlib，seaborn`来处理和可视化。

## 实例（波士顿房价）

### 读取

```python
# !pip install seaborn pandas matplotlib numpy
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

#绘图画质更好
from IPython import display
display.set_matplotlib_formats('svg')
# Alternative to set svg for newer versions
# import matplotlib_inline
# matplotlib_inline.backend_inline.set_matplotlib_formats('svg')
```

```python
data = pd.read_csv('house_sales.zip') #可以直接用csv格式读取zip文件
#对于文本会快很多
```

### 数据清理

We drop columns that at least 30% values are null to simplify our EDA.

```python
#缺失数据
null_sum = data.isnull().sum() #缺失数据个数 为空的个数 是一个键值对
data.columns[null_sum < len(data) * 0.3]  # columns will keep #键值对 返回值满足条件的键
```

> ```
> Index(['Id', 'Address', 'Sold Price', 'Sold On', 'Summary', 'Type',
>        'Year built', 'Heating', 'Cooling', 'Parking', 'Bedrooms', 'Bathrooms',
>        'Total interior livable area', 'Total spaces', 'Garage spaces',
>        'Home type', 'Region', 'Elementary School', 'Elementary School Score',
>        'Elementary School Distance', 'High School', 'High School Score',
>        'High School Distance', 'Heating features', 'Parking features',
>        'Lot size', 'Parcel number', 'Tax assessed value', 'Annual tax amount',
>        'Listed On', 'Listed Price', 'Zip'],
>       dtype='object')
> ```

```python
data.drop(columns=data.columns[null_sum > len(data) * 0.3], inplace=True) #inplace直接修改
```

#### 核对数据类型

```python
data.dtypes #核对数据类型
```

> ```
> Id                               int64
> Address                         object
> Sold Price                      object
> Sold On                         object
> Summary                         object
> Type                            object
> Year built                      object
> Heating                         object
> Cooling                         object
> Parking                         object
> Bedrooms                        object
> Bathrooms                      float64
> Total interior livable area     object
> Total spaces                   float64
> Garage spaces                  float64
> Home type                       object
> Region                          object
> Elementary School               object
> Elementary School Score        float64
> Elementary School Distance     float64
> High School                     object
> High School Score              float64
> High School Distance           float64
> Heating features                object
> Parking features                object
> Lot size                        object
> Parcel number                   object
> Tax assessed value              object
> Annual tax amount               object
> Listed On                       object
> Listed Price                    object
> Zip                              int64
> dtype: object
> ```

#### 修改数据类型

金额为object这是不合常理的

Convert currency from string format such as `$1,000,000` to float.

```python
currency = ['Sold Price', 'Listed Price', 'Tax assessed value', 'Annual tax amount']
# r'[$,-]' r的作用是：去除转义字符，replace可以用正则形式
for c in currency:
    data[c] = data[c].replace(
        r'[$,-]', '', regex=True).replace( 
        r'^\s*$', np.nan, regex=True).astype(float)
```

Convert currency from string format such as `$1,000,000` to float.

```python
areas = ['Total interior livable area', 'Lot size']
for c in areas:
    acres = data[c].str.contains('Acres') == True
    col = data[c].replace(r'\b sqft\b|\b Acres\b|\b,\b','', regex=True).astype(float)
    col[acres] *= 43560
    data[c] = col
```

> tips :wink:
>
> 字符串前加f，r，b，u
>
> 加f作用：相当于 format() 函数f“{变量名}”
>
> 加r的作用是：去除转义字符； 场景：想复制某个文件夹的目录。
>
> 加b的作用是：后面字符串是bytes 类型bytes；应用场景：像图片、音视频等文件的读写就是用bytes数据。
>
> 加u的作用：后面字符串以 Unicode 格式 进行编码；实际场景：一般用在中文字符串前面，防止因为源码储存格式问题，导致再次使用时出现乱码。

```python
#Now we can check values of the numerical columns. You could see the min and max values for several columns do not make sense.
data.describe()
```

可以查看一些不太正常的字段。。。

#### 数据清理数值

We filter out houses whose living areas are too small or too hard to simplify the visualization later.

> | & 和 or and
>
> DataFrame中切片需要求得满足多个逻辑条件的数据时，要使用& 和|，在某些条件下用and/ or会报错
>
> 一般情况下：
>
> - **如果a，b是数值变量**， 则&， |表示[位运算](https://so.csdn.net/so/search?q=位运算)， and，or则依据是否非0来决定输出
>
> - **如何a, b是逻辑变量**， 则两类的用法基本一致

```python
abnormal = (data[areas[1]] < 10) | (data[areas[1]] > 1e4) #不正常的数据
data = data[~abnormal] #使用~来求反
sum(abnormal)
```

#### 查看价格类别图像

Let's check the histogram of the `'Sold Price'`, which is the target we want to predict.

```python
ax = sns.histplot(np.log10(data['Sold Price'])) #直方图绘制 取log10 这样分布更加均匀
ax.set_xlim([3, 8])
ax.set_xticks(range(3, 9))
ax.set_xticklabels(['%.0e'%a for a in 10**ax.get_xticks()]);
#前面的可能有租房噪音
```

![](https://picture.mulindya.com/pML2-1.png)

A house has different types. Here are the top types:

```python
data['Type'].value_counts()[0:20] #value_counts对应值的个数
```

> ```
> SingleFamily            74318
> Condo                   18749
> MultiFamily              6586
> VacantLand               6199
> Townhouse                5846
> Unknown                  5390
> MobileManufactured       2588
> Apartment                1416
> Cooperative               161
> Residential Lot            75
> Single Family              69
> Single Family Lot          56
> Acreage                    48
> 2 Story                    39
> 3 Story                    25
> Hi-Rise (9+), Luxury       21
> RESIDENTIAL                19
> Condominium                19
> Duplex                     19
> Mid-Rise (4-8)             17
> Name: Type, dtype: int64
> 下面的一些均为噪音
> ```

Price density for different house types.

```python
types = data['Type'].isin(['SingleFamily', 'Condo', 'MultiFamily', 'Townhouse'])
sns.displot(pd.DataFrame({'Sold Price':np.log10(data[types]['Sold Price']),
                          'Type':data[types]['Type']}),
            x='Sold Price', hue='Type', kind='kde'); #kde是密度分布，hue指定线颜色按照Type分类
```

![](https://picture.mulindya.com/pML2-2.png)

Another important measurement is the sale price per living sqft. Let's check the differences between different house types.

`boxplot`中间横线表示均值，箱型图上四分和下四分，还有max和min值；适合用于表示分布的对比

```python
data['Price per living sqft'] = data['Sold Price'] / data['Total interior livable area'] #每平米价格
ax = sns.boxplot(x='Type', y='Price per living sqft', data=data[types], fliersize=0)
ax.set_ylim([0, 2000]);
```

![](https://picture.mulindya.com/pML2-3.png)


We know the location affect the price. Let's check the price for the top 20 zip codes.
```python
d = data[data['Zip'].isin(data['Zip'].value_counts()[:20].keys())]
ax = sns.boxplot(x='Zip', y='Price per living sqft', data=d, fliersize=0)
ax.set_ylim([0, 2000])
ax.set_xticklabels(ax.get_xticklabels(), rotation=90);
```

![](https://picture.mulindya.com/pML2-4.png)

### 查看协方差

Last, we visualize the correlation matrix of several columns.

`挑选某些列分布计算计算协方差使用corr()`可以查看关联度

```python
_, ax = plt.subplots(figsize=(4,4))
columns = ['Sold Price', 'Listed Price', 'Annual tax amount', 'Price per living sqft']
sns.heatmap(data[columns].corr(),annot=True,cmap='RdYlGn', ax=ax);
#使用热力图绘制
```

![](https://picture.mulindya.com/pML2-5.png)

## Summary

This notebook demonstrates the basic technologies for EDA, including

- Understanding column data types, values, and distributions
- Understanding the interactions between columns



We only explored a small aspect of the data. You are welcome to dive deep into more details.
