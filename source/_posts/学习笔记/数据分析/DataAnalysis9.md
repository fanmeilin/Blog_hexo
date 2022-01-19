---
title: 数据分析笔记--KNN
tags: [数据分析,python]
categories: [学习笔记,数据分析]
date: 2022-01-19 17:45:19
math: true
---

> 本科实训的时候记录的数据分析的笔记，感觉还挺全面的，部署到博客中，今后对数据分析的应用可以方便回顾。:no_mouth:

> 本篇主要内容是KNN，是一个分类算法；注意点是距离的选取方式。这里的案例分析值得学习一下，可以学习sklearn的相关用法。:sunny:

# 1 KNN :santa:

## 1.1 k近邻

最近邻域法：属于惰性算法

特点：不必事先创建全局的判别公式或者规则

## 1.2 k近邻的算法

1. 为了判别未知数据的类别，以所有已知的类别实例作为参考
2. 重要步骤:计算未知实例与所有已知实例的距离
3. 选择参考的实例参数k
4. 根据少数服从多数的原则，让未知的实例归类于k个最近邻样本中最多数的类别（投票法则）

## 1.3 距离的算法选择

### 1.3.1 欧氏距离

欧几里得度量（euclidean metric）（也称欧氏距离）是一个通常采用的距离定义，指在m维空间中两个点之间的真实距离，或者向量的自然长度（即该点到原点的距离）。在二维和三维空间中的欧氏距离就是两点之间的实际距离。
$$
\rho = \sqrt{(x_2-x_1)^2+(y_2-y_1)^2}
$$

### 1.3.2 闵可夫斯基距离：

闵氏距离有时也指[时空间隔](https://baike.baidu.com/item/时空间隔/894418)

②设n维空间中有两点坐标x, y，p为常数，闵式距离定义为 [1] 

{% raw %}
$$
D(x,y) = (\sum_{u=1}^n|x_u - y_u|^p)^{\frac{1}{p}}
$$
{% endraw %}

注意：

（1）闵氏距离与特征参数的量纲有关，有不同量纲的特征参数的闵氏距离常常是无意义的。

（2）闵氏距离没有考虑特征参数间的相关性，而马哈拉诺比斯距离解决了这个问题。

### 1.3.3 曼哈顿距离

两点在南北方向上的距离加上在东西方向上的距离，即$d(i,j)=|x_i-x_j|+|y_i-y_j|$​。

### 1.3.4 对比说明

欧式距离使用得最多 **连续占比较大时使用欧式距离** 分类变量

**连续占比较小时使用曼哈顿距离**  虚拟变量

## 1.4 交叉验证

在使用训练集对参数进行训练的时候，经常会发现人们通常会将一整个训练集分为三个部分（比如mnist手写训练集）。一般分为：训练集（train_set），评估集（valid_set），测试集（test_set）这三个部分。这其实是为了保证训练效果而特意设置的。其中测试集很好理解，其实就是完全不参与训练的数据，仅仅用来观测测试效果的数据。而训练集和评估集则牵涉到下面的知识了。

因为在实际的训练中，训练的结果对于训练集的拟合程度通常还是挺好的（初始条件敏感），但是对于训练集之外的数据的拟合程度通常就不那么令人满意了。因此我们通常并不会把所有的数据集都拿来训练，而是分出一部分来（这一部分不参加训练）对训练集生成的参数进行测试，相对客观的判断这些参数对训练集之外的数据的符合程度。这种思想就称为交叉验证（Cross Validation）。

***K-fold Cross Validation***

另外一种折中的办法叫做K折交叉验证，和LOOCV的不同在于，我们每次的测试集将不再只包含一个数据，而是多个，具体数目将根据K的选取决定。比如，如果K=5，那么我们利用五折交叉验证的步骤就是：

1.将所有数据集分成5份

2.不重复地每次取其中一份做测试集，用其他四份做训练集训练模型，之后计算该模型在测试集上的![[公式]](https://www.zhihu.com/equation?tex=MSE_i)

3.将5次的![[公式]](https://www.zhihu.com/equation?tex=MSE_i)取平均得到最后的MSE

{% raw %}
$$
CV_{(k)} = \frac{1}{k} \sum_{i=1}^k MSE_i
$$
{% endraw %}

## 1.5 ROC AUC 

### 1.5.1 ROC曲线

![](https://picture.mulindya.com/image-20210127114408570.png)

受试者工作特征曲线

ROC曲线的横坐标是假阳性率（FPR）纵坐标是真阳性率（TPR）

假阳性率：在实际为0 被错误判定为1比例

真阳性率：在实际为1 被正确判定为1比例

![](https://picture.mulindya.com/image-20210127114531940.png)

![](https://picture.mulindya.com/image-20210127114733950.png)

### 1.5.2 AUC

AUC（Area Under Curve）被定义为[ROC曲线](https://baike.baidu.com/item/ROC曲线/775606)下与[坐标轴](https://baike.baidu.com/item/坐标轴/9763108)围成的[面积](https://baike.baidu.com/item/面积/100551)，显然这个面积的数值不会大于1。又由于[ROC曲线](https://baike.baidu.com/item/ROC曲线/775606)一般都处于y=x这条直线的上方，所以AUC的取值范围在0.5和1之间。AUC越接近1.0，检测方法真实性越高;等于0.5时，则真实性最低，无应用价值。

**从AUC 判断分类器（预测模型）优劣的标准：**

- AUC = 1，是完美分类器。
- AUC = [0.85, 0.95], 效果很好
- AUC = [0.7, 0.85], 效果一般
- AUC = [0.5, 0.7],效果较低，但用于预测股票已经很不错了
- AUC = 0.5，跟随机猜测一样（例：丢铜板），模型没有预测价值。
- AUC < 0.5，比随机猜测还差；但只要总是反预测而行，就优于随机猜测。

# 2 案例分析 :cat:

## 2.1 数据预处理

### 2.1.1 极差标准化

$$
x' = (x - min(X))/(max(X)-min(X))
$$



### 2.1.2 中心标准化

### 2.1.3 哑变量生成

### 2.1.4 代码

提取特征值

```python
features = data.loc[:,'income':'edueduclass']
features.head()
```

提取目标值

```python
label = data.Dated
label.head()
```

连续变量进行预处理，进行数据标准化，消除量纲不一致对各个变量产生得影响；

```python
# 数据预处理
from sklearn import preprocessing
min_max_sca = preprocessing.MinMaxScaler()
features_sca = min_max_sca.fit_transform(features)
```

## 2.2 切割数据集

```python
from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(features_sca,label,test_size=0.2)
```

## 2.3 使用k近邻训练模型

```python
from sklearn.neighbors import KNeighborsClassifier
#模型训练
model = KNeighborsClassifier()
model.fit(X_train,y_train)
```

## 2.4 预测

```python
y_predict = model.predict(X_test)
```

## 2.5 评估训练结果

model.score（）：

```python
Signature: model.score(X, y, sample_weight=None)
Docstring:
Returns the mean accuracy on the given test data and labels.

In multi-label classification, this is the subset accuracy
which is a harsh metric since you require for each sample that
each label set be correctly predicted.
```

metrics.classification_report（）

```python
Signature: metrics.classification_report(y_true, y_pred, labels=None, target_names=None, sample_weight=None, digits=2, output_dict=False)
Docstring:
Build a text report showing the main classification metrics

Read more in the :ref:`User Guide <classification_report>`.
```

```python
import sklearn.metrics as metrics
print(metrics.classification_report(y_test,y_predict))
#计算平均准确率
model.score(X_test,y_test)
```

## 2.6 找出最优参数

### 2.6.1 找出最优得参数 k值

```python
x =[]
y=[]
for item in range(1,70):
    modelk = KNeighborsClassifier(n_neighbors=item)
    modelk.fit(X_train,y_train)
    score = modelk.score(X_test,y_test)
    x.append(item)
    y.append(score)
   # print("当k的值为：",item,'score is',score)
```

### 2.6.2 交叉验证

当样本量较小时，适合采用交叉验证 评估模型的效果 需要设定用户搜索空间

十折交叉验证

```python
from sklearn.model_selection import ParameterGrid,GridSearchCV
grid = ParameterGrid({'n_neighbors':[range(1,15)]})
new_model = KNeighborsClassifier()
knn_cv = GridSearchCV(new_model,grid,cv=10,scoring='roc_auc')
knn_cv.fit(X_train,y_train)
```

 GridSearchCV(new_model,grid,cv=10,scoring='roc_auc')中cv=10表示十折，评估标准是roc_auc

### 2.6.3 获取AUC

获取测试集上的AUC的值

```python 
metrics.roc_auc_score(y_test,knn_cv.predict(X_test))
```

