---
title: Depthwise Separable Convolution 
tags: [深度学习,MobileNet]
categories: [深度学习,MobileNet]
date: 2022-01-06 10:20:25
---

# Depthwise Separable Convolution

> 在Mobilenet中使用DSconv，通过改进架构减少参数量的方法，所以也顺势记录一下Depthwise Separable卷积的原理。笔记来源于李宏毅的课程。:cry:

## 传统的卷积过程

![](https://picture.mulindya.com/kDistillation-3.png)



## Depthwise Convolution

第一个步骤，每一个filter只作用到一个Chanel，这里input和output的channel是相同的。

![](https://picture.mulindya.com/kDistillation-4.png)



## Pointwise Convolution

跨channel操作是通过Pointwise Convolution来得到Feature map，这里是1*1的大小filter 因为只用考虑不同channel之间的关系即可。前面的Depthwise Convolution是已经考虑Channel内部的关系。

![](https://picture.mulindya.com/kDistillation-5.png)





![](https://picture.mulindya.com/kDistillation-6.png)

所以参数量会减少K*K倍。

## 原理

### Low rank approximation

![](https://picture.mulindya.com/kDistillation-7.png)

这样可以减少参数。从W到U+V的参数规模，但是这样的变换会导致某些限制，减少w的可能性，因为使用U*V的秩是小于等于W的秩，所以映射的空间会减小。

![](https://picture.mulindya.com/kDistillation-8.png)

就可以对比传统的卷积和Depthwise卷积的原理就相当于W和UV的关系，把一层的映射拆成两次，所以参数量减少了，模型表示减小。

## 相关网络

使用Depthwise Conv的网络架构

•SqueezeNet
• https://arxiv.org/abs/1602.07360
•MobileNet
• https://arxiv.org/abs/1704.04861
•ShuffleNet
• https://arxiv.org/abs/1707.01083
•Xception
• https://arxiv.org/abs/1610.02357
•GhostNet
• https://arxiv.org/abs/1911.11907
