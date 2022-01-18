---
title: praticalML第四章笔记
tags: [李沐,机器学习]
categories: [学习笔记，机器学习]
date: 2022-01-17 15:31:26
math: true
---

> 斯坦福2021秋季的实用机器学习上线啦~ :wink: 跟着沐神复习机器学习冲冲冲！ 记录一下笔记和重点，不一定很全哦~，只是记录自我感觉的重点。

# 第四章

## 4.1 模型评估

P来源于data采样得到模型之后得到预测，这个新的预测是更加关心的。

给定数据给定 超参数 已经获取到模型

- **Loss measures** how good the model in predicting the outcome in supervised learning 
-  Other metrics to evaluate the model performance 
  • Model specific: e.g. accuracy for classification, mAP for object detection 
  • Business specific: e.g. revenue, inference latency 
-  We select models by multiple metrics  
  • Just like how you choose cars

在监督学习中损失value是一个好的指标，除此之外，还有其他的精度比如acc，mAP，商业相关指标（营收增长，流量），我们会衡量多个指标来判断模型好坏。

### 4.1.1 常见分类指标

- 准确率Accuracy: # correct predictions / # examples  得到的y中有多少正确预测了	

    ```python
    sum(y==y_hat)/y.size
    ```

- 精度Precision: # True positive / # (True positive + False positive) 

  负类数据远大于正类，并且更关注正类时，acc就不适用了。

  precision对于预测具体真实类别（正例），哪些被正确预测了。判断为正例的置信度很大，也就是对正例判断越严谨精度越大。

    ```python
    sum((y_hat==1)&(y==1))/sum(y_hat==1)
    ```

- 召回率Recall: # True positive / # Positive examples 

  在所有的正类中有多少被预测出来了，也就是考虑覆盖性的问题，是否所有的正例都被预测出来了。

  ```python
  sum((y_hat==1)&(y==1))/sum(y==1)
  ```

- One metric that balances precision and recall  精度和召回率的权衡

    • **F1**: the harmonic mean of precision and recall: **2pr /( p + r)**

#### AUC-ROC

-  AUC，the area uder ROC curve，measures the chance a  model can distinguish classees.

- choose various $\theta$,predict as pos if $\hat{y} \geq \theta$ else neg

  实际生产当中，$ \theta $是需要选取调节的

  ROC曲线的

  x轴是 分母是负例样本 分子是预测成正例的负例样本数

  y轴是 正例的召回率 分母是所有的正类 分子是预测正确的正类样本数

  ![](https://picture.mulindya.com/pML4-1.png)

AUC是表示ROC下的面积，取值范围是[0,1]

![](https://picture.mulindya.com/pML4-2.png)

#### 商业指标

-  Optimize both revenue and customer experience 
  • Latency: ads should be shown to users at the same time as others   
  • ASN: average #ads shown in a page 
  • CTR: actual user click through rate 
  • ACP: average price advertiser pays per click 
-  revenue = #pageviews   ASN   CTR   ACP

Latency表示在多久在页面显示，一般控制在500ms之内，包括模型计算预测部署的时间

ASN 每一页投放的广告数量

CTR 上线之后点击频率

ACP 每一个广告点击，广告主的支付费用

#### 4.1.2 模型->商业评估

-  The key model metric is AUC 
-  A new model with increased AUC may harm business metrics, possible reasons: 
  • Lower estimated CTR   less ads displayed 
  • Lower real CTR because we trained and evaluated on past data 
  • Lower prices 
- Online experiment: deploy models to evaluate on real traffic data

实际上只看auc是不够的，需要各种权衡和模拟。

### 4.1.3 总结

-  We evaluate models with multiple metrics 
-  Model metrics evaluate model performance on examples 
  • E.g. accuracy, precision, recall, F1, AUC for classification models  
-  Business metrics measure how models impact the product

## 4.2 过拟合&欠拟合

### 4.2.1 训练误差 泛化误差

• **Training error**: model error on the training data 
• **Generalization error**: model error on new data

![](https://picture.mulindya.com/pML4-3.png)

### 4.2.2 原因

![](https://picture.mulindya.com/pML4-4.png)

数据复杂性 VS 模型复杂性

两者的复杂性越对等越好；

![](https://picture.mulindya.com/pML4-5.png)

数据简单 and 模型复杂就会导致过拟合

数据比模型更复杂，模型不能拟合数据，就会导致欠拟合。

### 4.2.3 模型复杂度

- The capacity of a set of function to fit data points 
- In ML, model complexity usually refers to: 
  • The number of learnable parameters  
  • The value range for those parameters 
-  It’s hard to compare between different types of ML models 
  • E.g. trees vs neural network 
-  More precisely measure of complexity: VC dimension 
  • VC dim for classification model: the maximum number of examples the model can shatter

模型复杂性可以描述为拟合各种函数的能力，很难比较模型之间的复杂度(比如树和神经网络)，通常参数越多，每层的参数范围越大，模型越复杂.

### 4.2.4 产生的影响

