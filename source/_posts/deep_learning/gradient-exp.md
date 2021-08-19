---
title: 梯度消失&梯度爆炸
tags: 深度学习
categories: 深度学习
date: 2021-08-17 10:42:10
math: true
---

> 本文探讨深度学习中经常提到的概念--梯度消失和梯度爆炸 。他们是影响模型收敛，学习好坏的重要因素。对此现象也提出了很多对应的解决方案。我们来大致做一个总结，对其概念，原因和相关的解决方案进行探讨叭~~

## 梯度爆炸&梯度消失

梯度爆炸就是在梯度更新的时候偏导数很大，导致更新参数无法收敛到最值（总是跳到其他不好的地方）。

梯度消失就是在梯度更新的时候偏导数很小，导致更新参数无法收敛到最值（动不了）。
$$
w_1=w_1− \alpha \frac{∂J(w)}{∂w1} 
$$

$$
w_2=w_2− \alpha \frac{∂J(w)}{∂w2}
$$

![](https://picture.mulindya.com/gradient-exp-pic1.png)

## 梯度消失和梯度爆炸原因

- 训练方式：网络训练时采用反向传播的方式，会使用链式求导法则，因此对激活函数求导时，如果权重乘以激活函数导数此部分大于1，那么当层数很多时，求出的梯度更新将以指数的形式增加，则会梯度爆炸。如果此部分小于1，则随着层数增多，求出的梯度会指数衰减，则会梯度消失。

- 激活函数：如果选用sigmoid，$S(x) = \frac{1}{1+e^{-x}}$ ，而其导数 $S'(x) = \frac{e^{-x}}{(1+e^{-x})^2}=S(x)(1-S(x))$ ，其梯度不会超过0.25。

- 权重初始值：因此一个均值为0标准差为1的高斯分布初始化参数很容易发生梯度消失，因为权重集中在-1到1之间。如果初始化比较大的值

- 根据链式求导和反向传播，我们很容易得出，其中C是代价函数

  ![](https://picture.mulindya.com/gradient-exp-pic2.png)

  ![](https://picture.mulindya.com/gradient-exp-pic3.png)

## 解决方案

### 1，采用好的参数初始化方法。比如[He方法](https://blog.csdn.net/u010505915/article/details/106608922/?utm_medium=distribute.pc_relevant.none-task-blog-2~default~baidujs_baidulandingword~default-0.base&spm=1001.2101.3001.4242)

1. 前向传播的时候, 每一层的卷积计算结果的方差为1.
2. 反向传播的时候, 每一 层的继续往前传的梯度方差为1(因为每层会有两个梯度的计算, 一个用来更新当前层的权重, 一个继续传播, 用于前面层的梯度的计算.)

### 2，梯度剪切--梯度爆炸

梯度裁剪是解决**梯度爆炸**的一种高效的方法，这里介绍梯度裁剪（Gradient Clipping）的方法，对梯度进行裁剪，论文提出对梯度的L2范数进行裁剪，也就是所有参数偏导数的平方和再开方。
$$
g_1=\frac{∂J(w)}{∂w1} 
$$

$$
g_2=\frac{∂J(w)}{∂w2}
$$

设定裁剪阈值为 C = max_norm，$\Vert g\Vert_2= \sqrt{g^2_1+g^2_2}$

当$\Vert g\Vert_2$大于c时：

$$
g = \frac{c}{\Vert g \Vert_2} \cdot g
$$
当$\Vert g\Vert_2$小于等于C时：g不变。其中，$\frac{c}{\Vert g \Vert_2}$是一个标量

### 3，正则化--梯度爆炸

​		采用权重正则化，主要是通过对网络权重做正则来限制过拟合，同时，如果发生梯度爆炸，那么权值的范数就会变的非常大，反过来，通过限制正则化项的大小，也可以在一定程度上限制梯度爆炸的发生。比较常见的是l1正则，和l2正则，在各个深度框架中都有相应的API可以使用正则化，比如在pytorch中，若搭建网络的时候已经设置了正则化参数，则调用以下代码可以直接计算出正则损失。
​		torch.optim集成了很多优化器，如SGD，Adadelta，Adam，Adagrad，RMSprop等，这些优化器自带的一个参数weight_decay，用于指定权值衰减率，相当于L2正则化中的λ参数，注意torch.optim集成的优化器只有L2正则化方法，你可以查看注释，参数weight_decay 的解析是：

```python
 weight_decay (float, optional): weight decay (L2 penalty) (default: 0)
 optimizer = optim.Adam(model.parameters(),lr=learning_rate,weight_decay=0.01)
```

loss计算公式
$$
Loss = (y-W^Tx)^2+\alpha {\Vert W \Vert}^2
$$

### 4，激活函数

#### 1.ReLU函数：

如果激活函数的导数为1，那么就不存在梯度消失爆炸的问题了，每层的网络都可以得到相同的更新速度，ReLU就这样应运而生。

ReLU的主要贡献在于：

![](https://picture.mulindya.com/gradient-exp-pic4.png)

##### 优点

解决了梯度消失、爆炸的问题。
计算方便，计算速度快。
加速了网络的训练。

##### 缺点：

由于负数部分恒为0，会导致一些神经元无法激活（可通过设置小学习率部分解决）。
输出不是以0为中心的。

#### 2.LeakyReLU函数：

LeakyReLU就是为了解决ReLU的0区间带来的影响，该函数输出对负值输入有很小的坡度，由于导数总是不为零，这能减少静默神经元的出现，允许基于梯度的学习（虽然会很慢），解决了ReLU函数进入负区间后，导致神经元不学习的问题。

![](https://picture.mulindya.com/gradient-exp-pic5.png)

#### 3.ELU函数：

![](https://picture.mulindya.com/gradient-exp-pic6.png)

- 融合了sigmoid和ReLU，**左侧具有软饱和性，右侧无饱和性**。

- 右侧线性部分使得ELU能够缓解梯度消失，而左侧软饱能够让ELU对输入变化或噪声更鲁棒。

- ELU的输出均值接近于零，所以收敛速度更快，但相对于LeakyReLU来说，计算要更耗时间一些。

<font size=3 color=BlueViolet>小知识：</font>

> 梯度饱和常常是和激活函数相关的，比如sigmod和tanh就属于典型容易进入梯度饱和区的函数，即自变量进入某个区间后，梯度变化会非常小，表现在图上就是函数曲线进入某些区域后，越来越趋近一条直线，梯度变化很小，梯度饱和会导致训练过程中梯度变化缓慢，从而造成模型训练缓慢

### 4，Batch Normalization

BN是深度学习发展以来提出的最重要的成果之一了，目前已经被广泛的应用到了各大网络中，具有加速网络收敛速度，提升训练稳定性的效果，**BN本质上是解决反向传播过程中的梯度问题。**BN全名是Batch Normalization，简称BN，即批规范化，**通过规范化操作将输出信号x规范化保证网络的稳定性。**
反向传播式子中有w的存在，所以w的大小影响了梯度的消失和爆炸，**BN就是通过对每一层的输出规范为均值和方差一致的方法**，消除了w带来的放大缩小的影响，进而解决梯度消失和爆炸的问题，或者可以理解为BN将输出从饱和区拉倒了非饱和区。
有关Batch Normalization详细的内容可以参考这篇博客： [Batch Normalization](http://blog.csdn.net/qq_25737169/article/details/79048516)

### 5,残差结构

事实上，就是残差网络的出现导致了image net比赛的终结，自从残差提出后，几乎所有的深度网络都离不开残差的身影，相比较之前的几层，几十层的深度网络，在残差网络面前都不值一提，残差可以很轻松的构建几百层，一千多层的网络而不用担心梯度消失过快的问题，原因就在于残差的捷径（shortcut）部分。原理可参见：[残差结构](https://zhuanlan.zhihu.com/p/42706477)

### 6，LSTM网络

LSTM是循环神经网络RNN的变体，全称是长短期记忆网络（long-short term memory networks），它是不那么容易发生梯度消失的，主要原因在于LSTM内部复杂的“门”结构，**LSTM通过它内部的“门”可以接下来更新的时候“记住”前几次训练的“残留记忆”**，因此，经常用于生成文本中。关于LSTM的原理详解后续再分析。[LSTM](https://zhuanlan.zhihu.com/p/32085405)


![](https://picture.mulindya.com/gradient-exp-pic7.png)
