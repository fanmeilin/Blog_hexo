---
title: 使用python删除文件和文件夹
tags: [python,文件]
categories: [python,文件]
date: 2021-10-06 15:33:02
---

> 总结删除文件和文件夹的相关操作和函数。

### 删除单个文件

```python
os.remove(path)
# 如果path是一个目录，抛出OSError错误，如果文件不在或者路径错误，会抛出错误
```

### 删除文件夹

空文件夹
```python
os.rmdir(dirName)
os.removedirs(dirName)
# 删除目录 dirName，要求dirName必须是个空目录，否则抛出OSError错误
```

### 递归删除文件夹

非空文件夹
```python
import shutil
shutil.rmtree()
```

遍历一个文件夹，先删除子文件，再删除文件夹。

```python
for root, dirs, files in os.walk("filename", topdown=False):
    for name in files:
        os.remove(os.path.join(root, name))
    for name in dirs:
        os.rmdir(os.path.join(root, name))
 
# os.walk的第一个参数是要遍历并删除子文件夹和文件的目录
# 上面的代码运行后，文件夹"filename"里的文件夹和文件全被删除，但是文件夹"filename"还存在
# 具体可以查下os.walk()的用法，以及其参数topdown的功能
```













