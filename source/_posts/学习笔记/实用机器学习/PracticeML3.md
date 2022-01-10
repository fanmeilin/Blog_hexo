---

title: praticalML第三章笔记
tags: [李沐,机器学习] 
categories: [ 学习笔记,机器学习]
date: 2022-01-10 14:27:22
math: True
---

> 斯坦福2021秋季的实用机器学习上线啦~ :wink: 跟着沐神复习机器学习冲冲冲！ 记录一下笔记和重点，不一定很全哦~，只是记录自我感觉的重点。
> 这一章的内容是对各种机器学习模型的介绍，包括有决策树，线性模型，多层感知机，卷积神经网络，循环神经网络。

# 第三章 机器学习模型

## 3.1 机器学习介绍:balloon:

分类可以分成：

1. 监督学习（Surprised）：有标号的数据上来训练模型来预测标号
   - 衍生出现self-supervised 自监督学习：可以产生标号，只是其标号是来自数据本身（eg:word2vec,BERT）
2. 半监督学习（Semi-superised）存在小部分有标号的数据，还有大部分没有标号的数据。
   - eg：self-training 使用自训练的过程来预测标号再一起训练。
3. 无监督学习（Unsuperised）在没有标号的数据上训练
   - eg：clustering，density estimation（GAN）
4. 强化学习（Reinforce）在一个环境中交互，并且基于观察点来学习，类似人类学习的方法。Use observations from the interaction with the environment to take actions to maximize reward。

### 3.1.1 监督学习中的Components

- Model（模型） 从输入中得到输出
- Loss（损失函数）评估真实样本和预测结果的差距
- Objective（目标函数对象）The goal to optimize model params for
- Optimization（优化算法）he algorithm for solving the objective

### 3.1.2 监督学习模型

- **Decision trees**  • Use trees to make decisions 
- **Linear methods** • Decision is made from a linear combination of input features（做决策的输出是输入的线性组合） 
- **Kernel machines** • Use kernel functions to compute feature similarities  （核函数来衡量两个样本特征之间的相似度，指定不同的核函数，特征相似度不同，达到非线性的效果）
- **Neural Networks** • Use neural networks to learn feature representations

### 3.1.3 总结

![](https://picture.mulindya.com/pML3-1.png)

## 3.2 决策树 :palm_tree:

包括有分类树，回归树（此时叶子节点不是类别而是实数值）

##### 好处（pros）：

- 可解释（可应用于银行业，保险业）；
- 可以用于数值或类别特征；

##### 缺点（cons）：

- 鲁棒性差（可以用集成学习改善）；
- 数据很复杂时可能产生过拟合（可以使用剪枝）；
- 难以使用并行计算

### 3.2.1 生成决策树

![](https://picture.mulindya.com/pML3-2.png)

### 3.2.2 随机森林

训练多个决策树来增强并行性，分类时使用投票机制，回归时使用多个树的平均；对整个树的稳定性有好处。

- Train multiple decision trees to improve robustness  
  • Trees are trained independently in parallel   
  • Majority voting for classification, average for regression 
-  Where is the randomness from? 
  • Bagging: randomly sample training examples with replacement  
      • E.g. [1,2,3,4,5]   [1,2,2,3,4] 
  • Randomly select a subset of features 

这里的随机森林中的随机来自于两个方面哦~

一个是Bagging，训练一棵树在训练集中随机采样一些样本出来（可重复采样），所以在训练集中会出现重复样本，继续重复训练其他树；

另一个是对于获取的训练集是随机进行采样特征列（此时是无重复的特征列采样）；

### 3.2.3 Gradient Boosting Decision Trees

训练多棵树，但是这里不是独立完成决策，而是顺序的完成，利用这些树来合成一个大的模型出来，在t时刻 $ F_t(x) $ 表示是对前面训练的t-1棵树求和，训练的这颗树需要和所有的树的结果加起来，利用残差的思想训练$f_t(x)$（也就是“不准”的部分）

同时这里的残差（$y_i-F_t(x_i)$）就等于梯度值($ -\frac{\alpha L}{\alpha F} $)（使用均方误差作为loss）

![](https://picture.mulindya.com/pML3-3.png)

### 3.2.3 总结

- Decision tree: an explainable model for classification/regression 
- Easy to train and tune, widely used in industry
-  Sensitive to data 
  • Ensemble can help (more on bagging and boosting latter)

决策树是一个为数不多的可解释性模型，对数据的噪音很敏感所以可以使用很多树一起训练来降低偏移和方差。可以用树模型时尽量用树模型哟。

## 3.3 线性回归 :chart_with_upwards_trend:

### 3.3.1 概念

 ![](https://picture.mulindya.com/pML3-4.png)

x*w是按元素来做乘积得到还是一个向量（list）

### 3.3.2 目标函数

![](https://picture.mulindya.com/pML3-5.png)

学习参数w，b；在所有样本中求均方误差，最小化MSE。

### 3.3.3 使用线性回归来分类

![](https://picture.mulindya.com/pML3-6.png)

使用线性回归的二分类称为逻辑回归；

这里类别数为m，真实标号y是one-hot向量，Oi也是一个长度为m的向量，Wi为矩阵形式，目标函数依然是最小化均方误差。类似没有隐藏层的”神经网络“。

### 3.3.4 Softmax Regression

![](https://picture.mulindya.com/pML3-7.png)

这种方法的侧重点是最大化one-hot中正确样本的值，对其他样本点值置信度不会强制逼近为0。避免精力集中于one-hot中其他样本为0的拟合；首先把输出转化为概率分布的形式，这里虽然出现了非线性变换（使用softmax），但是此决策方法还是线性模型。

此时比较两个概率分布，使用交叉熵来衡量向量的差别，只用关注真实类的值，让其越大越好。

## 3.4 随机梯度下降 :chart_with_downwards_trend:

![](https://picture.mulindya.com/pML3-8.png)

求解最优解的方法可以使用随机梯度下降的方法，线性回归中的b是在输入的X中增加一行1,所以这里的b表示批量大小。
$$
O = W^TX+b 
$$
在X中加一行全1数据
$$
O = W^TX
$$
可以解决除了决策树以外的其他算法（课内）的收敛，超参数是b和n；

### 3.4.1 代码

• Train a linear regression model with min-batch SGD 
• Hyperparameters 
	• batch_size 
	• learning_rate 
	• num_epochs

这里是输出一个结果值而非向量，因为这里是回归哟~   

```python
# `features` shape is (n, p),样本数 特征数 `labels` shape is (n, 1) 
def data_iter(batch_size, features, labels): #小批量的读取
    num_examples = len(features)  #样本数
    indices = list(range(num_examples)) 
    random.shuffle(indices)  # read examples at random  随机采样
    for i in range(0, num_examples, batch_size): 
        batch_indices = torch.tensor( 
            indices[i:min(i + batch_size, num_examples)]) 
        yield features[batch_indices], labels[batch_indices] #yield是一个反复的操作，会创建迭代器，可以用for来遍历
w = torch.normal(0, 0.01, size=(p, 1), requires_grad=True) 
b = torch.zeros(1, requires_grad=True) 
for epoch in range(num_epochs): 
    for X, y in data_iter(batch_size, features, labels): 
        y_hat = X @ w + b  #@是用来对tensor进行矩阵相乘的；*用来对tensor进行矩阵进行逐元素相乘；
        loss = ((y_hat - y)**2 / 2).mean() #均方误差
        loss.backward()  #求导
        for param in [w, b]: # 对w，b更新
            param -= learning_rate * param.grad   #梯度更新
            param.grad.zero_()  #梯度清零
```

### 3.4.2 总结

• Linear methods linearly combine inputs to obtain predictions 
• Linear regression uses MSE as the loss function 
• Softmax regression is used for multiclass classification 
	• Turn predictions into probabilities and use cross-entropy as loss 
	• Cross entropy loss between two probability distribution 
• Mini-batch SGD can learn both models (and later neural networks as well)

## 3.5 神经网络 :pencil2:

• NN usually requires more data and more computation 
• NN architectures to model data structures 
	• Multilayer perceptions 
	• Convolutional neural networks 
	• Recurrent neural networks 
	• Transformer
• Design NN to incorporate prior knowledge about the data

使用机器来提取特征比手动提取特征要好，但是需要更多的数据，可能数据集大了1000倍。

### 3.5.1 多层感知机

![](https://picture.mulindya.com/pML3-9.png)

- 线性回归相当于是m=1的全连接层

- Softmax回归是m为m的全连接层

#### MLP

通过激活函数来构建非线性模型

- Activation is a elemental-wise non-linear function 

  eg:

$$
sigmoid(x) = \frac{1}{1+e^{(-x)}}
$$


$$
Relu(x) = max(x,0)
$$
​	• It leads to non-linear models 

- Stack multiple hidden layers  (dense + activation) to get deeper models 堆叠隐藏层
- Hyper-parameters: 
  \# hidden layers, # outputs of each hidden layer 
-  Universal approximation theorem

#### code

• MLP with 1 hidden layer 
• Hyperparameter: num_hiddens 

一个隐藏层H 最后做一个线性映射输出。

```python
def relu(X): 
    return torch.max(X, 0) 
W1 = nn.Parameter(torch.randn(num_inputs, num_hiddens) * 0.01) 
b1 = nn.Parameter(torch.zeros(num_hiddens)) 
W2 = nn.Parameter(torch.randn(num_hiddens, num_outputs) * 0.01) 
b2 = nn.Parameter(torch.zeros(num_outputs)) 
H = relu(X @ W1 + b1) 
Y = H @ W2 + b2 
```

### 3.5.2 卷积神经网络

#### 引入

-  Learn ImageNet (300x300 images with 1K classes) by a MLP with a single hidden layer with 10K outputs  
  • It leads to 1 billion learnable parameters, that’s too big! 
  • Fully connected: an output is a weighted sum over all inputs 
- Recognize objects in images 
  • **Translation invariance**: similar output  no matter where the object is 
  • **Locality**: pixels are more related to  near neighbors  
-  Build the prior knowledge into the model structure 
  • Achieve same model capacity with less # params

由于全连接层的参数量为m*n，纯用MLP参数量太大了，引用卷积层

对于图像有两大特性

1. 变换不变性：表示同一object在图像区域的变换对结果没有影响；
2. 本地性：某一像素与附近的像素点的关联度较高，远处的关联度比较低；

#### 具体机制

![](https://picture.mulindya.com/pML3-10.png)

- 本地性：卷积层的一个输出只是来源于k*k的一个像素块进行局部计算；

- 平移（/变换）不变性：在一个feature map的channel上使用相同卷积核，权重共享，因为和位置无关。

所以模型的参数量只与k有关，与输入输出的大小无关；卷积核通常是会被学习成去识别一个图像中的pattern。

#### 代码

单通道卷积的实现，k是kernel的权重，Y是最后的输出，其维度是X的宽高减去对应的k宽高再加1。

```python
# both input `X` and weight `K` are matrices 
h, w = K.shape 
Y = torch.zeros((X.shape[0] - h + 1, X.shape[1] - w + 1)) 
# stride = 1 
for i in range(Y.shape[0]):   
    for j in range(Y.shape[1]): 
        Y[i, j] = (X[i : i+h, j : j+w] * K).sum() #点乘再求和的计算称为交叉相关
```

#### Pooling Layer 汇聚层

卷积层对输入的位置敏感，如果输入的object移动一个微小距离对应的输出也会出现移动，这样鲁棒性会降低，通过池化层（汇聚层）可以解决这个问题。

每一次在K*K的窗口中使用平均汇聚或者最大汇聚，这样对K个像素的偏移就不会太大影响。

- Convolution is sensitive to location  
  	• A translation/rotation of a pattern in the input results similar changes of a pattern in the output 
- A pooling layer computes mean/max in windows of size k × k

```python
# h, w: pooling window height and width 
# mode: max or avg 
Y = torch.zeros((X.shape[0] - h + 1, X.shape[1] - w + 1)) 
for i in range(Y.shape[0]): 
    for j in range(Y.shape[1]): 
        if mode == 'max': 
            Y[i, j] = X[i : i+h, j : j+w].max() 
        elif mode == 'avg': 
            Y[i, j] = X[i : i+h, j : j+w].mean()
```

#### 卷积神经网络

-  Stacking convolution layers to extract features 
  • Activation is applied after each convolution layer 
  • Using pooling to reduce location sensitivity  
- Modern CNNs are deep neural network with various hyper-parameters and layer connections (AlexNet, VGG, Inceptions, ResNet, MobileNet)

卷积神经网络把卷积层堆叠起来，使用卷积层抽取空间信息，满足变换不变性和本地性的特征。激活层在卷积层之后，卷积层是一种特殊的全连接层（每次只看小窗口，其他权重为0），本质上还是线性变换，所以需要激活层来非线性化；同时使用汇聚层来降低卷积层对位置的敏感性。

> lenet = nn.Sequential( 
>     nn.Conv2d(...), 
>     nn.Sigmoid(), 
>     nn.AvgPool2d(...), 
>     nn.Conv2d(), 
>     nn.Sigmoid(), 
>     nn.AvgPool2d(...), 
>     nn.Flatten(), 
>     nn.Linear(...), 
>     nn.Sigmoid(), 
>     nn.Linear(...), 
>     nn.Sigmoid(), 
>     nn.Linear(...))

### 3.5.3 循环神经网络 

语言模型中设计循环神经网络，通过前面的信息来预测当前信息，时间序列信息中通过前面几个项来预测后一个项。

使用Dense时由前一个词作为输入预测当前词，当时无法获取时间序列信息，因为输入长度维度不可随意变化。所以这里需要对时序信息添加到输入中，也就是RNN，可以将前面的输出（隐藏层）添加进入当前层的输入。**注意这里的对每个词权重是一样的**（后续代码中也可以看到）。

#### Dense与Recurrent networks

![](https://picture.mulindya.com/pML3-11.png)

#### RNN和变种

![](https://picture.mulindya.com/pML3-12.png)

注意隐藏层是经过激活层激活之后再输入，增加前向隐藏层。
$$
h_t = \sigma(W_{hh}h_{t-1}+W_{hx}x_t+b_h)
$$
有些变种会涉及门来抑制某些信息比如LSTM，GRU，会对信息流进行细致的控制，比如对过去或者现在的信息采取遗忘、抑制，这种操作也是通过一组权重来学习决定是否对特定信息抑制。

#### 代码

实现简单的RNN。

```python
W_xh = nn.Parameter(torch.randn(num_inputs, num_hiddens) * 0.01) 
W_hh = nn.Parameter(torch.randn(num_hiddens, num_hiddens) * 0.01)  #多出来的
b_h = nn.Parameter(torch.zeros(num_hiddens)) 
H = torch.zeros(num_hiddens) 
outputs = [] 
#把每个词放入作为输入
for X in inputs:  # `inputs` shape : (num_steps, batch_size, num_inputs)  num_steps表示一组输入 各个词
    H = torch.tanh(X @ W_xh + H @ W_hh + b_h)  #对每个词其实权重是一样的，只是绘图的时候方便表示展开拉长
    outputs.append(H)
```

#### Bi-RNN and Deep RNN

![](https://picture.mulindya.com/pML3-13.png)

可以从双向来检索，这样yt的信息来源是它两侧的信息，比如完形填空，是可以获取双向信息哦。

#### 模型选择

不同的模型使用与不同数据，表格数据使用一般树模型，线性模型，神经网络。Transformer对文本和图像都可以处理，实际上文本信息和图像信息有相似的内部特性，只是维度不一样而已。

![](https://picture.mulindya.com/pML3-14.png)

### 3.5.4 总结

• MLP: stack dense layers with non-linear activations 
• CNN: stack convolution activation and pooling layers to efficient extract spatial information 
• RNN: stack recurrent layers to pass temporal information through hidden state

CNN：高效抓取空间信息

RNN：持续信息的数据，比如对时序信息。
