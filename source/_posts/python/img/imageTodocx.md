---
title: 将图像保存值Word中
tags: [python,图像]
categories: [python,图像]
date: 2021-12-10 13:20:28
---

>利用python，向Word中保存信息，这里主要是记录对图像的保存；

## 按照python-docx

python-docx is a Python library for creating and updating Microsoft Word (.docx) files.
```
pip install python-docx
```

## 文档相关操作
### 插入图片
```python
# 导入模块
from docx import Document
# 此模块中包含 docx 中各类单位方法
from docx import shared

doc = Document()
doc.add_heading('python-docx 基础讲解（二）')

# 在文档中增加图片,并对设置图片大小
# 当只设置一个方向的长度（宽或高）时，另一方向会自动缩放
doc.add_picture('1.png',width=shared.Inches(1))  # 按英寸设置
doc.add_picture('1.png',height=shared.Cm(2))  # 按厘米设置
#也可以按照毫米设置shared.Mm(2)

# 保存文件
doc.save('test2.docx')
```
### 页面大小设置

```python
from docx import Document # 导入docx包
from docx.shared import Cm, Inches, Pt # 导入单位换算函数
document = Document() # 新建word文档
section = document.sections[0] # 获取section对象
print('默认页面的宽度和高度：', section.page_width.cm,
section.page_height.cm) # 打印默认页面宽度和高度
section.page_width = Cm(40)
section.page_height = Cm(40)

#A3纸的格式是297*420mm
```

