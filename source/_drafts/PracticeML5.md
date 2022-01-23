---
title: praticalML第章笔记PracticeML5
tags: [李沐,机器学习]
categories: [学习笔记,机器学习]
date: 2022-01-19 14:15:19
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

## 5.2 Bagging

- Learn  base learners in parallel, combine to reduce model variance

- Each base learner is trained on a bootstrap sample
	•Given a dataset of  examples, create a sample by randomly sampling examples with replacement
	•Around  $ 1-\frac{1}{e} \approx 63\% $ unique examples will be sampled use the out-of-bag examples for validation

- Combine learners by averaging the outputs (regression) or majority voting (classification)
- Random forest: bagging with decision trees 
	• usually select random subset of features for each bootstrap sample



![](https://picture.mulindya.com/ParacticeML5-5.png)



![](https://picture.mulindya.com/ParacticeML5-6.png)



![](https://picture.mulindya.com/ParacticeML5-7.png)

## 5.3 Boosting

![](https://picture.mulindya.com/ParacticeML5-14.png)



![](https://picture.mulindya.com/ParacticeML5-15.png)



![](https://picture.mulindya.com/ParacticeML5-16.png)



![](https://picture.mulindya.com/ParacticeML5-17.png)

## 5.4 Stacking

![](https://picture.mulindya.com/ParacticeML5-8.png)





![](https://picture.mulindya.com/ParacticeML5-9.png)



![](https://picture.mulindya.com/ParacticeML5-10.png)



![](https://picture.mulindya.com/ParacticeML5-11.png)



![](https://picture.mulindya.com/ParacticeML5-12.png)



![](https://picture.mulindya.com/ParacticeML5-13.png)



