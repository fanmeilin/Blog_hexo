---
title: 数据分析笔记--RFM模型
tags: [数据分析,python]
categories: [学习笔记,数据分析]
date: 2022-01-19 16:24:19
math: true
---

> 本科实训的时候记录的数据分析的笔记，感觉还挺全面的，部署到博客中，今后对数据分析的应用可以方便回顾。

> 本篇主要内容是客户生命周期以及在数据分析中常用的RFM模型，本篇的内容是对数据分析中更抽象的角度出发，对客户进行分析，提取有价值的信息。其他主要是对代码操作介绍比较硬核，相比其他的介绍，本篇既有代码的介绍，还包括一些价值分析中的一些概念。更加实际一些哦~ :no_mouth:

# 1 客户的生命周期 :speech_balloon:

## 1.1 定义

客户生命周期经历诞生，成长，成熟，衰老，死亡的过程。

## 1.2 电信行业为例

生命周期包含着从成为该公司客户并且产生消费开始，经历消费成长，消费稳定，消费下降，最后离网过程；根据客户不同角色分为4个阶段；每个阶段对应不同的数据分析场景和数据挖掘主题；

## 1.3 客户终生价值线

客户在整个客户生命周期带来的总利润曲线

![](https://picture.mulindya.com/image-20210120093416691.png)

第一阶段：潜在客户阶段，并不清楚谁会成为我们的客户，只有通过产品设计或者既有的客户画像，知道潜在客户的大致特征；

第二阶段：响应客户阶段，当前阶段客户已经在递推点完成了申请信用卡的基本信息的填写，当前阶段我们需要对客户价值和信用进行预测，决定信用卡初始额度；若收到信用卡不激活，需执行客户营销策略，决定分配多少 资源进行营销；

第三阶段：既得客户阶段，当前阶段客户已经成功激活信用卡，并且正常使用信用卡消费，只是客户使用产品单一；我们希望他们购买理财产品，分期还款业务等，会涉及交叉，销售精准营销等工作内容；

第四阶段：流失客户阶段，对于高价值客户，尽量避免；在客户流失之前尽量挽回；但是对于低价值客户，价值如果一直无法得到提升，可以被动离开

# 2 RFM模型简介 :droplet:

**R:最近一次消费（Recency）客户上一次的购买时间**

**F:消费频率（Frequency）在限定时间内购买次数，最常购买的用户也是满意度最高的用户 体现忠诚度**

**M:消费金额（Monetary）最近消费的平均金额 体现客户短期价值的重要变量**



![](https://picture.mulindya.com/image-20210119093821088.png)

|   客户类型   |                 消费特征                 |            属性            |                方法                |
| :----------: | :--------------------------------------: | :------------------------: | :--------------------------------: |
| 重要价值客户 |   消费额度高 购物频率高 最近购物时间近   | 重要也是忠诚度较高的大客户 |              细心维护              |
| 重要发展客户 |  消费额度高 购物频率不高 最近购物时间近  |       有巨大发展潜力       |   个性化推荐发放优惠券 增加粘性    |
| 重要挽留客户 |  消费额度高 购物频率不高 最近购物时间远  |   可能已经流失的重要客户   | 了解流失原因，进行预警，针对性改变 |
| 重要保持客户 |   消费额度高 购物频率高 最近购物时间远   |    可能是快要流失的客户    |     沟通了解其体验感变差的原因     |
| 一般价值客户 |  消费额度不高 购物频率高 最近购物时间近  |  感兴趣，活跃，价格敏感型  |       推荐金融产品增加购买力       |
| 一般发展客户 | 消费额度不高 购物频率不高 最近购物时间近 |    新晋用户 试探性体验     | 留意此类客户 进行短信发送优惠信息  |
| 一般保持客户 |  消费额度不高 购物频率高 最近购物时间远  |     快要流失的一般客户     |          一般性低成本营销          |
| 一般挽留客户 | 消费额度不高 购物频率不高 最近购物时间远 |        不是目标客户        |       经费有限时可以直接忽略       |

# 3 RFM模型分析代码 :feet:

## 3.1 R

### 3.1.1 时间转化

```python 
import time
time.mktime(time.strptime('14JUN09:17:58:34','%d%b%y:%H:%M:%S'))
```

**注意点**：将非标准的字符串时间格式转化时间数组(strptime) 再转化为为时间戳(mktime)便于计算

```python 
data['newtime'] = data['time'].map(lambda x:time.mktime(time.strptime(x,'%d%b%y:%H:%M:%S')))
```

**注意点**：使用map指定新列newtime

### 3.1.2 根据id和type分组再显示最近时间

查看每一个购物id的每个类型的最近时间

```python 
R1 = data.groupby(['cumid','type'])[['newtime']].max()
```

转化为透视表指定行列和内容

```python 
R2 = pd.pivot_table(R1,index='cumid',columns='type',values='newtime') 
```

![](https://picture.mulindya.com/image-20210119104539349.png)

### 3.1.3 空值填充

用最久远的购物时间替换缺失值

```python 
R[['Special_offer','returned_goods']] = R[['Special_offer','returned_goods']].apply(lambda x:x.replace(np.nan,min(x)),axis=0)
```

对选取的列进行替换 axis为0 对行应用function

### 3.1.4 查找最近的购物时间

最近的购物时间 购物时间越大 则时间戳越大

```python 
R['rmax'] = R[['Normal','Presented','Special_offer']].apply(lambda x:max(x),axis=1)
```

![](https://picture.mulindya.com/image-20210119111110105.png)

## 3.2 F 购物频次

### 3.2.1 分组统计用户购物的次数

```python 
F1 = data.groupby(['cumid','type'])[['transID']].count()
F = pd.pivot_table(F1,index='cumid',columns='type',values='transID')
```

![](https://picture.mulindya.com/image-20210119111839505.png)

### 3.2.2 处理空值以及退货数据

将空值替换为0值，将退货列处理为负数；

```python 
F[['Special_offer','returned_goods']] = F[['Special_offer','returned_goods']].fillna(0)
F['returned_goods'] = F['returned_goods'].map(lambda x:-x)
F.head()
```

![](https://picture.mulindya.com/image-20210119112103692.png)

### 3.2.3 求出购物总次数

```python 
F['total'] = F.apply(lambda x:sum(x),axis=1)
F.head()
```

![](https://picture.mulindya.com/image-20210119112143811.png)

## 3.3 M 购物金额汇总

### 3.3.1 根据用户，类别分类金额

```python 
M1 = data.groupby(['cumid','type'])[['amount']].sum()
```

### 3.3.2  构建透视图

```python 
M = pd.pivot_table(M1,index='cumid',columns='type',values='amount')
M.head()
```

![](https://picture.mulindya.com/image-20210119114146934.png)

### 3.3.3 缺失值填充

```python 
M[['Special_offer','returned_goods']] = M[['Special_offer','returned_goods']].fillna(0)
```

补充：将其填充为0值

### 3.3.4 总金额汇总

```python 
M['mtotal'] = M.apply(lambda x:sum(x),axis=1)
M.head()
```

![](https://picture.mulindya.com/image-20210119114246668.png)

## 3.4 RFM 模型结果分析

### 3.4.1 数据拼接

```python 
RFM = pd.concat([R['rmax'],F['total'],M['mtotal']],axis=1)
RFM.head()
```

![](https://picture.mulindya.com/image-20210119120421853.png)

### 3.4.2 分箱打分

cut函数：将x数组离散化成bins个分组

```python 
Signature: pd.cut(x, bins, right=True, labels=None, retbins=False, precision=3, include_lowest=False, duplicates='raise')
Docstring:
Bin values into discrete intervals.

Use `cut` when you need to segment and sort data values into bins. This
function is also useful for going from a continuous variable to a
categorical variable. For example, `cut` could convert ages to groups of
age ranges. Supports binning into an equal number of bins, or a
pre-specified array of bins.
```

```python 
RFM['rscore'] = pd.cut(RFM.rmax,3,labels=[1,2,3],precision=2)
RFM['fscore'] = pd.cut(RFM.total,3,labels=[1,2,3],precision=2)
RFM['mscore'] = pd.cut(RFM.mtotal,3,labels=[1,2,3],precision=2)
```

**补充**：***cut与qcut***

```
cut(x,bins,right=True,labels=None,retbins=False,precision=3,include_lowest=False)
```


​    需要将数据值分段并排序到bins中时使用cut。 此函数对于从连续变量转换为离散变量也很有用。 例如，cut可以将年龄转换为年龄范围组。 支持bins到相同数量的箱柜或预先指定的bins阵列。

```
qcut(x, q, labels=None, retbins=False, precision=3, duplicates='raise')
```


​    基于分位数的离散化功能。 根据等级或基于样本分位数将变量分离为相等大小的桶。 例如，10个分位数的1000个值将产生一个分类对象，表示每个数据点的分位数成员资格

### 3.4.3 打标

```python 
def handler_Score(x,y,z):
    if x==3 and y==3 and z==3:
        return '重要价值客户'
    elif x==3 and(y in [1,2]) and z==3:
        return '重要发展客户'
    elif (x in [1,2]) and y==3 and z==3:
        return '重要保持客户'
    elif (x in [1,2]) and (y in [1,2]) and z==3:
        return '重要挽留客户'
    elif x==3 and y==3 and (z in[1,2]):
        return '一般价值客户'
    elif (z in [1,2]) and (y in [1,2]) and x==3:
        return '一般发展客户'
    elif (x in [1,2]) and y==3 and (z in[1,2]):
        return '一般保持客户'
    elif (x in [1,2]) and (y in [1,2]) and (x in [1,2]):
        return '一般挽留客户'
```

应用于3个分数

```python
RFM['label'] = RFM[['rscore','fscore','mscore']].apply(lambda x:handler_Score(x[0],x[1],x[2]),axis=1)
RFM.head()
```

![](https://picture.mulindya.com/image-20210119121121466.png)

