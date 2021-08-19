---
title: Sobel算子
tags: 图像处理
categories: [图像处理]
date: 2021-08-14 10:25:07
math: true
---

>本文主要介绍Sobel算子，主要用于边缘检测；由于该算子引入了局部平均，对噪声有平滑作用，因此还可以消除噪声。

## 图像边缘与梯度

在图像边缘，灰度值的变化较大，因此图像在此处的梯度值也较大。一般情况，图像梯度时计算图像的边缘信息。图像梯度严格来说时需要求导数，但是在图像计算上时使用像素值的差得到梯度的近似值。
图像强度的显著变化可分为：

- 阶跃变化函数，即图像强度在不连续处的两边的像素灰度值有着显著的差异；
- 线条（屋顶）变化函数，即图像强度突然从一个值变化到另一个值，保持一较小行程后又回到原来的值。

![](https://picture.mulindya.com/sobel-pic1.png)

（a）（b）分别是阶跃函数和屋顶函数的二维图像；（c）（d）是阶跃和屋顶函数的函数图象；（e）（f）对应一阶倒数；（g）（h）是二阶倒数。

## Sobel算子

常用如下两个模板进行边缘检测，将Gx，Gy与图像卷积，即可得到横向和纵向的亮度差分近似值。

{% raw %}
$$
G_x = \begin{bmatrix} -1 & 0 & 1 \\ -2 & 0 & 2\\-1 & 0 & 1\end{bmatrix} \qquad G_y = \begin{bmatrix} 1 & 2 & 1 \\ 0 & 0 & 0\\-1 & -2 & -1\end{bmatrix}
$$
{% endraw %}

图像每一个像素的梯度可以使用$G = \sqrt{G^2_x+G^2_y}$来表示，梯度的方向使用$\Theta = arctan(\frac{G_y}{G_x})$。

还有另外一个比`Sobel`函数的近似效果更好的 `Scharr`函数，其内核矩阵如下:

{% raw %}
$$
G_x = \begin{bmatrix} -3 & 0 & 3 \\ -10 & 0 & 10 \\ -3 & 0 & 3\end{bmatrix} \qquad G_y = \begin{bmatrix} -3 & -10 & -3 \\ 0 & 0 & 0 \\ 3 & 10 & 3\end{bmatrix}
$$

{% endraw %}

## 代码使用

### cv2.Sobel()

Sobel算子依然是一种过滤器，只是其是带有方向的

```python
dst = cv2.Sobel(src, ddepth, dx, dy[,ksize[, scale[, delta[, borderType]]]])
```

- dst代表目标函数
-  src代表原始图像
-  ddpeth代表输出图像的深度 ，-1表示采用的是与原图像相同的深度。目标图像的深度必须大于等于原图像的深度；
-   dx代表x方向上的求导阶数 ，0表示这个方向上没有求导，一般为0、1、2。
-   dy代表y方向上的求导阶数，0表示这个方向上没有求导，一般为0、1、2。
-   ksize代表Sobel核的大小，该值为-1时，则会使用Scharr算子进行运算,一般选择为1、3、5、7
-   scale代表计算导数时所采用的缩放因子，默认为1，无缩放
-  delta代表加在目标图像dst上的值，该值是可选的，默认为0
-  borderType代表边界样式，这个参数默认值为cv2.BORDER_DEFAULT。

> 其中ddepth设计图像深度的概念：
> 图像深度是指存储每个像素值所用的位数，例如cv2.CV_8U，指的是8位无符号数，取值范围为0~255，超出范围则会被截断（截断指的是，当数值大于255保留为255，当数值小于0保留为0，其余不变）。
>
> 具体还有：CV_16S（16位无符号数），CV_16U（16位有符号数），CV_32F（32位浮点数），CV_64F（64位浮点数）等.

```python
import cv2
#载入原图，图像深度为CV_8U
img_original=cv2.imread('E:\ShannonT\\notebook workspace\\images\\4.28.9.jpg',0)
#求X方向梯度，并且输出图像一个为CV_8U,一个为CV_64F
img_gradient_X_8U=cv2.Sobel(img_original,-1,1,0)
img_gradient_X_64F=cv2.Sobel(img_original,cv2.CV_64F,1,0)
#将图像深度改为CV_8U
img_gradient_X_64Fto8U=cv2.convertScaleAbs(img_gradient_X_64F)
#图像显示
cv2.imshow('X_gradient_8U',img_gradient_X)
cv2.imshow('X_gradient_64Fto8U',img_gradient_X_64Fto8U)
cv2.waitKey()
cv2.destroyAllWindows()
```

![](https://picture.mulindya.com/sobel-pic2.png)

`cv2.imshow()`的默认显示为8位无符号数，即[0,255]，因此在显示`CV_64F`的图像前使用了函数`cv2.convertScaleAbs()`将图像深度为`CV_64F`的梯度图像重新转化为`CV_8U`。

### cv2.convertScaleAbs()

```
cv2.convertScaleAbs(src[,alpha[,beta]])
```

先计算数组绝对值，后转化为8位无符号数

- src:输入图像（多维数组）
- alpha:比例因子
- beta:保存新图像（数组）前可以增加的值

### 归一化

防止梯度大小被截断最简单的方法就是先将输入图像归一化（实际归一化的过程就已经实现了图像深度的转变）。在使用深度大于8U的格式之前将灰度先归一化，就不用`convertScaleAbs`转换了。

```python
import cv2
import numpy as np
#载入灰度原图，图像深度为CV_8U
img_original=cv2.imread('E:\ShannonT\\notebook workspace\\images\\4.28.9.jpg',0)
#原图归一化,实际图像深度已经变为CV_64F
img_standard=img_original/255
#采用灰度原图求X方向梯度
original_gradient_X_64F=cv2.Sobel(img_original,cv2.CV_64F,1,0)
original_gradient_X_64Fto8U=cv2.convertScaleAbs(original_gradient_X_64F)
#采用归一化的图像求X方向梯度
standard_gradient_X=cv2.Sobel(img_standard,-1,1,0)
#图像显示
cv2.imshow('original',img_original)
cv2.imshow('original_X',original_gradient_X_64Fto8U)
cv2.imshow('standard_X',standard_gradient_X)
cv2.waitKey()
cv2.destroyAllWindows()
```

![](https://picture.mulindya.com/sobel-pic3.png)

### cv2.addWeighted()

```
cv2.addWeighted(src1, alpha, src2, beta, gamma[, dst[, dtype]]) → dst
```

- src1 输入的第一个数组
- alpha 第一个数组的权重
- src2 输入的第二个数组（与第一个数组有相同的shape）
- beta 第二个数组的权重
- dst 输出的数组名称
- gamma 计算和时所采用的缩放因子，默认为1，无缩放
- dtype 输出图像的深度，-1表示和input相同
- 
> dst = src1 * alpha + src2 * beta + gamma;

注意：由参数说明可以看出，被叠加的两幅图像必须是尺寸相同、类型相同的；并且，当输出图像array的深度为CV_32S时，这个函数就不适用了，这时候就会内存溢出或者算出的结果压根不对。

### 边缘检测

通过cv2.Sobel()我们可以轻松计算出X,Y方向的梯度大小，根据公式

$$
G = \sqrt{G^2_x+G^2_y}
$$
可以求出梯度图像，实际操作时，为了简化运算，我们使用公式

$$
G = \vert{G_x}\vert+\vert{G_y}\vert
$$

```python
import cv2
import numpy as np
#载入灰度原图，并且归一化
img_original=cv2.imread('E:\ShannonT\\notebook workspace\\images\\4.28.9.jpg',0)/255
#分别求X,Y方向的梯度
grad_X=cv2.Sobel(img_original,-1,1,0)
grad_Y=cv2.Sobel(img_original,-1,0,1)
#求梯度图像
grad=cv2.addWeighted(grad_X,0.5,grad_Y,0.5,0)
cv2.imshow('gradient',grad)
```

## 官方说明

当年作者并没有公开发表过论文，仅仅是在一次博士生课题讨论会(1968)上提出("A 3x3 Isotropic Gradient Operator for Image Processing")，后在1973年出版的一本专著（"Pattern Classification and Scene Analysis"）的脚注里作为注释出现和公开的。

详细介绍，请参考以下内容。

<iframe src='/js/pdfjs_old/web/viewer.html?file=https://paper.mulindya.com/An%20Isotropic%203x3%20Image%20Gradient%20Operator.pdf' style='width:100%;height:100%'></iframe>

