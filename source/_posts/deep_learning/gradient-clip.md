---
title: 梯度裁剪
tags: [深度学习，梯度]
categories: 深度学习
date: 2021-08-12 10:20:29
math: true
---

>阅读代码 optimizer_config = dict(grad_clip=dict(max_norm=35, norm_type=2))，就此探究一下grap_clip。他的作用是梯度裁剪，为了防止梯度爆炸。其中max_norm是最大梯度阈值，norm_type是指定的范数类型。

## 梯度爆炸

梯度爆炸就是在梯度更新的时候偏导数很大，导致更新参数无法收敛到最值（总是跳到其他不好的地方）。

$$
w_1=w_1− \alpha \frac{∂J(w)}{∂w1} 
$$

$$
w_2=w_2− \alpha \frac{∂J(w)}{∂w2}
$$

![](https://img-blog.csdn.net/20180313201807699?watermark/2/text/Ly9ibG9nLmNzZG4ubmV0L2d1b2xpbmRvbmdnbGQ=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 梯度裁剪

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

## 总结

训练模型出现Loss值出现跳动，一直不收敛时，除了设小学习率之外，梯度裁剪也是一个好方法。

然而效果不佳时，那这就跟学习率和梯度爆炸没啥关系了。因此，**学习率**的设定和**梯度裁剪**的阈值并不能提高模型的准确率

