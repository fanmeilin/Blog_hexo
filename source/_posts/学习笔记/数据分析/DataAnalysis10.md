---
title: 数据分析笔记--朴素贝叶斯
tags: [数据分析,python]
categories: [学习笔记,数据分析]
date: 2022-01-19 17:57:19
math: true
---

> 本科实训的时候记录的数据分析的笔记，感觉还挺全面的，部署到博客中，今后对数据分析的应用可以方便回顾。:no_mouth:

> 本篇主要内容是朴素贝叶斯，也是一个分类模型​，​具体​貌似用的而不太多​，​所以我好像不是特别清楚，看后续是否需要再了解一下。:sunny:

# 1 朴素贝叶斯 :bell:

## 1.1 定义

分类模型，构造基础贝叶斯理论

朴素贝叶斯是基于贝叶斯定理和全概率公式，可以计算在自变量一定取值条件下，因变量的条件概率限制了自变量的取值类型（**分类变量**），并且自变量**相互独立**；

## 1.2 公式

### 1.2.1 全概率公式

![](https://picture.mulindya.com/image-20210128105624694.png)

### 1.2.2 贝叶斯公式

![](https://picture.mulindya.com/image-20210128105642741.png)

### 1.2.3 高斯模型

| 模型       | 头文件                                        | 说明                                                         |
| ---------- | --------------------------------------------- | ------------------------------------------------------------ |
| 高斯模型   | from sklearn.naive_bayes import GaussianNB    | 有些特征可能是连续型变量                                     |
| 伯努利模型 | from sklearn.naive_bayes import BernoulliNB   | 使用特征为全局特征，在伯努利模型中，每个特征的特征是布尔类型 |
| 多项式模型 | from sklearn.naive_bayes import MultinomialNB | 常用文本分类 特征是单词值出现的次数                          |



## 1.3 拉普拉斯平滑系数

出现原因：在训练样本过程中，可能出现一些特征的缺失，某些特征出现的次数为0,以此方式计算时可能最终结果为0；
$$
p(x1,x2,x3,....|yi) = p(x1|yi)p(x2|yi)p(x3|yi)
$$

$$
pi = (Ni+a)/(N+a*m)
$$

a：平滑系数；m：特征值向量个数；a=1时称为拉普拉斯平滑

# 2 文本特征提取 :wind_chime:

 用于文档分类 垃圾邮件分类 新闻分类 文本分类是通过词是否存在或者词的重要性（概率）来表示

## 2.1 文档中词的出现

```python
from sklearn.feature_extraction.text import CountVectorizer
data2 = [
    'i love python',
    'life is short,i use python',
    'i dislike python'
]
cv = CountVectorizer()
cv.fit_transform(data2).toarray()
```

```python
array([[0, 0, 0, 1, 1, 0, 0],
       [0, 1, 1, 0, 1, 1, 1],
       [1, 0, 0, 0, 1, 0, 0]], dtype=int64)
```

```python
cv.get_feature_names()
结果为：['dislike', 'is', 'life', 'love', 'python', 'short', 'use']
```

## 2.2 文章中词的重要性

```python
from sklearn.feature_extraction.text import TfidfVectorizer
tv = TfidfVectorizer(stop_words='english')
tv.fit_transform(data2).toarray()
```

```python
array([[0.        , 0.        , 0.861037  , 0.50854232, 0.        ,
        0.        ],
       [0.        , 0.54645401, 0.        , 0.32274454, 0.54645401,
        0.54645401],
       [0.861037  , 0.        , 0.        , 0.50854232, 0.        ,
        0.        ]])
```

```python
tv.vocabulary_
结果是 {'love': 2, 'python': 3, 'life': 1, 'short': 4, 'use': 5, 'dislike': 0}
tv.get_feature_names()
结果是 ['dislike', 'life', 'love', 'python', 'short', 'use']
```

## 2.3 关于中文文章进行分析的问题

### 2.3.1 结巴分词

```python 
import jieba
data3 = [
    '因为在实际的训练中，训练的结果对于训练集的拟合程度通常还是挺好的',
    '但是对于训练集之外的数据的拟合程度通常就不那么令人满意了。',
    '因此我们通常并不会把所有的数据集都拿来训练'
]
datalist=[]
for i in range(len(data3)):
    newlist=[]
    for j in jieba.cut(data3[i]):
        newlist.append(j)
    content = (' ').join(newlist)
    datalist.append(content)
ch_tf = TfidfVectorizer(stop_words=['的','（','）','，','。','了'])
ch_tf.fit_transform(datalist).toarray() 
```

```python 
array([[0.        , 0.        , 0.        , 0.        , 0.32927047,
        0.        , 0.32927047, 0.25041868, 0.        , 0.        ,
        0.25041868, 0.        , 0.        , 0.25041868, 0.32927047,
        0.58341732, 0.32927047, 0.19447244, 0.        , 0.        ],
       [0.        , 0.37766105, 0.37766105, 0.37766105, 0.        ,
        0.        , 0.        , 0.28722096, 0.        , 0.        ,
        0.28722096, 0.        , 0.28722096, 0.28722096, 0.        ,
        0.2230527 , 0.        , 0.2230527 , 0.37766105, 0.        ],
       [0.37072514, 0.        , 0.        , 0.        , 0.        ,
        0.37072514, 0.        , 0.        , 0.37072514, 0.37072514,
        0.        , 0.37072514, 0.28194602, 0.        , 0.        ,
        0.21895624, 0.        , 0.21895624, 0.        , 0.37072514]])
```

```python
ch_tf.get_feature_names()
结果是 ['不会',
 '之外',
 '令人满意',
 '但是',
 '因为',
 '因此',
 '实际',
 '对于',
 '我们',
 '所有',
 '拟合',
 '拿来',
 '数据',
 '程度',
 '结果',
 '训练',
 '还是',
 '通常',
 '那么',
 '集都']
```

# 