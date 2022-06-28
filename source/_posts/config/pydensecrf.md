---
title: 安装pydensecrf
tags: [配置]
categories: [配置]
date: 2022-06-28 16:17:57
---

>记录安装pydensecrf的过程。

### Windows安装

直接下载会报错，可以进入下面链接，下载对应版本的whl文件。

下载地址：https://www.lfd.uci.edu/~gohlke/pythonlibs/#pydensecrf

在对应文件夹下输入命令：

```
pip ionstall filename（.whl）
```

### linux 安装

#### python3.7 安装pydensecrf

```
// An highlighted block
pip install cython
pip install git+https://github.com/lucasb-eyer/pydensecrf.git
```

> 在官网找到的文件是适用于3.6及以下版本的，不想降版本可以使用上述方式；
>
> python3.8也可以采用这种方式。
