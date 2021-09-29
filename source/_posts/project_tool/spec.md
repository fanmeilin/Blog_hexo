---
title: 利用spec文件打包
tags: [项目打包]
categories: [工具,pyinstaller]
date: 2021-09-28 14:09:20
---

> pyinstaller打包方式一般可以分为**直接输入指令**和**利用spec文件**进行打包两种方式，直接输入指令就是根据指令生成spec文件，再根据spec文件的内容进行打包操作，因此spec文件就是核心部分，在此对其内容的相关配置进行归纳。

### spec文件参数

spec文件参数：a，pyz，exe，coll，block_cipher;
|变量  |含义  |
| :---: | :--- |
| a | Analysis类的实例,要求传入各种脚本用于分析程序的导入和依赖，a中的内容主要包括四部分：scripts：可以在命令行中输入的python脚本；pure，程序代码文件中的纯python模块；binaries：程序代码文件中需要的非python模块，包括add-binary参数指定的内容；datas：非二进制文件，包括add-data参数指定的内容 |
| pyz | pyz的实例，是一个.pyz文件，包含了所有pure的所有python模块 |
| exe | exe类的实例，这个类是用来处理Analysis和PYZ的结果。也是用来生成最后的exe可执行程序 |
| coll | collect类的实例，用于创建输出目录，在-F模式（单一exe程序）下，是没有collect实例的，并且所有脚本，模块和二进制文件都包含在最终生成的exe文件中|
| block_cipher | 加密密钥 |

以上内容中修改比较多的是a,exe的内容，coll和pyz基本上没有遇到需要修改的情况。

### 参数a，exe的说明
下面对a和exe参数内容进行详细介绍：
| 参数 | 子参数 |具体含义 |
| :--: | :--: | :--|
| Analysis参数 | scripts  | 第一个参数，他是一个脚本列表，可以传入多个py脚本，效果与命令行中指定多个py文件相同，比如说“pyinstaller XXX1.py XXX2.py”，pyinstaller会依次分析执行，并且把第一个py文件的名称作为spec和dist下的文件夹及程序名称|
| Analysis参数 | pathex   | 默认有一个spec目录，当我们有一些模块不在该项目路径下的时候，可以将使用到的模块路径添加到pathex变量中，相当于“-p DIR/-paths DIR”|
| Analysis参数 | datas    | 作用是将本地文件打包时拷贝到目标路径下。datas是一个元素为元组的列表，每个元组有两个元素，都必须是字符串类型，元组的第一个元素是数据文件（文件夹），元组的第二个元素为运行时这些文件（文件夹）的位置。例如：datas = [('./src/a.txt','./dst')]表示打包时将'./src/a.txt'文件添加到相对exe目录先的dist目录中，也可以使用通配符datas = [('./myfile/*.mp3','sfx')]，表示将myfile下的所有mp3文件都copy到sfx文件夹中，也可以添加整个文件夹：datas = [('./myfile/data','data')]，表示将myfile下的data文件夹下所有文件都copy到data文件夹下，同命令“-add-data” |
| Analysis参数 | binaries | 添加二进制文件，也是一个列表，定义方式与datas参数一样，同命令“-add-binary” |
| Analysis参数 | hiddenimports|指定脚本中需要隐式导入的模块，比如在import、imp.find_module()、exec、eval等语句中导入模块，这些模块PyInstaller是找不到的，需要手动指定导入，这个选项可以使用多次。同命令“–hidden-import MODULENAME/–hiddenimport MODULENAME”。|
| Analysis参数 | hookspath |指定额外的hook文件（可以是py文件）的查找路径，这些文件的作用是在pyinstaller运行时改变一些python或者其他库原有的函数或者变量的执行逻辑（并不会改变这些库本身的代码），以便能顺利的打包完成，这个选项可以使用多次。同命令“–additional-hooks-dir HOOKSPATH”。|
| Analysis参数 | runtime_hooks |指定自定义的运行hook文件路径（可以时py文件），在打包好的exe程序中，运行这个exe程序时，指定的hook文件会在所有代码和模块之前运行，包括main文件，以满足一些运行环境的特殊要求，这个选项可以使用多次，同命令“-runtime-hook RUNTIME_HOOKS”.|
| Analysis参数 | excludes |指定可以被忽略的可选的模块或包，因为某些模块只是PyInstaller根据自身的逻辑去查找的，这些模块对于exe程序本身并没有用到，但是在日志中还是会提示“module not found”，这种日志可以不用管，或者使用这个参数选项来指定不用导入，这个选项可以使用多次。同命令“–exclude-module EXCLUDES”。|
| exe参数 | console |设置是否显示命令行窗口，同命令 “-W/-c”|
| exe参数 | icon |设置程序图标，默认spec是没有图标的，需要手动添加，参数值就是图片路径的字符串，同命令“-i/-icon”|

### 我的记录

在此记录一下detectui的spec文件呢~~~

```python
# -*- mode: python ; coding: utf-8 -*-


block_cipher = None


a = Analysis(['detectui.py',
              'E:\\masterProjects\\foot\\footRevise\\utils\\__init__.py',
              'E:\\masterProjects\\foot\\footRevise\\utils\\torch_utils.py',
              'E:\\masterProjects\\foot\\footRevise\\utils\\autoanchor.py',
              'E:\\masterProjects\\foot\\footRevise\\utils\\datasets.py',
              'E:\\masterProjects\\foot\\footRevise\\utils\\general.py',
              'E:\\masterProjects\\foot\\footRevise\\utils\\google_utils.py',
              'E:\\masterProjects\\foot\\footRevise\\utils\\metrics.py',
              'E:\\masterProjects\\foot\\footRevise\\utils\\plots.py',
              'E:\\masterProjects\\foot\\footRevise\\models\\__init__.py',
              'E:\\masterProjects\\foot\\footRevise\\models\\common.py',
              'E:\\masterProjects\\foot\\footRevise\\models\\experimental.py',
              'E:\\masterProjects\\foot\\footRevise\\models\\yolo.py',
              'E:\\masterProjects\\foot\\footRevise\\detectInfo.py',
              ],
             pathex=['E:\\masterProjects\\foot\\footRevise',
             'E:\\masterProjects\\foot\\footRevise\\models',
             'E:\\masterProjects\\foot\\footRevise\\utils',
             'D:\\anaconda3\\envs\\torch\\Lib\\site-packages\\scipy\\.libs',
             'D:\\anaconda3\\envs\\torch\\Lib\\site-packages\\torch\\lib',
              ],
             binaries=[],
             datas=[
             ('E:\\masterProjects\\foot\\footRevise\\weights\\best.pt','.\\weights'),
             ('E:\\masterProjects\\foot\\footRevise\\models\\*.yaml','.\\models'),
             ('E:\\masterProjects\\foot\\footRevise\\models\\hub\\*.yaml','.\\models\\hub'),
             ('E:\\masterProjects\\foot\\footRevise\\icon.jpg','.'),
             ('E:\\masterProjects\\foot\\footRevise\\utils\\__pycache__\\torch_utils.pyc','.\\utils'),
             ],
             hiddenimports=['pkg_resources.py2_warn','pkg_resources.markers'],
             hookspath=[],
             hooksconfig={},
             runtime_hooks=[],
             excludes=[],
             win_no_prefer_redirects=False,
             win_private_assemblies=False,
             cipher=block_cipher,
             noarchive=False)
for d in a.datas:
    if '_C.cp38-win_amd64.pyd' in d[0]:
		    a.datas.remove(d)
		    break
pyz = PYZ(a.pure, a.zipped_data,
             cipher=block_cipher)

exe = EXE(pyz,
          a.scripts,
          [],
          exclude_binaries=True,
          name='detectui',
          debug=False,
          bootloader_ignore_signals=False,
          strip=False,
          upx=True,
          console=False,
          icon='icon.ico')
coll = COLLECT(exe,
               a.binaries,
               a.zipfiles,
               a.datas,
               strip=False,
               upx=True,
               name='detectui')

```

