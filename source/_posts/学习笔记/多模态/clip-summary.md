---
title: CLIP总结--Learning Transferable Visual Models From Natural Language Supervision
tags: [文献,经典论文]
categories: [文献,经典论文]
date: 2022-10-07 13:20:26
---

>视频讲解：[CLIP 论文精读](https://www.bilibili.com/video/BV1SL4y1s7LQ/?spm_id_from=333.999.0.0&vd_source=d26291f722468f7096aa948876c55640)
>论文下载：https://openai.com/blog/clip/
>代码地址：https://github.com/openai/CLIP
>论文投稿：PMLR2021 **Proceedings of Machine Learning Research** 机器学习顶会

### 领域

计算机视觉领域，但融合了文字来促进视觉模型；

### 目的

通过NLP学习一个可迁移的视觉模型，并且发现语言和图像结合学习可以让模型学到更强的语义信息。

### 背景

- 如今最好的机器视觉领域模型训练都是基于预设好的图像类别数，这种形式局限了模型泛化性和可用性，因为需要额外的标签数据来具体化视觉任务。

- 而另一方面，在NLP领域，利用文本的监督信号涵盖的范围更加广泛（数据多样且足量），直接从**文本图像对**中学习是一个有前景的方向。

### 方法

首先从网上构建4亿文本对数据，利用预测文本对的匹配来从头训练一个简单的预训练任务模型，并且学到了最好的图像特征表示。

- 得到预训练模型后，通过自然语言作为reference学习视觉信息实现下游的zero-shot迁移；

- 通过图像和文本的配对，利用相似性/生成式的方法，摆脱固定类别的范式局限性；

就个人理解来说：

- 提升数据规模：openai创建了一个超级大的样本库，涵盖了4亿文本图像对数据，之前的imagenet（10万），JFT（3亿）数据规模上有大幅度的提升。

- 提升模型规模：具体是分别对图像，文本首先进行encoder，图像的encoder采用的是VIT和resnet，文本采用的时tranfomer的encoder。然后对encoder后的结果进行“对比学习”，类似协方差矩阵对各自进行匹配学习。
- trick：
  - 在文本和图像的匹配时，文本这边使用的不是单词匹配，而是句子，这样可以解决单词多义性的问题，缩小解空间；
  - 同时提供一个提示模板（prompt template），这种简单粗暴的方式可以在imagenet上提升1.3%。
  - 使用句子来匹配后还可以使用集成的方法，官方提供80多个模板的句子做集成模型投票。这样得到的推理是多次推理的综合结果

### 伪码

```python
# image_encoder - ResNet or Vision Transformer
# text_encoder - CBOW or Text Transformer
# I[n, h, w, c] - minibatch of aligned images
# T[n, l] - minibatch of aligned texts
# W_i[d_i, d_e] - learned proj of image to embed
# W_t[d_t, d_e] - learned proj of text to embed
# t - learned temperature parameter
# extract feature representations of each modality
I_f = image_encoder(I) #[n, d_i]  图片编码（使用resnet、VIT）
T_f = text_encoder(T) #[n, d_t]   文本编码 （CBOW、text tranformer、Bags of words）
# joint multimodal embedding [n, d_e]
I_e = l2_normalize(np.dot(I_f, W_i), axis=1)  #L2范数归一化+投射层操作
T_e = l2_normalize(np.dot(T_f, W_t), axis=1)   
# scaled pairwise cosine similarities [n, n]
logits = np.dot(I_e, T_e.T) * np.exp(t) #求相似度矩阵
# symmetric loss function
labels = np.arange(n)
loss_i = cross_entropy_loss(logits, labels, axis=0) #求图片的匹配求交叉熵损失
loss_t = cross_entropy_loss(logits, labels, axis=1) #求文字的匹配求交叉熵损失
loss = (loss_i + loss_t)/2 #对两者的损失取平均
```

### 结果

- 在30个不同的视觉数据集上验证模型的有效性，包括OCR，视频动作识别，地理定位，以及一些微调变形的物体分类。CLIP模型可以很容易的迁移到大多数任务，不需要特定数据集的微调，可以与全监督的baseline比肩。

- 在ImageNet上，Zero-shot的情况下与resnet50的效果差不多。

### 缺点

1. 模型的训练结果没有特别强，与现在的一些更先进的模型效果有差距，仅仅与resnet50比肩；
2. 对细分类，更加抽象的任务效果不好，比如说像纹理分类，计数这种任务的Zero-shot迁移效果一般；
3. 在自然图像上效果不错，但是如果与自然图像差异较大的图像，比如MNIST这种简单但是手工标制造的分类效果仅仅88%，这是不符合直觉的情况；
4. CLIP的训练是给定的类别中对比，这限制了他的灵活性；
5. CLIP依然存在数据效率不高的情况，希望在数据读取不增多的情况下使得数据训练样本增多，比如数据增强，自监督，伪标签；
6. 在Zero-shot中带入了偏见，因为是在验证集上直接微调的；
7. 数据未清洗，有一定的隐藏偏见；
8. 有反直觉现象：在迁移任务中，few-shot中会出现不如zero-shot的情况，具体来说就是在下游任务中对每个类别提供1-2张样本训练时的效果，还不如不提供任何样本直接预测的效果。


### 展望

- 根据上面的第4点，可以使用image caption来预测文本，增强模型灵活性；
- 可以将对比学习（计算相似度矩阵）的方式改进为与生成学习目标函数相结合的方式；
- 利用数据增强，自监督，伪标签提升数据的利用效率；

#### 相关论文

现在CLIP论文在下游论文有大量的后续工作了，比如目标检测，分割，视频动作识别，检索，多模态，图像生成。

