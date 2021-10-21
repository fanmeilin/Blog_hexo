---
title: cv读取带有中文路径的图片
tags: python
categories: python
date: 2021-10-20 21:12:21
---

> 常规在读取图片时使用的代码是`cv.imread(path)`，但是路径中出现中文时就会出现，读取为空的情况，以下给出解决方法。



## 背景

首先介绍一下`cv2.imread()函数`

```python
cv2.imread(filepath,flags)
filepath:是要读入的图片路径
flags: 读入图片的格式
cv2.IMRAED_COLOR:默认选择此参数，读入彩色图片，BGR的格式，忽略了alpha通道，也可以使用数字1代替。
cv2.IMREAD_GRAYSCALE:读入灰度图片，可以直接写0
cv2.IMREAD_UNCHANGED:顾名思义，读入完整图片，包括alpha通道，可以直接写-1（BGRA）

cv2.COLOR_BGR2GRAY:可以转换颜色空间，由BGR转换为RGB
cv2.COLOR_RGB2GRAY:有RGB转换为灰度图格式
```
> alpha通道，又称A通道，是一个8位的灰度通道，该通道用256级灰度来记录图像中的透明度复信息，定义透明、不透明和半透明区域，其中黑表示全透明，白表示不透明，灰表示半透明。如果读取的图片没有alpha通道则还是按照三通道读取。



## 解决方案

**原因：**  在读取含有中文字符的路径图片时会返回None，这是由于opencv不接受non-ascii的路径。

**方法：** 先使用numpy的fromfile将图片读取为np.uint8的格式，再使用cv的imdecode函数解码。 

**具体代码**

```python
import cv2
import numpy as np
im_path = './测试数据/temp_long.jpg'
im = cv2.imdecode(np.fromfile(im_path, dtype=np.uint8))
cv2.imshow("显示图片",im)
print(im.shape)
cv2.waitKey(0)
```
**代码具体分析：**
先不直接读取图片，而是采用`numpy`中的`fromfile`读取文件，将图片按照int类型读入数据，读入的是一维数组，然后通过cv中`imdecode`来对数组解码得到图片，`imdecode`函数的作用是`从内存缓冲区中读取图像`，如果缓冲区太短或包含无效数据时，函数返回一个空矩阵(Mat::data==NULL)。如果是彩色图像，解码后的图像将按照B G R顺序存储通道。这函数有两个参数`imdecode(buf,flags)`，buf是输入数组或字节向量，flags 与cv::imread相同的flag。

> cv2.IMREAD_COLOR：加载彩色图片，这个是默认参数，可以直接写1 （BGR形式）
> cv2.IMREAD_GRAYSCALE：以灰度模式加载图片，可以直接写0
> cv2.IMREAD_UNCHANGED：包括alpha，可以直接写-1

**保存**


'.jpg'表示把当前图片img按照jpg格式编码，按照不同格式编码的结果不一样

```python
import cv2
import numpy as np
im_path = './测试数据/temp_long.jpg'
im = cv2.imdecode(np.fromfile(im_path, dtype=np.uint8))
cv2.imshow("显示图片",im)
cv2.imencode('.jpg', im)[1].tofile('E:\测试路径/frameTest.jpg')#英文或中文路径均适用
```

