---
title: python将图片存进PDF中
tags: python
categories: python
date: 2021-10-06 10:43:13
---

> 在公安部足迹项目中，需要将矫正的足迹图片打印出来，所有首先转成pdf文件中再进行打印。就涉及到将图片存入pdf中，这里使用的工具是FPDF。FPDF是一个pdf文件的处理库，我们可以个性化创建和规范设定pdf文件。
> 

### 安装

```python
pip install fpdf
```

### 具体内容

#### 实现代码

```python
from fpdf import FPDF
import glob
def imagesTopdf(imagesPath,pdfName):
    pdf = FPDF()
    for imagePath in imagesPath:
        pdf.add_page()
        pdf.image(imagePath,x=0,y=0,w=170,h=297)
    pdf.output(pdfName,"F")

images = glob.glob("current_revise/"+"*.jpg")
# jpg_path = "test.jpg"
pdf_path = "test_file3.pdf"
imagesTopdf(images,pdf_path)
```

#### 相关参数

1，其中`pdf = FPDF()`是创建对象，默认是：

2，`orientation`为竖向（P：竖向，L横向）；

3，`unit`为mm毫米。用于表示文档中位置的计量单元。可用的值有以下四种:

- pt: 点
- mm: 毫米
- cm: 厘米
- in: 英寸

4，`format`用于表示创建的PDF文档的纸张类型。可用值可以是用于表示纸的字符串，如"A4"、"A5"、"Letter"等。

```python
class FPDF(object):
    "PDF Generation class"
    def __init__(self, orientation='P',unit='mm',format='A4')
```

#### 相关函数

`pdf.add_page()`用于创建新页。

` pdf.image(imagePath,x=0,y=0,w=170,h=297)`是用于添加图像，其中`x`和`y`表示图片所在的坐标，`width`和`height`表示图片的宽度和高度。如果需要图片保持原来的大小，只需要将`width`和`height`设置成`0`即可。矫正后的图片是1700，2981；A4纸的尺寸是210*297，所以只能设置为297，也就是说这里误差至少有1.1mm

image源代码如下：

```python
    def image(self, name, x=None, y=None, w=0,h=0,type='',link=''):
        "Put an image on the page"
        if not name in self.images:
            #First use of image, get info
            if(type==''):
                pos=name.rfind('.')
                if(not pos):
                    self.error('image file has no extension and no type was specified: '+name)
                type=substr(name,pos+1)
            type=type.lower()
            if(type=='jpg' or type=='jpeg'):
                info=self._parsejpg(name)
            elif(type=='png'):
                info=self._parsepng(name)
            else:
                #Allow for additional formats
                #maybe the image is not showing the correct extension,
                #but the header is OK,
                succeed_parsing = False
                #try all the parsing functions
                parsing_functions = [self._parsejpg,self._parsepng,self._parsegif]
                for pf in parsing_functions:
                    try:
                        info = pf(name)
                        succeed_parsing = True
                        break;
                    except:
                        pass
                #last resource
                if not succeed_parsing:
                    mtd='_parse'+type
                    if not hasattr(self,mtd):
                        self.error('Unsupported image type: '+type)
                    info=getattr(self, mtd)(name)
                mtd='_parse'+type
                if not hasattr(self,mtd):
                    self.error('Unsupported image type: '+type)
                info=getattr(self, mtd)(name)
            info['i']=len(self.images)+1
            self.images[name]=info
        else:
            info=self.images[name]
        #Automatic width and height calculation if needed
        if(w==0 and h==0):
            #Put image at 72 dpi
            w=info['w']/self.k
            h=info['h']/self.k
        elif(w==0):
            w=h*info['w']/info['h']
        elif(h==0):
            h=w*info['h']/info['w']
        # Flowing mode
        if y is None:
            if (self.y + h > self.page_break_trigger and not self.in_footer and self.accept_page_break()):
                #Automatic page break
                x = self.x
                self.add_page(self.cur_orientation)
                self.x = x
            y = self.y
            self.y += h
        if x is None:
            x = self.x
        self._out(sprintf('q %.2f 0 0 %.2f %.2f %.2f cm /I%d Do Q',w*self.k,h*self.k,x*self.k,(self.h-(y+h))*self.k,info['i']))
        if(link):
            self.link(x,y,w,h,link)
```

