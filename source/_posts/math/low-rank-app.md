---
title: 低秩逼近的思考
date: 2021-08-06 16:38:25
tags: [math,线性代数]
categories: [math,线性代数]
math: true
---

> 阅读文章**Semi-orthogonal Embedding for Effificient Unsupervised Anomaly Segmentation**时出现一个概念--**Low-rank approximation** ，就此进行相关讨论。

### 低秩（Low-Rank）

如果X是一个m行n列的数值矩阵，rank(X)是X的秩，假如rank (X)远小于m和n，则我们称X是低秩矩阵。低秩矩阵每行或每列都可以用其他的行或列线性表出，可见它包含大量的冗余信息。利用这种冗余信息，可以对缺失数据进行恢复，也可以对数据进行特征提取。

图像处理中，*rank可以理解为图像所包含的信息的丰富程度*，在显示生活中，一张图片中大部分成分是相似的。比如给一张大草原的图片

![](https://picture.mulindya.com/low-rank-app-pic1.png)



草原是由很多草组成的，而草是相似的，所以如果全是草，那么这张图所包含的信息量是很少的的，因为可以理解为草是草的复制品。而上图的蒙古包，人，马之类的则可以理解为图片所包含的信息，实际上，相对于只有草的草原图片和有草和蒙古包的草原图片，后者的秩是较高的。也就是说，图片中比较突兀的成分，比如蒙古包，比如人像照片中的红眼亮点，会增加图像矩阵的秩。而现实生活中一张不错的图片的秩其实是比较低的，如果图像的秩比较高，往往是因为图像中的噪声比较严重。比如拍照的时候ISO感光度设置过高造成噪点太过泛滥之类的。所以，*图像处理的低秩性其实可以拿来去除照片中的噪点*。

### 低秩和稀疏

我们认为图像有一些公共的模式，所有图像都由这些基本的模式组成。例如，如果图像是一个叉，可以看成是一个正斜线和反斜线的叠加。**只要我们找到了所有的基底（称作字典**，就是上面说的正斜线和反斜线之类的东西）**，就能通过基底的线性组合表示出所有的图像。**这就好像学画画，先学会基本的画正方体、球体、圆柱体等等，就可以组合出各种各样的复杂形状。

**在很多情形下，基底的数量是很少的**，比如一张照片拍的是一面砖墙，那么它显然具有周期重复的特点，换句话说低秩。即使整个图不低秩，往往也能找出一些相似的块，这些块是低秩的。再退一步，就算这也做不到，往往也可以把已有的数据看成一组低维的结果加上噪声，也即原来的数据**可以被低秩矩阵很好的逼近**。**稀疏性**的意思是（以稀疏表示为例），任给一个图像，**字典可能是过完备的**，从而用字典里的基向量表出这幅图有很多种不同的方案。我们希望**选取使用基底数量最少的那种方案**，

应用：

***1）矩阵填充(Matrix Completion)***

***2）鲁棒PCA***

***3）背景建模***

***4）变换不变低秩纹理（TILT）***

> 在论文 **Semi-orthogonal Embedding for Effificient Unsupervised Anomaly Segmentation**中有一段可以参考。

**Low-rank approximation of precision matrix**

The feature data **X** is subject to low-rank approximation due to the narrower target domain for anomaly-free images than the ImageNet dataset’s. The multi-scale features from different layers may also contribute to it due to the inter-dependency among the features from the layers. Inspired by the truncated SVD of a precision matrix, a low-rank embedding of input features with $W \in R^{F \times k}$,where *F > k*, is considered as follows:
$$
d^2_{i,j} = X^TW(W^TC_{i,j}W)^{−1}W^TX
$$
where the below Theorem 1 shows the optimal **W*** is the eigenvectors related to the *k*-smallest eigenvalues of $C_{i,j}$ . Notice that 1) the computational complexity of the equation is cubically reduced to *O*($HWk^3$) set aside the cost of SVD, although which is the concern, 2) PCA embedding would fail to minimize approximation error since it uses the *k*-largest eigenvectors [14], and 3) near-zero eigenvalues may induce substantial anomaly scores.

选取协方差矩阵的k个最小的特征值对应的特征向量，进行低秩逼近

> 参考
>
>  https://www.zhihu.com/question/28630628
>
> https://blog.csdn.net/zouxy09/article/details/24972869
