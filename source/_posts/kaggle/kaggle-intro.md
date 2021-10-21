---
title: kaggle比赛介绍--Sartorius - Cell Instance Segmentation
tags: kaggle
categories: kaggle
date: 2021-10-21 16:18:08
math: True
---

> 最近参赛Sartorius - Cell Instance Segmentation，对竞赛题目和相关注意点进行梳理记录，以便后续回顾。

## 竞赛说明

Sartorius - Cell Instance Segmentation，是一个有关医学图像**实例分割**的竞赛

地址： https://www.kaggle.com/c/sartorius-cell-instance-segmentation/overview

### Description

Neurological disorders, including neurodegenerative diseases such as Alzheimer's and brain tumors, are a leading cause of death and disability across the globe. However, it is hard to quantify how well these deadly disorders respond to treatment. **One accepted method is to review neuronal cells via light microscopy,** which is both accessible and non-invasive. Unfortunately, **segmenting individual neuronal cells** in microscopic images can be challenging and time-intensive. Accurate instance segmentation of these cells—with the help of computer vision—could lead to new and effective drug discoveries to treat the millions of people with these disorders.

![img](https://storage.googleapis.com/kaggle-media/competitions/Sartorius/Sartorius_Competition%20Description%20Image%20350x379.png)

Current solutions have limited accuracy for neuronal cells in particular. In internal studies to develop cell instance segmentation models, the neuroblastoma cell line SH-SY5Y consistently exhibits the lowest precision scores out of eight different cancer cell types tested. This could be because neuronal cells have a very **unique, irregular and concave morphology** associated with them, making them challenging to segment with commonly used mask heads.

Sartorius is a partner of the life science research and the biopharmaceutical industry. They empower scientists and engineers to simplify and accelerate progress in life science and bioprocessing, enabling the development of new and better therapies and more affordable medicine. They're a magnet and dynamic platform for pioneers and leading experts in the field. They bring creative minds together for a common goal: technological breakthroughs that lead to better health for more people.

<font color=purple > **In this competition, you’ll detect and delineate distinct objects of interest in biological images depicting neuronal cell types commonly used in the study of neurological disorders.** More specifically, you'll use phase contrast microscopy images to train and test your model for instance segmentation of neuronal cells. Successful models will do this with a high level of accuracy.</font>

If successful, you'll help further research in neurobiology thanks to the collection of robust quantitative data. Researchers may be able to use this to more easily measure the effects of disease and treatment conditions on neuronal cells. As a result, new drugs could be discovered to treat the millions of people with these leading causes of death and disability.

#### 个人理解

也就是说为了量化神经系统类的致命疾病对治疗的反应。一种方法是通过光学显微镜检查神经元细胞，因为这种方法既方便又非侵入性。但是，在显微图像中分割单个神经元细胞可能具有挑战性且耗时。所以需要采取计算机视觉的方法提高精度和效率。由于神经母细胞瘤细胞系（SH-SY5Y）独特，不规则，凹形的形态（unique, irregular and concave morphology），使用常规的分割模型进行分割效果不好。

### Evaluation

This competition is evaluated on the mean average precision at different intersection over union IUO thresholds. The IoU of a proposed set of object pixels and a set of true object pixels is calculated as:

$$
IoU(A,B) = \frac{A \cap B}{A \cup B}
$$

The metric sweeps over a range of IoU thresholds, at each point calculating an average precision value. The threshold values range from 0.5 to 0.95 with a step size of 0.05: `(0.5, 0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.85, 0.9, 0.95)`. In other words, at a threshold of 0.5, a predicted object is considered a "hit" if its intersection over union with a ground truth object is greater than 0.5.

At each threshold value **t**, a precision value is calculated based on the number of true positives **TP**, false negatives **FN**, and false positives **FP** resulting from comparing the predicted object to all ground truth objects:

$$
\frac{TP(t)}{TP(t)+FP(t)+FN(t)}
$$

A true positive is counted when a single predicted object matches a ground truth object with an IoU above the threshold. A false positive indicates a predicted object had no associated ground truth object. A false negative indicates a ground truth object had no associated predicted object. The average precision of a single image is then calculated as the mean of the above precision values at each IoU threshold:
$$
\frac{1}{\vert thresholds \vert} \sum_t \frac{TP(t)}{TP{t}+FP(t)+FN(t)}
$$
Lastly, the score returned by the competition metric is the mean taken over the individual average precisions of each image in the test dataset.

#### 个人理解

此处介绍了评估指标，以及最后排名score的度量方式。人为设置prediction和ground truth的IoU的thresholds，这样可以度量TP，FN，FP（正确实例分割object个数，没有检测到的object个数，误检出的object个数），进而得到score。

##### 疑问

- 这里评估指标中没有提到分类，实例分割除了分割前景和背景，不应该还需要评估类别吗？还是说在度量IOU的时候已经包含了对类别的判断。
- 最后的score中为什么要除以thresholds，意义何在？

## Submission File

In order to reduce the submission file size, our metric uses run-length encoding on the pixel values. Instead of submitting an exhaustive list of indices for your segmentation, you will submit pairs of values that contain a start position and a run length. E.g. '1 3' implies starting at pixel 1 and running a total of 3 pixels 1,2,3.

The competition format requires a space delimited list of pairs. **For example, '1 3 10 5' implies pixels 1,2,3,10,11,12,13,14 are to be included in the mask. The pixels are one-indexed**
**and numbered from top to bottom, then left to right: 1 is pixel 1,1, 2 is pixel 2,1, etc.**

The metric checks that the pairs are sorted, positive, and the decoded pixel values are not duplicated. <font color=purple>**It also checks that no two predicted masks for the same image are overlapping.**</font>

The file should contain a header and have the following format. Each row in your submission represents a single predicted nucleus segmentation for the given `ImageId`.

```
id,predicted  
0114f484a16c152baa2d82fdd43740880a762c93f436c8988ac461c5c9dbe7d5,1 1  
0999dab07b11bc85fb8464fc36c947fbd8b5d6ec49817361cb780659ca805eac,1 1  
0999dab07b11bc85fb8464fc36c947fbd8b5d6ec49817361cb780659ca805eac,2 3 8 9  
etc...
```

Submission files may take several minutes to process due to the size.

#### 个人理解

这里说明了提交的文件格式。

- 不同与一般的图像文件，首先需要将图片的像素点从上到下，从左到右标号为1，2，3.....,然后将图片的分割得到的像素点标识为`'起始点1 个数1 起始点2 个数2 .....'`，

- 注意点是提交的预测在同一张图中预测的mask不允许有重合像素。也就是说该竞赛涉及对于不同的细胞系实例分割，并且在一张图上分割的细胞系mask，不能有交点。**训练数据中label是会出现重叠部分的，在预测的结果中需要消除预测重叠部分。**
  
    > Note: while predictions are not allowed to overlap, the training labels are provided in full (with overlapping portions included). This is to ensure that models are provided the full data for each object. Removing overlap in predictions is a task for the competitor.

##### attention（待尝试）

在讨论区中有人说mask实际上要 (left -> right, top -> bottom) 标号，不知道后续主办方有没有更换内部测试代码。

##### Mask encoding

In submission, we have to encoding mask. Evaluation page show the pixels are numbered from top to bottom, then left to right. But, this is not correct. As you know, the training annotations provided are numbered from left to right, then top to bottom, and this is also the case with submission.
An LB score with encoded mask (top -> bottom, left -> right) was 0.0000, but a score with (left -> right, top -> bottom) was over 0.22.
Unfortunately, the evaluation page is just a copy from Data Science Bowl 2018. I hope that the competition hosts will update the evaluation page for this competition.
[@christoffersartorius](https://www.kaggle.com/christoffersartorius) [@addisonhoward](https://www.kaggle.com/addisonhoward)

#### tips

**后续可参考**

**RLE**相关代码说明（https://www.kaggle.com/c/sartorius-cell-instance-segmentation/discussion/278663）

In this great [EDA notebook](https://www.kaggle.com/ihelon/cell-segmentation-run-length-decoding) created by [@ihelon](https://www.kaggle.com/ihelon), I found Inversion's classical [RLE encoding function](https://www.kaggle.com/ihelon/cell-segmentation-run-length-decoding). The function has definitely stood the test of time and works great here, but I had a bit of difficulty understanding it, so I refactored it to be a bit easier for beginners. Here's the code (with some personal notes):

```python
# modified from: https://www.kaggle.com/inversion/run-length-decoding-quick-start
def rle_decode_refactored(mask_rle, shape, color=1):
    '''
    mask_rle: run-length as string formated (start length)
    shape: (height,width) of array to return 
    Returns numpy array, 1 - mask, 0 - background
    '''
    # Split the string by space, then convert it into a integer array
    s = np.array(mask_rle.split(), dtype=int)

    # Every even value is the start, every odd value is the "run" length
    starts = s[0::2] - 1
    lengths = s[1::2]
    ends = starts + lengths

    # The image image is actually flattened since RLE is a 1D "run"
    h, w, d = shape
    img = np.zeros((h * w, d), dtype=np.float32)

    # The color here is actually just any integer you want!
    for lo, hi in zip(starts, ends):
        img[lo : hi] = color
    # Don't forget to change the image back to the original shape
    return img.reshape(shape)
```

### Timeline

12月30号是最终的截止日期，冲冲冲！

- **October 14, 2021** - Start Date.
- **December 23, 2021** - Entry Deadline. You must accept the competition rules before this date in order to compete.
- **December 23, 2021** - Team Merger Deadline. This is the last day participants may join or merge teams.
- **December 30, 2021** - Final Submission Deadline.

All deadlines are at 11:59 PM UTC on the corresponding day unless otherwise noted. The competition organizers reserve the right to update the contest timeline if they deem it necessary.

## 相关paper

参考 https://www.kaggle.com/c/sartorius-cell-instance-segmentation/discussion/278716

**Papers:**

- [Instance Segmentation of Neural Cells](https://www.researchgate.net/publication/329933921_Instance_Segmentation_of_Neural_Cells) - Instance segmentation of neural cells plays an important role in brain study. However, this task is challenging due to the special shapes and behaviors of neural cells. Existing methods are not precise enough to capture their tiny structures, e.g., filopodia and lamellipodia, which are critical to the understanding of cell interaction and behavior. To this end, we propose a novel deep multi-task learning model to jointly detect and segment neural cells instance-wise. Our method is built upon SSD, with ResNet101 as the backbone to achieve both high detection accuracy and fast speed. Furthermore, unlike existing works which tend to produce wavy and inaccurate boundaries, we embed a deconvolution module into SSD to better capture details. Experiments on a dataset of neural cell microscopic images show that our method is able to achieve better performance in terms of accuracy and efficiency, comparing favorably with current state-of-the-art methods.
- [Mask-RCNN for Cell Instance Segmentation](https://www.researchgate.net/publication/340998089_Rank_6_Mask-RCNN_for_Cell_Instance_Segmentation) - We proposed an automatic nucleus segmentation algorithm of H&E stained tissue microscopy images. Mask-RCNN is a recently proposed state-of-the-art algorithm for object detection and object instance segmentation of natural images. In this paper, we demonstrate that Mask-RCNN can be used to perform highly effective and efficient automatic segmentation of H&E microscopy images for cell nuclei. We propose a novel MASK Non-maximum suppression (NMS) module which can automatically ensemble classifiers results and increase the robustness of model.
- [IRNet: Instance Relation Network for Overlapping Cervical Cell Segmentation](https://arxiv.org/abs/1908.06623) - Cell instance segmentation in Pap smear image remains challenging due to the wide existence of occlusion among translucent cytoplasm in cell clumps. Conventional methods heavily rely on accurate nuclei detection results and are easily disturbed by miscellaneous objects. In this paper, we propose a novel Instance Relation Network (IRNet) for robust overlapping cell segmentation by exploring instance relation interaction. Specifically, we propose the Instance Relation Module to construct the cell association matrix for transferring information among individual cell-instance features. With the collaboration of different instances, the augmented features gain benefits from contextual information and improve semantic consistency. Meanwhile, we proposed a sparsity constrained Duplicate Removal Module to eliminate the misalignment between classification and localization accuracy for candidates selection. The largest cervical Pap smear (CPS) dataset with more than 8000 cell annotations in Pap smear image was constructed for comprehensive evaluation. Our method outperforms other methods by a large margin, demonstrating the effectiveness of exploring instance relation.
- [Weakly Supervised Cell Instance Segmentation by Propagating from Detection Response](https://www.researchgate.net/publication/336392797_Weakly_Supervised_Cell_Instance_Segmentation_by_Propagating_from_Detection_Response) - Cell shape analysis is important in biomedical research. Deep learning methods may perform to segment individual cells if they use sufficient training data that the boundary of each cell is annotated. However, it is very time-consuming for preparing such detailed annotation for many cell culture conditions. In this paper, we propose a weakly supervised method that can segment individual cell regions who touch each other with unclear boundaries in dense conditions without the training data for cell regions. We demonstrated the efficacy of our method using several data-set including multiple cell types captured by several types of microscopy. Our method achieved the highest accuracy compared with several conventional methods. In addition, we demonstrated that our method can perform without any annotation by using fluorescence images that cell nuclear were stained as training data.
- [Deep Semi-supervised Knowledge Distillation for Overlapping Cervical Cell Instance Segmentation](https://arxiv.org/abs/2007.10787) - Deep learning methods show promising results for overlapping cervical cell instance segmentation. However, in order to train a model with good generalization ability, voluminous pixel-level annotations are demanded which is quite expensive and time-consuming for acquisition. In this paper, we propose to leverage both labeled and unlabeled data for instance segmentation with improved accuracy by knowledge distillation. We propose a novel Mask-guided Mean Teacher framework with Perturbation-sensitive Sample Mining (MMT-PSM), which consists of a teacher and a student network during training. Two networks are encouraged to be consistent both in feature and semantic level under small perturbations. The teacher’s self-ensemble predictions from K-time augmented samples are used to construct the reliable pseudolabels for optimizing the student. We design a novel strategy to estimate the sensitivity to perturbations for each proposal and select informative samples from massive cases to facilitate fast and effective semantic distillation. In addition, to eliminate the unavoidable noise from the background region, we propose to use the predicted segmentation mask as guidance to enforce the feature distillation in the foreground region. Experiments show that the proposed method improves the performance significantly compared with the supervised method learned from labeled data only, and outperforms state-of-the-art semi-supervised methods.
- [Attentive neural cell instance segmentation](https://www.sciencedirect.com/science/article/pii/S1361841518308442) - Neural cell instance segmentation, which aims at joint detection and segmentation of every neural cell in a microscopic image, is essential to many neuroscience applications. The challenge of this task in- volves cell adhesion, cell distortion, unclear cell contours, low-contrast cell protrusion structures, and background impurities. Consequently, current instance segmentation methods generally fall short of pre- cision. In this paper, we propose an attentive instance segmentation method that accurately predicts the bounding box of each cell as well as its segmentation mask simultaneously. In particular, our method builds on a joint network that combines a single shot multi-box detector (SSD) and a U-net. Furthermore, we employ the attention mechanism in both detection and segmentation modules to focus the model on the useful features. The proposed method is validated on a dataset of neural cell microscopic images. Experimental results demonstrate that our approach can accurately detect and segment neural cell in- stances at a fast speed, comparing favorably with the state-of-the-art methods.

📌 [U-net with Pytorch](https://github.com/milesial/Pytorch-UNet)
📌 [Using U-net for a Kaggle competition (AutoEncoder)](https://github.com/Fpiotro/MOLECULAR-TRANSLATION)

#### attention

**主办方有关LIVECell的论文**

Edlund, C., Jackson, T.R., Khalid, N. et al.
LIVECell-A large-scale dataset for label-free live cell segmentation.
Nat Methods 18, 1038 -1045 (2021).
Available at: https://doi.org/10.1038/s41592-021-01249-6

Their paper is not just a dataset paper, **it evaluates the performance of both recent anchor-free and anchor-based models for each cell type under four task conditions**, which I think is very informative.
Within their paper, it is shown that <font color=purple>**the results are better when other cell types not included in the test data are also included in the training**</font>. This may be because using even unrelated cell types in the training data allows the model to learn morphology and other factors.

Therefore, in addition to the dataset provided in Kaggle, transfer learning using other cell types in LIVECell, the predecessor of the data, will be important for this competition.

If you want to use the model trained by LIVECell for transfer learning, this page on GitHub may be useful.
👉 https://github.com/sartorius-research/LIVECell/tree/main/model

The models are based on PyTorch, but are from FIAR's Dectron 2 library.
Dectron2: https://github.com/facebookresearch/detectron2

