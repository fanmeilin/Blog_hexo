---
title: YOLO学习
tags: [深度学习,目标检测]
categories: [深度学习,目标检测]
date: 2021-08-21 15:56:11
math: true
---

> YOLO系列是基于深度学习的回归方法。YOLO：you only look once的优点是实时快速目标检测。一直都很想把YOLO系统的学习一下。在此，记录下相关的知识和个人理解。做笔记也算是督促我好好的整理相关内容叭！ok开始！

> 参考：
> https://zhuanlan.zhihu.com/p/136382095
> https://mp.weixin.qq.com/s/df1JaGtnoEY4FQford4UIw

## YOLO 和 Faster R-CNN

两个网络的差异有两个方面：

1. Yolo没有显示求取region proposal的过程，虽然Faster R-CNN中的RPN于Fast R-CNN共享卷积层，但是在模型训练过程中，还是需要反复的训练RPN于Fast R-CNN，也就是说这种方式还是需要”look twice“ ：确定候选框和分类；而Yolo系列只需要”look once“

   > 关于Faster R-CNN的知识后续再填坑.....

2. Yolo将检测统一为一个回归问题。而R-CNN将检测结果分为两个部分进行求解：分类`物体的类别` ， 回归`物体的bounding  box`

## YOLOv1

**论文下载：**http://arxiv.org/abs/1506.02640

**代码下载：**https://github.com/pjreddie/darknet

核心思想：将整张图作为网络的输入（与Faster-RCNN类似），直接在输出层对BBox的位置和类别进行回归。

实现方法：

![](https://picture.mulindya.com/yolov1-pic1.png)


- 首先将一幅图像分成S*S个网格（grid cell）,如果某个物体的中心落在这个网格中，那么这个网格就负责预测这个物体。

- 每个网格需要预测B个边界框(BBox)的位置信息和对应的置信度（confidence）;一个BBox对应四个位置信息和一个confidence信息，confidence表示所预测的Box中含有objext的置信度和box的预测情况。

  > 也就是$conf = Pr(object)\times IOU^{truth}_{pred}$ 如果有object落在其中的grid cell里，那么第一项为1否则取0.

每个bounding box要预测(x, y, w, h)和confidence共5个值，每个网格还要预测一个类别信息，记为C类。则SxS个网格，每个网格要预测B个bounding box还要预测C个categories。判断这个落在此网格的物体是c个物体中的哪一个物体。输出就是S x S x (5*B+C)的一个tensor。（**注意：class信息是针对每个网格的，confidence信息是针对每个bounding box的。**）

举例说明: 在PASCAL VOC中，图像输入为448x448，取S=7，B=2，一共有20个类别(C=20)。则输出就是7x7x30的一个tensor。*其中30也就是2*5+20*，整个网络结构如下图所示：

![](https://picture.mulindya.com/yolov1-pic2.png)

未完待续。。。。

