---
title: 计算模型的GFlops和Params
tags: [python]
categories: [python]
date: 2022-06-04 16:18:36
---



> 计算模型的参数量和计算量可以更加公平的评估模型的真实效果，记录一些使用的工具来测量。
>
> **torchstat.stat**：计算[Pytorch](https://so.csdn.net/so/search?q=Pytorch&spm=1001.2101.3001.7020)模型的FLOPs、模型参数量、MAdd、模型显存占用量
> **thop**：工具包仅支持FLOPs和参数量的计算
> **ptflops**：统计 参数量 和 FLOPs
> **torchsummary**：用来计算网络的计算参数等信息

### 概念

`FLOPs`是floating point operations的缩写（s表复数），意指浮点运算数，理解为计算量，用以衡量算法/模型复杂度。
`MACs` 每秒执行的定点乘累加操作次数的缩写，它是衡量计算机定点处理能力的量，这个量经常用在那些需要大量定点乘法累加运算的科学运算中，记为`MACs`。

> GMAC=0.5GFLOPs

### 换算

一个 MFLOPS (megaFLOPS) 等于每秒1百万 (=10^6) 次的浮点运算，
一个 GFLOPS (gigaFLOPS) 等于每秒10亿 (=10^9) 次的浮点运算，
一个 TFLOPS (teraFLOPS) 等于每秒1万亿 (=10^12) 次的浮点运算，
一个 PFLOPS (petaFLOPS) 等于每秒1千万亿 (=10^15) 次的浮点运算

### thop

#### 安装

```
pip install thop
```

#### 使用方法

```python
from thop import profile, clever_format
import torch
from networks import Network
sigmaFlag = False
net = Network
input = torch.randn(1, 3, 224, 224)
flops, params = profile(net, inputs=(input,))
flops, params = clever_format([flops, params], "%.3f")
print('FLOPs = ' , flops)
print('Params = ',params)
```

### ptflops

#### 安装

```
pip install ptflops 或者 pip install --upgrade git+https://github.com/sovrasov/flops-counter.pytorch.git
```

#### 使用方法

```python
import torchvision.models as models
import torch
from ptflops import get_model_complexity_info

with torch.cuda.device(0):
  net = models.densenet161()
  macs, params = get_model_complexity_info(net, (3, 224, 224), as_strings=True,
                                           print_per_layer_stat=True, verbose=True)
  print('{:<30}  {:<8}'.format('Computational complexity: ', macs))
  print('{:<30}  {:<8}'.format('Number of parameters: ', params))
```

其中print_per_layer_stat用来管理是否输出每一层的参数量和计算量。
