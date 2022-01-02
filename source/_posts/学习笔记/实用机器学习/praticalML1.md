---
title: praticalML第一章笔记
date: 2021-12-30 15:35:09
tags: [李沐,机器学习]
categories: [学习笔记，机器学习]
---

> 斯坦福2021秋季的实用机器学习上线啦~ :wink: 跟着沐神复习机器学习冲冲冲！ 记录一下笔记和重点，不一定很全哦~，只是记录自我感觉的重点。

# 第一章
## 1.1 课程介绍
介绍机器学习balabala 工业界的机器学习哦
### Role
SDE , 领域专家 -> 数据科学家 机器学习专家

### Skill

数据科学家需要的技能：
- **数据**： 收集处理数据，独立同分布
- **训练**： 模型融合，微调，迁移学习，多模态
- **部署**： 蒸馏，模型性能优化
- **监控** ：模型公平性，可解释性



## 1.2 数据获取

第一步是找数据，一般情况数据不够，问两个问题：

- 是否能到不同的数据源来融合

- 是否可以数据生成

### Discover what data is available

1. 判断公用数据集
2. 非常大的数据集
3. 采集新的数据

### Source

- mnist
- imageNet
- AudioSet：youtube sound
- Kinetics：youtube video
- KIITI：traffic senarios 自动驾驶
- Amazon Rewiew：用户评论
- SQuAD：维基百科的问答
- LibriSpeech：有声读物 文字<->语音
- 更多数据获取：https://en.wikipedia.org/wiki/List_of_datasets_for_machine-learning_research

### Where to Find Datasets

• [Paperswithcodes Datasets](https://paperswithcode.com/datasets): academic datasets with leaderboard
• [Kaggle Datasets](https://www.kaggle.com/datasets): ML datasets uploaded by data scientists 
• [Google Dataset search](https://datasetsearch.research.google.com/): search datasets in the Web 
• Various toolkits datasets: [tensorflow](https://www.tensorflow.org/datasets), [huggingface](https://huggingface.co/docs/datasets/)(专注于文本transformer的数据集)
• Various conference/company ML competitions 
• [Open Data on AWS](https://registry.opendata.aws/): 100+ large-scale raw data 
• Data lakes in your own organization

### 数据集比较

| 数据集类别 | 优点 | 缺点 |
| :----: | :----: | :----: |
|学术| 干净，难度适中 | 选择面小，小数据集 |
|竞赛| 接近应用 | 偏向于简单，专注于热门业务 |
|原始| 应用灵活 | 需要很多精力预处理 |

### 数据融合

- Combine data from multiple sources into a coherent dataset 
- Product data is often stored in multiple tables 
	• E.g. a table for house information, a table for sales, a table for listing agents  
- Join tables by keys, which are often entity IDs 
- Key issues: identify IDs, missing rows, redundant columns, value conflicts 

### 数据生成

- Use GANs
- 数据增强
  - image augmentation
  - Back Translation（中文-英文-中文）

## 1.3 网页数据抓取

### Web Scraping

•The goal is to extract data from website 
	• Noisy, weak labels, can be spammy 
	• Available at scale 
	• E.g. price comparison/tracking website 
• Many ML datasets are obtained by web scraping 
	• E.g. ImageNet, Kinetics 
• Web crawling VS scrapping 
	• Crawling: indexing whole pages on Internet  爬取所有信息
	• Scraping: scraping particular data from web pages of a website 网页数据提取 ；特定的网站 ；特定数据

### Web Scraping tools

- “curl” often doesn’t work  
  • Website owners use various ways to stop bots 
- Use headless browser: a web browser without a GUI 

    python中可以使用selenium中的webdriver来模拟搜索，取消图形化界面使用命令行:happy:
    ```python
    from selenium import webdriver
    chrome_options = webdriver.Chromeoptions()
    chrome_options.headless = True
    chrome = webdriver.Chrome(chrome_options = chrome_options) 

    page = chrome.get(url)
    ```

-  You need a lot of new IPs, easy to get through public clouds 
  • In all IPv4 IPs, AWS owns 1.75%, Azure 0.55%, GCP 0.25% 

最后一点，要注意版权问题哦~

## 1.4 数据标注

### 情况描述

![](https://picture.mulindya.com/pML1.4-1.png)

### 三种方案

### 1. 半监督学习(Semi-supervised learning SSL)

小部分数据标注了，还有大部分没有标注

- Focus on the scenario where there is a small amount of labeled data, along with large amount of unlabeled data 
-  Make assumptions on data distribution to use unlabeled data 两者分布假设
  • **Continuity assumption**（连续性假设）: examples with similar **features** are more likely to have the same **label** 
  • **Cluster assumption**（聚类假设）: data have **inherent cluster structure**, examples in the same cluster tend to have the same label   
  • **Manifold assumption**（流型假设）: data lie on a manifold of **much lower dimension** than the input space 降维

#### 典型算法

##### 自学习（self-training）

![](https://picture.mulindya.com/pML1.4-2.png)

用现有标号的样本训练模型来预测未标号的样本，将所得标号进行筛选，选择置信度高的样本合并继续训练，直到筛掉的剩余样本获得较高的置信度或者某个阈值范围。这个模型可以不计成本同时模型融合。

### 2. label through crowdsourcing 众包

简单来说就是花钱找人标注。:confused:

#### 典型算法

##### 主动学习 active learning

-  Focus on same scenario as SSL but with human in the loop 
  • Self training: Model helps propagate labels to unlabeled data 
  • Active learning: Model select the most “interesting” data for labelers 

-  **Uncertainty sampling**  
  • Select examples whose predictions are most uncertain 
  • The highest class prediction score is close to random ( 1/n) 

  模型选择置信度偏向于随机的样本让人来判断。然后放进模型区训练再预测再判断‘难’的数据。

-  **Query-by-committee** 
  • Trains multiple models and select samples that models disagree with 1/n

  多个模型投票来确定哪些数据比较‘难’  

### 3 Active Learning + Self-training

混合使用

![](https://picture.mulindya.com/pML1.4-3.png)

### 质量控制

可能出现误标或者出现标注并不精确的情况

#### Weak Supervision 弱监督学习

-  Semi-automatically generate labels 
  • Less accurate than manual ones, but good enough for training 

-  **Data programming**:

  总结规律规则编程  
  • Domain specific heuristics to assign labels 
  • Keyword search, pattern matching, third-party models 
  • E.g. rules to check if YouTube comments are spam or ham

> 什么是弱监督学习呢？弱监督学习可以分为三种典型的类型，不完全监督（Incomplete supervision），不确切监督（Inexact supervision），不精确监督（Inaccurate supervision）。
>
> - 不完全监督是指，训练数据中只有一部分数据被给了标签，有一些数据是没有标签的。
>
> - 不确切监督是指，训练数据只给出了粗粒度标签。我们可以把输入想象成一个包，这个包里面有一些示例，我们只知道这个包的标签，Y或N，但是我们不知道每个示例的标签。
>
> - 不精确监督是指，给出的标签不总是正确的，比如本来应该是Y的标签被错误标记成了N。
>
> ##### 解决方案
>
> - 为了解决不完全监督，我们可以考虑两种主要技术，主动学习和半监督学习。一种是有人类干预的，一种是没有人类干预的。
> - 为了解决不确切监督，我们可以考虑多示例学习。
> - 为了解决不精确监督，我们考虑带噪学习。
