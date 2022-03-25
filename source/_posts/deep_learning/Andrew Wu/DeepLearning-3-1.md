---
title: 三 结构化机器学习项目--机器学习策略（1）
tags: [深度学习,吴恩达]
categories: [深度学习,吴恩达]
date: 2022-03-24 21:01:01
math: true
---

> 此为吴恩达的深度学习课程的第三门课的第一周内容总结，记下相关要点，方便后续的复习和巩固。:wink:

# ML策略

优化深度学习系统的想法：

- 收集更多数据

- 增加训练集的多样性

- 梯度下降更久

- 使用其他的优化算法

- 使用更大或者更小的网络

- 使用dropout或者L2正则化

- 修改网络架构...

## 正交化

要优化深度学习的效果的方法（使用正交的控制）

1. 在训练集上得到的效果不错。 （更大的网络，优化算法）
2. 在开发集上效果不错。 （正则化，更多数据）
3. 在测试集上效果不错。（使用更多开发数据）
4. 在测试集上的成本函数在实际使用中效果不错。 （改变开发及或者成本函数）

早停这个方法对1，2都有影响，所以不是非常正交的影响。

## 单一数字评估指标

### 查准率（precision）

在所有判断为猫猫的例子中有多少是真的猫猫

所以说当一个分类器是95%，就可以说有95%概率说对了

### 查全率 （Recall）

在所有的猫猫中有多少被识别出来了

当分类器查全率为90%，意味着这个分类器准确分辨了90%的猫猫，还有10%猫猫分辨错误了。

### F1

使用F1分数可以结合两者，可以看作是查准率P和查全率R的平均数，准确说是调和平均：
$$
F1 = \frac 2 {\frac 1 P+ \frac 1 R} = \frac {2PR} {P+R}
$$
所以需要一个单实数评估指标可以提高优化算法的效率，或是提高团队做出决策的效率。

## 满足和优化指标

如何设置优化和满足指标