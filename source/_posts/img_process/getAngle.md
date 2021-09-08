---
title: 获取两个向量角度
tags: [图像处理，角度]
categories: [图像处理]
date: 2021-09-08 16:46:35
---

> 获取两个向量的夹角

![](https://picture.mulindya.com/getAngle.jpg)

比如AB向量表示为[1,-3,5,-1],前两位是A的坐标，后两位是B的坐标。

直接计算出每个向量与x正轴的夹角，然后相减即可；核心的部分使用atan2函数（atan和atan2优先使用atan2）。

> atan与atan2的区别：
> atan 和 atan2 都是求反正切函数，如：有两个点 point(x1,y1), 和 point(x2,y2);
> 那么这两个点形成的斜率的角度计算方法分别是：
> float angle = atan( (y2-y1)/(x2-x1) ); 或 float angle = atan2( y2-y1, x2-x1 );
> atan2 的优点在于如果 x2-x1等于0 依然可以计算，但是atan函数就会导致程序出错；


```python
import math
def get_angle(vec1,vec2):
    dx1 = vec1[2] - vec1[0]
    dy1 = vec1[3] - vec1[1]
    dx2 = vec2[2] - vec2[0]
    dy2 = vec2[3] - vec2[1]
    angle1 = math.atan2(dy1,dx1)*180/math.pi #atan2结果为弧度制(可以处理90度的情况)
    angle2 = math.atan2(dy2,dx2)*180/math.pi
    angle = abs(angle1-angle2)
    if(angle>180):angle = 360-angle
    return angle
```

