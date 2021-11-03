---
title:论文总结《 Anatomical-guided attention enhances unsupervised PET image
denoising performance》
tags: paper
categories: [paper,pet]
date: 2021-11-03 13:04:40
math: true
---

> 2021年2月投稿的一篇论文《Anatomical-guided attention enhances unsupervised PET image
denoising performance》提出使用Anatomical-guided的注意力加强非监督的PET图像降噪性能。



## ABSTRACT

> Although supervised convolutional neural networks (CNNs) often outperform conventional alternatives for denoising positron emission tomography (PET) images, they require many low- and high-quality reference PET image pairs. Herein, we propose an unsupervised 3D PET image denoising method based on an anatomical information-guided attention mechanism. The proposed magnetic resonance-guided deep decoder (MR-GDD) utilizes the spatial details and semantic features of MR-guidance image more effectively by introducing encoder-decoder and deep decoder subnetworks. Moreover, the specific shapes and patterns of the guidance image do not affect the denoised PET image, because the guidance image is input to the network through an attention gate. In a Monte Carlo simulation of [18F]fluoro-2-deoxy-D-glucose (FDG), the proposed method achieved the highest peak signal-to-noise ratio and structural similarity (27.92 ± 0.44 dB/0.886 ± 0.007), as compared with Gaussian filtering (26.68 ± 0.10 dB/0.807 ± 0.004), image guided filtering (27.40 ± 0.11 dB/0.849 ± 0.003), deep image prior (DIP) (24.22 ± 0.43 dB/0.737 ± 0.017), and MR-DIP (27.65 ± 0.42 dB/0.879 ± 0.007). Furthermore, we experimentally visualized the behavior of the optimization process, which is often unknown in unsupervised CNN-based restoration problems. For preclinical (using [18F]FDG and [11C]raclopride) and clinical (using [18F]florbetapir) studies, the proposed method demonstrates state-of-the-art denoising performance while retaining spatial resolution and quantitative accuracy, despite using a common network architecture for various noisy PET images with 1/10th of the full counts. These results suggest that the proposed MR-GDD can reduce PET scan times and PET tracer doses considerably without impacting patients.
>

##### 总结

使用监督训练CNN网络比传统的方法在PET降噪处理上效果表现的更好，但是需要 low- and high-quality reference PET image pairs作为label。因此基于解剖学信息指引的注意力机制提出了无监督的3D的PET图像的重建。

- 此网络（MR-GDD）引入了两个子网络（encoder-decoder and deep decoder subnetworks）更效率地利用MR（核磁共振）图像的空间信息和语义特征。
- 同时，由于guidance image通过attention gate后再输入网络，特定的guidance image的shapes和patterns不会影响降噪的PET图像。
-  并且，我们通过实验可视化了优化过程的行为。这在无监督卷积图像重建通常是无法表示的。



##  Introduction

> Positron emission tomography (PET) is a functional imaging modality that observes the molecular-level activity in tissues caused by radioactive tracers. It offers excellent diagnostic accuracy both for observing normal tissues and for detecting specific diseases such as cancer and neurodegenerative disorders (Phelps, 2012). In response to the increased demand for more accurate dementia diagnosis in recent years, brain-dedicated PET scanners with enhanced sensitivity that are capable of acquiring high-resolution brain images have been developed (Tashima et al., 2019; Watanabe et al., 2017). The acquisition of high-quality diagnostic PET images requires the administration of high dose or a long scan time. However, massive radiation exposure to PET tracers may induce genetic damage and cancerous growths, thereby raising health risk concerns (ICRP, 2017). Therefore, to mitigate the radiation exposure-related risk, it is desirable to administer low-dose PET tracers. Unfortunately, this increases the statistical noise, thus degrading the quality of PET images and potentially affecting the diagnostic accuracy. Thus, improved noise suppression methods for PET images are essential.

##### 逻辑

为了治疗疾病 --->  需要获取高像素的脑PET图像 --->  需要高剂量&长时间的扫描时间 ---> 引发健康风险 ---> 只能使用低剂量的PET示踪剂 ---> 改进用于 PET 图像的噪声抑制方法是必不可少的。

> Conventionally, Gaussian filtering (GF) is applied as a basic post-denoising method, despite compromising the spatial resolution and, thus, the quantitative accuracy of PET images. To avoid such compromises, various denoising algorithms, such as bilateral filtering ([Hoifheinz et al., 2011](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0018)), non-local means filtering ([Arabi and Zaidi, 2020](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0001)), image-guided filtering (IGF) ([He et al., 2013](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0017); [Hashimoto et al., 2018](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0016)), and block-matching filtering ([Ote et al., 2020](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0027)) have been developed and applied to PET images. These post-denoising algorithms provide a better denoising performance than GF while retaining spatial resolution and quantitative accuracy.

##### 传统降噪方法

高斯滤波 (GF) 被用作基本的后去噪方法，尽管会影响空间分辨率，从而影响 PET 图像的定量精度。后来使用双边滤波、非局部均值滤波、图像引导过滤（IGF）和块匹配过滤的去噪方法。这些去噪算法提供了比 GF 更好的去噪性能，同时保留了空间分辨率和定量精度。

> Aside from the above mentioned conventional [filtering algorithms](https://www.sciencedirect.com/topics/engineering/filtering-algorithm), methods based on deep learning (DL) have been applied in various medical fields ([Litjens et al., 2017](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0023)), and the use of [convolutional neural networks](https://www.sciencedirect.com/topics/engineering/convolutional-neural-networks) (CNNs) has been reported to improve the quality of PET images ([Gong et al., 2019](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0010)a; [Häggström et al., 2019](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0012); [Liu and Qi, 2019](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0024); [Sanaat et al., 2020](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0030); [Sphuler et al., 2020](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0034); [Zhou et al., 2020](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0047)). However, the general CNN-based denoising methods typically require a pair of large reference datasets comprising high-quality images. This is a major problem in clinical usage owing to the difficulty of preparing huge sets of low-noise PET data without unduly burdening patients. In addition, the huge volume of novel PET tracers being developed, makes it difficult to collect large amounts of training data for each domain. The interpretation of denoised PET images may suffer inherent biases if unknown cases are excluded from the [training dataset](https://www.sciencedirect.com/topics/computer-science/training-dataset). Despite these challenges, DL algorithms often outperform conventional denoising algorithms. Therefore, there is a need for technology that can be uniformly adapted to various domains without using high-quality PET data.

##### 深度学习方法的难题

除了上述传统过滤算法之外，基于深度学习 (DL) 的方法已应用于各个医学领域，使用卷积神经网络 (CNN) 可以提高PET 图像质量。而深度学习的去噪方法需要高质量图像的大型参考数据集。但是在不给患者造成过度负担的情况下准备大量的低噪声 PET 数据是一个难题，因此目标是需要能够在不使用高质量 PET 数据的情况下，统一适应各种情况的方法。

> In recent years, unsupervised or self-supervised DL approaches such as Noise2Noise and deep image prior (DIP) have demonstrated the potential to overcome these challenges ([Lehtinen et al., 2018](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0021); [Ulyanov et al., 2018](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0040)). In particular, the DIP algorithm is a powerful noise suppression method that does not require the preparation of a prior training dataset ([Hashimoto et al., 2019](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0015), [2020](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0014); [Lin and Huang, 2020](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0022)). Furthermore, PET reconstruction and denoising methods in which [computed tomography](https://www.sciencedirect.com/topics/engineering/computed-tomography) (CT) and magnetic resonance (MR) images serve as the prior images input to the DIP framework have been developed ([Cui et al., 2019](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0008); [Gong et al., 2019](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0011)b). Compared to PET alone, the denoising performance has been improved by using multi-modal data combined with anatomical information. However, while this method shows potential for adapting various PET image denoising approaches, the [network architecture](https://www.sciencedirect.com/topics/computer-science/network-architecture) does not fully utilize the [semantic features](https://www.sciencedirect.com/topics/computer-science/semantic-feature) or image details of anatomical-guidance images. Furthermore, the process of converting the guidance image to the PET image can result in the shape and pattern of the guidance image remaining in the output PET image, with the extent to which the features of the guidance image affect PET image denoising is yet to be elucidated. Moreover, the process by which the DIP algorithm optimizes the denoising remains unclear. Therefore, these issues must be clarified for future development.

##### 深度学习改进方法：Noise2Noise；DIP；

##### DIP的优点：

- 一种强大的噪声抑制方法，不需要准备先验训练数据集；
- 其中计算机断层扫描 (CT) 和磁共振 (MR) 图像作为输入到 DIP 框架的先验图像；
- 与单独的 PET 相比，通过使用多模态数据结合解剖信息，去噪性能得到了提高。

##### DIP的问题：

- 网络架构并没有充分利用解剖指导图像的语义特征或图像细节；
- 引导图像转换为PET图像的过程会导致输出PET图像中保留引导图像的形状和图案；
- 引导图像的特征对PET图像去噪的影响程度尚待确定且阐明；
- DIP算法优化去噪的过程仍不清楚。

> In this study, we propose an unsupervised 3D PET image denoising method that incorporates anatomical information into the DIP architecture via an attention mechanism. The attention gates ([Fukui et al., 2019](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0009); [Schlemper et al., 2019](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0032)) used in the proposed network help optimize a noisy PET image using multi-scale semantic features extracted from the guidance image. As such, this method can prevent the leakage of guidance image features. The guidance of multi-scale features can lead to an effective regularizer for PET image denoising. The main contributions of this study are as follows:
>
> - We propose a new PET image denoising method guided by anatomical information using an unsupervised [DL method](https://www.sciencedirect.com/topics/computer-science/deep-learning-method).
> - We demonstrate that the proposed network has the flexibility to handle the different PET tracer domains used to show the distribution of various tissues in the brains of human and non-human primates.
> - The behavior of the optimization process is visualized experimentally, thereby providing useful insights that were unresolved in unsupervised CNN-based restoration problems.

##### 本文的方法：

使用了无监督的3D的PET图像降噪方法，该方法通过**注意机制将解剖信息整合到 DIP 架构中**，使用从引导图像中提取的多尺度语义特征来优化嘈杂的 PET 图像。多尺度特征的引导可以为 PET 图像去噪提供有效的正则化器。

##### 贡献：

- 我们提出了一种新的 PET 图像去噪方法，该方法使用无监督的 DL 方法**以解剖信息为指导**；

- 具有处理不同PET 示踪域的**灵活性**，可以用于显示人类和非人类灵长类动物大脑中各种组织的分布；

-  优化过程的行为通过实验进行**可视化**，从而提供在基于 CNN 的无监督重建问题中未解决问题的相关见解。

  

## 2. Related work

> The [PET](https://www.sciencedirect.com/topics/engineering/positron-emission-tomography) image restoration process is further complicated by the limited availability of information that can be extracted from noisy PET data. Another approach adopted for PET image denoising is to use anatomical prior extracted from the [CT](https://www.sciencedirect.com/topics/engineering/computed-tomography) or MR images of the patient for [regularization](https://www.sciencedirect.com/topics/engineering/regularization). Because multi-modal images have become easier to obtain owing to the increasing availability of PET/CT and PET/MR scanners, various [hybrid methods](https://www.sciencedirect.com/topics/engineering/hybrid-method) using anatomical priors have been developed to facilitate PET image denoising.

 PET 图像去噪采用的另一种方法是**使用从患者的 CT 或 MR 图像中提取的解剖先验**进行正则化。由于 PET/CT 和 PET/MR 扫描仪的可用性不断提高，多模态图像变得更容易获得，因此开发了各种使用解剖学先验的混合方法来促进 PET 图像去噪。

### 2.1. Classical approach

> Conventionally, hybrid denoising methods using anatomical priors have been adopted for PET image reconstruction and post-filtering. For example, [maximum a posteriori](https://www.sciencedirect.com/topics/engineering/maximum-a-posteriori) image reconstruction has been incorporated alongside anatomical priors ([Comtat et al., 2002](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0007); [Vunckx et al., 2012](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0041)). In addition, [Sudarshan et al. (2020)](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0035) proposed joint PET and MR image reconstruction using a patch-based joint-dictionary prior. [Bland et al. (2018)](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0003) introduced MR-derived kernels to the kernel expectation maximization reconstruction. Although advanced image reconstruction algorithms can provide better denoising performance, they require significant computational resources and it is often difficult to set optimal parameters. Therefore, anatomically-guided post-denoising is often performed separately from the image reconstruction process. [Chan et al. (2014)](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0004) proposed incorporating CT information and applying median non-local mean filtering to achieve PET denoising. Alternatively, [Yan et al. (2015)](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0045) proposed MR-guided PET filtering by adapting a local linear model. In addition, the authors performed partial volume correction without MR image [parcellation](https://www.sciencedirect.com/topics/engineering/parcellation) by incorporating [partial volume effects](https://www.sciencedirect.com/topics/engineering/partial-volume-effect) into the model.

##### 经典方法：

将解剖先验的混合去噪方法应用于PET图像重建和后滤波处理，将最大后验图像重建与解剖先验结合在一起。基于a patch-based joint-dictionary prior联合PET和MR图像重建

### 2.2. Supervised DL approach

The supervised DL approach has recently demonstrated state-of-the-art performance in PET image denoising. When large amounts of training and label PET data pairs are available, the general [CNN](https://www.sciencedirect.com/topics/engineering/convolutional-neural-networks) can be trained according to the following operation:
$$
θ^*=argmin_θ \frac{1}{N_t}∑_{i∈D_t}∥x_{ref}^i−f_θ(x_0^i)∥
$$
where ∥·∥ is the L2 norm, f represents the CNN, θ denotes the trainable parameters contained in the weights and biases, Dt is a mini-batch sample of size Nt, x0i is the *i*th element in the training data (noisy PET images), and xrefi is the *i*th element in the label data (clean PET images). Regarding supervised PET image denoising using anatomical information, in separate studies, [Liu and Qi et al. (2019)](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0024), [Schramm et al. (2021)](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0033), and [Chen et al. (2019)](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0005) trained CNNs to map multi-modal images, including noisy PET and MR images, to obtain clean PET images. In accordance with these methods, the mapping function, fθ(x0i), in [Eq. (1)](https://www.sciencedirect.com/science/article/pii/S1361841521002711#eqn0001) is represented by fθ(x0i,gi) using anatomical-guidance images, g. The supervised DL approach requires a vast number of low-dose (or short-time scan), high-dose (or long-time scan), and guidance image pairs.

### 2.3. Unsupervised DL approach

Unsupervised DL approaches such as DIP do not require label data for PET image denoising. The DIP training process is optimized as follows ([Ulyanov et al., 2018](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0040)):
$$
θ^*=argmin_θ∥x_0−f_θ(z)∥,x^*=f_{θ^*}(z)
$$
where x0 is a [noisy image](https://www.sciencedirect.com/topics/engineering/noisy-image), x* is the final [denoised image](https://www.sciencedirect.com/topics/engineering/denoised-image) output, and the network input z is random noise. The DIP algorithm uses a CNN to map a [degraded image](https://www.sciencedirect.com/topics/engineering/degraded-image), x0, and obtains the optimal denoised image by regularization of the architecture via moderate iteration. This is based purely on the prior information included in the CNN structure. [Hashimoto et al. (2019](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0015)), ([2020](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0014)) proposed dynamic PET image denoising by directly inputting static PET images into 3D and 4D DIP as prior information. In contrast, [Cui et al. (2019)](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0008) and [Gong et al. (2019](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0010)a) both proposed PET denoising methods that rely on inputting anatomical-guidance images, g (e.g., CT and MR images), instead of the DIP input, z. In these methods, the mapping function, fθ(z), in [Eq. (2)](https://www.sciencedirect.com/science/article/pii/S1361841521002711#eqn0002) is represented by fθ(g).

The unsupervised DL approach can bridge the technical gap between the classical and supervised DL approaches for PET image denoising based on anatomical information. Nevertheless, previous methods often fail to clarify how the [semantic features](https://www.sciencedirect.com/topics/computer-science/semantic-feature) of the guidance image affect PET image denoising.

## 3. Methodology

### 3.1. MR-guided deep decoder

To explicitly utilize the [semantic features](https://www.sciencedirect.com/topics/computer-science/semantic-feature) of anatomical-guidance image for [PET](https://www.sciencedirect.com/topics/engineering/positron-emission-tomography) image denoising, we propose a method for unsupervised 3D PET image denoising based on anatomical information that uses an MR-guided deep decoder (MR-GDD), which is inspired by [Uezato et al. (2020)](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0039). [Fig. 1](https://www.sciencedirect.com/science/article/pii/S1361841521002711#fig0001) shows the [network structure](https://www.sciencedirect.com/topics/computer-science/network-structure) of the proposed MR-GDD, which comprises two [subnetworks](https://www.sciencedirect.com/topics/engineering/subnetwork): an encoder-decoder subnetwork with a skip connection and a deep decoder subnetwork. The two subnetworks are connected by an upsampling refinement unit (URU) and a feature refinement unit (FRU), which incorporate an attention gate to weight the multi-scale features extracted from the MR image to the deep decoder subnetwork. This combined network performs end-to-end learning from scratch.

![](https://picture.mulindya.com/MR-guided-deep-decoder.jpg)

Fig. 1. Overview of the proposed MR-GDD used for unsupervised 3D [PET](https://www.sciencedirect.com/topics/engineering/positron-emission-tomography) image denoising. This architecture consists of two [subnetworks](https://www.sciencedirect.com/topics/engineering/subnetwork) connected by attention gates: an encoder-decoder subnetwork with a skip connection (top) and a deep decoder subnetwork (bottom). This combined architecture is optimized using end-to-end learning. The attention gates in the upsampling refinement unit (URU) and the feature refinement unit (FRU) guide the optimization of noisy PET image using the multi-scale [semantic features](https://www.sciencedirect.com/topics/computer-science/semantic-feature) extracted from the MR image. This architecture can prevent the semantic features of the MR image from leaking.

#### 3.1.1. Encoder-decoder subnetwork

The encoder-decoder subnetwork is designed to extract low-scale to high-scale hierarchical semantic features from the MR image. It is based on the 3D U-Net architecture ([Çiçek et al., 2016](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0006)) and consists of encoding and decoding paths. In the encoding path, the combination of a 3 × 3 × 3 3D [convolution layer](https://www.sciencedirect.com/topics/computer-science/convolution-layer) with [batch normalization](https://www.sciencedirect.com/topics/computer-science/batch-normalization) (BN) and a leaky rectified linear unit (LReLU) is repeated twice, before being constructed by a 3 × 3 × 3 3D convolution layer with two strides for downsampling, followed by the BN and LReLU. At each downsampling step, the size of the feature maps is halved. In the decoding path, the outputs of the upsampling layer and the skip connection supplied from the encoding path are added, before the combination of the 3 × 3 × 3 3D convolution layer with the BN and LReLU is repeated twice. At each upsampling step, the size of the feature maps is doubled.

#### 3.1.2. Deep decoder subnetwork

The deep decoder subnetwork reconstructs the denoised PET image from the network input filled with uniform noise. Each step in the deep decoder subnetwork is upsampled first by the URU, then by a 3 × 3 × 3 3D convolution layer, and finally by the BN, LReLU, and FRU. Owing to the presence the attention gates, the URU and FRU can generate conditional weights using the MR image features via a 1 × 1 × 1 3D convolution layer, LReLU, and [sigmoid function](https://www.sciencedirect.com/topics/engineering/sigmoid-function), and then weights the features obtained from the pre-layer in the deep decoder. The URU promotes the [spatial locality](https://www.sciencedirect.com/topics/computer-science/spatial-locality) of MR image features, whereas the FRU promotes similar semantic alignment. Finally, a 1 × 1 × 1 3D convolution layer outputs a denoised PET image.

### 3.2. Loss function and optimization

To denoise the PET image, the training process of the proposed MR-GDD, which utilizes [unsupervised learning](https://www.sciencedirect.com/topics/computer-science/unsupervised-learning) that does not require PET reference data, is optimized as follows:
$$
θ^*=argmin_θ∥x_0−f_θ(z,g)∥,x^*=f_{θ^*}(z,g)
$$
where ∥·∥ is the L2 norm, f represents the proposed MR-GDD network, the training label x0 represents the noisy PET image, and the network inputs z and g are the random noise and the MR-guidance image, respectively. The input noise was generated by adding a fixed uniform random noise and [Gaussian noise](https://www.sciencedirect.com/topics/engineering/gaussian-white-noise) with different seed for each epoch. The attention gates used in the proposed architecture help optimize the noisy PET image by using the multi-scale semantic features extracted from a [guidance image](https://www.sciencedirect.com/topics/medicine-and-dentistry/image-guided-intervention) g. If the *k*-th scale feature of the encoder path in the encoder-decoder subnetwork is defined as Γk and the *k*-th scale features of the decoder path are defined as Ξk, the influence on the mapping function, f, can be expressed as follows:
$$
f=f_θ(z|Γ1,⋯Γk,Ξ1,⋯Ξk).
$$
In this method, the limited memory BFGS (L-BFGS) algorithm ([Zhu et al., 1997](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0048)), which is a quasi-Newtonian method, is introduced to solve the nonlinear [least squares problem](https://www.sciencedirect.com/topics/engineering/least-square-problem) described by [Eq. (3)](https://www.sciencedirect.com/science/article/pii/S1361841521002711#eqn0003). By considering the approximate [Hessian matrix](https://www.sciencedirect.com/topics/engineering/hessian-matrix) based on the second-order gradient, the L2 norm converges more stably and quickly than first-order [gradient descent](https://www.sciencedirect.com/topics/engineering/gradient-descent) algorithms, such as the stochastic gradient descent algorithm or Adam. In addition, because a small amount of data is generated as a result of using the unsupervised architecture, which does not require a prior [training dataset](https://www.sciencedirect.com/topics/computer-science/training-dataset), the MR-GDD can reduce the computational complexity and load required to performed denoising. We used the L-BFGS algorithm at a learning rate of 0.01 without line search to minimize the processing time. The proposed architecture was processed using PyTorch 1.6.0 on Ubuntu 16.04 with acceleration by a [graphics processing unit](https://www.sciencedirect.com/topics/engineering/graphics-processing-unit) (NVIDIA Quadro RTX8000 with 48 GB memory).

## 4. Experimental setup

A simulation study using [18F]fluoro-2-deoxy-D-glucose (FDG), a preclinical study using [18F]FDG and [11C]raclopride, and a clinical study using [18F]florbetapir ([Wong et al., 2010](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0043)) were performed to verify the effectiveness of the proposed [PET](https://www.sciencedirect.com/topics/engineering/positron-emission-tomography) image denoising method. In addition, the denoising performance of the proposed MR-GDD was compared against four other unsupervised algorithms under the same conditions as the proposed MR-GDD;

- *Gaussian filtering (GF).* GF is a basic post-denoising method for suppressing noise in PET images. We used a 3D [Gaussian kernel](https://www.sciencedirect.com/topics/engineering/gaussian-kernel).
- *Image guided filtering (IGF).* IGF performs PET image denoising by adapting a local linear model using a [guidance image](https://www.sciencedirect.com/topics/medicine-and-dentistry/image-guided-intervention) ([Hashimoto et al., 2018](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0016); [He et al., 2013](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0017)). We used the MR image as the guidance image.
- *Deep image prior (DIP).* The general DIP algorithm uses random noise as the network input ([Ulyanov et al., 2018](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0040)). We used the encoder-decoder network in the proposed MR-GDD as the DIP architecture.
- *MR-DIP.* MR-DIP uses an MR prior as a direct input in the DIP architecture ([Cui et al., 2019](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0008); [Gong et al., 2019](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0010)a). We used the same architecture as in the DIP algorithm.

As a pre-processing step for all the data, voxel intensity normalization was performed on each of the MR and PET images. The MR image intensity was normalized in the [0, 1] range using a min-max normalization technique. Furthermore, the 99.95th [percentile](https://www.sciencedirect.com/topics/engineering/percentile) was defined for PET image intensity, which was also normalized in the [0, 1] range using a min-max normalization technique.

### 4.1. Simulation study

We performed a [Monte Carlo simulation](https://www.sciencedirect.com/topics/medicine-and-dentistry/monte-carlo-method) using the 3D brain phantom from BrainWeb ([Aubert-Broche et al., 2006](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0002)). The Monte Carlo simulation modeled the geometry of a brain-dedicated PET scanner (HITS-655000 ([Watanabe et al., 2017](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0042)), [Hamamatsu Photonics](https://www.sciencedirect.com/topics/computer-science/hamamatsu-photonics) K.K., Japan). The scanner consists of 32 detector blocks with [cerium](https://www.sciencedirect.com/topics/engineering/cerium) doped [lutetium](https://www.sciencedirect.com/topics/engineering/lutetium) [yttrium](https://www.sciencedirect.com/topics/engineering/yttrium) [orthosilicate](https://www.sciencedirect.com/topics/engineering/orthosilicates) crystals per ring, with 5 of these blocks aligned to the scanner axis. To ensure a mismatch between the MR and PET images, two hot spheres (with radii of 10 and 12 mm, respectively) were inserted exclusively into the PET image to present tumor regions. Then, we simulated a static [18F]FDG scan equivalent to 150 M counts, including attenuation and scattering effects. An attenuation map was created from the segmented MR image, and the attenuation effects of water and bone were considered. The gray matter:white matter:cerebrospinal fluid:left tumor:right tumor activity ratio was set to 1:0.25:0.05:2:2 based on the [18F]FDG contrast. We also simulated low-activity tumor data (left tumor:right tumor activity ratio was set to 1.5:1.2) for some low-grade tumors or pathology linked to [neurodegenerative disease](https://www.sciencedirect.com/topics/medicine-and-dentistry/degenerative-disease). To generate the reference PET image, the simulated list-mode data were reconstructed using a 3D list-mode dynamic row-action maximum-likelihood algorithm (DRAMA) ([Tanaka and Kudo, 2010](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0037)) with two iterations and 40 subsets. The reconstructed image measured 128 × 128 × 83 voxels (2.6 × 2.6 × 2.4 mm/voxel). The reference image was reconstructed using all the list-mode data. The noisy PET image was obtained by periodically downsampling to 1/30th of the reference list-mode data (see Supplementary Material 0.1) and reconstructing the low-count image (5 M counts). The corresponding T1-weighted MR image was used as the guidance image.

### 4.2. Preclinical study

A preclinical study was conducted using monkeys and was approved by the Animal Ethics Committees of the Central [Research Laboratory](https://www.sciencedirect.com/topics/engineering/research-laboratories), Hamamatsu Photonics K.K. PET scans using [18F]FDG and [11C]raclopride imaged the brains of conscious [rhesus monkeys](https://www.sciencedirect.com/topics/engineering/rhesus-monkey), whose bodies and heads were fixed using an animal PET scanner (SHR-38000 ([Hamamatsu 2021](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0013)), Hamamatsu Photonics K.K., Japan). After a 30 min transmission scan using a 68Ge-68Ga source, doses of [18F]FDG (113 MBq) and [11C]raclopride (282 MBq) were injected into each monkey, before dynamic PET scans were performed for 120 and 90 min, respectively. We performed image reconstruction using 3D DRAMA with two iterations and 60 subsets that incorporated attenuation correction via transmission scan data. The reconstructed images measured 256 × 256 × 103 voxels (0.65 × 0.65 × 1.0167 mm/voxel) and were cropped [to 192](https://www.sciencedirect.com/topics/medicine-and-dentistry/pamicogrel) × 192 × 64 voxels to reduce the demand on the [GPU](https://www.sciencedirect.com/topics/engineering/graphics-processing-unit) memory. The reference images were reconstructed using all the list-mode data for [18F]FDG and the list mode data for the 60 min period between 30 and 90 min of the scan such that the contrast created by the distribution of [11C]raclopride in the striatum to be observed clearly. Each noisy PET image was obtained by periodically downsampling to 1/10th of the reference list-mode data. The corresponding T1-weighted MR images were taken on another day and registered manually by two radiological [technologists](https://www.sciencedirect.com/topics/engineering/technologist).

### 4.3. Clinical study

An amyloid scan using [18F]florbetapir was conducted on the human brain of a cognitive normal subject using a Biograph mMR scanner (Siemens Healthineers, Germany) as part of the “Insight 46″ sub-study of the MRC National Survey of Health and Development ([Lane et al., 2017](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0020); [Markiewicz et al., 2018](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0025)a). The PET data were acquired dynamically for 60 min using a [18F]florbetapir dose of 409 MBq. During PET image reconstruction, attenuation correction was performed via a pseudo-CT image, which was synthesized using T1- and T2-weighted MR images that were acquired simultaneously, and enabled an μ-map to be was calculated. Image reconstruction was performed using an ordered subset expectation maximization (OS-EM) algorithm involving four iterations and 14 subsets using the NiftyPET package ([Markiewicz et al., 2018](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0026)b). The reconstructed images comprised 334 × 334 × 127 voxels (2 × 2 × 2 mm/voxel), which were cropped to 128 × 128 × 83 voxels to reduce the demand on the GPU memory. The reference image was reconstructed using the list-mode data for the period from 30 to 60 min to observe the contrast between gray and white matter clearly. The noisy PET image was obtained by periodically downsampling to 1/10th of the reference list-mode data.

### 4.4. Evaluation metrics

To quantitatively evaluate the performance of different denoising methods, for the simulation study, we calculated the peak signal-to-noise ratio (PSNR) and structural similarity (SSIM) of the target image, x, and the reference image, xref, which are defined as
$$
PSNR=10log_{10}(\frac{max(x^{ref})^2}{\frac{1}{N_R}∑_{j∈R}(x_j−x_j^{ref})^2})
$$
and
$$
SSIM=\frac{1}{N_R}∑_{j∈R}\frac{(2μ_{jx}μ_{jx^{ref}}+c_1)(2σ_{jxx^{ref}}+c_2)}{(μ_{jx}^2+μ_{jx^{ref}}^2+c_1)(σ_{jx}^2+σ_{jx^{ref}}^2+c^2)}
$$
respectively. Here, R and NR represent the brain region in the PET image and the number of voxels, respectively, μ and σ are the mean and standard deviation of the square window corresponding to the *j*-th voxel, respectively, and σjxxref is the covariance between x and xref. Furthermore, c1=(0.01L)2 and c2=(0.03L)2 where L represents the dynamic range of the reference. The contrast-to-noise ratio (CNR) between gray matter and white matter was calculated as(7)CNR=|Sg¯−Sw¯|σg2+σw2,where Sg¯, Sw¯ and σg, σw are the mean activity and standard deviation corresponding to the regions of interest (ROIs) in the gray and white matter, respectively. The ROIs were constructed in the gray matter regions on the left and right brains of different slices, whereas the white matter regions were selected within the centrum semiovale ([Paxinos et al., 2000](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0028)). In the [11C]raclopride calculation, the ROIs were set on the [putamen](https://www.sciencedirect.com/topics/medicine-and-dentistry/putamen) instead of the gray matter. A Wilcoxon signed-rank test was performed on the PSNR, SSIM, and CNR to compare the performance of different denoising methods. As the noisy PET data were generated by downsampling the reference list-mode data, we generated multiple independent noisy samples (10 samples) to examine the uncertainty and test the statistical significance.

We also evaluated the tradeoffs between noise and quantitative information of the [denoised images](https://www.sciencedirect.com/topics/engineering/denoised-image) when FWHM (GF), ε (IGF), and epochs (CNNs) are changed. For the simulation study, we calculated the tradeoff between the mean squared bias and the variance in the ROI:(8)Bias2=∑j∈R(xj−xjref)2∑j∈R(xjref)2,(7)Variance=∑j∈R(xj−x¯)2∑j∈R(xjref)2,where R denotes the tumor regions, x¯ is the average pixel value inside the ROI. For preclinical study, we calculated the tradeoff between the mean uptake (putamen and caudate and striatum) and the standard deviation (white matter). Each ROI used for the evaluation was set manually to include any partial volume voxels on the MR image and was calculated via superimposition on the co-registered PET image.

Thus far, the optimization process for the DIP algorithm has only been reported as a conceptual diagram ([Hashimoto et al., 2020](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0014); [Ulyanov et al., 2018](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0040)), with several aspects such as the actual behavior remaining unclarified. To elucidate the DIP optimization process, we visualized it by performing nonlinear dimensionally reduction using the locally linear embedding (LLE) algorithm ([Saul and Roweis, 2003](https://www.sciencedirect.com/science/article/pii/S1361841521002711#bib0031)), which implements manifold learning. We projected the PET data used for optimization under different training conditions onto a three-dimensional manifold, considering a neighborhood of 15 for each point.