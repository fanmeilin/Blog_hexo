---
title: 分割文件名相关操作
tags: [python,文件]
categories: [python,文件]
date: 2021-10-07 10:34:04
---

> 对文件名的相关操作总结

### 函数介绍

`os.path`相关函数

```python
os.path.split() #分割文件名
os.path.splitdrive() #分割盘符
os.path.splitext() #分割扩展名
os.path.basename() #获取文件名，split的后一元素
os.path.dirname()  #获取路径名，split的前一元素
os.path.join()     #连接path字符串
```

`os`相关函数

```python
os.walk()     #遍历路径下的文件信息和子文件信息（root，dir，file的形式）
os.listdir()  #返回路径下的文件信息
```

### 具体介绍

#### os.path.split()

`os.path.split()`函数返回路径的元组信息（父路径，文件名）

```python
Signature: os.path.split(p)
Docstring:
Split a pathname.

Return tuple (head, tail) where tail is everything after the final slash.
Either part may be empty.
File:      d:\anaconda3\lib\ntpath.py
Type:      function
    
例如：
spath = "./a/b/c/name.txt"
path,filename = os.path.split(spath)
path,filename为('./a/b/c', 'name.txt')
```

#### os.path.splitdrive()

`os.path.splitdrive()`函数返回元组信息（盘符，路径（除去盘符））

```python
Signature: os.path.splitdrive(p)
Docstring:
Split a pathname into drive/UNC sharepoint and relative path specifiers.
Returns a 2-tuple (drive_or_unc, path); either part may be empty.

If you assign
    result = splitdrive(p)
It is always true that:
    result[0] + result[1] == p

If the path contained a drive letter, drive_or_unc will contain everything
up to and including the colon.  e.g. splitdrive("c:/dir") returns ("c:", "/dir")

If the path contained a UNC path, the drive_or_unc will contain the host name
and share up to but not including the fourth directory separator character.
e.g. splitdrive("//host/computer/dir") returns ("//host/computer", "/dir")

Paths cannot contain both a drive letter and a UNC path.
File:      d:\anaconda3\lib\ntpath.py
Type:      function
    
例如：  
cpath = "C:/a/b/a.csv"
os.path.splitdrive(cpath)
('C:', '/a/b/a.csv')
```

#### os.path.splitext()

`os.path.splitext()`返回路径的元组信息（路径及文件名，扩展名）

```python
Signature: os.path.splitext(p)
Docstring:
Split the extension from a pathname.
```

#### os.path.dirname()与os.path.basename()

`os.path.dirname()`和`os.path.basename()`分别返回`split`函数的前后元素。

```python
Signature: os.path.basename(p)
Docstring: Returns the final component of a pathname
File:      d:\anaconda3\lib\ntpath.py
Type:      function
    
例如：
cpath = "C:/a/b/a.csv"
os.path.dirname(cpath) #dirpath
'C:/a/b'
os.path.basename(cpath) #filename
'a.csv'
相当于split的分解：
os.path.split(cpath)
('C:/a/b', 'a.csv')
```

#### os.path.join()

`os.path.join()`使用特定的分隔符连接路径。Windows下默认使用`\\`。Linux下默认使用`/`。

```python
Signature: os.path.join(path, *paths)
Docstring: <no docstring>
File:      d:\anaconda3\lib\ntpath.py
Type:      function
    
例如：
os.path.join('./a/b/c', "a123", 'name.txt') 
'./a/b/c\\a123\\name.txt'
```

#### os.walk()

`os.walk()`遍历文件夹下的文件和子文件夹，然后递归遍历下列子文件夹。`for root,dirs,files in os.walk(temp)`


```python
Signature: os.walk(top, topdown=True, onerror=None, followlinks=False)
Docstring:
Directory tree generator.

For each directory in the directory tree rooted at top (including top
itself, but excluding '.' and '..'), yields a 3-tuple
    dirpath, dirnames, filenames
dirpath is a string, the path to the directory.  dirnames is a list of
the names of the subdirectories in dirpath (excluding '.' and '..').
filenames is a list of the names of the non-directory files in dirpath.
Note that the names in the lists are just names, with no path components.
To get a full path (which begins with top) to a file or directory in
dirpath, do os.path.join(dirpath, name).

If optional arg 'topdown' is true or not specified, the triple for a
directory is generated before the triples for any of its subdirectories
(directories are generated top down).  If topdown is false, the triple
for a directory is generated after the triples for all of its
subdirectories (directories are generated bottom up).

Caution:  if you pass a relative pathname for top, don't change the
current working directory between resumptions of walk.  walk never
changes the current directory, and assumes that the client doesn't
either.
例如：
temp = "E:\迅雷下载"
for root,dirs,files in os.walk(temp,topdown=False):
    #遍历文件夹下的文件和子目录 root,dirs,files,topdown为false时表示从底向上，为true是从顶向下
    for name in files:
        print(os.path.join(root,name))
    for name in dirs:
        print(os.path.join(root,name))
        
E:\迅雷下载\Suplicant_for_Campus_Network_For_Windows_V6.61\Suplicant_for_Campus_Network_For_Windows_V6.61.exe
E:\迅雷下载\cuda_10.2.89_441.22_win10.exe
E:\迅雷下载\Git-2.33.0.2-64-bit.exe
E:\迅雷下载\ide-eval-resetter-2.1.13.zip
E:\迅雷下载\npp.8.1.4.Installer.exe
E:\迅雷下载\sogou_explorer_11.0.0.33862_7793.exe
E:\迅雷下载\windows_v6.61.rar
E:\迅雷下载\Suplicant_for_Campus_Network_For_Windows_V6.61 
```

#### os.listdir()

`os.listdir()`返回文件夹下的所有一级文件夹和文件。

```python
Signature: os.listdir(path=None)
Docstring:
Return a list containing the names of the files in the directory.

path can be specified as either str, bytes, or a path-like object.  If path is bytes,
  the filenames returned will also be bytes; in all other circumstances
  the filenames returned will be str.
If path is None, uses the path='.'.
On some platforms, path may also be specified as an open file descriptor;\
  the file descriptor must refer to a directory.
  If this functionality is unavailable, using it raises NotImplementedError.

The list is in arbitrary order.  It does not include the special
entries '.' and '..' even if they are present in the directory.
Type:      builtin_function_or_method
    
例如：
temp = "E:\迅雷下载"
os.listdir(temp) #列出dirname下的目录和文件
['cuda_10.2.89_441.22_win10.exe',
 'Git-2.33.0.2-64-bit.exe',
 'ide-eval-resetter-2.1.13.zip',
 'npp.8.1.4.Installer.exe',
 'sogou_explorer_11.0.0.33862_7793.exe',
 'Suplicant_for_Campus_Network_For_Windows_V6.61',
 'windows_v6.61.rar']
```

