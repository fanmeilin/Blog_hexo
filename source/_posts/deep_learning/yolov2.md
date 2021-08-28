---
title: YOLOv2
tags: [深度学习,目标检测,yolo]
categories: [深度学习,目标检测]
date: 2021-08-27 10:57:37
math: true
---

## YOLOv2

### 综述

**论文地址**：https://arxiv.org/abs/1612.08242

Yolov2与Yolov1在保持速度的基础上，对预测效果的准确度，耗费时间，鲁棒性三个方面进行了改进，检测能力提高到9000种不同对象。文章提出了一种新的**训练方法--联合训练**方法。这种算法可以将两种数据集混合到一起，使用一种分层的观点进行分类，用大型的分类数据集扩充检测的数据集。也成为YOLO9000.

联合训练的思路：**在检测数据集和分类数据集上训练物体检测器（Object Detectors），用检测数据集学习物体的准确位置，用分类数据集来增加分类的类别两。提升健壮性。**

Yolo9000就是使用联合训练的算法，拥有来自于Imagenet的9000种分类信息，物体检测的部分来自于CoCo的检测数据集。

### 论文


<details>
<summary> yolov2 论文：YOLO9000: Better, Faster, Stronger</summary>
<iframe src='/js/pdfjs_old/web/viewer.html?file=https://paper.mulindya.com/YOLOv2.pdf' width=100% height=650></iframe>
</details>


### 改进点

#### BN(batch normalization) 批量归一化

BN层有助于解决反向传播过程的**梯度消失和梯度爆炸**的问题，**降低**对超参数的**敏感性**，同时对batch归一化时，起到了一定的**正则化**的效果（去掉的dropout层）。通常，在网络的线性变换与激活函数之前增加一个BN层，BN层可以将其特征量归一化使得变换后的特征均值为0，方差为1，从而每一批训练样本都有类似的分布。同时还有修正的参数$\gamma,\beta$可以恢复原有信息。实验结果mAP提升2.4%

一般的归一化公式：

{% raw %}
$$
\widehat x^{(k)} = \frac{x^{(k)}-E[x^{(k)}]}{\sqrt {Var[x^{(k)}]}} \\
$$
{% endraw %}

![](https://picture.mulindya.com/yolov2-pic1.png)

#### High resolution classifier（高分辨率图像分类器）

由于对象检测的样本相对图像分类的训练样本要少得多，在对象检测时模型通常时先用图像分类的样本训练卷积层提取图像特征（训练backbone）。但是图像分类样本的分辨率不高，比如在yolov1中，训练集是224\*224的图片来训练卷积层，但是在训练对象检测的模型使用的是448\*448的图片，这样的切换对模型性能有一定影响。所以Yolo2在采用**224\*224图像分类模型预训练之后再采用448\*448的高分辨率样本对分类模型进行微调**(10个epoch)，这样再训练对象检测模型之前，网络特征就逐渐适应448\*448的分辨率，然后再使用448\*448的检测样本进行对象检测模型的训练，以缓解了分辨率突然切换造成的影响。通过这种方式，mAP提升了3.7%。

#### Convolution with anchor boxes(使用先验框)

Yolov1是使用全连接层直接预测BBox的坐标值（每个grid预测k个Bbox），Faster R-CNN的方法是只用卷积层和region proposal network来预测锚框的偏移度和置信度。但是作者发现采用Faster R-CNN的方法比Yolov1的方法更加简便，让神经网络学习起来更加容易。

因此，Yolov2也尝试了先验框（anchor），在每个grid预先设定一组不同大小不同宽高比的边框，来覆盖整个图像的不同位置和多种尺度，这些先验框作为预定义的候选区检测框内是否有目标，以及微调边框的位置。之前yolov1并没有采用先验框，并且每个grid只预测两个bounding box，整个图像有98个，yolov2入轨每个grid采用9个先验框，收缩网络运行在416\*416的图片，一个grid有32像素，那么总共有13\*13\*9=1521个先验框，最终去掉了全连接层，采用anchor boxes来预测bounding boxes。由于图片中的物体都倾向于出现在图片的中心位置，特别是那种比较大的物体，所以有一个单独位于物体中心的位置用于预测这些物体。YOLO的卷积层采用32这个值来下采样图片，所以通过选择416\*416用作输入尺寸最终能输出一个13\*13的Feature Map。使用Anchor Box会让精确度稍微下降，但用了它能让YOLO能预测出大于一千个框，同时recall达到88%，mAP达到69.2%。

#### Dimension clusters（聚类提取先验框的尺度信息）

之前Anchor Box的尺寸是手动选择的，所以尺寸还有优化的余地。YOLO2尝试统计出更符合样本中对象尺寸的先验框，这样就可以减少网络微调先验框到实际位置的难度。YOLO2的做法是对训练集中标注的边框进行K-mean聚类分析，以寻找尽可能匹配样本的边框尺寸。

在使用Kmeans聚类分析时，并不是直接采用的欧氏距离度量，因为这样大边框的距离会相对小边框大，这样误差就很大，因此我们采用IOU的形式。
$$
d(box,centroid) = 1-IOU(box,centroid)
$$
centroid是聚类时被选作中心的边框，box就是其它边框，d就是两者间的“距离”。IOU越大，“距离”越近。YOLO2给出的聚类分析结果如下图所示：

![](https://picture.mulindya.com/yolov2-pic2.png)

通过分析实验结果，在model复杂性与high recall之间权衡之后，选择聚类分类数K=5。

![](https://picture.mulindya.com/yolov2-pic3.png)

说明用K-means选择Anchor Boxes时，选择值为5时，AVG IOU的值是61，这个值要比不用聚类的方法的60.9要高。选择值为9的时候，AVG IOU更有显著提高。总之就是说明用聚类的方法是有效果的。

#### Direct location prediction（约束预测边框的位置）

借鉴于Faster RCNN的先验框方法，在训练的早期阶段，其位置预测容易不稳定。其位置预测公式为：

{% raw %}
$$
x = (t_x*w_a)+x_a \\
y = (t_y*h_a)+y_a
$$
{% endraw %}

其中， 是预测边框的中心， $x_a,y_a$是先验框（anchor）的中心点坐标， $w_a,h_a$是先验框（anchor）的宽和高，$t_x,t_y$ 是要学习的参数。注意，YOLO论文中写的是$x = (t_x*w_a)-x_a$ ，根据Faster RCNN，应该是"+"。

但是$t_x,t_y$ 不加约束的这种方式，会导致预测边框中心会出现在任意位置，因此在早期训练阶段不稳定，文章将边框的中心约束在grid网格当中。

![](https://picture.mulindya.com/yolov2-pic4.png)

其中， $b_x,b_y,b_w,b_h$是预测边框的中心和宽高。 $Pr(object)*IOU(b,object)$是预测边框的置信度，在YOLO1是直接预测置信度的值，这里对预测参数$t_o$进行σ变换后作为置信度的值。 $c_x,c_y$是当前网格左上角到图像左上角的距离，要先将网格大小归一化，即令一个网格的宽=1，高=1。 $p_w,p_h$是先验框的宽和高($t_w,t_h$会对初始的设置进行调整)。σ是sigmoid函数。 $t_x,t_y,t_w,t_h,t_o$是要学习的参数($t_o$也可以学习的嘛，学到某种规律用以表示置信度:question:)，分别用于预测边框的中心和宽高，以及置信度。

![](https://picture.mulindya.com/yolov2-pic5.png)

这种方式可以让数值更幅度稳定，也让网络更容易学习。

#### Fine-Grained Features(passthrough层检测细粒度特征)

对象检测面临一个问题：即目标检测的对象有大有小，输入图像经过多层网络提取特征，最后输出的特征图中（比如YOLO2中输入416*416经过卷积网络下采样最后输出是13*13），较小的对象可能特征已经不明显甚至被忽略掉了。为了更好的检测出一些比较小的对象，最后输出的特征图需要保留一些更细节的信息。

YOLO2引入一种称为passthrough层的方法在特征图中保留一些细节信息。具体来说，就是在最后一个pooling之前，特征图的大小是26\*26\*512，将其1拆4，直接传递（passthrough）到pooling后（并且又经过一组卷积）的特征图，两者叠加到一起作为输出的特征图。
![](https://mmbiz.qpic.cn/sz_mmbiz_png/gYUsOT36vfrVPO5dCS8SFFLceGUMkGDWjLDkibibfuO5LIGloXSRnzrichTTuS9FezhwDY4LiavUiaJO3QtDEwgIXRQ/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

具体怎样1拆4，下面借用一副图看的很清楚。图中示例的是1个4\*4拆成4个2\*2。另外，根据YOLO2的代码，特征图先用1\*1卷积从 26\*26\*512 降维到 26\*26\*64，再做1拆4并passthrough。

```python
ut = tf.extract_image_patches(in, [1, stride, stride, 1], [1, stride, stride, 1], [1,1,1,1], padding="VALID")
# or use tf.space_to_depth
# out = tf.space_to_depth(in, 2)
```

```python
tf.extract_image_patches(
    images,
    ksizes,
    strides,
    rates,
    padding,
    name=None
)
#images：必须是shape为[batch, in_rows, in_cols, depth]的tensor；
#ksize：长度大于等于4的list，滑动窗的大小
#strides:每块patch区域之间中心点之间的距离，必须是: [1, stride_rows, stride_cols, 1].
    #具体点说就是用来计算每次选取patch的初始点位置
#rates: 在每次提取的patch中，对应dim像素点位置之间的差距，必须是[1, rate_rows, rate_cols, 1]；「或者理解为 提取出来的每个框里面的像素不是都选择的 根据rate的不同 隔几个选一个 默认是1也就是的都选择 若为2 那么就是隔一个来选择」
#padding:有两个取值，“VALID”或者“SAME”，“VALID”表示所取的patch区域必须完全包含在原始图像中."SAME"表示可以取超出原始图像的部分，这一部分进行0填充。
```

#### Multi-scale Training（多尺度图像训练）

作者希望YOLOv2能健壮的运行于不同尺寸的图片之上，所以把这一想法用于训练model中。

区别于之前的补全图片的尺寸的方法，YOLOv2每迭代几次都会改变网络参数。每10个Batch，网络会**随机地选择一个新的图片尺寸**，由于使用了下采样参数是32，所以不同的尺寸大小也选择为32的倍数{320，352…..608}，最小320\*320，最大608\*608，网络会自动改变尺寸，并继续训练的过程。

这一方法让网络在不同的输入尺寸上都能达到一个很好的预测效果，同一网络能在不同分辨率上进行检测。当输入图片尺寸比较小的精度高，输入图片尺寸比较大的时候精度相对低，所以你可以在YOLOv2的速度和精度上进行权衡。
<center class="half">
<img src = "https://picture.mulindya.com/yolov2-pic6.png">
<img src = "https://picture.mulindya.com/yolov2-pic7.png">
</center>


#### hi-res-detect(高分辨率图像的对象检测)

上面左图表格中最后一行是使用高分辨l率的图像hi-res detector，因为YOLO2调整网络结构后能够支持多种尺寸的输入图像。通常是使用416\*416的输入图像，如果用较高分辨率的输入图像，比如544\*544，则mAP可以达到78.6，有1.8的提升。

#### Hierarchical classification(分层分类)

作者提出了一种在分类数据集和检测数据集上联合训练的机制。使用检测数据集的图片去学习检测相关的信息，例如bounding box 坐标预测，是否包含物体以及属于各个物体的概率。使用仅有类别标签的分类数据集图片去扩展可以检测的种类。作者通过ImageNet训练分类、COCO和VOC数据集来训练检测，这是一个很有价值的思路，可以让我们达到比较优的效果。通过将两个数据集混合训练，**如果遇到来自分类集的图片则只计算分类的Loss，遇到来自检测集的图片则计算完整的Loss**。

但是ImageNet对应分类有9000种，而COCO则只提供80种目标检测，作者使用multi-label模型，即假定一张图片可以有多个label，并且不要求label间独立。因为作者选择在COCO和ImageNet数据集上进行联合训练，遇到的第一问题是两者的类别并不是完全互斥的，比如"Norfolk terrier"明显属于"dog"，所以作者提出了一种层级分类方法（Hierarchical classification），主要思路是根据各个类别之间的从属关系（根据WordNet）建立一种树结构WordTree，结合COCO和ImageNet建立的WordTree如下图所示：

![](https://picture.mulindya.com/yolov2-pic8.png)

1. 遍历Imagenet的label，然后在WordNet中寻找该label到根节点(指向一个物理对象)的路径；
2. 如果路径只有一条，那么就将该路径直接加入到分层树结构中；
3. 否则，从剩余的路径中选择一条最短路径，加入到分层树。

这个分层树我们称之为 WordTree，作用就在于将两种数据集按照层级进行结合。(感觉就是为了扩充数据集同时简便计算)

分类时的概率计算借用了**决策树思想**，**某个节点的概率值等于该节点到根节点的所有条件概率之积**。最终结果是一颗 WordTree （视觉名词组成的层次结构模型）。用WordTree执行分类时，预测每个节点的条件概率。如果想求得特定节点的绝对概率，只需要沿着路径做连续乘积。例如，如果想知道一张图片是不是“Norfolk terrier ”需要计算：

![](https://picture.mulindya.com/yolov2-pic10.png)

另外，为了验证这种方法作者在WordTree（用1000类别的ImageNet创建）上训练了Darknet-19模型。为了创建WordTree1k，作者添加了很多中间节点，把label由1000扩展到1369。训练过程中ground truth标签要顺着向根节点的路径传播。例如，如果一张图片被标记为“Norfolk terrier”，它也被标记为“dog” 和“mammal”等。为了计算条件概率，模型预测了一个包含1369个元素的向量，而且基于所有“同义词集”计算softmax。

softmax操作也同时应该采用分组操作，下图上半部分为ImageNet对应的原生Softmax，下半部分对应基于WordTree的Softmax：

![](https://picture.mulindya.com/yolov2-pic9.png)

通过上述方案构造WordTree，得到对应9418个分类，通过重采样保证Imagenet和COCO的样本数据比例为4:1。

### 总结

通过联合训练策略，YOLO9000可以快速检测出超过9000个类别的物体，总体mAP值为19,7%。我觉得这是作者在这篇论文作出的最大的贡献，因为YOLOv2的改进策略亮点并不是很突出，但是YOLO9000算是开创之举。
