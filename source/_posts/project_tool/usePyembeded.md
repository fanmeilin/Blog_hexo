---
title: python-embeded打包文件生成exe
tags: [项目打包]
categories: [工具,python-embeded]
date: 2021-12-29 09:58:14
---
> 使用pyinstaller打包的文件太大了！！所以！所以！学到了另一招，将所需的环境配置到python-embeded中，然后使用c来调用py的启动文件，再gcc生成exe文件，酱紫工程文件就会小很多；实践证明，pyinstaller打包5.2G，采用这种方式后降低到1.5G哦~ 这种方式主要就是使用python-embeded来配置环境。

## 下载embeded版本

- python37的[embedded版本](https://link.zhihu.com/?target=https%3A//www.python.org/downloads/release/python-373/)
- 下载zip文件解压到某处，比如`E:\python_embeded\`

![](https://picture.mulindya.com/python-embeded1.png)

## 安装pip

- 去[官网](https://link.zhihu.com/?target=https%3A//pip.pypa.io/en/stable/installing/%23id7)下载get-pip.py

- 点击installation,下载[get-pip.py]( https://bootstrap.pypa.io/get-pip.py.)文件到`E:\python_embeded\`

- 运行该文件。注意使用emdeded版本的python来运行配置要**带路径**哦！

  ```apl
  #打开cmd,cd到相应的目录下（E:\python_embeded\），运行下载的文件
  E:\python_embeded\python.exe  get-pip.py
  ```
  
## 配置相关环境
常规配置pytorch时，使用以下代码
```python
#cpu 版本
pip install torch==1.8.1 torchvision==0.9.1 torchaudio==0.8.1

# CUDA 10.2
conda install pytorch==1.8.1 torchvision==0.9.1 torchaudio==0.8.1 cudatoolkit=10.2 -c pytorch

# CUDA 10.2
pip install torch==1.8.1+cu102 torchvision==0.9.1+cu102 torchaudio==0.8.1 -f https://download.pytorch.org/whl/torch_stable.html
```

在python-embeded中，要带上路径哦！

```python
#打开cmd,cd到相应的目录下（E:\python_embeded\），运行下载的文件
这里使用cpu的torch版本，够用了并且文件更小。
E:\python_embeded\Scripts\pip.exe  install 相关配置(torch==1.8.1 torchvision==0.9.1 torchaudio==0.8.1 )
    
E:\python_embeded\Scripts\pip.exe  install -r requirements.txt #一样的操作
```

### 配置tkinter

如果项目使用tkinter的话，就单独配置。由于python embedable是不带tkinter的，而且无法通过pip来安装，解决方法：下载一个与python embedable版本相同的python安装包，安装时不要加入环境变量（如果你电脑上已经有anaconda的话），然后将安装路径下的一些文件复制到python embedable的路径下

> /tcl 拷贝到 /
>
> /Lib/tkinter 拷贝到 /Lib/site-packages/
>
> /DLLs/_tkinter.pyd 拷贝到 /
>
> /DLLs/tcl86t.dll 拷贝到 /
>
> /DLLs/tk86t.dll 拷贝到 / 

### 打包

然后！把这个配置好的embeded文件直接放进项目文件夹中。把启动程序的py文件头中加入以下代码，它的作用是写入环境变量中，这样如果有自定义的包调用才可以找得到哟。

```python
import os
cwd=os.getcwd()
import sys
sys.path.append(cwd)
```

#### 新建.bat文件

上面是取消黑框命令行，下面是调用启动程序！双击即可运行！

```apl
@echo off 
if "%1" == "h" goto begin 
mshta vbscript:createobject("wscript.shell").run("%~nx0 h",0)(window.close)&&exit 
:begin 

%CD%\python_embeded\python.exe footprint.py 
```

#### 新建.c文件

使用system来用c调用bat文件，后续把c编译为exe文件大功告成啦！

```c
#include<stdio.h>
#include<stdlib.h>

int main()
{
    system("footprint.bat");
    return 0;
}
```

#### 新建.rc文件（可选）

这个文件指定exe的icon和exe文件的详细信息

```apl
2 ICON "icon.ico"
1 VERSIONINFO
	FILEVERSION     2,3,3,3
	PRODUCTVERSION  2,3,3,3
	FILEOS 0x4L
	BEGIN
	BLOCK "StringFileInfo"
	BEGIN
		BLOCK "080404E4"
		BEGIN
		VALUE "CompanyName", "hust"
		VALUE "FileDescription", "Project General Launcher"
		VALUE "FileVersion", "1.0"
		VALUE "InternalName", "Launcher on Windows"
		VALUE "LegalCopyright", "GPLv2"
		VALUE "OriginalFilename", "足迹矫正"
		VALUE "ProductName", "足迹矫正与标注"
		VALUE "ProductVersion", "2.3.3 build 42"
		VALUE "Comments", "足迹矫正"
		END
	END
	
	BLOCK "VarFileInfo"
	BEGIN
		VALUE "Translation", 0x0804, 1252
	END
	END
```

### 编译成exe

上面命令会生成demo.o目标文件，链接的时候加上这个目标文件编译出来的exe文件就有图标了呀！okk！结束啦~真是艰辛......

```apl
windres -i "demo.rc" -o "demo.o"
gcc main.c demo.o -o demo.exe
```
#### 安装gcc

```apl
gcc -v
```
如果没有gcc的话，参考这边博客https://zhuanlan.zhihu.com/p/47935258
简单来说就是安装Mingw，然后添加minge32-gcc-g++,点击apply change就可以下载
