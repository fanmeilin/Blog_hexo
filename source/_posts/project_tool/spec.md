---
title: 利用spec文件打包
tags: [项目打包]
categories: [工具,pyinstaller]
date: 2021-09-28 14:09:20
---

> pyinstaller打包方式一般可以分为**直接输入指令**和**利用spec文件**进行打包两种方式，直接输入指令就是根据指令生成spec文件，再根据spec文件的内容进行打包操作，因此spec文件就是核心部分，在此对其内容的相关配置进行归纳。

spec文件参数：a，pyz，exe，coll，block_cipher;
|变量  |含义  |
| :---: | :--- |
| a | Analysis类的实例,要求传入各种脚本用于分析程序的导入和依赖，a中的内容主要包括四部分：scripts：可以在命令行中输入的python脚本；pure，程序代码文件中的纯python模块；binaries：程序代码文件中需要的非python模块，包括add-binary参数指定的内容；datas：非二进制文件，包括add-data参数指定的内容 |
| pyz | pyz的实例，是一个.pyz文件，包含了所有pure的所有python模块 |
| exe | exe类的实例，这个类是用来处理Analysis和PYZ的结果。也是用来生成最后的exe可执行程序 |
| coll | collect类的实例，用于创建输出目录，在-F模式（单一exe程序）下，是没有collect实例的，并且所有脚本，模块和二进制文件都包含在最终生成的exe文件中|
| block_cipher | 加密密钥 |

