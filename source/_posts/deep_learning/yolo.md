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

举例说明: 在PASCAL VOC中，图像输入为448x448，取S=7，B=2，一共有20个类别(C=20)。则输出就是7x7x30的一个tensor。*其中30也就是2\*5+20，整个网络结构如下图所示：

![](https://picture.mulindya.com/yolov1-pic2.png)

在test的时候，每个网格预测的class信息与BBox得到的confidenci信息相乘，就可以得到每个BBox的class-specific confidence score：
$$
Pr(Class_i \vert Object)*Pr(Object)*IOU^{truth}_{pred} = Pr(Class_i)*IOU^{truth}_{pred}
$$
得到每个box的class-specific confidence score之后，设置阈值，过滤掉得分低的boxes，对保留的boxes进行NMS处理，即可得到最终的检测结果。

> NMS：non-maximum suppression 非极大抑制，其操作即是从集合中找到得分score最高的候选框，与其他候选框计算IOU，删除重合率高的候选框，因为这些候选框和最高score的框“竞争”同一个物体，但是score又不够高，所以是应该被淘汰的。确定了这个最高score的BBOX之后就可以不考虑他了，再继续找寻最高score的候选框，把与他竞争的候选框给pass掉即可，以此类推。

#### 流程
1. 输入一张图像将其分为7\*7的网格
2. 对于每一个网格,预测两个边框；（包括边框的置信度和其对应的类别概率）
3. 根据预测的7\*7\*2的目标窗口，首先通过阈值去除可能性地的窗口，再采用NMS去除冗余的窗口。

### 损失函数

最重要的是设计损失函数，作者使用了sum-squared error loss（https://blog.csdn.net/shengyan5515/article/details/84036734）

> 关于YOLO的损失函数，采用sum-squared error整合localization error（bboxes的坐标误差）和classification error，其中classification error包括两部分，一部分是没有包含object的box的confidence loss权值，另一部分则是有包含object的box的confidence loss权值

![](https://picture.mulindya.com/yolov1-pic3.png)

#### 问题：

- 8维的localization error(4*2),和20维的classification error同等重要是不合理的
- 如果一个网格中没有object(大部分),将这些网格的box对应confidence设置为0，是比较“暴力”的，会让loss特别大，网络不稳定并且不容易收敛。

#### 解决方案：

- 对于坐标预测赋予更大的权重（重视框的位置）
- 对没有object的confidence loss，赋予小的权重(注意力转移到其他地方)

- 对存在object的box的confidence loss和类别的预测权重正常取1

> 为什么第二项出现了根号呢？
>
> 是因为我们的误差度量量反应出大box的小偏差要小于小box。为了逐步解决这个问题，我们预测了边界框的宽度和高度的平⽅根，而不是直接预测宽度和⾼度。因为根号之后曲线越大越平缓。这样对小的box的偏差相对更加敏感。

观察损失函数可以看出：

- 只有在网格中存在object的时候才会对classification error进行计算

- 只有当某个网格的box的和对于的ground truth box是负责回归的，才会对这个box 的位置xywh损失进行计算，确定对应ground truth box就需要将这个box与这个网格中的所有bbox计算IOU，最大的那个ground truth是由这个网络负责预测的。

  激活函数使用的是leak relu，模型是使用预训练的Imagenet。

### 优点

- 快速，pipline简单

- 背景误检率低

- 通用性强，对艺术品中的物体也可以检测，对非自然的图像物体的检测率比一般的DOM，R-CNN都要好很多

### 缺点

- 由于输出层是全连接层，因此在检测时，YOLO训练模型只能支持与训练图像分辨率相同的图像
- 每个格子可以预测B个Bbox，但是最终只能选择IOU最高的BBox作为物体检测结果，也就是说，一个各自只能最多预测出一个物体；当物体比较小或者分布密集的时候也只能检测出一个。
- 在loss的求解方程中，大目标和小目标的IOU误差在loss计算上是接近的（即使用了平方根缓解），因此对于小物体的检测准确性不高。
