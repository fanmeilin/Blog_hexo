---
title: RuntimeError: expected dtype Double but got dtype Float
tags: [报错解决]
categories: [报错解决]
date: 2022-02-25 19:57:16
---

>在搭建去噪网络训练的时候出现RuntimeError: expected dtype Double but got dtype Float

## 问题描述

利用[Pytorch](https://so.csdn.net/so/search?q=Pytorch&spm=1001.2101.3001.7020)框架自己构建网络结构，在程序运行到“loss.backward()”的时候报错：

```python
RuntimeError: expected dtype Double but got dtype Float
```

通过查询资料得知，该错误来自于输入数据的[类型](https://so.csdn.net/so/search?q=类型&spm=1001.2101.3001.7020)和模型参数类型不一致。因此最好在程序开始统一数据类型。

## 解决方案

### 统一为DoubleTensor

Pytorch里的[tensor](https://so.csdn.net/so/search?q=tensor&spm=1001.2101.3001.7020)创建时默认是Torch.FloatTensor类型（torch.float32),

可通过在import语句后增加语句

```python
torch.set_default_tensor_type(torch.DoubleTensor)
```

这样之后创建的变量类型都是[Double](https://so.csdn.net/so/search?q=Double&spm=1001.2101.3001.7020)类型(torch.float64)。不过这样也有些占用内存开销。

### 统一为FloatTensor

如果想要创建变量类型都是[Float](https://so.csdn.net/so/search?q=Float&spm=1001.2101.3001.7020)类型，在import后增加语句

```python
torch.set_default_tensor_type(torch.FloatTensor)
```

但是这样卷积操作也会报错，这是因为numpy的默认数据类型为float64，这样创建的tensor还是为double类型，还是会导致类型不一致的情况。

因此如果想要项目中[参数](https://so.csdn.net/so/search?q=参数&spm=1001.2101.3001.7020)类型都为Float类型，不仅要加

```
torch.set_default_tensor_type(torch.FloatTensor)
```

还要将数据转化为float32的格式：

转化为tensor类型时：

```
images = torch.Tensor(images).float() #增加.float()
```

在训练数据时：

```
inputs, targets = inputs.to(device).to(torch.float32), targets.to(device, non_blocking=True).to(torch.float32)
```

