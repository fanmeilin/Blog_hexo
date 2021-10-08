---
title: pipenv的安装和使用
tags: [项目打包]
categories: [工具]
date: 2021-10-08 16:51:25
---

> pipenv 是Kenneth Reitz大神的作品，能够有效管理Python多个环境，各种包。过去我们一般用virtualenv搭建虚拟环境，管理python版本，但是跨平台的使用不太一致，且有时候处理包之间的依赖总存在问题；过去也常常用 pip进行包的管理，pip已经足够好，但是仍然推荐pipenv，相当于virtualenv和pip的合体，且更加强大。pipenv开源之后，在GitHub上有很高人气（截止于现在有9600多星）。


> 在项目打包时，项目文件104M打包之后文件5.8G，有人说，Anaconda里内置了很多库，打包的时候打包了很多不必要的模块进去，要用纯净的Python来打包。于是尝试使用pipenv虚拟环境来打包，emmm最后完成是5.2G，感觉，也，没有，多大改变吖，尤其是torch包直接占到了2.8G(这还是改了from import之后呢)。 哎 :persevere:

**pipenv主要有以下特性：**

　　（1）pipenv集成了pip，virtualenv两者的功能，且完善了两者的一些缺陷。

　　（2）过去用virtualenv管理requirements.txt文件可能会有问题，Pipenv使用Pipfile和Pipfile.lock，后者存放将包的依赖关系，查看依赖关系是十分方便。

　　（3）各个地方使用了哈希校验，无论安装还是卸载包都十分安全，且会自动公开安全漏洞。。

　　（4）通过加载.env文件简化开发工作流程。

　　（5）支持Python2 和 Python3，在各个平台的命令都是一样的。

下面快速介绍pipenv的基本使用，文章末尾有其github链接。本文的测试环境是windows下的Python3.6，对于其他平台同样适用。

## 1 安装pipenv

```python
pip install pipenv
```

## 2 创建虚拟环境

新建文件夹在文件夹中建立虚拟环境。

```python
mkdir envfile
cd envfile
pipenv install
```

初始化好虚拟环境后，会在项目目录下生成2个文件`Pipfile`和`Pipfile.lock`。为pipenv包的配置文件，代替原来的 requirement.txt。

项目提交时，可将`Pipfile` 文件和`Pipfile.lock`文件一并提交，待其他开发克隆下载，根据此Pipfile 运行命令`pipenv install --dev`生成自己的虚拟环境。

`Pipfile.lock` 文件是通过hash算法将包的名称和版本，及依赖关系生成哈希值，可以保证包的完整性。

## 3 安装包

在虚拟环境下安装包

可以使用

```python
pipenv install package
```

或者先进入虚拟环境中再安装包。

```python
pipenv shell  #激活虚拟环境
pip install package
```

也可使用txt文件来安装包

```python
pipenv install -r requirements.txt #通过requirements文件安装包
```
requirements.txt文件形如

```
# pip install -r requirements.txt

# base ----------------------------------------
matplotlib>=3.2.2
numpy>=1.18.5
opencv-python>=4.1.2
Pillow
PyYAML>=5.3.1
scipy>=1.4.1
torch==1.8.2
torchvision>=0.9.2
tqdm>=4.41.0
PyQt5
fpdf
# logging -------------------------------------
#tensorboard>=2.4.1
# wandb

# plotting ------------------------------------
seaborn>=0.11.0
pandas
requests
```

## 4 相关的命令

```python
pipenv --py    #显示python解释器信息
pipenv --where #显示本地工程路径
pipenv --venv  #显示虚拟环境信息
pipenv graph   #显示目前安装的库以及依赖关系
pipenv uninstrall package #卸载依赖包
pipenv uninstall --all    #卸载全部依赖包
exit                      #退出虚拟环境
pipenv --rm               #删除虚拟环境
```

#### 运行代码

```python
pipenv run python XXX.py
或者
pipenv shell
python XXX.py
```

## 5 pyinstaller打包压缩

### 第一次打包

```python
pip install pipenv        #安装pipenv库
pipenv install            #新建环境，cd进入，建立虚拟环境
pipenv shell              #进入虚拟环境
pip install [...]         #安装项目所需的模块
pip install pyinstaller   #安装打包的模块
pyinstaller 参数 [..]      #打包
```

生成dist文件夹和结果。

### 再次打包

```python
pipenv shell               #cd进入之前创建的虚拟环境文件夹，进入虚拟环境
pip install [new package]  #安装新模块
pyinstaller 参数 [...]      #再次打包
```

