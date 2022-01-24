---
title: praticalML第五章笔记
tags: [李沐,机器学习]
categories: [学习笔记,机器学习]
date: 2022-01-24 14:15:19
math: true
---

> 斯坦福2021秋季的实用机器学习上线啦~ :wink: 跟着沐神复习机器学习冲冲冲！ 记录一下笔记和重点，不一定很全哦~，只是记录自我感觉的重点。这一章的中心是模型融合，也就是Model Combination，主要讲解方差和偏差，bagging，boosting，stacking的慨念和算法！

# 第五章

## 5.1 方差和偏差 :waning_gibbous_moon:

### 5.1.1 概念

统计学习中使用方差和偏差来衡量模型。

![](https://picture.mulindya.com/ParacticeML5-1.png)

训练的模型对于样本得到的预测值，采样5次数据训练5个模型的到的5个结果值，黄色区域是容忍的区域；

偏差是学习到的模型和真实的模型得到的解的差距；

方差是每次学习到的东西的差别有多大。

### 5.1.2 重要公式

![](https://picture.mulindya.com/ParacticeML5-2.png)



Bias为第一项，Var为第三项，可以需要使得模型的方差和偏差尽可能的小。这个公式灰常重要:mag_right:！

### 5.1.3 模型优化方法

![](https://picture.mulindya.com/ParacticeML5-3.png)

随着模型越复杂，偏差会递减，而方差会递增，因为会过拟合，模型对于小的扰动会对结果扰动很大。

如果要得到好的模型，增强泛化能力，就需要把偏差，方差，噪声都降低。

![](https://picture.mulindya.com/ParacticeML5-4.png)

- 降低偏差：复杂模型，boosting，Stacking；

- 降低方差：简单模型，正则化参数，Bagging，Stacking；

- 降低噪音：增强数据质量；

其中Boosting，Stacking,Bagging是Ensemble Learning也就是集成学习。**核心思想是使用多个模型来提升预测性能~**

### 5.1.4 总结

- Decompose model generalization error into bias,variance and intrinsic error
- Ensemble learning combines mutiple models to reduce both bias and variance

将模型的泛化误差分解成方差，偏差的平方，采集数据误差。

可以使用集成模型来降低方差和偏差。

## 5.2 Bagging :crystal_ball:

### 5.2.1 概念

Bagging是生产词，来自于Bootstrap Aggrgrating

- Learn  base learners in parallel, combine to reduce model variance

- Each base learner is trained on a bootstrap sample
  •Given a dataset of  examples, create a sample by randomly sampling examples with replacement
  •Around 公式1 unique examples will be sampled use the out-of-bag examples for validation

   {% raw %}
  $$
  公式1: \ 1-\frac{1}{e} \approx 63\%
  $$
   {% endraw %}

- Combine learners by averaging the outputs (regression) or majority voting (classification)

- Random forest: bagging with decision trees 
	• usually select random subset of features for each bootstrap sample

将n个模型做预测，回归可以得到的结果做平均，分类可以使用n个模型得到的结果来投票取最大统计数的结果。

bootstrap采样 也就是随机放回采样得到训练的模型，这样的采样方式大概含有了63%的原始样本，剩下的37%是重复样本，out of bag剩下没有采样的原始样本可以作为验证集。

### 5.2.2 代码

![](https://picture.mulindya.com/ParacticeML5-5.png)

`__init__`方法是初始化n个学习器：`clone`可以把一个`base_learner`复制n次，因为模型不是share权重的，是独立的，不能直接使用`[base_learner for _ in range(n_leaners)]`。

`fit`方法是训练学习器：`fit`中的`example`是在m个样本中又有放回随机选择m个样本。然后训练n个训练模型。

`predict`方法是：预测是给x来得到pred，存到一个数组中，转为array在第一个维度求均值。

### 5.2.3 本质

![](https://picture.mulindya.com/ParacticeML5-6.png)

Baggin降低了模型的方差，尤其是不稳定的学习器，因此泛化能力会增强，大方差的模型可以称作Unstable Learner。

下面公式中的$f(x)$不是随机变量是确定的，因此是可以化成$\hat{f}(x)^2$​​,这里没有看懂:dizzy_face:，单个小于等于多个f的期望。

### 5.2.4 Unstable Learners

随机森林也就是降低了方差，但是没有增加偏差和噪声；

在使用bagging的时候使用不稳定的Learner会有显著提升泛化性能的效果，决策树不是稳定的模型，数据一旦发生变化，那么选取哪些特征切开分支会很不一样，线性回归相对是比较稳定的模型，协方差矩阵（最小特征值和最大特征值的比）比较好的模型相对比较稳定

![](https://picture.mulindya.com/ParacticeML5-7.png)

### 5.2.5 总结

- Bagging train multiple learner on data by bootstrap sampling(随机放回采样)

- Bagging reduce variance,especially for unstable learners 

  对于不稳定的模型，比如决策树效果最佳，比如随机森林

## 5.3 Boosting

### 5.3.1 定义

![](https://picture.mulindya.com/ParacticeML5-14.png)

Boosting是为了降低模型的偏差，Bagging是为了降低模型的方差。

Boosting是将偏差比较大的模型（weak learners）将其组合成一个比较强的模型

### 5.3.2 Gradient Boosting

![](https://picture.mulindya.com/ParacticeML5-15.png)

这里注意是在残差上学习，也就是样本本身，特征不变化，只有标号变了，标号为$y_i-H_t(s_i)$​,也就是前面模型没有学够的部分然后加到当前的模型中继续Boosting，在加入新的$\hat{h_t}_(x)$​(上面公式中的f是沐神笔误了)时前有一个$\eta$​​​作为正则项​避免过拟合，**可以将$ \eta $​​​​​设置为0.1或者0.几，避免一次性拟合太过。**

残差等于求损失对函数梯度的负方向，拟合等价与 每次学习一个新的ht是去拟合负梯度的方向，以前的梯度下降是使用负的导数梯度乘以学习率加到权重中，由于这里是学习的函数，在这里不是加到权重中，而是加到函数中。不同的L可采取不同的Boosting的算法。

### 5.3.3 实现代码

![](https://picture.mulindya.com/ParacticeML5-16.png)

`fit`方法是首先将y copy到residual中，然后训练模型（X,residual）,然后更新残差形式；

`predict`时需要求和乘以学习率时为了加权每个弱学习器的结果。

#### 5.3.4 Gradient Boosting Decision Trees(GBDT)

![](https://picture.mulindya.com/ParacticeML5-17.png)

Boosting容易过拟合，所以需要一些正则化；我们需要一些弱模型，可以使用少层的决策树（或其他模型）或者在少量的特征上学习的模型。这里没有过拟合一个是取得模型都是很弱，另外学习率取为0.1.

### 5.3.5 总结

- Boosting combines weak learners into a strong one to reduce bias

- Gradient Boosting learns weak learners by fitting the residuals

  弱模型组合成强模型降低偏差

## 5.4 Stacking :battery:

### 5.4.1 定义

![](https://picture.mulindya.com/ParacticeML5-8.png)

可以融合**不同种**模型，然后Concat结果再进行线性组合也就是全连接层，既可以降低偏差，也可以降低方差，在竞赛中常用此方法。

#### 对比Bagging

- 类似Bagging组合模型投票，但是这里是不同种类的模型来融合。

- 不需要Bootstrap来获取多样性因为模型本身就具有多样性；

- 模型不一样在特征提取也会不一样。

### 5.4.2 Stacking result

![](https://picture.mulindya.com/ParacticeML5-9.png)

需要注意模型的选取。

### 5.4.3 多层Stacking 

之前的stacking主要是降低方差，也可以使用多层的方法降低偏差

![](https://picture.mulindya.com/ParacticeML5-10.png)

下一层的模型是上一层的输出结果，原始特征加上模型输出结果来concat。多层的stacking很容易过拟合，容易过度注意噪音，需要减轻过拟合。

### 5.4.4 减轻过拟合

![](https://picture.mulindya.com/ParacticeML5-11.png)

#### 不重复数据

可以把数据分成两块A，B，在A上训练第一层的模型，在B得到预测的结果在加上B的本身用于第二层模型的训练。这样每一层数据的训练集是不耦合的，缺点是每一层只能使用一半的数据。

#### 重复K折Bagging

类似交叉验证将数据分成K份，在k-1上训练，在i上做验证，这样可以训练k个模型，将得到的结果可以组成和原始数据一样的大小，但是预测都是没有再次参与当前模型训练的，再进入到下一层训练，同时下一层可以看到整个样本的预测同时都没有参加，训练n次就一层之中的小模型可以看到所有数据，这样实际上就训练了k*n个模型，也就是说n个模型并排成为一层，然后使用k成交叉，使得每一次训练小模型看到的数据不同。然后再求平均输出到下一层。

### 5.4.5 代码实例

![](https://picture.mulindya.com/ParacticeML5-12.png)

### 5.4.6 总结

- Stacking combine multiple learners to reduce variance

- Stacking learners in multiple levels to reduce bias

  - Repeated K-fold bagging:fully utilize data and alleviate overfitting

  多层减轻偏差，多个模型减轻方差

## 5.5 模型融合总结 :mailbox:

- 集成学习的方法来降低偏差和方差

![](https://picture.mulindya.com/ParacticeML5-13.png)



