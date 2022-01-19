---
title: 数据分析笔记--神经网络
tags: [数据分析,python]
categories: [学习笔记,数据分析]
date: 2022-01-19 18:03:19
math: true
---

> 本科实训的时候记录的数据分析的笔记，感觉还挺全面的，部署到博客中，今后对数据分析的应用可以方便回顾。:no_mouth:

> 本篇主要内容是神经网络，简要介绍概念和反向传播，后面是sklearn ​来​建模​哈​。:sunny:

# 1 神经网络 :hourglass_flowing_sand:

## 1.1 BP神经网络

![](https://picture.mulindya.com/image-20210128233510841.png)



根据真实值，对于偏置和权重进行更新

![](https://picture.mulindya.com/image-20210129000757438.png)

## 1.2 计算

> 神经元4：0.332
>
> 神经元5：0.525
>
> 神经元6：0.474
>
> Err6 = 0.1311 Err4 = -0.0087 Err5 = -0.0065
>
> 学习率为：0.9
>
> 更新： 
>
> 权重更新：
>
> w46 = -0.3 + 0.9\*0.1311\*0.332 = -0.261          w56 = -0.2 + 0.9\*0.1311*0.525 = 0.138
>
> w14 = -0.2 + 0.9\*-0.0087\*1 = 0.192                 w15 = -0.3 + 0.9\*-0.0065* = -0.306
>
> w24 = -0.4 + 0.9\*-0.0087\*0 = -0.4                    w25 = -0.1 + 0.9\*-0.0065\*0 = 0.1
>
> w34 = -0. + 0.9\*-0.0087\*1 = -0.508                  w35 = 0.2 + 0.9\*-0.0065\*1 = 0.194
>
> 偏置项更新：
>
> θ6 = 0.1+0.9*0.1311 = 0.218                              θ5 = 0.2+0.9\*-0.0065 = 0.194
>
> θ4 = -0.4+0.9*-0.0087 = -0.408

# 2 案例分析 :high_brightness:

## 2.1 切分特征值和目标值

```python
feature = data.loc[:,'gender':]
print(feature.head())
label = data['churn']
print(label.head())
```

## 2.2 将数据集进行切分 

```python
from sklearn.model_selection import train_test_split
X_train,X_test,y_train,y_test = train_test_split(feature,label)
```

#神经网络需要对数据进行极差标准化 是一个黑盒模型
#变量是连续变量，分类变量 一般数据处理要求进行极差标准化 分类变量需要转换为虚拟变量
#但是也可以特殊处理 多分类名义变量必须转化为寻变量 等级变量和二分类变量可以不转换当作连续变量处理

## 2.3 利用数据进行训练转换器

应用训练集x数据的固有属性，将其应用于训练集和测试集

```python 
from sklearn.preprocessing import MinMaxScaler
scaler = MinMaxScaler()
scaler.fit(X_train)
#得到数据转化之后的数据
scaler_train_data = scaler.transform(X_train)
scaler_test_data = scaler.transform(X_test)
```

## 2.4 构建感知器模型

```python
#设置一个隐藏层 和10个神经元
from sklearn.neural_network import MLPClassifier
mlp = MLPClassifier(hidden_layer_sizes=(10,),activation='logistic')
mlp.fit(scaler_train_data,y_train)
```

## 2.5 预测模型

```python
y_predict = mlp.predict(scaler_test_data)
```

## 2.6 评估模型

```python 
import sklearn.metrics as metrics
print(metrics.classification_report(y_test,y_predict))
#混淆矩阵
print(metrics.confusion_matrix(y_test,y_predict,labels=[0,1]))
#平均准确率
mlp.score(scaler_test_data,y_test)
```

## 2.7 寻找最优参数

```python 
# 寻找最优参数
from sklearn.model_selection import GridSearchCV
param ={
    'hidden_layer_sizes':[(10,),(20,)],
    'activation':[ 'logistic', 'tanh', 'relu'],
    'alpha':[0.001,0.1,0.01]
}
newmlp = MLPClassifier(max_iter=1000)
#cv=5表示5折交叉验证
gsc = GridSearchCV(estimator=newmlp,param_grid=param,scoring='roc_auc',cv=5)
gsc.fit(scaler_train_data,y_train)
```

