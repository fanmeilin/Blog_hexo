---
title: 随机数的总结
tags: numpy
categories: 包的使用
date: 2021-09-09 20:48:15
---

> 经常会用到随机数，在此，对numpy包中的随机数相关函数进行总结。

- numpy.random.rand(d0, d1, ..., dn)
 该函数可以指定shape，返回服从0~1均匀分布的随机样本值。

- numpy.random.randint(low, high=None, size=None, dtype='l')
 该函数返回随机的整数，可以指定随机数组范围和大小；在这里low是包含，high不包含;默认数据类型是long。

- numpy.random.randn(d0, d1, ..., dn)
 该函数与rand类似，但是分布不同，这里是返回服从标准正态分布的随机样本值。
  
- numpy.random.uniform(low=0.0, high=1.0, size=None)
 该函数与randint类似，可以指定范围和大小，但是这里返回的随机数服从区间的均匀分布。
   
- numpy.random.choice(a, size=None, replace=True, p=None)
 该函数的作用是在给定的数据点中（一维数组）随机不重复的抽取大小为size的样本数据。

- numpy.random.random_sample(size=None)
 该函数是在[0,1)的范围随机返回指定大小的浮点数。也就是说与numpy.random.rand()类似，但是这里是需要输入size，而rand直接输入维度即可。

