---
title: 拉普拉斯算子
tags: [图像处理]
categories: [图像处理]
date: 2021-08-20 14:27:00
math: true
---

>  ​	图像锐化处理的作用是使灰度反差增强，从而使模糊图像变得更加清晰。图像模糊的实质就是图像受到平均运算或积分运算，因此可以对图像进行逆运算，如微分运算能够突出图像细节，使图像变得更为清晰。
> ​	积分运算的模板可以平滑图像，反过来对应微分运算的模板卷积可以锐化图像。锐化模板系数的取值再中心为正数而周围为负数。或者中心为负数周围为正数。而拉普拉斯算子就是一种常用的线性锐化滤波的方法。

## 拉普拉斯的背景

在图像中的边缘区域，像素值会发生“跳跃”，对这些像素求导，在其一阶导数在边缘位置为极值（Sobel算子）：

![img](https://picture.mulindya.com/laplace-pic1.png)

如果对像素值求二阶导数，会发现边缘处的导数值为0；**但是并不是说二阶导数为0就意味着是边缘**。

![](https://picture.mulindya.com/laplace-pic2.png)

## 计算方法

### 像素二阶导数

二阶导数的计算方法：
$$
\nabla^2f = \frac{\partial^2 f}{\partial x^2}+\frac{\partial^2 f}{\partial y^2}
$$
分别沿着X和Y方向有二阶偏导数均可借用差分计算：
$$
\frac{\partial^2 f}{\partial x^2} = f(x+1,y)+f(x-1,y)-2f(x,y)
$$

$$
\frac{\partial^2 f}{\partial y^2} = f(x,y+1)+f(x,y-1)-2f(x,y)
$$

那么可以得到
$$
\nabla^2f = f(x+1,y)+f(x-1,y)+f(x,y+1)+f(x,y-1)-4f(x,y)
$$
### 模板卷积

对应的模板卷积即为

{%raw%}
$$
\begin{bmatrix} 0 & 1 & 0\\ 1 & -4 & 1 \\ 0 & 1 & 0 \end{bmatrix} 或者\begin{bmatrix} 0 & -1 & 0 \\ -1 & 4 & -1 \\ 0 & -1 & 0 \end{bmatrix}
$$
{%endraw%}

前者是mask中心为负数，后者是mask中心为正数；他们的目的和效果是一致的，只是表现形式稍有不同，前者在卷积后，在边缘的亮处为负数，在边缘暗处为正数。后者相反。

mask为负数时，在边缘的亮处为负数，在边缘暗处为正数。可以参见下图：

![](https://picture.mulindya.com/laplace-pic3.png)

上述是考虑中心像素4邻域，类似还有考虑8邻域，此时中心点区8或-8，周围为-1或1。

{%raw%}
$$
\begin{bmatrix} 1 & 1 & 1 \\ 1 & -8 & 1 \\ 1 & 1 & 1 \end{bmatrix} 或者\begin{bmatrix} -1 & -1 & -1 \\ -1 & 8 & -1 \\ -1 & -1 & -1 \end{bmatrix}
$$

{%endraw%}

## 图像锐化

锐化处理可选择拉普拉斯算子对原图像进行处理，产生描述灰度突变的图像，再将拉普拉斯图像与原始图像叠加而产生锐化图像。拉普拉斯锐化的基本方法可以由下式表示：
$$
g(x,y) = \begin{cases} f(x,y) - \nabla^2f(x,y) & \text{mask中心为负数}\\f(x,y) + \nabla^2f(x,y) & \text{mask中心为正数} \end{cases}
$$

这种简单的锐化方法既可以产生拉普拉斯锐化处理的效果，同时又能保留背景信息，将原始图像叠加到拉普拉斯变换的处理结果中去，可以使图像中的各灰度值得到保留，使灰度突变处的对比度得到增强，**最终结果是在保留图像背景的前提下，突现出图像中小的细节信息**。

缺点是没有了边缘的方向信息；双倍加强了噪声的影响。

> 锐化处理的公式从模板形式容易看出，如果在图像中一个较暗的区域中出现了一个亮点，那么用拉普拉斯运算就会使这个亮点变得更亮。因为图像中的边缘就是那些灰度发生跳变的区域，所以拉普拉斯锐化模板在边缘检测中很有用。一般增强技术对于陡峭的边缘和缓慢变化的边缘很难确定其边缘线的位置。但此算子却可用二次微分正峰和负峰之间的过零点来确定，对孤立点或端点更为敏感，因此特别适用于以**突出图像中的孤立点、孤立线或线端点为目的的场合**。同梯度算子一样，拉普拉斯算子也会增强图像中的噪声，有时用拉普拉斯算子进行边缘检测时，可将图像先进行**平滑处理**。

## 代码

在OpenCV内使用函数cv2.Laplacian()实现Laplacian算子的计算，该函数的语法格式为：

```
dst = cv2.Laplacian( src, ddepth[, ksize[, scale[, delta[, borderType]]]] )
```

式中：
● dst代表目标图像。
● src代表原始图像。
● ddepth代表目标图像的深度。
● ksize代表用于计算二阶导数的核尺寸大小。该值必须是正的奇数。
● scale代表计算Laplacian值的缩放比例因子，该参数是可选的。默认情况下，该值为1，表示不进行缩放。
● delta代表加到目标图像上的可选值，默认为0。
● borderType : 用于推断图像外部像素的边界模式，一般是DORDER_DEFAULT,不支持BORDER_WRAP.

```python
import cv2
img = cv2.imread("img.png",0)
laplacian = cv2.Laplacian(img,cv2.CV_64F)
laplacian = cv2.convertScaleABs(laplacian)
cv2.imshow(img)
cv2.imshow(laplacian)
```
原图
![](https://picture.mulindya.com/laplace-pic4.png)
处理之后
![](https://picture.mulindya.com/laplace-pic5.png)

