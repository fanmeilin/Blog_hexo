---
title: 直观理解协方差矩阵
date: 2021-08-05 11:26:21
tags: [math,概率论]
categories: [math,概率论]
math: true
---

> 原文出自 https://zhuanlan.zhihu.com/p/349802953

## 1 概率论中的定义

### 随机变量：

随机变量(Random Variable) X 是一个映射，把随机试验的结果与实数建立起了一一对应的关系。而期望与方差是随机变量的两个重要的数字特征。

### 数学期望：

在概率论和统计学中，数学期望(mean)(或均值，亦简称期望(Expectation, or expected value))是试验中每次可能结果的概率乘以其结果的总和，是最基本的数学特征之一。它反映随机变量平均取值的大小。 期望值是该变量输出值的平均数。期望值并不一定包含于变量的输出值集合里。

大数定律规定，随着重复次数接近无穷大，数值的算术平均值几乎肯定地收敛于期望值。

### 方差：

方差(Variance)是在概率论和统计方差衡量随机变量或一组数据时离散程度的度量。概率论中方差用来度量随机变量和其数学期望(即均值)之间的偏离程度。统计中的方差(样本方差)是每个样本值与全体样本值的平均数之差的平方值的平均数。

设$X$为随机变量， 如果$\mathrm{E}[X]$，则随机变量$X$的方差为：
$$
\mu=\mathrm{E}[X]
$$

方差也记为 $\sigma_{X}^{2}$。

样本方差计算公式：

$$
S^{2}=\Sigma\left(X-\overline{X}\right)^{2}/\left(n-1\right)
$$

其中，$S^{2}$为样本方差，$X$ 为变量，$\overline{X}$为样本均值，$n$ 为样本例数。如果要了解为什么要除以$n-1$，请看[这篇文章](https://link.zhihu.com/?target=https%3A//www.visiondummy.com/2014/03/divide-variance-n-1/)。

### 标准差：

标准差(Standard Deviation)是离均差平方的算术平均数(即：方差)的算术平方根，用$\sigma$表示。标准差也被称为标准偏差，或者实验标准差，在概率统计中最常使用作为统计分布程度上的测量依据。 见下图：

![](https://pic1.zhimg.com/80/v2-37e04458baf17d09c914981b5dbae140_720w.jpg)

标准差是方差的算术平方根。标准差能反映一个数据集的离散程度。平均数相同的两组数据，标准差未必相同。

### 协方差：

**协方差(Covariance)在概率论和统计学中用于衡量两个变量的总体误差。而方差是协方差的一种特殊情况，即当两个变量是相同的情况。**

期望值分别为$ E[X]$与$[Y]$的两个实随机变量$X$与$Y$之间的协方差 $\mathrm{Cov}(X,Y)$ 定义为：

{% raw %}
$$
\begin{aligned}
\mathrm{Cov}(X,Y)&=\mathrm{E}\left[\left(X\mathrm{E}\left[X\right]\right)\left(Y-\mathrm{E}\left[Y\right]\right)\right]  
\\&=\mathrm{E}\left[XY\right]-2\mathrm{E}\left[Y\right]\mathrm{E}\left[X\right]+\mathrm{E}\left[X\right]\mathrm{E}\left[Y\right]
\\&=\mathrm{E}\left[XY\right]-\mathrm{E}\left[X\right]\mathrm{E}\left[Y\right] 
\\&=\mathrm{E}\left[XY\right]-\mathrm{E}\left[X\right]\mathrm{E}\left[Y\right]
\end{aligned}
$$
{% endraw %}

协方差表示的是两个变量总体误差的期望。 如果两个变量的变化趋势一致，也就是说如果其中一个大于自身的期望值，另外一个也大于自身的期望值，那么两个变量之间的协方差就是正值。 如果两个变量的变化趋势相反，即其中一个大于自身的期望值，另外一个却小于自身的期望值，那么两个变量之间的协方差就是负值。

如果$X$与$Y$是统计独立的，那么二者之间的协方差就是0，因为两个独立的随机变量满足$\mathrm{E}[XY]=\mathrm{E}[X]\mathrm{E}[Y]$。但是，反过来并不成立。即如果$X$与$Y$的协方差为0，二者并不一定是统计独立的。

**协方差为0的两个随机变量称为是不相关的。**

### 协方差矩阵：

在统计学与概率论中，协方差矩阵(Covariance matrix)的每个元素是各个向量元素之间的协方差，是从标量随机变量到高维度随机向量的自然推广。

设$X=\left(X_{1},X_{2},\ldots,X_{n}\right)^{\mathrm{T}}$为$n$ 维随机变量，称矩阵

{% raw %}
$$
C=\left(\begin{array}{cccc} c_{11} & c_{12} & \cdots & c_{1n}\\ c_{21} & c_{22} & \cdots & c_{2n}\\ \vdots & \vdots & \ddots & \vdots\\ c_{n1} & c_{n2} & \cdots & c_{nn} \end{array}\right)
$$
{% endraw %}

为 n 维随机变量x的协方差矩阵，也记为 $D\left(X\right)$ ，其中
$$
c_{ij}=\mathrm{Cov}(X_{i},X_{j}),\quad i,j=1,2,\ldots,n
$$
为X的分量$X_{i}$和$X_{j}$的协方差。*并且对角线上的元素为各个随机变量的方差：*

$$
c_{ii}=\mathrm{Cov}(X_{i},X_{i}),\quad i=1,2,\ldots,n
$$

协方差矩阵是对称半正定矩阵。协方差矩阵的对称性，可从定义得知。对于半正定特性，证明如下：

现给定任意一个非零向量$\boldsymbol{x}$，则

{% raw %}
$$
\begin{aligned}
\boldsymbol{x}^{\mathrm{T}}C\boldsymbol{x}	&=\boldsymbol{x}^{\mathrm{T}}\mathrm{E}\left[\left(X-\mu\right)\left(X-\mu\right)^{\mathrm{T}}\right]\boldsymbol{x} 	
\\&=\mathrm{E}\left[\boldsymbol{x}^{\mathrm{T}}\left(X-\mu\right)\left(X-\mu\right)^{\mathrm{T}}\boldsymbol{x}\right] 	\\&=\mathrm{E}\left[\left(\left(X-\mu\right)^{\mathrm{T}}\boldsymbol{x}\right)^{\mathrm{T}}\left(\left(X-\mu\right)^{\mathrm{T}}\boldsymbol{x}\right)\right] 	
\\&=\mathrm{E}\left(\left\Vert \left(X-\mu\right)^{\mathrm{T}}\boldsymbol{x}\right\Vert ^{2}\right) 	
\\&=\sigma_{X}^{2}
\end{aligned}
$$
{% endraw %}

其中，
$$
\sigma_{X}=\left(X-\mu \right)^{\mathrm{T}}\boldsymbol{x}
$$
由于 $\sigma_{X}^{2}\geq0$，因此$\boldsymbol{x}^{\mathrm{T}}C\boldsymbol{x}\geq0$，因此协方差矩阵$C$ 是半正定矩阵。

