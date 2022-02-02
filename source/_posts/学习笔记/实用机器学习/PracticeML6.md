---
title: praticalML第六章笔记 Tuning
tags: [李沐,机器学习]
categories: [学习笔记,机器学习]
date: 2022-02-02 12:13:06
---

> 斯坦福2021秋季的实用机器学习上线啦~ :wink: 跟着沐神复习机器学习冲冲冲！ 记录一下笔记和重点，不一定很全哦~，只是记录自我感觉的重点。这一章的内容主要是对建立的模型进行Tuning，包括模型调参，超参数优化，网络架构搜索。

# 第六章

## 6.1 模型调参 :paw_prints:

### 6.1.1 Manual Hyperparameter Tuning

- Start with a good baseline, e.g. default settings in high-quality toolkits, values reported in papers

- Tune a value, retrain the model to see the changes

- Repeat multiple times to gain insights about

  • Which hyperparameters are important 哪些参数比较重要

  • How sensitive the model to hyperparameters 敏感度

  • What are the good ranges  找寻好的区间

一般来说，会从一个好的基线开始，找寻工具包有一个大致的参数，或者参考相关论文中，相关数据集中的参数设置，再在验证集上对比结果。

当SGD调参调的比较好的时候通常比Adam要更好，但是Adam对学习率不那么敏感，更好调参。

#### 参数的记录和保存

- Needs careful experiment management 

-  Save your training logs and hyperparameters to compare, share and reproduce later

  • The simplest way is saving logs in text and put key metrics in Excel

   • Better options exist, e.g. **tenesorboard and weights & bias**

- Reproducing is hard, it relates to

  • Environment (hardware & library)  

  • Code

  • Randomness (seed)

最好记录好自己的训练日志，各种参数设置利于重复。

推荐的工具：tenesorboard and weights & bias（wandb）

重复实验是比较难实现，因为实验和硬件，包环境，代码，**随机种子**相关。实在做不到的重复实验，想要达到效果可以使用多个模型进行Ensemble融合起来。

### 6.1.2 机器调参

![](https://picture.mulindya.com/ParacticeML6-1.png)

在小的任务上可以使用机器调参。

#### AutoML

![](https://picture.mulindya.com/ParacticeML6-2.png)

在模型选择这一块，AutoML有所发展。

### 6.1.3 总结

• Hyperparameter tuning aims to find a set of good values

• It’s time consuming as data preprocessing

• There is a trend to use algorithm for tuning

调整参数的目的是找一组好的参数值，现在更倾向于使用算法来Tuning。

## 6.2 超参数优化 :sunflower:

![](https://picture.mulindya.com/ParacticeML6-3.png)

### 6.2.1 HPO algorithms: Black-box or Multi-fidelity

-  Black-box: treats a training job as a black-box in HPO； 黑盒

​	• Completes the training process for each trial

-  Multi-fidelity: modifies the training job to speed up the search 

  • Train on subsampled datasets

  • Reduce model size (e.g less #layers, #channels)

  • Stop bad configuration earlier 

调参的trick：在小数据集，减少模型的size，训练的时候减少epoch；

这样可以很快的对参数的效果有一些比较和对比。

![](https://picture.mulindya.com/ParacticeML6-4.png)

### 6.2.2 常见的HPO策略

1. 网格搜索 Grid Search

   暴力穷举，把所有的组合过一遍得到最好的结果

2. 随机搜索 Random Search 

   循环n次，随机选择超参数的组合，在没有很好的头绪的时候可以先选择随机搜索来确定参数值

![](https://picture.mulindya.com/ParacticeML6-5.png)

### 6.2.3 （BO） Bayesian Optimization

•**BO**: Iteratively learn a mapping from HP to objective function.  Based on previous trials. Select the next trial based on the current estimation. 

•**Surrogate model** 

​	• Estimate how the objective function depends on HP 

​	• Probabilistic regression models: Random forest, Gaussian process, ... 

贝叶斯优化，目前应用得不太广泛，了解一下

### 6.2.4 Successive Halving （SH算法）

![](https://picture.mulindya.com/ParacticeML6-6.png)

有很多超参数得选择，首先选择n组个超参数，训练m个epoch，淘汰n/2组超参数，然后再训练更多一点epoch 2m次epoch，这样每一次的选取计算开销是差不多的。

### 6.2.5 Hyperband（实际中可用）

![](https://picture.mulindya.com/ParacticeML6-7.png)

SH中选大的n，小的m。Hyperband实际上是将多个SH结合起来，然后在前面选取的超参数中选取减半n数目的比较好的参数组合，双倍m，目的是多跑一跑，给第一次在少量epoch的参数再次确认的机会。这样在n和m的选取上就不会那么敏感了。

### 6.2.6 总结

-  Black-box HPO: grid/**random search**, bayesian optimization 

- Multi-fidelity HPO: Successive Halving, **Hyperband**

- In practice, start with random search

- Beware there are **top performers**

	• You can find them by mining your training logs, or what common configurations used in paper/code

再次说明调参的trick：在小数据集，减少模型的size，训练的时候减少epoch；

这样可以很快的对参数的效果有一些比较和对比。

总有几个模型几组参数在所有的数据集任务都表现得比较好，在论文和比赛中记录下比较好得参数组合，只用试试这些参数即可。

## 6.3 神经架构搜索（NAS）:mushroom:

### 6.3.1 概念

模型架构的搜索Neural Architecture Search (NAS)

-  A neural network has different types of hyperparameters:

  • Topological structure: resnet-ish, mobilenet-ish, #layers 

  • Individual layers: kernel_size, #channels in convolutional layer, #hidden_outputs in dense/recurrent layers

-  NAS automates the design of neural network

​	• How to specify the search space of NN 

​	• How to explore the search space

​	• Performance estimation

![](https://picture.mulindya.com/ParacticeML6-8.png)

NAS的工作是尽量使得模型架构的选择自动化

### 6.3.2 使用强化学习来NAS

![](https://picture.mulindya.com/ParacticeML6-9.png)

使用RNN来生成模型的架构，得到的反馈是模型的精度，但是强化学习很贵，实际上不太适用。

### 6.3.3 One-shot方法（更实用）

- Combines the learning of architecture and model params

- Construct and train a single model presents a wide variety of architectures

-  Evaluate candidate architectures

	• Only care about the candidate ranking

	• Use a proxy metric: the accuracy after a few epochs

- Re-train the most promising candidate from scratch

同时学习网络架构的参数和其中的超参数，训练一个巨大的模型，每个子模型的架构和超参数也可以得到。实际上只需要得到模型对前面得模型有提升即可。

#### 例子 Differentiable Architecture Search

![](https://picture.mulindya.com/ParacticeML6-10.png)

使用softmax来判定子路，每一层有很多候选层，比如L层的第i个候选输出为$O_i^l$然后通过对权重参数a通过softmax可以获得${\alpha}^l$​​​加权求和得到​​值赋值m份给到L，通过训练之后得到的a可以来选择好的单元（单元对应的a越大越好）

### 6.3.4 Scaling CNNs（更简单实用）

![](https://picture.mulindya.com/ParacticeML6-11.png)

EfficientNet就是这样的方法搜索出来的，但是Scaling CNNs这个方法有一定的局限性，只对于小部分的神经网络使用，具体是对于卷积神经网络。

调节网络的三个方法：

更多层，更多channel，更大的输入分辨率；

Efficientnet建议组合调节这三个部分，当网络深度变深时通道数也可以相应变多，同样resolution也对应变多。通过4个参数来调节这三个部分。

### 6.3.5 研究方向

-  Explainability of NAS result

-  Search architecture to fit into edge devices

   • Edge devices are more and more powerful, data privacy concerns

   • But they are very diverse (CPU/GPU/DSP, 100x performance difference) and have power constraints

  • Minimize both model loss and hardware latency

  ​	•E.g. minimize $ loss×log(latency)^β $​

- To what extend can we automates the entire ML workflow?

### 6.3.6 总结

-  NAS searches a NN architecture for a customizable goal

  ​	 • Maximize accuracy or meet latency constraints on particular hardware

-  NAS is practical to use now:

  ​	• Compound depth, width, resolution scaling 

  ​	• Differentiable one-hot neural network

