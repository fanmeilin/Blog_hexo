---
title: praticalML第章笔记PracticeML3
tags: [李沐,机器学习] 
categories: [ 学习笔记，机器学习]
date: 2022-01-03 14:27:22
math: True
---

> 斯坦福2021秋季的实用机器学习上线啦~ :wink: 跟着沐神复习机器学习冲冲冲！ 记录一下笔记和重点，不一定很全哦~，只是记录自我感觉的重点。
> 这一章的内容是对各种机器学习模型的介绍，包括有决策树，线性模型，多层感知机，卷积神经网络，循环神经网络。

# 第三章 机器学习模型

## 3.1 机器学习介绍

分类可以分成：

1. 监督学习（Surprised）：有标号的数据上来训练模型来预测标号
   - 衍生出现self-supervised 自监督学习：可以产生标号，只是其标号是来自数据本身（eg:word2vec,BERT）
2. 半监督学习（Semi-superised）存在小部分有标号的数据，还有大部分没有标号的数据。
   - eg：self-training 使用自训练的过程来预测标号再一起训练。
3. 无监督学习（Unsuperised）在没有标号的数据上训练
   - eg：clustering，density estimation（GAN）
4. 强化学习（Reinforce）在一个环境中交互，并且基于观察点来学习，类似人类学习的方法。Use observations from the interaction with the environment to take actions to maximize reward。

### 3.1.1 监督学习中的Components

- Model（模型） 从输入中得到输出
- Loss（损失函数）评估真实样本和预测结果的差距
- Objective（目标函数对象）The goal to optimize model params for
- Optimization（优化算法）he algorithm for solving the objective

### 3.1.2 监督学习模型

- **Decision trees**  • Use trees to make decisions 
- **Linear methods** • Decision is made from a linear combination of input features（做决策的输出是输入的线性组合） 
- **Kernel machines** • Use kernel functions to compute feature similarities  （核函数来衡量两个样本特征之间的相似度，指定不同的核函数，特征相似度不同，达到非线性的效果）
- **Neural Networks** • Use neural networks to learn feature representations

### 3.1.3 总结

![](https://picture.mulindya.com/pML3-1.png)

## 3.2 决策树

包括有分类树，回归树（此时叶子节点不是类别而是实数值）

##### 好处（pros）：

- 可解释（可应用于银行业，保险业）；
- 可以用于数值或类别特征；

##### 缺点（cons）：

- 鲁棒性差（可以用集成学习改善）；
- 数据很复杂时可能产生过拟合（可以使用剪枝）；
- 难以使用并行计算

### 3.2.1 生成决策树

![](https://picture.mulindya.com/pML3-2.png)

### 3.2.2 随机森林

训练多个决策树来增强并行性，分类时使用投票机制，回归时使用多个树的平均；对整个树的稳定性有好处。

- Train multiple decision trees to improve robustness  
  • Trees are trained independently in parallel   
  • Majority voting for classification, average for regression 
-  Where is the randomness from? 
  • Bagging: randomly sample training examples with replacement  
      • E.g. [1,2,3,4,5]   [1,2,2,3,4] 
  • Randomly select a subset of features 

这里的随机森林中的随机来自于两个方面哦~

一个是Bagging，训练一棵树在训练集中随机采样一些样本出来（可重复采样），所以在训练集中会出现重复样本，继续重复训练其他树；

另一个是对于获取的训练集是随机进行采样特征列（此时是无重复的特征列采样）；

### 3.2.3 Gradient Boosting Decision Trees

训练多棵树，但是这里不是独立完成决策，而是顺序的完成，利用这些树来合成一个大的模型出来，在t时刻 $ F_t(x) $ 表示是对前面训练的t-1棵树求和，训练的这颗树需要和所有的树的结果加起来，利用残差的思想训练$f_t(x)$（也就是“不准”的部分）

同时这里的残差（$y_i-F_t(x_i)$）就等于梯度值($ -\frac{\alpha L}{\alpha F} $)（使用均方误差作为loss）

![](https://picture.mulindya.com/pML3-3.png)

## 3.3 总结

- Decision tree: an explainable model for classification/regression 
- Easy to train and tune, widely used in industry
-  Sensitive to data 
  • Ensemble can help (more on bagging and boosting latter)

决策树是一个为数不多的可解释性模型，对数据的噪音很敏感所以可以使用很多树一起训练来降低偏移和方差。可以用树模型时尽量用树模型哟。
