---
title: NBnet paper 要点
tags: [文献,去噪]
categories: [文献,去噪]
date: 2022-05-26 16:06:47
math: true
---

>近年来的去噪顶刊《 NBNet: Noise Basis Learning for Image Denoising with Subspace Projection》发表于2021年的cvpr，在DND数据集的benchmark上的位居第三名。在实验中使用到NBnet，因此对这篇文章进行研读，以下是记录的要点。


![](https://picture.mulindya.com/Apaper_collect%2FDND_benchmark.png)

## Abstract
- 解决问题：图像去噪；

- 新的视角：使用图像自适应的投影降噪；

- 方法：
    1，特征空间的重构基，训练一个分离信号和噪声的网络

    ​	Specifically, we propose to train a network that can separate signal and noise by learning a set of reconstruction basis in the fea-ture space. 
    2，选择对应信号子空间的基，并投影实现去噪
     	image denosing can be achieved by selecting corresponding basis of the signal subspace and projecting the input into such space
    
- Key insight：
projection can naturally maintain the local strcture of insight signal. especially for areas with low light or weak textures.

- Proposed key：
     - SSA：
        - 非局部注意力模块
        - learn the basis generation as well as subspace projection

- 成果
  我们对基准进行评估，包括SIDD和DND, NBNet在PSNR和SSIM上实现了最先进的性能，大大降低了计算成本。

![](https://picture.mulindya.com/Apaper_collect%2FGflops_NBnet.png)


## 引入

图像去噪是病态问题，因此使用图像先验和去噪模型从噪声观测中估计干净图像和噪声。

- 传统方法：
    - NLM，BM3D ：利用图片的局部相似性和噪声独立的特性
    - NBNet: Noise Basis Learning for Image Denoising with Subspace Projectionnoising：利用在变换域图片的稀疏性；

- DNN方法：利用图像先验和监督学习噪声分布

### 挑战：
在硬场景，比如纹理较弱或高频细节恢复高质量图像仍然具有挑战性。

### 理论：
卷积网络通常依赖于局部滤波器对噪声和信号的响应。但是在低信噪比的硬场景中，如果没有全局的结构信息，局部的响应容易被混淆。

### 应对方法：
通过投影机制使用非局部图像信息，对于自然图像而言，通常处于低秩信号子空间中，通过对基向量的学习和生成，重构的图像可以保留大部分的原始信息而抑制噪声。

![](https://picture.mulindya.com/Apaper_collect%2FNB_fig2.png)

## 2 相关工作
### 2.1传统经典方法
传统方法是基于图像先验（NLM，sparse coding，BM3D），但是算法复杂度较高，泛化程度有限。

### 2.2 网络架构
- FFDNet，非盲去噪方法，将噪声水平作为一个map输入到噪声图像，对过平滑细节的图像的真实噪声图像具备空间不变性。
- MIRNet提出了一种去噪和超分辨率图像增强的通用网络架构。使用提取，交换，利用多尺度特征信息的新型模块。
- NBnet 采用带有空间注意力模块（SSA）的unet架构。SSA是用于学习子空间基和图像投影而非区域或者特征选择。

### 2.3噪声分布
噪声合成：
高斯-泊松分布，摄像机内过程模拟，高斯混合模型，gan生成噪声。

## 3方法
### 3.1 子空间投影

Figure 2:

- 投影分为两个步骤
    1， 基向量的生成：从图像的特征图中生成子空间基向量；
    2， 投影：特征图变换到到信号空间；
    用$X_1,X_2$表示单张图片的两个特征图，是卷积激活的中间层，可以由不同层产生，但是size一致。由$X_1,X_2$估计k个基向量，基向量的尺寸为(HW,1)，然后将X1变换为由基向量表示的子空间。
#### 3.1.1 基向量的生成
两个feature map进行concat后卷积生成k通道的same特征图，再进行reshape操作，转换为HW*K的size。
#### 3.1.2 投影
通过正交线性投影将图像特征X1投影到V。通过V求出正交投影矩阵将N空间投影到V空间。
正交矩阵P定义为$V(V^TV)^{-1}V^T$,维度是(HW,HW),最后使用PX1进行重构。

### 3.2 网络架构和损失函数

![](https://picture.mulindya.com/Apaper_collect%2FNB_fig3.png)

- 架构

使用Unet架构，SSA模块放在每个skip-connection，因为低层次的特征包含更多的原始图像细节信息，因此将低层次的特征图作为X1，高层次的特征图作为X2放入SSA、然后将高层次特征和投影特征进行融合输出到下一个decoder。
与传统的方式相比，NBnet主要区别在于低级特征在融合前由SSA模块处理。最后一个decoder输出由3*3的卷积核作为全局残差传递到输入图像得到结果。

- 损失函数

使用1范数作为损失函数。

> ### 结果

![](https://picture.mulindya.com/Apaper_collect%2FNB_tab1.png)

![](https://picture.mulindya.com/Apaper_collect%2FNB_tab3.png)

![](https://picture.mulindya.com/Apaper_collect%2FNB_tab4.png)

## 4 实验

### 4.1 训练设置

- 无预训练
- K 16 
- 优化器 AdamW （0.9，0.999）
- 学习率 2e-4
- 学习率衰减 cosine annealing
- iterations 70000
- batch size 32
- 数据增强 rotaion cropping flipping

### 4.2 合成高斯噪声

- 训练数据集

    - BSD：432
    - imagenet：400
    - Waterloo Exploration Database：4744

- 测试数据集
    - Set5
    - LIVE1 
    - BSD68 
    为了实现公平性对比，使用独立同分布的高斯噪声。

### 4.3 真实噪声SIDD

SIDD提供10个场景30000个噪声图片，benchmark是切分其中1280作为验证。

![](https://picture.mulindya.com/Apaper_collect%2FNB_fig4.png)

### 4.4 真实噪声DND

DND包括50个真实噪声图像和对应的干净图像。源图像以基准ISO水平拍摄，而噪声图像以更高的ISO和适当调整的曝光时间拍摄。DND数据集不提供训练数据，因此通过结合SIDD和Renoir数据来训练，通过使用SIDD基准上的最佳验证效果的模型。将结果提交到DND进行测试。计算成本比MIRNet更好，但是计算成本更低。该方法可以在保持图像纹理和清晰度的同时，输出清晰的图像。

![](https://picture.mulindya.com/Apaper_collect%2FNB_fig5.png)

### 4.5 消融实验

模型三个决定因素
a) 网络的SSA模块
b) 信号的子空间维数--基向量的数量K
c)  投影的选择

#### 4.5.1 整合到DnCNN

为了评估SSA模块的有效性，我们考虑使用另一个经典架构DbCNN作为基线，为了使用X1和X2，使用第一次卷积的特征为X1，最后的卷积特征为X2，简单的concat X1和X2可以提高0.2db的psnr，使用SSA模块可以提高0.5db

#### 4.5.2 超参数K的影响

K取32时模型无法收敛，这是因为第一阶段的通道数本身为32因此SSA模块不能进行有效的投影，K值等于空间的维度，另一方面，子空间的高维度会增加模型拟合的难度，从而导致训练的不稳定。而K值太小会导致子空间的信息不足，信息丢失严重，将K设置为8和16可以得到类似的性能，SSA模块会创建一个低维，紧凑，可分类的子空间。

> 投影到低维的子空间，由低维的子空间基对低层次的信息进行投影还原Y，从而过滤掉噪声信息，再进行特征融合到下一阶段。

![](https://picture.mulindya.com/Apaper_collect%2FNB_ablation.png)

#### 4.5.3 投影方式的选择

Proj(a,b)表示将a投影到b生成的基。参见表8，可以看到，对于X1生成的基会使得训练不稳定无法收敛。对X2参与生成的基可以达到一个好的效果，同时考虑X1和X2可以生成更好的基空间，网络效果更好。

![](https://picture.mulindya.com/Apaper_collect%2FNB_ablation2.png)

#### 4.6 基向量的可视化和讨论

参见图7

使用SSA模块后，对于暗色区域的虚线纹理被恢复，当SSA模块被禁用时，会导致暗色区域模糊，因此NBnet可以在弱纹理区域表现得更好。

这种现象是因为投影基向量产生非局部相关性。

相反，传统的卷积神经网络依赖于定值局部滤波器的响应和下采样特征的粗信息。当滤波器响应不显著且粗信息模糊时，例如在纹理较弱的区域，非局部信息很难改善局部响应。

> 因此使用HW*K进行投影，以达到对全局信息的响应。

## 5 结论

所提出的子空间基生成和投影运算，不依赖于复杂的网络架构，自然可以将全局结构信息引入到去噪过程中，较好地保持了局部细节。我们进一步证明，这种基础生成和投影可以通过SSA端到端学习，并产生比添加卷积块更好的效果。子空间学习是图像去噪和其他低水平视觉任务的一个很有前途的方向，值得进一步探索。







