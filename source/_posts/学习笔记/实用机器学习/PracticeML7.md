---
title: praticalML第七章笔记
tags: [李沐,机器学习]
categories: [学习笔记,机器学习]
date: 2022-02-09 16:12:36
---

> 斯坦福2021秋季的实用机器学习上线啦~ :wink: 跟着沐神复习机器学习冲冲冲！ 记录一下笔记和重点，不一定很全哦~，只是记录自我感觉的重点。这一章主要是讲神经网络中的归一化，残差连接以及注意力机制。

# 第七章 ​归一化:purple_heart:

## 7.1 深度学习 :notes:
Deep Network Tuning 
• DL is a programming language to extract information from data
	• Some values will be filled by data later 
	• Differentiable
• Various design patterns, from layers to network architecture
• Here we talk about some of them

定义一个模板，模板中的参数是根据数据和目标学习得到的，因此其有很多模式。

## 7.2 Batch Normalization（批量归一化） :ocean:

• Standardizing data makes the loss smother for linear methods
	•Smooth: $ ∥∇f(x)− ∇f(y)∥^2 ≤ β∥x−y∥^2 $ 
	•A smaller $β$  allows a larger learning rate

​	• Does not help deep NN 

• Batch Normalization (BN) standards inputs for internal layers 

​	• Improves the smoothness to make training easier

• (Still controversial why BN works)

对于线性回归而言标准化的作用是使得数据均值为0，方差为1；作用是使得损失函数更加平滑，平滑就是$ ∥∇f(x)− ∇f(y)∥^2 ≤ β∥x−y∥^2 $​​​​​​ ，意味着在优化时求梯度更新时更稳定，可以调整使得学习率稍微大。但是对于神经网络而言，由于神经网络存在隐藏层，存在非线性就不能对中间层起到作用，可能只能对最后一层线性层有帮助。

因此需要BN层来对中间层进行数据标准化，使得函数更容易收敛。其实BN层的论文提出并不是此作用，存在争议，但是现在研究领域发现BN层的作用实际上就说数据标准化。

## 7.3 具体机制 :honeybee:

![](https://picture.mulindya.com/ParacticeML7-1.png)

可以将其拆解为4步。

第一步是reshape：如果输出不是2D就将其转化为2D矩阵，比如说n,c,w,h就会转化为nwh乘以c，可以理解c为特征数，每个通道识别不同的模式，可以将样本压到一维。

第二步是Normalize：也就是标准化，对每一列的数据标准化。（总共有c列）

第三步是Recovery：对刚刚做完的标准化的数据进行反标准化，通过可学习的参数$\gamma \ \beta$ 来进行一些调整，起到一定程度上的还原。

第四步是将得到的结果的维度还原到原始维度。

这里严谨来说应该是Batch Standardization，因为就统计上而言是标准化。

## 7.4 具体代码 :leaves:

```python
def batch_norm(X, gamma, beta, moving_mean, moving_var, eps, momentum): 
    #X是二维或者4维的向量 gamma和beta是可学的向量 moving_mean，moving_var是存着后续预测使用 eps是为了避免除零 momentum是全局的冲量
	if not torch.is_grad_enabled(): # In prediction mode 没有梯度是预测模式 这里使用的是训练过程中存的全局均值和方差
    	X_hat = (X - moving_mean) / torch.sqrt(moving_var + eps) 
	else: 
		assert len(X.shape) in (2, 4) 
		if len(X.shape) == 2:
        	mean = X.mean(dim=0) #对每一列求均值
            var = ((X - mean)**2).mean(dim=0) 
        else: 
        	mean = X.mean(dim=(0, 2, 3), keepdim=True) 
        	var = ((X - mean)**2).mean(dim=(0, 2, 3), keepdim=True) 
        X_hat = (X - mean) / torch.sqrt(var + eps) 
        moving_mean = momentum * moving_mean + (1.0 - momentum) * mean
        moving_var = momentum * moving_var + (1.0 - momentum) * var
    Y = gamma * X_hat + beta
    return Y, moving_mean, moving_var
```

## 7.5 Layer Normalization（层归一化） :gift:

• If apply to RNN, BN needs maintain separated moving statistics for each time step

​	• Problematic for very long sequences during inference

• Layer normalization reshapes input  $ X∈ ℝ^{n×p}→X′∈ ℝ^{p×n} $​ or $ X∈ ℝ^{n×c×w×h}→X′∈ ℝ^{cwh×n}$​ , rest is same with BN

​	• Normalizing within each example, up to current time step

​	 • Consistent between training and inference

​	• Popularized by Transformers

主要是用于循环神经网络

假设句子长度是p，进行p次mlp，每个时间步骤是把当前的矩阵（样本乘以特征）以及放入mlp，每个句子也是不等长的，在每一个时间步需要用均值方差和参数$\gamma  \beta$​​​​​​,而在不同时间步他们的差别是比较大的，​​但是BN应该是对当前的数据进行稳定的方差估计，如果均值方差抖动比较大的话，就失去了标准化的意义，并且在预测的时候如果出现长度更长的句子，效果就不好了。层归一化就是对每一个小单元做标准化。比如说一个句子，一张图像。在预测的时候无须全局的信息，在RNN和Transformer中效果很好，在CNN上可能没有什么效果。

## 7.6 更多归一化 :key:

More Normalizations• Modify “reshape”, e.g

.•InstanceNorm:$ n \times c \times w \times h \to wh \times cn$​ 每一个位置

•GroupNorm: $ n \times c \times w \times h \to swh \times gn $​  with $ c = sg$​  对c分组​

• CrossNorm: swap mean/std between a pair of features 交换mean和std

• Modify “normalize”: e.g. whitening  使用白化，不仅仅使得均值为0方差为1，而且使得特征之间没有关系，也就是进行PCA降维

 •Modify “recovery”: e.g.  $\gamma \ \beta$​​​​ replace  with a dense layer 可以把参数改成线性层甚至mlp去还原

• Apply to weights or gradients （Normalizations主要对层的输入中，也可以对权重w或者梯度来标准化）

最近发现在GAN，Adversarial Attack中使用BN效果不好，针对不同的问题要选择合适的Normalizations的技术。

## 7.7 Summary :e-mail:

• Normalizing inputs of internal layers makes deep NNs easier to train   

• A normalization layer performs three steps: r**eshape input, normalize data, recovery with learnable parameters**  通用步骤

​	• Notable examples include Batch Normalization for CNNs, Layer Normalization for Transformers 现在很多人发现在CNN上不用BN也是没有什么问题的。

Normalizing 可以把中间层的数值更稳定，使得损失函数更加平滑，使得网络的训练更加容易，一般来说，对准确率没有太大影响，但是可以让曲线更加稳定平滑。其实神经网络并不一定需要使用BN，可以进行一些其他的操作，比如对梯度进行Clipping，使其不要太大。并且其实BN在计算上，在实现上会带来很大的问题。
