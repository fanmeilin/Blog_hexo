---
title: Windows不支持PosixPath问题
tags: [报错解决]
categories: [报错解决]
date: 2022-08-02 13:15:36
---

>在运行CVF-SID的代码时，加载模型测试出现
>报错：NotImplementedError: cannot instantiate 'PosixPath' on your system

### 原因

推测原因是作者的模型是之前在Linux环境下训练好了模型，现在我使用Windows系统加载模型导致的不兼容

### 解决办法

修改所使用环境下的lib/pathlib.py代码大概1040行的函数：

```
#修改前
def __new__(cls, *args, **kwargs):
        if cls is Path:
            cls = WindowsPath if os.name == 'nt' else PosixPath
        self = cls._from_parts(args, init=False)
        if not self._flavour.is_supported:
            raise NotImplementedError("cannot instantiate %r on your system"
                                      % (cls.__name__,))
        self._init()
        return self

```

```
#修改后    
def __new__(cls, *args, **kwargs):
        if cls is Path:
            # cls = WindowsPath if os.name == 'nt' else PosixPath
            cls = WindowsPath
        self = cls._from_parts(args, init=False)
        # Windows doesn't support PosixPath
        if type(self) == PosixPath:
            cls = WindowsPath
            self = cls._from_parts(args, init=False)
        if not self._flavour.is_supported:
            raise NotImplementedError("cannot instantiate %r on your system"
                                      % (cls.__name__,))
        self._init()
        return self

```

解决~
