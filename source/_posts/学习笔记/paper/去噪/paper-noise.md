---
title: 论文中的各种加噪方式
tags: [文献,去噪]
categories: [文献,去噪]
date: 2022-02-16 23:30:18
---

>整理论文中的加噪方式
>
>参考论文具体如下：
>
>**Adaptive Consistency Prior based Deep Network for Image Denoising**
>Paper：https://readpaper.com/pdf-annotate/note?noteId=652422328685277184&pdfId=630634874308022272 (笔记)
>Code：https://github.com/chaoren88/DeamNet/tree/827c736dec2fe675e7bf4de06c3f026d9aaf4dbf
>
>**Unpaired Learning of Deep Image Denoising**
>Paper：https://www.ecva.net/papers/eccv_2020/papers_ECCV/papers/123610732.pdf
>Code：https://github.com/majedelhelou/SFM
>
>**Learning Graph-Convolutional Representations for Point Cloud Denoising**
>Paper：https://www.ecva.net/papers/eccv_2020/papers_ECCV/papers/123650103.pdf
>Code：https://github.com/diegovalsesia/GPDNet
>
>**Spatial-Adaptive Network for Single Image Denoising**
>Paper：https://www.ecva.net/papers/eccv_2020/papers_ECCV/papers/123750171.pdf
>Code:https://github.com/JimmyChame/SADNet

## 1，Adaptive Consistency Prior based Deep Network for Image Denoising

#### 实验部分

分为对合成噪声数据集和真实数据集上去噪两个模块。

**噪声类型**： 加性高斯白噪声AWGN(Additive White Gaussian Noise)  （在论文中提到的强度对比 15, 25 and 50.）

- 训练部分

```python
parser.add_argument("--noiseL", type=float, default=25, help='noise level')
def train(epoch):
    epoch_loss = 0
    model.train()
    for iteration, batch in enumerate(training_data_loader, 1):
        target = Variable(batch)
        noise = torch.FloatTensor(target.size()).normal_(mean=0, std=opt.val_noiseL / 255.)
        input = target + noise
        .....
```

- 测试部分（合成）

```python
parser.add_argument("--test_noiseL", type=float, default=15, help='noise level used on test set') #噪声强度
opt = parser.parse_args()

ISource = torch.Tensor(Img)    
# noise
noise = torch.FloatTensor(ISource.size()).normal_(mean=0, std=opt.test_noiseL / 255.) #高斯噪声
# noisy image
INoisy = ISource + noise #加性
ISource, INoisy = Variable(ISource.cuda()), Variable(INoisy.cuda())
```

真实数据集

```python
    def __getitem__(self, index):
        clean = Image.open(self.path[index])

        if self.transform:
            clean = self.transform(clean)

        noise = torch.randn(clean.size()).mul_(self.sigma/255.0) #噪声？
        noisy = clean + noise
        noisy = torch.clamp(noisy, 0.0, 1.0)
        return noisy, clean
```

> 这里加噪代码存疑
>
> 论文中对真实数据集的去噪细节中写道：
>
> 由于真实噪声通常是信号相关的，并且随着摄像机内管线的不同，真实图像去噪通常是一项极具挑战性的任务，为了进一步展示DeamNet对真实噪声的泛化能力，选择DND基准、SIDD基准和RNI15数据集作为测试数据集。请注意，对于DND和SIDD基准，几乎无噪音的图像不是公开的，但PSNR/SSIM结果可以通过他们的在线服务器获得。而对于RNI15，只有噪声图像可用。

#### 合成噪声数据集（重点关注）

**训练数据集**包括：

1. the Berke-ley Segmentation Dataset (BSD)  是为图像分割和边界检测的研究提供经验基础的数据集，包含来自 30 个人类受试者的 1000 个手工标记的 1000 个 Corel 数据集图像的分割，其中一半的分割是通过向主体呈现彩色图像而获得的; 另一半来自呈现灰度图像。

2. Div2K：数据集有1000张高清图(2K分辨率)，其中800张作为训练，100张作为验证，100 张作为测试。

三个标准**基线数据集**进行了评估 （指标：PSNR and SSIM）

1. Set12：数字图像处理常用数据集Set12，12张灰度图（含lena，cameraman，house，pepper，fishstar，monarch，airplane，parrot，barbara，ship，man，couple），01-07是256\*256,08-12是512\*512.

2. BSD68  数字图像处理常用数据集BSD68，68张灰度图，大小不一。

3. Urban100  ：一个用于超分辨率和图像重建的数据集 Urban100，总计100张建筑高清图片，同时对应了100张降低分辨率的图片。

#### 真实噪声数据集

##### 训练数据集

1. SIDD：智能手机图像去噪数据集（SIDD）使用5个具有代表性的智能手机摄像头，从10个场景中提取约30000个噪声图像，并生成它们真实的场景图像。
2. RENOIR：一个真实的图像降噪数据集，包含了3个子数据集，分别是Xiaomi Mi3，Canon S90，Canon T3i拍摄，拥有低噪和高噪对比图。

##### 测试数据集

- DND：是由50幅真实世界的噪声图像组成的，但没有几乎没有噪声的对应图像。通常，可以通过将去噪图像上传到DND网站来获得PSNR/SSIM结果。

- SIDD：提供320对噪声图像和近无噪声图像用于训练，1280个图像patch用于验证。PSNR/SSIM结果可以通过将去噪图像提交到SIDD网站获得。

- RNI15：提供了15幅真实噪声图像。不幸的是，地面真实的干净图像不可用，因此我们只展示RNI15的视觉结果。

#### 数据增强

我们将这些训练图像对随机裁剪成大小为128×128的小块。为了增加训练样本，采用了180度的旋转和水平翻转。

#### 对比网络

- TNRD

- DnCNN

- FFDNet

- RED 

- MemNet 

- UNLNet

- CFSNet

- N3Net 

- ADNet 

- BRDNet

- RIDNet

##### 合成数据集效果

![](https://picture.mulindya.com/deamnet1.png)

##### 真实数据集效果

![](https://picture.mulindya.com/deamnet2.png)



## 2，Unpaired Learning of Deep Image Denoising

- AWGN                                       (代码中为gaussian)

- heteroscedastic Gaussian  （代码中为poisson_gaussian）

  - 参数 $\alpha$  和$\sigma$  分别表示混合噪声中Poisson分量和Gaussian分量的强度。
- multivariate Gaussian        （代码中为multivariate_gaussian）多元高斯分布

### 代码

路径：DBSN/dbsn_cocor/data/dn_dataset.py

```python
class DnDataset(BaseDataset):
    def __init__(self, opt, split, dataset_name, noiseL):
        super(DnDataset, self).__init__(opt, split, dataset_name)        
    	if len(noiseL) == 1:
            self.noiseL = noiseL[0]
            self.get_noiseL = self._get_noiseL_1
        elif len(noiseL) == 2:
            if self.noise_type.lower=='gaussian':
                self.noiseL = noiseL
                self.get_noiseL = self._get_noiseL_2
            else:
                self.noiseL = noiseL
                self.get_noiseL = self._get_noiseL_1
        elif len(noiseL) == 3:
            self.noiseL_p = [noiseL[0], noiseL[1]]
            self.noiseL_g = [noiseL[0], noiseL[2]]
            self.get_noiseL_p = self._get_noiseL_p
            self.get_noiseL_g = self._get_noiseL_g
        else:
            raise ValueError('noiseL should have one or two or three values')
```

#### AWGN

```python
    def _add_noise_gaussian(self, img):
        if self.split == 'val':
            np.random.seed(seed=0)
        noise = np.random.normal(0, self.get_noiseL()/255.,
                                img.shape).astype(np.float32) 
        return img + noise 
```

#### heteroscedastic Gaussian 

```python
    def _add_noise_poisson_gaussian(self, img):
        # implemented in paper
        noiseLevel = [v/255. for v in self.get_noiseL()]
        sigma_s = noiseLevel[0]
        sigma_c = noiseLevel[1]
        if self.split == 'val':
            np.random.seed(seed=0)
        n1 = np.random.randn(*img.shape)*sigma_s*img
        if self.split == 'val':
            np.random.seed(seed=0)
        n2 = np.random.randn(*img.shape)*sigma_c
        noise = (n1 + n2).astype(np.float32)
        return img + noise 
```

```python
    def _add_noise_poisson_gaussian_blind(self, img):
        if self.split == 'val':
            np.random.seed(seed=0)
        sigma_s = [v/255. for v in self.get_noiseL_p()]
        sigma_c = [v/255. for v in self.get_noiseL_g()]
        noiseL = np.sqrt((sigma_s**2)*img+(sigma_c**2))
        noise = (np.random.randn(*img.shape)*noiseL).astype(np.float32)
        return img + noise 
```

#### multivariate Gaussian 

```python
    def _add_noise_multivariate_gaussian(self, img):
        _,H,W=img.shape
        L=75/255
        if self.split == 'val':
            np.random.seed(seed=0)
            D=np.diag(np.random.rand(3))
            np.random.seed(0)
            U=orth(np.random.rand(3,3))
        else:
            D=np.diag(np.random.rand(3))
            U=orth(np.random.rand(3,3))
        tmp = np.matmul(D, U)
        tmp = np.matmul(U.T,np.matmul(D, U))
        tmp = (L**2)*tmp
        noiseSigma=np.abs(tmp)
        if self.split == 'val':
            np.random.seed(0)
        noise = np.random.multivariate_normal([0,0,0], noiseSigma, (H,W)).astype(np.float32)
        noise = noise.transpose(2, 0, 1)
        return img + noise    
```

## 3，Stochastic Frequency Masking to Improve Super-Resolution and Denoising Networks

### 噪声类型

论文中的提到的两种噪声**AWGN(强度 10 20 30 40 50 60 70 80 90 100 )Poisson-Gaussian **

### 训练代码中加噪

```python
            # ADD Noise
            img_train = data
                        
            noise = torch.zeros(img_train.size())
            noise_level_train = torch.zeros(img_train.size())
            stdN = np.random.uniform(noiseL_B[0], noiseL_B[1], size=noise.size()[0])
            sizeN = noise[0,:,:,:].size()
                        
            # Noise Level map preparation (each step)
            for n in range(noise.size()[0]):
                noise[n,:,:,:] = torch.FloatTensor(sizeN).normal_(mean=0, std=stdN[n]/255.)
                noise_level_value = stdN[n] / noiseL_B[1]
                noise_level_train[n,:,:,:] = torch.FloatTensor( np.ones(sizeN) )
                noise_level_train[n,:,:,:] = noise_level_train[n,:,:,:] * noise_level_value
            noise_level_train = Variable(noise_level_train.cuda())

            # Modifying the frequency content of the added noise (Low or High only)
            if opt.mask_train_noise in([1,2]):
                noise_mask = get_mask_low_high(w=sizeN[1], h=sizeN[2], radius_perc=0.5, mask_mode=opt.mask_train_noise)
                for n in range(noise.size()[0]):
                    noise_dct = dct(dct(noise[n,0,:,:].data.numpy(), axis=0, norm='ortho'), axis=1, norm='ortho')
                    noise_dct = noise_dct * noise_mask
                    noise_numpy = idct(idct(noise_dct, axis=0, norm='ortho'), axis=1, norm='ortho')
                    noise[n,0,:,:] = torch.from_numpy(noise_numpy)
            elif opt.mask_train_noise == 3: #Brownian noise
                for n in range(noise.size()[0]):
                    noise_numpy = gaussian_filter(noise[n,0,:,:].data.numpy(), sigma=3)
                    noise[n,0,:,:] = torch.from_numpy(noise_numpy)
```

### test代码中加噪

```python
def create_varying_noise(image_size, noise_std_min, noise_std_max):
    ''' outputs a noise image of size image_size, with varying noise levels, ranging from noise_std_min to noise_std_max
    the noise level increases linearly with the number of rows in the image '''
    noise = torch.FloatTensor(image_size).normal_(mean=0, std=0).cuda()

    row_size = torch.Size([image_size[0], image_size[1], image_size[2]])
    for row in range(image_size[3]):
        std_value = noise_std_min + (noise_std_max-noise_std_min) * (row/(image_size[3]*1.0-1))
        noise[:,:,:,row] = torch.FloatTensor(row_size).normal_(mean=0, std=std_value/255.).cuda()

    return noise
后续图片加上噪声
```

## 4，Spatial-Adaptive Network for Single Image Denoising

### 合成噪声

测试数据集：BSD68，KODAK24

**噪声：在间隙中加入不同噪声水平的AWGN 噪声强度取值30 50 70**

方法：

​	传统：BM3D和CBM3D

​	cnn：DnCNN[35]、MemNet[27]、FFDNet[36]、RNaN[37]和RIDNet[4]， SADNet（论文提出的方法）

### 真实噪声

测试数据集：DND[25]、SIDD[1]和NAM[22]

