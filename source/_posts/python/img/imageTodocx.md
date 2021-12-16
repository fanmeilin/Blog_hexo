---
title: 将图像保存至Word中
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



## 其他功能

### 打开文档

你需要的第一件事是工作的文档。最简单的方法是：

```python
from docx import Document
document = Document()
```

这将打开一个基于默认“模板”的空白文档，您可以打开并使用现有的Word文档的工作`python-docx`，我们会让事情变得简单。

 

### 增加一段

段落是Word的基础。它们用于正文文本，但也用于标题和列表项目（如项目符号）。

这里是添加一个最简单的方法：

```python
paragraph = document.add_paragraph('Lorem ipsum dolor sit amet.')
```

此方法返回对段落的引用，新添加的段落在文档的结尾。新的段落引用被分配给`paragraph` 在这种情况下，我将要离开了这一点在下面的例子中，除非我有一个需要它。在你的代码中，通常你不会对项目做任何事情，在添加它，所以没有什么意义，保持引用它挂在周围。

还可以使用一个段落作为“光标”，并在其上直接插入一个新段落：

```python
prior_paragraph = paragraph.insert_paragraph_before('Lorem ipsum')
```

这允许将一个段落插入到文档的中间，这在修改现有文档时通常很重要，而不是从头开始生成。

 

### 添加标题

在除了最短文档之外的任何内容中，正文文本被分成多个部分，每个部分以一个标题开始。以下是如何添加一个：

```python
document.add_heading('The REAL meaning of the universe')
```

默认情况下，这会添加顶级标题，Word中显示为“标题1”。当您需要子节的标题时，只需指定所需的级别为1到9之间的整数：

```python
document.add_heading('The role of dolphins', level=2)
```

如果指定级别0，将添加“标题”段落。这可以方便地启动一个相对较短的文档，没有单独的标题页。

 

### 添加分页符

每隔一段时间，你想要下一个文本在一个单独的页面，即使你所在的一个不是满的。“hard”分页符可以做到这一点：

```python
document.add_page_break()
```

如果你发现自己经常使用它，这可能是一个标志，你可以通过更好地了解段落样式受益。可设置的一个段落样式属性是在包含该样式的每个段落之前立即断开页面。因此，您可以将标题设置为某个级别，以便始终启动新页面。更多风格后。它们对于真正充分利用Word至关重要。

 

### 添加表

一个经常遇到的内容，它自己的表格呈现，排列在整齐的行和列。Word在这方面做得相当不错。以下是添加表格的方法：

```python
table = document.add_table(rows=2, cols=2)
```

表具有几个属性和方法，您将需要它们来填充它们。访问单个单元格可能是一个好的开始的地方。作为基线，您可以始终按其行和列指示访问单元格：

```python
cell = table.cell(0, 1) #根据行列指定
```

这就给出了我们刚刚创建的表格最上面一行的右边单元格。注意，行和列指示是基于零的，就像在列表访问中一样。

一旦你有一个单元格，你可以把东西在它：

```python
cell.text = 'parrot, possibly dead'
```

通常，一次访问一行单元格更容易，例如，当从数据源填充可变长度的表时。在`.rows` 一个表中的属性提供给单独的行，每个都具有一个 `.cells`属性。该`.cells`两个物业`Row`和`Column` 支持索引访问，就像一个列表：

```python
row = table.rows[1]
row.cells[0].text = 'Foo bar to you.'
row.cells[1].text = 'And a hearty foo bar to you too sir!'
```

在`.rows`和`.columns`桌子上的集合是可迭代的，这样你就可以直接在使用它们`for`循环。相同的`.cells`上行或列序列：

```python
for row in table.rows:
    for cell in row.cells:
        print(cell.text)
```

如果你想在表中的行或列的计数，只要使用`len()`的顺序：

```python
row_count = len(table.rows)
col_count = len(table.columns)
```

您还可以以递增方式向表中添加行，如下所示：

```python
row = table.add_row()
```

这对于我们上面提到的可变长度表场景非常方便：

```python
# get table data -------------
items = get_things_from_database_or_something()
 
# add table ------------------
table = document.add_table(1, 3)
 
# populate header row --------
heading_cells = table.rows[0].cells
heading_cells[0].text = 'Qty'
heading_cells[1].text = 'SKU'
heading_cells[2].text = 'Description'
 
# add a data row for each item
for item in items:
    cells = table.add_row().cells
    cells[0].text = str(item.qty)
    cells[1].text = item.sku
    cells[2].text = item.desc
```

同样的工作对列，虽然我还没有看到它的一个用例。

Word具有一组预格式化的表格样式，您可以从其表格样式库中选择。您可以将其中的一个应用于表格，如下所示：

```python
table.style = 'LightShading-Accent1'
```

通过从表样式名称中删除所有空格形成样式名称。通过将鼠标悬停在Word的表样式库中的缩略图上，可以找到表样式名称。

### 添加图片

Word中，您可以将图像使用的文档中的菜单项。以下是如何做到这一点的：`Insert > Photo > Picture fromfile...``python-docx`

```python
document.add_picture('image-filename.png')
```

此示例使用路径，从本地文件系统加载图像文件。你也可以使用一个*类文件对象*，本质上就像一个打开的文件的任何对象。如果您从数据库或网络检索图像，并且不想获取涉及的文件系统，这可能很方便。

#### 图像大小

默认情况下，添加图像出现在*本地*的大小。这通常比你想要的更大。本机大小的计算方法。因此，具有300dpi分辨率的300×300像素图像出现在一平方英寸。问题是大多数图像不包含dpi属性，它默认为72 dpi。这将使同一图像在一边，在一半左右的某处出现4.167英寸。`pixels / dpi`

要获得所需的图像大小，您可以以方便的单位指定其宽度或高度，如英寸或厘米：

```python
from docx.shared import Inches
document.add_picture('image-filename.png', width=Inches(1.0))
```

你可以自由地指定宽度和高度，但通常你不想要。如果仅指定一个，`python-docx`用它来计算出其他的适当换算值。这样的*高宽比*是保留的，你的图像看起来不拉伸。

在`Inches`和`Cm`提供课程，让你指定派上用场单位进行测量。在内部，`python-docx`使用英语公制单位，914400为英寸。所以，如果你忘记了，只是把喜欢的东西`width=2`，你会得到一个非常小的图像:)。你需要从导入`docx.shared` 子包。你可以在算术中使用它们，就像它们是一个整数，事实上它们是。因此，像一个表达式的作品就好了。`width = Inches(3) /thing_count`

### 应用段落样式

如果你不知道一个Word段落风格是你应该肯定检查出来。基本上，它允许您将一整套格式化选项立即应用到段落。这很像CSS样式，如果你知道那些是。

您可以在创建段落时应用段落样式：

```python
document.add_paragraph('Lorem ipsum dolor sit amet.', style='ListBullet')
```

这种特殊的风格导致段落显示为一个子弹，一个非常方便的东西。您也可以在之后应用样式。这两行相当于上面的一行：

```python
paragraph = document.add_paragraph('Lorem ipsum dolor sit amet.')
paragraph.style = 'ListBullet'
```

在此示例中，样式使用其样式ID“ListBullet”指定。通常，通过去除样式名称中出现在Word用户界面（UI）中的空格来形成样式ID。所以风格'列表3号'将被指定为`'ListNumber3'`。但是，请注意，如果您使用的是本地化版本的Word，则样式ID可能来自英语样式名称，并且可能不会完全对应于其在Word UI中的样式名称。

 
