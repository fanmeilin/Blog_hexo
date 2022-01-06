---
title: Knowledge Distillation笔记
tags: [李宏毅,知识蒸馏]
categories: [学习笔记,深度学习]
date: 2022-01-05 16:38:33
math: true
---

> 因为项目中要使用到知识蒸馏来训练网络，所以先好好学一下它的原理。在网上找到了李宏毅机器学习的模型压缩中讲到了这个，那，就开始学习叭:wink:

# 知识蒸馏:milky_way:

## 概念

先训练一个大的network（teacher），再根据这个network来制造小的network（student），同时student是根据teacher的结构做一些修剪得到的小网络，student network是根据teacher network来学习的哦。

![](https://picture.mulindya.com/kDistillation-1.png)

student network是去拟合teacher的结果，可以使用Ensemble的网络作为teacher，这样表现得结果更好。

![](https://picture.mulindya.com/kDistillation-2.png)

在使用知识蒸馏时有一个小技巧，可以稍微改一下Softmax的函数，T是一个超参数，可以使得函数点更加平滑。因为student要学习teacher给的结果，并且teacher给的结果要告诉student，哪些类别比较相似，而不是直接给出1，0，0（和真实结果没有差别），所以teacher 的输出不应该过度集中，需要更加平滑。这样分类结果不同，但是student学习更加有意义。同时不一定要用softmax之后的结果去拟合student，完全可以使用之前的，或者类似student的第6层拟合teacher的12层，第3层拟合teacher的第6层，这样结果往往会更好。

## 实例:sunflower:

### Intuition

通常模型Teacher比模型Student更强，在模型Teacher的帮助下，模型student可以"青出于蓝而胜于蓝":wink:,因为从计算资源的角度上庞大的模型部署有很多问题，所以通过知识蒸馏可以训练一个相似的小模型去拟合大模型的训练效果，这样预测和部署会便捷很多。同时使用知识蒸馏的方法可以让小模型学到样本之间的相似关系。

![](https://picture.mulindya.com/kDistillation-9.png)

这里不仅仅知道西红柿是真实标签，还可以知道这个样本和柿子这个标签很相似，这样可以获取更多信息，这是蒸馏更有价值的地方。

### Loss Function in Pytorch

- `Softmax`：将一个数值序列映射到概率空间（每个元素分布并且所有和为1）
- `log_softmax`：在softmax的基础上取对数
- `NLLLoss`：对log_softmax与one-hot进行计算
- `CrossEntropy`：衡量两个概率分布的差别（交叉熵）

#### 代码实证

```python
import torch
import torch.nn.functional as F
'''
torch.nn.functional 涉及了所有 torch.nn 需要 类 和 方法 ，torch.nn 构建的模块通常就是调用 torch.nn.functional 里的方法实现的.
'''
torch.manual_seed(0)
```

```python
output = torch.randn(2, 3)
print(output)
#tensor([[ 1.5410, -0.2934, -2.1788],
#        [ 0.5684, -1.0845, -1.3986]])
print(F.softmax(output, dim=1))
# 这里dim的意思是计算Softmax的维度，这里设置dim=1，可以看到每一行的加和为1。0是对列 1 是对行
#tensor([[0.8446, 0.1349, 0.0205],
#       [0.7511, 0.1438, 0.1051]])
```
#### What is log_softmax

这个很好理解，其实就是对`softmax`处理之后的结果执行一次对数运算。可以理解为 `log(softmax(output))`

```python
print(F.log_softmax(output, dim=1))
print(torch.log(F.softmax(output, dim=1)))
# 输出结果是一致的
```

> tensor([[-0.1689, -2.0033, -3.8886],        [-0.2862, -1.9392, -2.2532]]) tensor([[-0.1689, -2.0033, -3.8886],        [-0.2862, -1.9392, -2.2532]])
>

#### 损失函数

#### What is NLLLoss？

该函数的全称是`negative log likelihood loss`. 若$x_i=[q_1, q_2, ..., q_N]$ 为神经网络对第i个样本的输出值，$y_i$为真实标签。则：
$$
f(x_i,y_i)=-q_{y_i}
$$
其中输入：log_softmax(output), target

```python
print(F.nll_loss(torch.tensor([[-1.2, -2, -3]]), torch.tensor([0])))
#结果是tensor(1.2000) 就是取第0个的负数
```

**通常我们结合 log_softmax 和 nll_loss一起用** :wave:。

#### CrossEntropy交叉熵

**在分类问题中，CrossEntropy等价于log_softmax 结合 nll_loss**

$N$分类问题，对于一个特定的样本，已知其真实标签，`CrossEntropy`的计算公式为：

$$
cross\_entropy=-\sum_{k=1}^{N}\left(p_{k} * \log q_{k}\right)
$$

其中p表示真实值，在这个公式中是one-hot形式；q是经过`softmax`计算后的结果， $q_k$为神经网络认为该样本为第$k$类的概率。

仔细观察可以知道，因为p的元素不是0就是1，而且又是乘法，所以很自然地我们如果知道1所对应的index，那么就不用做其他无意义的运算了。所以在pytorch代码中target不是以one-hot形式表示的，而是直接用scalar表示。若该样本的真实标签为$y$,则交叉熵的公式可变形为：

$$cross\_entropy=-\sum_{k=1}^{N}\left(p_{k} * \log q_{k}\right)=-log \, q_{y}$$

```python
output = torch.tensor([[1.2, 2, 3]])
target = torch.tensor([0])

log_sm_output = F.log_softmax(output, dim=1)
nll_loss_of_log_sm_output = F.nll_loss(log_sm_output, target)
print(nll_loss_of_log_sm_output)
```

```python
output = torch.tensor([[1.2, 2, 3]])
target = torch.tensor([0])

ce_loss = F.cross_entropy(output, target)
print(ce_loss)

F.cross_entropy 《==》 F.log_softmax(output, dim=1)+F.nll_loss(log_sm_output, target)
```

这两者是等价的哦~

#### T-softmax

T-softmax的目的是平滑分布，不让分布太过于极端。比如可以看下面的实例哈。

```python
import numpy as np

def softmax(x):
    x_exp = np.exp(x)
    return x_exp / np.sum(x_exp)

output = np.array([0.1, 1.6, 3.6])
print(softmax(output))
#[0.02590865 0.11611453 0.85797681]
```

```python
def softmax_t(x, t):
    x_exp = np.exp(x / t)
    return x_exp / np.sum(x_exp)

output = np.array([0.1, 1.6, 3.6])
print(softmax_t(output, 5))
#[0.22916797 0.3093444  0.46148762]
```

设置为5可以看到分布在【0，1】的数更加平滑了哦~

## KD训练代码

### 导入包

```python
import math
import torch
import torch.nn as nn
import torch.nn.functional as F
from torchvision import datasets, transforms
import torch.utils.data
torch.manual_seed(0)
torch.cuda.manual_seed(0) #设置GPU生成随机数的种子，方便下次复现实验结果。
```

### 网络架构
#### teacher网络

```python
class TeacherNet(nn.Module): #继承Module
    def __init__(self):
        super(TeacherNet, self).__init__()
        self.conv1 = nn.Conv2d(1, 32, 3, 1)
        self.conv2 = nn.Conv2d(32, 64, 3, 1)
        self.dropout1 = nn.Dropout2d(0.3)
        self.dropout2 = nn.Dropout2d(0.5)
        self.fc1 = nn.Linear(9216, 128)
        self.fc2 = nn.Linear(128, 10)

    def forward(self, x):
        x = self.conv1(x)
        x = F.relu(x)
        x = self.conv2(x)
        x = F.relu(x)
        x = F.max_pool2d(x, 2)
        x = self.dropout1(x)
        x = torch.flatten(x, 1)
        x = self.fc1(x)
        x = F.relu(x)
        x = self.dropout2(x)
        output = self.fc2(x)
        return output
```
#### student网络

```python
class StudentNet(nn.Module):
    def __init__(self):
        super(StudentNet, self).__init__()
        self.fc1 = nn.Linear(28 * 28, 128)
        self.fc2 = nn.Linear(128, 64)
        self.fc3 = nn.Linear(64, 10)

    def forward(self, x):
        x = torch.flatten(x, 1)
        x = F.relu(self.fc1(x))
        x = F.relu(self.fc2(x))
        output = F.relu(self.fc3(x))
        return output
```

### teacher网络训练
#### 定义基本函数

```python
def train_teacher(model, device, train_loader, optimizer, epoch):
    model.train() #train过程model.train()的作用是启用 Batch Normalization 和 Dropout。model.train()是保证BN层能够用到每一批数据的均值和方差
    trained_samples = 0
    for batch_idx, (data, target) in enumerate(train_loader):
        data, target = data.to(device), target.to(device) #放到GPU
        optimizer.zero_grad() #归0
        output = model(data) #得到结果
        loss = F.cross_entropy(output, target) #计算损失 使用交叉熵
        loss.backward() #后向传播更新参数
        optimizer.step() #优化器调整超参数

        trained_samples += len(data)
        progress = math.ceil(batch_idx / len(train_loader) * 50)
        print("\rTrain epoch %d: %d/%d, [%-51s] %d%%" %
              (epoch, trained_samples, len(train_loader.dataset),
               '-' * progress + '>', progress * 2), end='')


def test_teacher(model, device, test_loader):
    model.eval() #保证BN层能够用全部训练数据的均值和方差
    test_loss = 0
    correct = 0
    with torch.no_grad(): #冻结参数
        for data, target in test_loader:
            data, target = data.to(device), target.to(device)
            output = model(data) #模型得到结果
            test_loss += F.cross_entropy(output, target, reduction='sum').item()  # 统计所有的losssum up batch loss
            pred = output.argmax(dim=1, keepdim=True)  # get the index of the max log-probability 得到每一行的最大值下标
            correct += pred.eq(target.view_as(pred)).sum().item() #eq是一个判断函数 view_as是拉成一列

    test_loss /= len(test_loader.dataset) #得到平均loss

    print('\nTest: average loss: {:.4f}, accuracy: {}/{} ({:.0f}%)'.format(
        test_loss, correct, len(test_loader.dataset),
        100. * correct / len(test_loader.dataset)))
    return test_loss, correct / len(test_loader.dataset)

```
#### 训练主函数

```python
def teacher_main():
    epochs = 10
    batch_size = 64
    torch.manual_seed(0) #设置CPU生成随机数的种子，方便下次复现实验结果。

    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

    train_loader = torch.utils.data.DataLoader(
        datasets.MNIST('../data/MNIST', train=True, download=True,
                       transform=transforms.Compose([
                           transforms.ToTensor(),
                           transforms.Normalize((0.1307,), (0.3081,))
                       ])),
        batch_size=batch_size, shuffle=True)
    test_loader = torch.utils.data.DataLoader(
        datasets.MNIST('../data/MNIST', train=False, download=True, transform=transforms.Compose([
            transforms.ToTensor(),
            transforms.Normalize((0.1307,), (0.3081,))
        ])),
        batch_size=1000, shuffle=True)

    model = TeacherNet().to(device) #模型装进GPU中
    optimizer = torch.optim.Adadelta(model.parameters()) #定义优化器 其实需要传入模型参数让优化器知道参数空间
    '''
    optimzier优化器的作用：优化器就是需要根据网络反向传播的梯度信息来
    再次更新网络的参数，以起到降低loss函数计算值的作用。
    '''
    
    teacher_history = [] #保存历史数据

    for epoch in range(1, epochs + 1):
        train_teacher(model, device, train_loader, optimizer, epoch)
        loss, acc = test_teacher(model, device, test_loader) #相当于验证集作用 也可以绘图
        
        teacher_history.append((loss, acc))

    torch.save(model.state_dict(), "teacher.pt")
    return model, teacher_history
```

```python
# 训练教师网络
teacher_model, teacher_history = teacher_main()
```

### student网络训练（重点）:cherry_blossom:

#### 理论部分

![](https://picture.mulindya.com/kDistillation-10.png)

这里的q是经过了`softmax`之后的分布

student的loss来源于两个部分，Loss将两个loss相加

- studet的HARD Loss是根据one-hot的真实样本p分布得到（和一般的loss一样）
- student的SOFT loss是来源于teacher的分布q’‘（是将q’蒸馏平滑后的结果）

#### 定义kd的loss


```python
# 这里定义的是SOFT Loss + 交叉熵（HARD Loss）
def distillation(y, labels, teacher_scores, temp, alpha):
    return nn.KLDivLoss()(F.log_softmax(y / temp, dim=1), F.softmax(teacher_scores / temp, dim=1)) * (
            temp * temp * 2.0 * alpha) + F.cross_entropy(y, labels) * (1. - alpha) #两个分布都是T_softmax来求相对熵

```

> nn.KLDivLoss()(input,target)相对熵损失 通过求散度得到Loss值
>
>  用于衡量两个分布的相似性，越小越相似


{% raw %}
$$
l_{n}=y_{n} \cdot\left(\log y_{n}-x_{n}\right)
$$
{% endraw %}

可以指定loss function的reduction参数，来设置每个样本loss的最后得到数据loss计算方式；

{% raw%}
$$
\ell(x, y)=\left\{\begin{array}{ll}L, & \text { if reduction }=\text { 'none' } \\ \operatorname{mean}(L), & \text { if reduction }=\text { 'mean' } \\ N*\operatorname {mean}(L), & \text { if reduction }=\text { 'batchmean' } \\ \operatorname{sum}(L), & \text { if reduction }=\text { 'sum' }\end{array} \right.
$$
{% endraw %}

#### 定义基本函数

```python
def train_student_kd(model, device, train_loader, optimizer, epoch):
    model.train()
    trained_samples = 0
    for batch_idx, (data, target) in enumerate(train_loader):
        data, target = data.to(device), target.to(device)
        optimizer.zero_grad()
        output = model(data)
        teacher_output = teacher_model(data)  #得到teacher网络的推断用于后续计算student的loss
        teacher_output = teacher_output.detach()  # 切断老师网络的反向传播
        loss = distillation(output, target, teacher_output, temp=5.0, alpha=0.7)
        loss.backward()
        optimizer.step()

        trained_samples += len(data)
        progress = math.ceil(batch_idx / len(train_loader) * 50)
        print("\rTrain epoch %d: %d/%d, [%-51s] %d%%" %
              (epoch, trained_samples, len(train_loader.dataset),
               '-' * progress + '>', progress * 2), end='')


def test_student_kd(model, device, test_loader):
    model.eval()
    test_loss = 0
    correct = 0
    with torch.no_grad():
        for data, target in test_loader:
            data, target = data.to(device), target.to(device)
            output = model(data)
            test_loss += F.cross_entropy(output, target, reduction='sum').item()  # sum up batch loss item()函数可以理解为得到纯粹的数值
            pred = output.argmax(dim=1, keepdim=True)  # get the index of the max log-probability
            correct += pred.eq(target.view_as(pred)).sum().item()

    test_loss /= len(test_loader.dataset)

    print('\nTest: average loss: {:.4f}, accuracy: {}/{} ({:.0f}%)'.format(
        test_loss, correct, len(test_loader.dataset),
        100. * correct / len(test_loader.dataset)))
    return test_loss, correct / len(test_loader.dataset)
```

#### 训练主函数


```python
def student_kd_main():
    epochs = 10
    batch_size = 64
    torch.manual_seed(0)

    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

    train_loader = torch.utils.data.DataLoader(
        datasets.MNIST('../data/MNIST', train=True, download=True,
                       transform=transforms.Compose([
                           transforms.ToTensor(),
                           transforms.Normalize((0.1307,), (0.3081,))
                       ])),
        batch_size=batch_size, shuffle=True)
    test_loader = torch.utils.data.DataLoader(
        datasets.MNIST('../data/MNIST', train=False, download=True, transform=transforms.Compose([
            transforms.ToTensor(),
            transforms.Normalize((0.1307,), (0.3081,))
        ])),
        batch_size=1000, shuffle=True)

    model = StudentNet().to(device)
    optimizer = torch.optim.Adadelta(model.parameters())
    
    student_history = []
    for epoch in range(1, epochs + 1):
        train_student_kd(model, device, train_loader, optimizer, epoch)
        loss, acc = test_student_kd(model, device, test_loader)
        student_history.append((loss, acc))

    torch.save(model.state_dict(), "student_kd.pt")
    return model, student_history
```


```python
student_kd_model, student_kd_history = student_kd_main()
```

### 绘制结果

```python
import matplotlib.pyplot as plt
epochs = 10
x = list(range(1, epochs+1))

plt.subplot(2, 1, 1)
plt.plot(x, [teacher_history[i][1] for i in range(epochs)], label='teacher')
plt.plot(x, [student_kd_history[i][1] for i in range(epochs)], label='student with KD')
plt.plot(x, [student_simple_history[i][1] for i in range(epochs)], label='student without KD')

plt.title('Test accuracy')
plt.legend()


plt.subplot(2, 1, 2)
plt.plot(x, [teacher_history[i][0] for i in range(epochs)], label='teacher')
plt.plot(x, [student_kd_history[i][0] for i in range(epochs)], label='student with KD')
plt.plot(x, [student_simple_history[i][0] for i in range(epochs)], label='student without KD')

plt.title('Test loss')
plt.legend()
```

![](https://picture.mulindya.com/kDistillation-13.png)

可以看到在teacher的帮助下，student可以学得更好:cat:

### teacher网络的暗知识:bamboo:

#### softmax_t

```python
import numpy as np
from matplotlib import pyplot as plt

def softmax_t(x, t):
    x_exp = np.exp(x / t)
    return x_exp / np.sum(x_exp)

test_loader_bs1 = torch.utils.data.DataLoader(
    datasets.MNIST('../data/MNIST', train=False, download=True, transform=transforms.Compose([
        transforms.ToTensor(),
        transforms.Normalize((0.1307,), (0.3081,))
    ])),
    batch_size=1, shuffle=True)
```
#### 推断

```python
teacher_model.eval()
with torch.no_grad():
    data, target = next(iter(test_loader_bs1))
    data, target = data.to('cuda'), target.to('cuda')
    output = teacher_model(data)

test_x = data.cpu().numpy() #放进cpu转换成numpy
y_out = output.cpu().numpy()
y_out = y_out[0, ::]
print('Output (NO softmax):', y_out)



plt.subplot(3, 1, 1)
plt.imshow(test_x[0, 0, ::])

plt.subplot(3, 1, 2)
plt.bar(list(range(10)), softmax_t(y_out, 1), width=0.3) #直方图

plt.subplot(3, 1, 3)
plt.bar(list(range(10)), softmax_t(y_out, 10), width=0.3)
plt.show()
```
> Output (NO softmax): [-31.14481   -30.600847   -3.2787514 -20.624037  -31.863455  -37.684086 -35.177486  -22.72263   -16.028662  -26.460657 ]

![](https://picture.mulindya.com/kDistillation-12.png)

可以看到数据更加平滑，并且可以体现出这个数字不仅是2还和8有些类似:snowman:。

## 本质:balloon:

![](https://picture.mulindya.com/kDistillation-11.png)

在知识蒸馏中，本质上就是使用SOFT Loss来替代正则化项，去拟合teacher的效果。

L2左边是极大似然，右边是先验知识（人为设置）

这里用teacher的知识去正则化作为先验知识，嗯！nice！





