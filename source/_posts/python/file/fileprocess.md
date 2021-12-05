---
title: 文件处理（复制，移动）
tags: [python,文件]
categories: [python,文件]
date: 2021-11-25 11:06:10
---

> 整理文件的复制，移动等相关操作。相关的模块涉及shuti和os包，针对这两个包对文件操作进行整理。

## shutil

shutil模块包含了一些用于复制文件和文件夹，和文件压缩的函数. 
os模块是Python标准库中一个重要的模块，里面提供了对目录和文件的一般常用操作。而Python另外一个标准库——shutil库，它作为os模块的补充，提供了复制、移动、删除、压缩、解压等操作，

### 拷贝

#### 常规复制方法


|        函数         |                             作用                             |
| :-----------------: | :----------------------------------------------------------: |
| copyfile( src, dst) | 从源src复制到dst中去。当然前提是目标地址是具备可写权限。抛出的异常信息为IOException. 当前的dst已存在的话就会被覆盖掉 |
|   copy( src, dst)   |               复制一个文件到一个文件或一个目录               |
|  copy2( src, dst)   | 在copy上的基础上再复制文件最后访问时间与修改时间也复制过来了，也就是包含文件的属性信息，类似于cp–p的东西 |

- dst：复制至dst文件夹或文件

 一般dst填写相应的文件夹，就会建立同名文件，就会复制文件到对应的文件夹下，如果要复制文件夹就不能用以上函数了。dst可以是个目录，会在该目录下创建与src同名的文件，**若该目录下存在同名文件，将会报错提示已经存在同名文件**。

#### 复制文件内容

如果是复制文件内容到某文件中，则使用`copyfile`，如果存在同名文件，可以覆盖同名文件夹。

```python
shutil.copyfile(src, dst)
功能：将src文件内容复制至dst文件

src： 源文件路径
dst： 复制至dst文件，若dst文件不存在，将会生成一个dst文件；若存在将会被覆盖
follow_symlinks：设置为True时，若src为软连接，则当成文件复制；如果设置为False，复制软连接。默认为True。Python3新增参数

import shutil
shutil.copyfile("./资料/1.txt","./资料/1_empty.txt")
```

#### 复制目录

`shutil.copytree(src, dst, symlinks=False, ignore=None)`
功能：复制整个文件目录(无论文件夹是否为空，均可以复制，而且会复制文件夹中的所有内容)

```
src：源文件夹
dst：复制至dst文件夹，该文件夹会自动创建，需保证此文件夹不存在，否则将报错
symlinks：是否复制软连接，True复制软连接，False不复制，软连接会被当成文件复制过来，默认False
ignore：忽略模式，可传入ignore_patterns()
copy_function：拷贝文件的方式，可以传入一个可执行的处理函数，默认为copy2，Python3新增参数
ignore_dangling_symlinks：sysmlinks设置为False时，拷贝指向文件已删除的软连接时，将会报错，如果想消除这个异常，可以设置此值为True。默认为False,Python3新增参数
```

##### 示例

```python
import shutil,os
shutil.copytree("./资料/ceshi","./资料/taiget/",ignore=shutil.ignore_patterns("abc.txt","bcd.txt"))#忽略哪些文件
```

### 移动

`shutil.move(src, dst)`
功能：文件移动,可重命名，会删除原文件，新路径需**指定文件名**，注意需要指定文件名，要么可以剪裁文件夹或者文件，要么可以重命名。

```
src：**源文件夹或文件**
dst：**移动至dst文件夹，或将文件改名为dst文件。**如果src为文件夹，而dst为文件将会报错
copy_function：拷贝文件的方式，可以传入一个可执行的处理函数。默认为copy2，Python3新增参数
```

##### `示例

```python
import shutil
#重命名文件夹
shutil.move('./资料/ceshi', './资料/ceshi1')
#移动文件进入新移动的文件夹
shutil.move('./资料/1-2.txt', './资料/ceshi1')
```

### 删除文件夹

函数：shutil.rmtree(src)
含义：删除文件夹；
参数：src表示源文件夹；
注意：区别这里和os模块中remove()、rmdir()的用法，remove()方法**只能删除某个文件**，**rmdir()只能删除某个空文件夹**。但是shutil模块中的rmtree()可以递归彻底**删除非空文件夹；**

```python
# 将c文件夹彻底删除
src = r".\publish\os模块\test_shutil_c"
shutil.rmtree(src)
```

### 删除文件

函数：删除文件使用`os.remove()`函数进行操作

```python
import os  # 导入模块

# 删除目标文件的根目录
movabs_path = "删除文件的目录" 

# 删除操作
os.remove(rawabs_path+"test.txt")
```

### 解压和压缩文件

函数：`make_archive(base_name, format, root_dir, …)`
功能：生成压缩文件

```
base_name：压缩文件的文件名，不允许有扩展名，因为会根据压缩格式生成相应的扩展名
format：压缩格式
root_dir：将制定文件夹进行压缩
get_archive_formats()： 获取支持的压缩文件格式。目前支持的有：tar、zip、gztar、bztar。在Python3还多支持一种格式xztar
```

#### 示例

```python
import shutil
#指定要压缩的文件
base_name = "./资料/2.txt"
#指定压缩形式
format = "zip"
#指定压缩后放在哪里
root_dir = "./资料/"

shutil.make_archive(base_name, format, root_dir)
```

函数：`unpack_archive(filename, extract_dir=None, format=None)`
功能：解压操作

```
filename：文件路径
extract_dir：解压至的文件夹路径。文件夹可以不存在，会自动生成
format：解压格式，默认为None，会根据扩展名自动选择解压格式
```

#### 示例

```python
import shutil
#指定压缩文件的地址
zip_path = "./资料/2.txt.zip"
#指定解压缩到哪里
extract_dir = "./资料/ceshi1/"
shutil.unpack_archive(zip_path, extract_dir)
```

## os

在这里整理os的相关操作哦，粗略记录一下

参考：https://blog.csdn.net/silentwolfyh/article/details/74931123

### os目录操作

1.得到当前工作目录，即当前Python脚本工作的目录路径: os.getcwd()

2.返回指定目录下的所有文件和目录名:os.listdir()

3.函数用来删除一个文件:os.remove()

4.删除多个目录：os.removedirs(r“c：\python”)

5.检验给出的路径是否是一个文件：os.path.isfile()

6.检验给出的路径是否是一个目录：os.path.isdir()

7.判断是否是绝对路径：os.path.isabs()

8.检验给出的路径是否真地存:os.path.exists()

9.返回一个路径的目录名和文件名:os.path.split() eg os.path.split(‘/home/swaroop/byte/code/poem.txt’) 结果：(‘/home/swaroop/byte/code’, ‘poem.txt’)

10.分离扩展名：os.path.splitext()

11.获取路径名：os.path.dirname()

12.获取文件名：os.path.basename()

13.运行shell命令: os.system()

14.读取和设置环境变量:os.getenv() 与os.putenv()

15.给出当前平台使用的行终止符:os.linesep Windows使用’\r\n’，Linux使用’\n’而Mac使用’\r’

16.指示你正在使用的平台：os.name 对于Windows，它是’nt’，而对于Linux/Unix用户，它是’posix’

17.重命名：os.rename(old， new)

18.创建多级目录：os.makedirs(r“c：\python\test”)

19.创建单个目录：os.mkdir(“test”)

20.获取文件属性：os.stat(file)

21.修改文件权限与时间戳：os.chmod(file)

22.终止当前进程：os.exit()

23.获取文件大小：os.path.getsize(filename)

### 2、文件操作方法大全：

1.os.mknod(“test.txt”) #创建空文件

2.fp = open(“test.txt”,w) #直接打开一个文件，如果文件不存在则创建文件

3.关于open 模式：

w：以写方式打开，

a：以追加模式打开 (从 EOF 开始, 必要时创建新文件)

r+：以读写模式打开

w+：以读写模式打开 (参见 w )

a+：以读写模式打开 (参见 a )

rb：以二进制读模式打开

wb：以二进制写模式打开 (参见 w )

ab：以二进制追加模式打开 (参见 a )

rb+：以二进制读写模式打开 (参见 r+ )

wb+：以二进制读写模式打开 (参见 w+ )

ab+：以二进制读写模式打开 (参见 a+ )

fp.read([size]) #size为读取的长度，以byte为单位

fp.readline([size]) #读一行，如果定义了size，有可能返回的只是一行的一部分

fp.readlines([size]) #把文件每一行作为一个list的一个成员，并返回这个list。其实它的内部是通过循环调用readline()来实现的。如果提供size参数，size是表示读取内容的总长，也就是说可能只读到文件的一部分。

fp.write(str) #把str写到文件中，write()并不会在str后加上一个换行符

fp.writelines(seq) #把seq的内容全部写到文件中(多行一次性写入)。这个函数也只是忠实地写入，不会在每行后面加上任何东西。

fp.close() #关闭文件。python会在一个文件不用后自动关闭文件，不过这一功能没有保证，最好还是养成自己关闭的习惯。 如果一个文件在关闭后还对其进行操作会产生ValueError

fp.flush() #把缓冲区的内容写入硬盘

fp.fileno() #返回一个长整型的”文件标签“

fp.isatty() #文件是否是一个终端设备文件(unix系统中的)

fp.tell() #返回文件操作标记的当前位置，以文件的开头为原点

fp.next() #返回下一行，并将文件操作标记位移到下一行。把一个file用于for … in file这样的语句时，就是调用next()函数来实现遍历的。

fp.seek(offset[,whence]) #将文件打操作标记移到offset的位置。这个offset一般是相对于文件的开头来计算的，一般为正数。但如果提供了whence参数就不一定了，whence可以为0表示从头开始计算，1表示以当前位置为原点计算。2表示以文件末尾为原点进行计算。需要注意，如果文件以a或a+的模式打开，每次进行写操作时，文件操作标记会自动返回到文件末尾。

### 3、目录操作方法大全

1.创建目录

os.mkdir(“file”)
