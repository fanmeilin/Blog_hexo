---
title: praticalML第四章笔记
tags: [李沐,机器学习]
categories:[学习笔记，机器学习]
date: 2022-01-12 15:31:26
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

### 常见分类指标

- 准确率Accuracy: # correct predictions / # examples  得到的y中有多少正确预测了	

    ```python
    sum(y==y_hat)/y.size
    ```

- 精度Precision: # True positive / # (True positive + False positive) 

  负类数据远大于正类，并且更关注正类时，acc就不适用了。

  precision对于预测具体真实类别（正例），哪些被正确预测了。

    ```python
    sum((y_hat==1)&(y==1))/sum(y_hat==1)
    ```

- 召回率Recall: # True positive / # Positive examples 

  在所有的正类中有多少被预测出来了

  ```python
  sum((y_hat==1)&(y==1))/sum(y==1)
  ```

- One metric that balances precision and recall  精度和召回率的权衡

    • **F1**: the harmonic mean of precision and recall: **2pr /( p + r)**

