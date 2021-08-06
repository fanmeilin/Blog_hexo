---
title: 子模块为空的解决方案
date: 2021-08-06 02:09:00
tags: git
categories: git
---

> 针对子模块文件夹为空的情况，采取下列解决方案。
>
> 当一个 git 项目包含子模块（submodule) 时，直接克隆下来的子模块目录里面是空的。

**有两种方法解决**：

### 方法一

如果项目已经克隆到了本地，执行下面的步骤：

1. 初始化本地子模块配置文件

   ```
   git submodule init
   1
   ```

2. 更新项目，抓取子模块内容。

   ```
   git submodule update
   ```

### 方法二

另外一种更简单的方法，就是在执行 `git clone` 时加上 `--recursive` 参数。它会自动初始化并更新每一个子模块。例如：

```
git clone --recursive https://github.com/example/example.git
```

