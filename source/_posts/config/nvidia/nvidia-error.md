---
title: NVIDIA驱动失效简单解决方案
tags: [配置,nvidia]
categories: [配置,nvidia]
date: 2022-07-11 11:24:48
---

> 跑模型的时候出现报错cuda找不到了，输入命令nvidia-smi报错： NVIDIA-SMI has failed because it couldn‘t communicate with the NVIDIA driver.

以下方法，不需要重装驱动，简单快捷。适用于Ubuntu系统下，之前已经安装过驱动，但驱动失效的问题。如果此方法仍然无法解决问题，可参考[Ubuntu下安装nvidia显卡驱动](https://blog.csdn.net/wjinjie/article/details/108512153)，重装驱动。

### 查看

```
NVIDIA-SMI has failed because it couldn't communicate with the NVIDIA driver. 
Make sure that the latest NVIDIA driver is installed and running.
```

主要原因还是系统内核升级了，导致**新版本内核和原来显卡驱动不匹配**

### 检查驱动

```
nvcc -V
```

输入

```
nvcc: NVIDIA (R) Cuda compiler driver
Copyright (c) 2005-2019 NVIDIA Corporation
Built on Wed_Oct_23_19:24:38_PDT_2019
Cuda compilation tools, release 10.2, V10.2.89
```

发现驱动是存在的，于是进行下一步

### 查看驱动版本
```
ls /usr/src | grep nvidia
输入 nvidia-440.33.01
```

### 修改版本号

```
sudo apt-get install dkms
sudo dkms install -m nvidia -v 440.33.01
```

### 成功解决

![](https://picture.mulindya.com/nvidia-error.png)
