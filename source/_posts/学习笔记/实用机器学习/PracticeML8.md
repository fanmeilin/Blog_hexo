---
title: praticalML第八章笔记--迁移学习
tags: [李沐,机器学习]
categories: [学习笔记,机器学习]
date: 2022-02-23 16:51:52
math: true
---

> 斯坦福2021秋季的实用机器学习上线啦~ :wink: 跟着沐神复习机器学习冲冲冲！ 记录一下笔记和重点，不一定很全哦~，只是记录自我感觉的重点。本章的内容包括迁移学习，对视觉，NLP两个方面的微调。

# 第八章

## 8.1 迁移学习 :droplet:

• Motivation 
	• Exploit a model trained on one task for a related task 
	• Popular in deep learning as DNNs are data hungry and training cost is high 
• Approaches 
	• Feature extraction (e.g. Word2Vec, ResNet-50 feature, I3D feature) 
	• Train a model on a related task and reuse it 
	• Fine-tuning from a pertained model (focus of this lecture) 
• Related to 
	• Semi-supervised learning  半监督学习
	• In the extreme, zero-shot / few-shot learning 
	• Multi-task learning, where some labeled data is available for each task 多任务学习

- 途径：
  - 训练好模型作为特征抽取的模块
  - 在相关任务上训练一个模型，直接在另外一个任务上使用该模型
  - 对预训练模型进行微调

## 8.2 计算机视觉上的应用 :blossom:

### 8.2.1 Transferring Knowledge

• There exists large-scale labeled CV datasets 
	• Especially for image classification, the cheapest one to label  
• Transfer knowledge from models trained on these datasets to your CV applications (with 10-100X smaller data)

比如：ImageNet有120万图片1000类图片

### 8.2.2 预训练模型

- Partition a neural network into: 
	• A feature extractor (encoder) maps raw pixels into linearly separable features 
	• A linear classifier (decoder) makes decisions 
-  Pre-trained model 
	• a neural network trained on a large-scale and general enough dataset  
-  The feature extractor may generalize well to  
	• other datasets (e.g. medical/satellite images) 
	• other tasks (e.g. object detection, segmentation)

可以把神经网络分成两块 encoder + decoder，这是一种抽象的概念。

encoder就是一种特征提取器，把原始像素转换为语义空间中线性可分的特征（浅表示/语义表示）；

decoder 是对编码器的表示进行一些决策转化为标号空间；

![](https://picture.mulindya.com/Blog_PracticeML/pML8-1.png)

比如说上图这个网络结构，可以把下面的L-1层作为encocder，最后一层可以作为decoder。

预训练模型可以理解为在大型数据集上训练过的，因此是具有一定分泛化能力的。在imagenet上训练好的神经网络具有一定的特征提取能力，虽然它是自然图片，但是换到医学数据，卫星图片也是有一定帮助的。

### 8.2.3 Fine-Tuning

一种简单的方法是将预训练模型只进行特征提取，也就是encoder部分。

-  Initialize the new model: 
	• Initialize the feature extractor with the feature extractor parameters of a pre-trained model 
	• Randomly initialize the output layer 
	• Start the parameter optimization near a local minimal 
-  Train with a small learning rate with just a few epochs 
	•   Regularize the search space

微调比直接替换encoder更有效。

在新的任务上构建新的模型，但是他的架构和预训练模型有一致的地方，再去初始化模型；

初始化表示的是把预训练好的模型权重复制到那些一致的地方，而对decoder部分随机初始化，如下图所示；

![](https://picture.mulindya.com/Blog_PracticeML/pML8-2.png)

然后再进行训练，对于如何训练也有一些技巧，通过初始化encoder权重，可以使得自己的权重值已经比较接近最优解了，这个时候训练可以**使用比较小的学习率，采用更小的epoch，或者冻结部分层**，使得搜索空间更小，避免梯度偏离。因为泛化误差和训练误差是不一样的，我们要让泛化误差更好。

### 8.2.4 Freeze Bottom Layers

-  Neural networks learn hierarchical features  
	• Low-level features are universal, generalize well, e.g. curves /edges / blobs 
	• High-level features are more task and dataset specific, e.g. classification labels 
-  Freeze bottom layers during fine tuning Train the top layers from scratch 
	• Keep low-level universal features intact 
	• Focus on learning task specific features 
	• A strong regularizer

限制搜索空间也可以使用冻结的方法，在下面的层是学习像素底层的特征，比如颜色，纹理，这种特征提取是可以冻结的，越往上越靠近语义相关的特征.

![](https://picture.mulindya.com/Blog_PracticeML/pML8-3.png)

对于神经网络是一个很平滑的过程从下而上慢慢学习任务；也就是说对下面几层可以固定住；如果应用和预训练数据差别比较大，可以少固定几层。

### 8.2.5 find Pre-trained Models

• Tensorflow Hub: https://tfhub.dev/  
	• Tensorflow models submitted by users 
• TIMM:  https://github.com/rwightman/pytorch-image-models  最近比较流行，整理比较清晰，但是模型性能一般般
	• PyTorch models collected by Ross Wightman

也有modelhub modelzoo

```python
import timm
from torch import nn
model = timm.creat_model('resnet18',pretrained=True) #模型和预训练模型权重
model.fc = nn.Linear(model.fc.in_features,n_classes) #修改最后一层 个人数据集n_classes 默认随机初始化
# Train model as a normal training job 
#固定层就是对其学习率改成0
```

### 8.2.6 应用

-  Fine-tuning pre-trained models (on ImageNet) is widely used in various CV applications: 
	• Detection/segmentation (similar images but different targets)  
	• Medical/satellite images (same task but very different 
	images) 
-  Fine-tuning accelerates convergence 
-  Though not always improve accuracy 
	• Training from scratch could get a similar accuracy, especially when the target dataset is also large

![](https://picture.mulindya.com/Blog_PracticeML/pML8-4.png)

微调加速了收敛，对任务不同，数据集不同都能得到不错的效果；当数据集和预训练数据集差别非常大不一定会提升精度，但是不会变差。

### 8.2.7 总结

• Pre-train models on large-scale datasets (often image classification) 
• Initialize weights with pre-trained models for down-stream tasks 
• Fine-tuning accelerates converges and (sometimes) improves 
accuracy

在大型数据集上预训练模型，引入到自身的任务中，再进行微调。计算机视觉中对此有较好的应用性。

## 8.3 NLP中的微调 :golf:

### 8.3.1 自监督预训练

• No large-scale labeled NLP dataset 
• Large quantities of unlabeled documents  
	• Wikipedia, ebooks, crawled webpages 
• Self-supervised pre-training 
	• Generate “pseudo label” and use supervised learning task 
	• Common tasks for NLP 
		• Language model (LM): predict next word. e.g. I like your hat  预测下一个词
		• Masked language model (MLM): random masked word prediction. e.g. I like your hat 类似完型填空（更容易）

在NLP中不存在大型数据集预训练模型，存在大量的无标注的文档。在NLP一般会使用自监督来产生伪标号。

可以使用LM（语言模型）和MLM（带掩码的语言模型）来生成标号。

### 8.3.2 预训练模型

![](https://picture.mulindya.com/Blog_PracticeML/pML8-5.png)

- 词嵌入（比较旧），在一个文档中挑一个y，用左右的词来预测y，窗口大小为n，y用u来表示，上下文用v表示。得到y和上下文的关系。在预测时使用词典中的y取最大化CBOW；也可以使用中心词来预测周围词。向量空间可以一定程度上反映词的相似度。可以使用某个词周围的词放入公式得到该词作为中心词的特征向量表示。
- 基于Transformer的预训练模型（最近火热）
  - **BERT：Transformer的编码器，训练时使用带掩码的词预测。编码器时双向的模型，所以需要带掩码；**
  - **GPT：解码器时一个从左对右的模型，可以用于预测下一个词；**
  - **T5：基于编码器和解码器的架构。**

### 8.3.3 BERT

![](https://picture.mulindya.com/Blog_PracticeML/pML8-6.png)

使用两个训练任务：

- 使用masked token盖住部分词来预测；
- 一次处理两个句子，可以相连为正例，无相连关系为负例。

每个词会得到向量表示，还有一个分类cls来分类两个句子是否相连

### 8.3.4 BERT微调

![](https://picture.mulindya.com/Blog_PracticeML/pML8-7.png)

得到预训练模型之后可以进行微调了，微调的方法和CV比较相似。把BERT的最后一层来微调，他是根据任务的不同而不同。将最后一层随机初始化，再使用小的学习率微调。

### 8.3.5 实践

• BERT fine-tuning on small datasets can be unstable 
	• BERT removed bias correction steps in Adam 
	• Too few (=3) epochs 
• Randomly initializing some top transformer layers help 
	• Features learned by top layers are too specific to the pre-training tasks 
	• The cutoff depends on downstream tasks

BERT微调结果很不稳定，是由于Adam在模型前期的系数估计不准确，这个参数对BERT无伤大雅，因为数据量庞大，但是在自己的小数据集上使用时使用完整版的Adam，BERT默认对任务时训练3次，但是在实际没有收敛，微调时建议多训练几轮。

对于Transformer和CNN没有本质区别，对于底层时语义层次信息，越向上和标注空间会更相似。所以同样将下面的层冻结，训练上面的层。

### 8.3.6 寻找NLP预训练模型

• HuggingFace: a collection of pre-trained transformer models on 
both PyTorch and TensorFlow

```python
from transformers import AutoTokenizer 
from transformers import AutoModelForSequenceClassification 
tokenizer = AutoTokenizer.from_pretrained("bert-base-cased") 
inputs = tokenizer(sentences, padding="max_length", truncation=True) 
model = AutoModelForSequenceClassification.from_pretrained( 
“bert-base-cased", num_labels=2) 
# Train model on inputs as a normal training job 

```

目前常见的NLP模型比较主流的是HuggingFace的transformers包。

NLP**关键点**：如何把文档表示为一个个的词/词元/token.这一步取决于模型。不同的模型有不同的表示方法，需要把对应的字典用相同的方式表示，否则无法对应，并且任务不同也对应的不同。

### 8.3.7 应用

• “(BERT) obtains new state-of-the-art results on eleven natural language processing tasks”, including 
	• If a sequence of words is a grammatical English sentence 
	• Sentiment of sentences from movie reviews 
	• Sentences/questions in a pair are semantically equivalent, or similar 
	• If the premise entails the hypothesis 
	• Find the span of the answer for a question 
• “(T5) achieve state-of-the-art results on many benchmarks covering 
summarization, question answering, text classification, and more”

BERT是编码器的架构，所以有一定的局限性，比如input为一段话生成一段新的句子就比较难实现。

适合于：

- 判断句子句法是否正确；

- 电影的评论为正面还是负面；

- 两句话或是两个问题是否语义等价；

- 假设和结论之间是否存在加强关系；

- 在问题中是否可以找到答案的范围；

### 8.3.8 总结

• Self-supervised pre-training for NLP models 
	• A common task is (masked) language model 
• BERT is a giant transformer encoder 
• Downstream tasks fine-tune BERT with a consistent manner

NLP的预训练使用自监督来完成。

- **BERT：Transformer的编码器，训练时使用带掩码的词预测。编码器时双向的模型，所以需要带掩码；**
- **GPT：解码器时一个从左对右的模型，可以用于预测下一个词；**
- **T5：基于编码器和解码器的架构。**
