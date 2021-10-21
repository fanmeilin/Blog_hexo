---
title: PyQt5中放置图片
tags: python
categories: python
date: 2021-10-21 09:56:23
---

> 在pyqt中使用label显示图片，或者使用继承了QLabel的类显示图片，实现在图片上进行长度，角度测量，标注，画板等功能。

## QLabel
Qlabel部件时用于提供文本或者图像显示。Qlabel可以包含纯文本（将字符串传递给setText），富文本（将富文本传递给setText），图像（将QPixmap对象传递setPixmap），动画（将QMovie对象传递给setMovie），数字（将int或在double数字传递给setNum），空（默认，由clear设置）。

- 当Qlabel使用setText设置文本内容，因为Qlabel会判断其为纯文本还是作为HTML标记的富文本，想明确显示文本格式，则调用setTextFormat。

## 图片插入
首先使用QPixmap()创建一个QPixmap对象，使用setPixmap函数插入图片，若使用setScaledContents（True）可以设置将图片填充该label的所有可用空间，此参数默认是False。

```python
class Example(QWidget):
    def initUI(self):
		#lb1是直接插入；lb2是缩放图片填充label区域；
        pix = QPixmap('sexy.jpg')

        lb1 = QLabel(self)
        lb1.setGeometry(0,0,300,200)
        lb1.setStyleSheet("border: 2px solid red")
        lb1.setPixmap(pix)

        lb2 = QLabel(self)
        lb2.setGeometry(0,250,300,200)
        lb2.setPixmap(pix)
        lb2.setStyleSheet("border: 2px solid red")
        lb2.setScaledContents(True)
```

## 项目实例

在项目代码中有

```python
self.lab = MyLabel(self.widget)
# self.lab.setStyleSheet("QLabel{background:black;}")
img_width = 1102
img_height = 629
self.image_list = ["./temp.jpg"]
self.image = QPixmap(self.image_list[0])
self.image = self.image.scaled(img_width, img_height)
self.lab.setPixmap(self.image)
self.lab.setMinimumSize(img_width, img_height)
```

- 首先创建Qpixmap(path)

- 对Qpixmap对象scaled调整图片大小

- 我们通常会使用Qt自带的scaled()函数；QImage、QPixmap等绘图设备类都提供scaled()函数。

     scaled()是一个重载函数，按照指定的宽和高，根据给的size和aspectRatioMode从原有图像返回一个经过比例转换的图像，如果宽高为0，返回一个空图像
  所以，获取控件的改变后的宽高，就能设定图像转换的宽高转换比例，用scaled()的返回重新进行绘图即可自适应窗口。

```python
QPixmap::scaled(const QSize & size, Qt::AspectRatioMode aspectRatioMode = Qt::IgnoreAspectRatio, Qt::TransformationMode transformMode = Qt::FastTransformation) const
其中aspectRatioMode
IgnoreAspectRatio  #矩形框有多大，图片就缩放成多大，不限制原图片的长宽比
KeepAspectRatio    #保持原图片的长宽比，且不超过矩形框的大小
KeepAspectRatioByExpanding   #根据矩形框的大小最大缩放图片
```

