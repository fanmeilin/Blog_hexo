---
title: fine-tuning的方法
tags: [深度学习,微调]
categories: [深度学习]
date: 2021-08-13 14:28:24
---

>收集关于深度学习的调参的相关笔记，主要用于网络训练的微调。

### **训练技巧**

1.要做**梯度归一化**,即算出来的梯度除以minibatch size

2.clip c(梯度裁剪): 限制最大梯度,其实是value = sqrt(w1^2 +w2^2….),如果value超过了阈值,就算一个衰减系数,让value的值等于阈值: 5,10,15

##### **3.防止过拟合**

​	一般常用的防止过拟合方法有使用**L1正则项、L2正则项、dropout、提前终止、数据集扩充等**。如果模型在训练集上表现比较好但在测试集上表现欠佳可以选择增大L1或L2正则的惩罚力度（**L2正则经验上首选1.0**，超过10很少见），或**增大dropout的随机失活概率**（经验首选0.5）；或者当随着训练的持续在测试集上不增反降时，使用提前终止训练的方法。当然**最有效的还是增大训练集的规模**，实在难以获得新数据也可以使用数据集增强的方法，比如CV任务可以对数据集进行裁剪、翻转、平移等方法进行数据集增强，这种方法往往都会提高最后模型的测试精度。
 	dropout对小数据防止过拟合有很好的效果,值一般设为0.5,小数据上dropout+sgd。在大部分实验中，效果提升都非常明显.**建议尝试**。 dropout的位置比较有讲究, 对于RNN,建议放到输入->RNN与RNN->输出的位置.关于RNN如何用dropout,可以参考:[http://arxiv.org/abs/1409.2329](https://link.zhihu.com/?target=http%3A//arxiv.org/abs/1409.2329)(Captain Jack令言:(不仅仅可以防止过拟合, 其实这相当于做人力成本最低的Ensemble, 当然, 训练起来会比没有Dropout的要慢一点, 同时网络参数你最好相应加一点, 对, 这会再慢一点).)

**4.超参** 

​	learning rate 最重要**，推荐了解 cosine learning rate 和 cyclic learning rate，其次是 **batchsize 和 weight decay**。当你的模型还不错的时候，可以试着做数据增广和改损失函数锦上添花了。(罗浩ZJU令言：随着网络训练的进行，学习率要逐渐降下来；网络性能越好，学习率要越小（即越需要微调而非粗调)；batchsize通常影响没那么大，塞满卡就行，除了特殊的算法需要batch大一点)
​	adam,adadelta等,在小数据上,我这里实验的效果不如sgd, sgd收敛速度会慢一些，但是最终收敛后的结果，一般都比较好。**如果使用sgd的话,可以选择从1.0或者0.1的学习率开始,隔一段时间,在验证集上检查一下,如果cost没有下降,就对学习率减半**. 我看过很多论文都这么搞,我自己实验的结果也很好. 当然,也可以先用ada系列先跑,最后快收敛的时候,更换成sgd继续训练.同样也会有提升.据说adadelta一般在分类问题上效果比较好，adam在生成问题上效果比较好。(Captain Jack令言：sgd adam 这些选择上, 看你个人选择. 一般对网络不是决定性的. 反正我无脑用sgd + momentum. ）

5.**激活函数**
	除了gate之类的地方,需要把输出限制成0-1之外,**尽量不要用sigmoid**,可以用tanh或者relu之类的激活函数.1. sigmoid函数在-4到4之外的区间梯度接近0，很容易造成梯度消失问题。2. 输入0均值，sigmoid函数的输出不是0均值的。（hzwer令言:虽然有至少十种激活函数，但在 Relu 外只推荐试一下 Swish。)

6.BN层具有加速训练速度，有效防止梯度消失与梯度爆炸，具有防止过拟合的效果，所以构建网络时最好要加上这个组件。(Captain Jack令言：batch normalization我一直没用, 虽然我知道这个很好, 我不用仅仅是因为我懒. 所以要鼓励使用batch normalization.）

7.如果你的模型包含全连接层（MLP），并且输入和输出大小一样，可以考虑将MLP替换成**Highway Network**,我尝试对结果有一点提升，建议作为最后提升模型的手段，原理很简单，就是给**输出加了一个gate来控制信息的流动**，详细介绍请参考论文: [http://arxiv.org/abs/1505.00387](https://link.zhihu.com/?target=http%3A//arxiv.org/abs/1505.00387)

8.来自@张馨宇的技巧：**一轮加正则，一轮不加正则，反复进行。**

**9.Ensemble**
Ensemble是论文刷结果的终极核武器,深度学习中一般有以下几种方式
同样的参数,不同的初始化方式
不同的参数,通过cross-validation,选取最好的几组
同样的参数,模型训练的不同阶段，即不同迭代次数的模型。
不同的模型,进行线性融合. 例如RNN和传统模型.

**10.自动调参方法**
（1）Grid Search：其原理就像是在数组里找最大值。缺点是太费时间了，特别像神经网络，一般尝试不了太多的参数组合。
（2）Random Search：经验上，Random Search比Gird Search更有效。实际操作的时候，一般也是先用Gird Search的方法，得到所有候选参数，然后每次从中随机选择进行训练。另外Random Search往往会和由粗到细的调参策略结合使用，即在效果比较好的参数附近进行更加精细的搜索。
（3）Bayesian Optimization：贝叶斯优化，考虑到了不同参数对应的 实验结果值，因此更节省时间，贝叶斯调参比Grid Search迭代次数少， 速度快；而且其针对非凸问题依然稳健。

**11.Loss设计**
\+ 一般来说分类就是Softmax, 回归就是L2的loss. 但是要注意loss的错误范围(主要是回归), 你预测一个label是10000的值, 模型输出0, 你算算这loss多大, 这还是单变量的情况下. 一般结果都是nan. 所以不仅仅输入要做normalization, 输出也要.
\+ 多任务情况下, 各loss想法限制在一个量级上, 或者最终限制在一个量级上, 初期可以着重一个任务的loss。

### **网络结构设计（关于SE)**

SE在分类上是个涨点必备的工具，换言之，堆最高精度是一定要给每个block都加上它的，但是如果需要考虑时间，参数量和精度等的trade-off，无脑堆就没有意义了，这个时候应该要选择在合适的地方使用合适的模块。这个时候，**推荐在block数量和添加SE上做权衡**，即**给部分blcok加上SE，同时砍掉一些block来加速**，这样可以在精度差不多的情况下减少一些参数量。当然inference时间这个事需要看具体的应用平台对SE的实现，就是GAP和FC的速度，这就具体问题具体分析了。**有余力有卡的人，可以迁移某种NAS方法来做这个的搜索。**
参考自：
你有哪些deep learning（rnn、cnn）调参的经验？ - 萧瑟的回答 - 知乎 https://www.zhihu.com/question/41631631/answer/94816420
你有哪些deep learning（rnn、cnn）调参的经验？ - Towser的回答 - 知乎 https://www.zhihu.com/question/41631631/answer/862075836
你有哪些deep learning（rnn、cnn）调参的经验？ - 罗浩.ZJU的回答 - 知乎 https://www.zhihu.com/question/41631631/answer/216788968
你有哪些deep learning（rnn、cnn）调参的经验？ - 京东白条的回答 - 知乎 [https://www.zhihu.com/question/4163](https://www.zhihu.com/question/41631631/answer/776852832)

> 所谓SE：SENet是Squeeze-and-Excitation Networks的简称，拿到了ImageNet2017分类比赛冠军，其效果得到了认可，其提出的SE模块思想简单，易于实现，并且很容易可以加载到现有的网络模型框架中。*<u>SENet主要是学习了channel之间的相关性，筛选出了针对通道的注意力</u>*，稍微增加了一点计算量，但是效果比较好。

对于CNN网络来说，其核心计算是卷积算子，其通过卷积核从输入特征图学习到新特征图。从本质上讲，卷积是对一个局部区域进行特征融合，这包括空间上（H和W维度）以及通道间（C维度）的特征融合。


![](https://img-blog.csdnimg.cn/2019051415564658.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L25pamlheWFuMTIz,size_16,color_FFFFFF,t_70)

卷积实际上是对<u>局部区域</u>进行的特征融合。 这也导致了普通卷积神经网络的感受野不大，当然你也可以设计出更多的通道特征来增加这个，但是这样做导致了计算量大大的增加。因此为了空间上融合更多特征融合，或者是提取多尺度空间信息。也提出了许多不同的方法如Inception网络的多分支结构。对于channel维度的特征融合，卷积操作基本上默认对输入特征图的所有channel进行融合。<u>而SENet网络的创新点在于关注channel之间的关系，希望模型可以自动学习到不同channel特征的重要程度</u>。为此，SENet提出了Squeeze-and-Excitation (SE)模块，如下图所示：


![](https://img-blog.csdnimg.cn/20190514160215998.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L25pamlheWFuMTIz,size_16,color_FFFFFF,t_70)

### 反面训诫

1.1、一上来就自己动手写模型。
建议首先用**成熟的开源项目及其默认配置**（例如 Gluon 对经典模型的各种复现、各个著名模型作者自己放出来的代码仓库）在自己的数据集上跑一遍，在等程序运行结束的时间里仔细研究一下代码里的各种细节，最后再自己写或者改代码。

1.2、**不推荐做人肉模型设计**，比如把某层卷积改大一点，或者微调一下通道数。除非有特别 insight，不要自己乱设计新组件。

2、训 RNN 不加 gradient clipping，导致训练一段时间以后 loss 突然变成 Nan。

3、tying input & output embedding（就是词向量层和输出 softmax 前的矩阵共享参数，在语言模型或机器翻译中常用）时学习率需要设置得非常小，不然容易 Nan。

4.1、在数据集很大的情况下，一上来就跑全量数据。建议先用 1/100、1/10 的数据跑一跑，对模型性能和训练时间有个底。

4.2认为网络层数越大越好。参数量什么的都不是大问题，在性能不丢的情况下，网络层数减到最小.（Captain Jack令言：你有95%概率不会使用超过40层的模型. ）

5、只喜欢漂亮的模型结构，瞧不起调参数的论文/实验报告，**看论文时经常不看超参数设置等细节**。殊不知在自己没有太多资源实验的情况下，实验报告类文章简直是业界良心！
NLP 领域主要推荐以下几篇：
Regularizing and Optimizing LSTM Language Models（LSTM 的训练技巧）
Massive Exploration of Neural Machine Translation Architectures（NMT 里各个超参的影响）
Training Tips for the Transformer Model（训练 Transformer 时会发生的各种现象）
RoBERTa: A Robustly Optimized BERT Pretraining Approach（BERT 预训练技巧，虽然跟大部分人没啥关系）
CV 我不算太熟，不过也可以勉强推荐几篇：

[Training ImageNet in 1 Hour（大批量训练技巧）](https://arxiv.org/pdf/1706.02677.pdf)
[Bag of Tricks for Image Classification with Convolutional Neural Networks（各种训练技巧集大成）](https://openaccess.thecvf.com/content_CVPR_2019/papers/He_Bag_of_Tricks_for_Image_Classification_with_Convolutional_Neural_Networks_CVPR_2019_paper.pdf)
[EfficientNet: Rethinking Model Scaling for Convolutional Neural Networks（当前对参数利用最有效的 CNN）](https://arxiv.org/pdf/1905.11946.pdf)

6、对于loss这种受 batch size、sequence length 各种因素影响的数字，人是没有数感的，建议首先计算一下 per token loss（如果是多任务，可以每个任务单独算；类似地，某些 CV 任务可以计算 per pixel loss），心里有点感觉。**脱离损失函数的形式谈学习率没有意义**（例如单是对 batch size 求和或者取平均这个差异就会使梯度差成百上千倍）。
在确定初始学习率的时候，从一个很小的值（例如 1e-7）开始，然后**每一步指数增大学习率（例如扩大1.05 倍）进行训练。**训练几百步应该能观察到损失函数随训练步数呈对勾形，选择损失下降最快那一段的学习率即可。
(Captain Jack令言：**观察loss胜于观察准确率**
准确率虽然是评测指标, 但是训练过程中还是要注意loss的. 你会发现有些情况下, 准确率是突变的, 原来一直是0, 可能保持上千迭代, 然后突然变1. 要是因为这个你提前中断训练了, 只有老天替你惋惜了. 而loss是不会有这么诡异的情况发生的, 毕竟优化目标是loss.
给NN一点时间, 要根据任务留给NN的学习一定空间. 不能说前面一段时间没起色就不管了. 有些情况下就是前面一段时间看不出起色, 然后开始稳定学习.）

7.1、优化器**只推荐** Momentum 和 Adam。在这些方面做尝试意义不大，如果性能提升反倒可能说明模型不成熟。

7.2、**Adam 可以解决一堆奇奇怪怪的问题**（有时 loss 降不下去，换 Adam 瞬间就好了），**也可以带来一堆奇奇怪怪的问题**（比如单词词频差异很大，当前 batch 没有的单词的词向量也被更新；再比如Adam和L2正则结合产生的复杂效果）。用的时候要胆大心细，万一遇到问题找各种魔改 Adam（比如 [MaskedAdam](https://www.zhihu.com/question/265357659/answer/580469438), AdamW 啥的）抢救。

8、subword 总是会很稳定地涨点，只管用就对了。

9、**GPU 上报错时尽量放在 CPU 上重跑**，错误信息更友好。例如 "ERROR:tensorflow:Model diverged with loss = NaN" 其实很有可能是输入 ID 超出了 softmax 词表的范围。

**10、别没耐心**！
**有些指标是有滞后性的，需要等训练一段时间才开始动。**很多人训练几步看没什么效果就把程序停掉开始 debug 了，但其实代码毫无问题。如此反复好几天甚至一两周都在原地踏步，其实需要做的仅仅是让程序自个儿安安静静地跑上几个小时或者一天……

### trick

-  fine-tuning: 通常来说，直接把预训练模型来用效果不一定足够好，因此需要进行fine-tuning（微调）。fine-tuning需要冻结网络的前几层参数，只更新网络结构的后面几层和最后的全连接层，这样效果会更好。

-   Learning rate:在迁移学习的微调过程中一般不建议使用过大的学习率，通常来说1e-5是比较合适的选择。

  #### 迁移学习往往还和你的任务中的数据关系密切，可以考虑以下几种情况。

  - ##### 新的数据集较小，并且和pre-trained model所使用的训练数据集相似度较高

    由于数据集较小，在进行finetune存在overfit的风险，又由于数据集和原始数据集相似度较高，因此二者不论是local feature还是global feature都比较相   近，所以此时最佳的方法是把CNN网络当做特征提取器然后训练一个分类器进行分类  

  - ##### 新的数据集较大，并且和pre-trained model所使用的训练数据集相似度较高：

    很明显，此时我们不用担心overfit，因此对全部网络结构进行fine-tune是较好的。

  - ##### 新的数据集较小，并且和pre-trained model所使用的训练数据集差异很大： 

    由于数据集较小，不适合进行fine-tune，由于数据集差异大，应该在单独训练网络结构中较高的层，前面几层local的就不用训练了，直接固定权值。在实际中，这种问题下较好的解决方案一般是从网络的某层开始取出特征，然后训练SVM分类器。 

  - ##### 新的数据集较大，并且和pre-trained model所使用的训练数据集差异很大：  

    本来由于数据集较大，可以从头开始训练的，但是在实际中更偏向于训练整个pre-trained model的网络。

  

  ​    