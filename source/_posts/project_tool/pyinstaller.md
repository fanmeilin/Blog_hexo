---
title: pyinstaller打包exe
tags: [项目打包]
categories: [工具,pyinstaller]
date: 2021-09-26 20:11:18
---

> pyinstaller的作用是可以将python应用程序打包为独立的可执行文件，相对与同类工具而言，其优势在于可以和python配合使用，构建较小的可执行文件并且完全多平台，完全兼容性。

> pyinstaller的主要目标是与第三方软件包兼容，因此在使用pyinstaller会将所有的外部包继承在pyinstaller本身中。

## 安装
直接从pypi安装pyinstaller：

``` python
pip install pyinstaller
```

然后在自己的程序目录中运行

``` python
pyinstaller yourprogram.py
```
就会生成dist文件夹，在dist文件夹下可以找到对应的exe文件。

## 命令选项说明
PyInstaller 支持如表所示的常用选项。

| 选项 | 含义 |
|:----:|:----:|
| -h，--help                  | 查看该模块的帮助信息                                         |
| -F，-onefile                | 产生单个的可执行文件                                         |
| -D，--onedir                | 产生一个目录（包含多个文件）作为可执行程序（默认）               |
| -a，--ascii                 | 不包含 Unicode 字符集支持                                    |
| -d，--debug                 | 产生 debug 版本的可执行文件                                  |
| -w，--windowed，--noconsolc | 指定程序运行时不显示命令行窗口（仅对 Windows 有效）          |
| -c，--nowindowed，--console | 指定使用命令行窗口运行程序（仅对 Windows 有效）              |
| -o DIR，--out=DIR           | 指定 spec 文件的生成目录。如果没有指定，则默认使用当前目录来生成 spec 文件 |
| -p DIR，--path=DIR          | 设置 Python 导入模块的路径（和设置 PYTHONPATH 环境变量的作用相似）。也可使用路径分隔符（Windows 使用分号，Linux 使用冒号）来分隔多个路径 |
| -n NAME，--name=NAME        | 指定项目（产生的 spec）名字。如果省略该选项，那么第一个脚本的主文件名将作为 spec 的名字 |

在此表列出的只是 PyInstaller 模块所支持的常用选项，如果需要了解 PyInstaller 选项的详细信息，则可通过 pyinstaller -h 或者--help查看帮助

``` python
pyinstaller --help
```

## 使用pyinstaller

- 打包成一个单一可执行文件

  ```python
  pyinstaller -F <options> test.py
  ```

- 打包成一个文件夹

  ```
  pyinstaller --onefile/-D <options> test.py （默认）
  ```

默认情况下打包会在当前目录下生成dist和build文件夹以及.spec文件，dist中即打包出来的可执行文件目录，build文件夹下为构建过程临时文件目录，.spec为打包的配置文件。

### 各自的优缺点

- 启动时间

  单一可执行文件比文件夹的启动时间要长很多，因为当程序运行时，单一的可执行文件需要解压程序的第三方依赖文件到临时文件夹，会耗费一定的不必要时间。

- 文件结构

  单一可执行文件的文件结构和工程目录是一样的，其路径与工程目录的效果是一样的，但是生成文件夹就不一样了，若程序中包含相对路径，这个相对路径是基于该文件夹目录的。

## spec文件

.spec文件类似于cmake的.makefile文件，都是用于`控制编译构建过程`的配置文件。正常使用实际上不需要管spec文件的，但是下面几种情况需要修改spec文件：

- 需要打包资源文件

- 需要include一些pyinstaller不知道的run-time库

- 为可执行文件添加run-time选项

- 多程序打包

后面可以直接通过.spec文件来打包

```python
pyinstaller <options> test.spec
```

当通过spec文件来生成app文件时只有下面参数是有用的：

-  `-upx-dir`  Path to UPX utility (default: search the execution path)
-  `-distpath`   Where to put the bundled app (default: .\dist)
-  `-y –noconfirm`  Replace output directory (default: SPECPATH\dist\SPECNAME) without asking for confirmation
-   `-a –ascii` Do not include unicode encoding support (default: included if available)

