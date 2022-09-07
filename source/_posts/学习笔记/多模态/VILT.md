---
title: ViLT: Vision-and-Language Transformer Without Convolution or Region Supervision
tags: [文献,多模态]
categories: [文献,多模态]
date: 2022-09-07 16:50:52
---

> 视频讲解：[ViLT 论文精读](https://www.bilibili.com/video/BV14r4y1j74y?vd_source=d26291f722468f7096aa948876c55640)
> 论文下载：https://arxiv.org/pdf/2102.03334.pdf
> 代码地址：https://github.com/dandelin/vilt
> 论文投稿：PMLR2021 **Proceedings of Machine Learning Research** 机器学习顶会

### 领域

Vision-and-Language 多模态

### 背景

现在的VLP模型过度依赖于图像特征提取，包括使用Convolution or Region的结构，这一过程时间冗杂，导致了

（1）计算速度和效率较低，简单地提取输入特征需要比多模态交互用到多得多的计算量

（2）表达能力的上限取决于视觉嵌入器和预定义的视觉词汇量（predefined visual vocabulary）

### 方法

- 结合BERT和VIT
  - 使用简单的patch线性投影（linear projection of a patch）代替之前的图像特征提取的工作。结合文本和图像为一个序列输入到Transformer中。
  - transfomer encoder作为Modality Interaction

- 使用了2个trick
  - Whole Word Masking：巧妙的加强文字和图像的联系
  - Image Augmentation：使用RandAugment的数据增强方法，但是这里剔除了color inversion和cutout。因为这两个部分可能会导致数据集中的图片和文字不对应。

### 结果

大大提升效率：在图像的处理上，从之前的885ms（region），45ms（convolution）提升到0.4ms

下游任务效果持平，算是有竞争力，但是没有太大提升

### 贡献

- ViLT is the simplest architecture by far for a vision-and-language model as it commissions the transformer module to extract and process visual features in place of a separate deep visual embedder. This design inherently leads to significant runtime and parameter efficiency.

- For the first time, we achieve competent performance on vision-and-language tasks without using region features or deep convolutional visual embedders in general.
- Also, for the first time, we empirically show that whole word masking and image augmentations that were unprecedented in VLP training schemes further drive downstream performance

### 缺点

- 模型是在64张32G的V100s上训练了3天，这个资源配置太贵了，99%的人无法承受。

> 后期在NeurlPS2021（机器学习顶会）出现更轻量的[ALBEF](#相关论文)（单机八卡训练3天）

- 时间上提升了很多，但是效果一般般


### 展望

- Scalability：扩大数据集或者增大模型的规模


- Masked Modeling for Visual Inputs：图像上进行mask的操作（完形填空）

    > 后期出现MAE，BEIT后，微软研究院在2022年6月提出的[VL-BEiT](https://arxiv.org/abs/2206.01127)，在此基础上加上了视觉的无监督重建损失.
    >
    > Bao H, Wang W, Dong L, et al. VL-BEiT: Generative Vision-Language Pretraining[J]. arXiv preprint arXiv:2206.01127, 2022.

- Augmentation Strategies: 数据增强，从消融实验可以看出数据增强作用很大，并且有可能可能提升data efficiency。

#### 相关论文

- Align before Fuse: Vision and Language Representation Learning with Momentum Distillation
- BLIP: Bootstrapping Language-Image Pre-training for Unified Vision-Language Understanding and Generation
- Masked Unsupervised Self-training for Zero-shot Image Classification



