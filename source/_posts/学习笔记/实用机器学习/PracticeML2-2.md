---
title: praticalML第二章笔记
tags: [李沐,机器学习]
categories: [学习笔记,机器学习]
date: 2022-01-02 17:52:57
---

> 斯坦福2021秋季的实用机器学习上线啦~ :wink: 跟着沐神复习机器学习冲冲冲！ 记录一下笔记和重点，不一定很全哦~，只是记录自我感觉的重点。

# 第二章 提升数据质量

> - 噪声多？
>
> - yes ->数据清理
>
> - no？ 格式对吗？
>
> - No ->数据变换
> - yes 适合学习嘛？
> - No ->特征提取

## 2.1 数据清理

### 2.1.1 outlier检测（异常）

![](https://picture.mulindya.com/pML2-6.png)

### 2.1.2 基于规则的检测

比如已知x决定y，但是出现了x->z那么z是一个异常情况。

### 2.1.3 基于模式的检测

-  Syntactic patterns  （语法模式）

  比如说大多数都是数字，少数是￥+数字，那么可以转换这些少数的字段为数字

  • e.g. Map a column to the most prominent data type and identify values do not fit 
  • eng, en, english -> English 

-  Semantic patterns （语义模式）
  • e.g. Add rules through knowledge graph 
  • Values in column “Country” need have capitals, so a value “Stanford” is invalid、

### 2.1.4 总结

-  Types of data errors: outliers, rule violations, pattern violations 
-  Multiple tools exist to help data cleaning 
  • Graphic interface for interactive cleaning 
  • Automatically detect and fix

> 现在也有很多数据清理的工具，有图形化界面，也可以自动分析处理。

## 2.2 数据变换

**机器学习的流程：数据收集-数据标注-数据变换-特征工程-模型构建及训练**

• ML algorithms prefer well defined fixed length, well-conditioned, nicely distributed input 
• Next, data transformation methods for different data types

![](https://picture.mulindya.com/pML2-7.png)

### 2.2.1 对实数归一化（Normalization）

• Normalization makes training more stable

![](https://picture.mulindya.com/pML2-8.png)

- Min-max normalization: linearly map to a new min a and max b也就是通过线性变换把数值变换到a到b之间，先通过min，max的变换到0-1之间然后进行扩增和移动。
- Z-score normalization: 0 mean, 1 standard deviation 其目的是将分布变为均值为0方差为1，减去均值除以标准差。
- Decimal scaling 将数字转换为0.XX (到0-1)
- Log scaling 原始数据比较大（正数）时可以变换到log'空间'，在log中的加减是原始数据的乘除，所以比值类的数据可以变换到这种形式

### 2.2.2 图像变换

-  Our previous web scraping will scrape 15 TB images for a year  
  • 5 millions houses sold in US per year, ~20 images/house, ~153KB per image, ~1041x732 resolution 

- cropping, downsampling, compression 
  • Save storage cost, faster loading at training 
       • At ~320x224 resolution, 15 TB -> 1.4TB 
  • ML is good at low-resolution images 
  • Be aware of lossy compression 
       • Medium (80%-90%) jpeg compression may lead to 1% acc drop in ImageNet

- Image whitening（数据白化 可以理解为降维）
  •make input less redundent
  •model converages faster

机器学习对于低分辨的图片可以做的挺好的。所以剪裁，下采样是可以接受的。**但是要注意下采样之后要使用较高质量的图片格式不要用jpeg。**   

白化的目的是去除输入数据的冗余信息。假设训练数据是图像，由于图像中相邻像素之间具有很强的相关性，所以用于训练时输入是冗余的；白化的目的就是降低输入的冗余性。白化分为PCA白化、ZCA白化.
输入数据集X，经过白化处理后，新的数据X'满足两个性质：
(1)特征之间相关性较低；
(2)所有特征具有相同的方差。

### 2.2.3 视频变换

-  Input variability high  
  • Average video length: Movies ~2h, YouTube videos ~11min, Tiktok short videos ~15sec 
-  Tractable ML problems with short video clips (<10sec)  
  • Ideally each clip is a coherent event (e.g. a human action) 
  • Semantic segmentation is extremely hard.. 
-  Preprocessing to tradeoff storage, quality and loading speed 
-  Common practice: decode a playable video clip, sample a sequence of  frames, compute spectrograms for audio 
  • Easy to load to model, increased storage space

采样关键的帧，图片不需要所有的信息，使用gpu来采样，需要权衡存储和解码。

### 2.2.3 文本变换

-  Stemming and lemmatization: a word ->  a common base form 
  • E.g. am, are, is   -> be        car, cars, car's, cars'  ->  car 
  • Example: Topic modeling 
-  Tokenization: text string  a list of tokens (smallest unit to ML algorithms) 
  • By word: text.split(' ') 
  • By char: text.split(‘') 
  • By subwords:  
      • e.g. “a new gpu!”   “a”, “new”, “gp”, “##u”, “!”  
      • Custom vocabulary learned from the text corpus  (Unigram, WordPiece)

方法是忽略语法，词根化，词源化，子词。

### 2.2.4 总结

主要是格式的转换，需要权衡数据大小，数据质量，存储的方式。

- •Transform data into formats preferred by ML algorithms 
  • Tabular: normalize real value features 
  • Images: cropping, downsampling, whitening 
  • Videos: clipping, sampling frames 
  • Text: stemming, lemmatization, tokenization 
-  Need to balance storage, quality, and loading speed

## 2.3 特征工程

-  Before deep learning (DL), feature engineering (FE) was critical to using ML models 
  • Traditional CV: detect corners / interest points.. 

- DL train deep neural networks to automatically extract features  
  • Train CNN to replace feature extractor 
  • Features are more relevant to the final task 
  • Limitation: data hungry, computation heavy

![](https://picture.mulindya.com/pML2-9.png)

深度学习出现之前主要是研究特征工程抽取特征；

深度学习没有改变流程但是现在并不是手动的过程，现在是自动抽取特征。

### 2.3.1 Tabular Data Features

- Tabular data are in the form of a table,  feature columns of numeric / categorical / string type 
-  Int/float: directly use or or bin to   unique int values 
-  Categorical data: one-hot encoding （独热编码）
  • Map rare categories into “Unknown” 
-  Date-time: a feature list such as  日期特征
  • [year, month, day, day_of_year, week_of_year, day_of_week] 
-  Feature combination: Cartesian product of two feature groups  特征组合
  • [cat, dog] x [male, female] ->  [(cat, male), (cat, female), (dog, male), (dog, female)]

### 2.3.2 文本特征

将词源的独热编码加起来

词表示为向量来表示语义信息

使用预训练好的语言模型来特定表示（通过自监督学习来训练，可以抽取时序信息）

![](https://picture.mulindya.com/pML2-10.png)

### 2.3.3 图像/视频特征

预训练的模型来抽取特征

![](https://picture.mulindya.com/pML2-11.png)

### 2.3.4 总结

-  Features are representations of raw data that are relevant to the target task 
- Feature engineering VS Feature learning 
  • The latter is preferred if available (images/videos/audio/text) 
  • Will cover more later in “transfer learning”
