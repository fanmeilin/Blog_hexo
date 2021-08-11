---
title: dvc相关设置
tags: [dvc]
categories: dvc
date: 2021-08-10 17:36:32
---

>

运行 sh setup.sh detection报错：

> (base) root@9b1a4b217508:/workspace/fanmeilin/project/task/ai_lab# sh setup.sh detection
> setup.sh: 12: setup.sh: dvc: not found
> cp: failed to get attributes of 'assets/examples': No such file or directory
> [*] copy DETECTION skeleton scripts to upper directory

原因是未安装dvc，运行下面的命令安装dvc

```
pip install dvc==2.3.0
pip install 'dvc[s3]'
```

> 在Win平台下可能会报错：
>
> ```
> ERROR: Cannot uninstall 'ruamel-yaml'. It is a distutils installed project and thus we cannot accurately determine which files belong to it which would lead to only a partial uninstall.
> ```
>
> 此时需要进入python 的lib/site-packages 中删除 ‘ruamel-yaml’ 相关的文件

**注意：** dvc 2.3.0 版本与之后的hash计算方法不同，不能混用

再次执行 sh setup.sh detection报错

> ERROR: unexpected error - Cannot connect to host ceph01:80 ssl:default [Name or service not known]: [Errno -2] Name or service not known  

则修改etc/hosts文件

- 配置hosts文件，在hosts文件中增加以下内容
  `192.168.10.91 ceph01`

##### *详细dvc的各种操作，可移步* [师兄博客 DVC 使用手册](https://www.zywvvd.com/2020/12/17/dvc/dvc/)

