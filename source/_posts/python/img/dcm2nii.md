---
title: dcm文件转换为3D的nii文件
tags: [python,图像]
categories: [python,图像]
date: 2021-11-26 11:09:37
---

> 记录dcm文件转换为nii文件的代码

# 前言

NIfTI 中的图像原始数据一般被存储成了三维图像，而dicom存储为二维图层，所以相对于DICOM文件，NIFTI文件更加易用于机器学习，因为NIfTI 是三维图像，处理一个单独的NIfTI 文件要比处理成百上千个DICOM文件更加容易一些。

# 医学图像格式

DICOM 和 NIFTI 是最常用的格式，下面对其进行简单介绍。

## DICOM

DICOM 代表的是医疗数字成像和通信。DICOM 是由美国国家电气制造商协会（NEMA）制定的标准。它定义了医疗成像领域中关于信息处理、存储、打印以及传输的标准，这些都是你在扫描仪或者某家医院的图片归档和通信系统（PACS）能够立即得到的文件格式。
它包括了文件格式和能够接收图像以及 DICOM 格式的病人数据的实体之间使用 TCP/IP 进行通信的协议。

一个 DICOM 文件包含文件头部和同文件名的*.dcm 图像数据。文件头部的大小取决于它所提供的信息的多少。文件头包含以下信息：病人的 ID，病人的姓名，图像的模态以及其他信息。它定义了帧的数量以及图像的精度。这些信息会被图像浏览器在显示图像时用到。对于一个图像采样，会有很多个 DICOM 文件。

## NIFTI

Nifti 格式最初是为神经影像学发明的。神经影像信息学技术计划（NIFTI）将 NIfTI 格式预设为 ANALYZE7.5 格式的替代品。它最初的应用领域是神经影像，但是也被用在其他领域。这种格式的主要特点就是它包含两个能够将每个体素的索引（i,j,k）和它的空间位置（x,y,z）关联起来的仿射坐标。

#### 代码

```python
#coding=utf-8
import SimpleITK as sitk
import os,glob

def dcm2nii(dcms_path, nii_path):
    # 1.构建dicom序列文件阅读器，并执行（即将dicom序列文件“打包整合”）
    reader = sitk.ImageSeriesReader()
    dicom_names = reader.GetGDCMSeriesFileNames(dcms_path)
    reader.SetFileNames(dicom_names)
    image2 = reader.Execute()
    # 2.将整合后的数据转为array，并获取dicom文件基本信息
    image_array = sitk.GetArrayFromImage(image2)  # z, y, x
    origin = image2.GetOrigin()  # x, y, z
    spacing = image2.GetSpacing()  # x, y, z
    direction = image2.GetDirection()  # x, y, z
    # 3.将array转为img，并保存为.nii.gz
    image3 = sitk.GetImageFromArray(image_array)
    image3.SetSpacing(spacing)
    image3.SetDirection(direction)
    image3.SetOrigin(origin)
    sitk.WriteImage(image3, nii_path)


if __name__ == '__main__':
    filelist = glob.glob("./data/AD_result/I*")
    save_path = "./data/AD_nii"
    os.makedirs(save_path,exist_ok=True)
    for dcms_path in filelist:
        dirname = dcms_path.split(os.path.sep)[-1]
        nii_path = os.path.join(save_path,dirname+ ".nii")
        print(nii_path)
       # r'.\test.nii.gz'  # 所需.nii.gz文件保存路径
        dcm2nii(dcms_path, nii_path)

```

# 图像自动处理工具SimpleITK的使用

参考：https://www.ebaina.com/articles/140000012739

#### 安装SimpleITK库

```
命令行模式下，任意位置输入：
  pip install SimpleITK
```

### SimpleITK处理医学图像

做医学图像时，SimpleITK是一个很常用的库。实际上大家往往喜欢把不同类型的数据割裂开，nrrd用pynrrd处理，dicom用dicom处理，nii用nibabel处理……实际上根本没必要，SimpleITK完全可以统一处理，各种类型的读取和保存一步搞定。

#### 读取

##### DICOM

首先是最常见的DICOM。这个文件格式是CT机器直接输出的结果，每个病人会是一个文件夹，里面有若干个DICOM文件，每个DICOM文件都是一个切片，可以被单独查阅（通过SimpleITK的ReadImage）。但是，处理起来一般我们会希望把这些DICOM组合起来形成一个3D的矩阵，这样就可以用到SimpltITK里的`ImageSeriesReader()`来实现：

```python
import SimpleITK as sitk
reader = sitk.ImageSeriesReader() 
img_names = reader.GetGDCMSeriesFileNames(img_path) 
reader.SetFileNames(img_names) 
image = reader.Execute() 
image_array = sitk.GetArrayFromImage(image) # z, y, x 
```

##### MHD

然后还有就是。这种格式的文件由一个MHD文件和一个RAW文件组成，其中MHD里面是病人和CT扫描结果的相关信息，RAW里面存的是真正的数组，对于这种格式，SimpleITK可以这样读取：

```python
import SimpleITK as sitk
itk_img = sitk.ReadImage(filename) 
img_array = sitk.GetArrayFromImage(itk_img) 
```

##### NII

```python
import SimpleITK as sitk
itk_img = sitk.ReadImage(filename)
img_array = sitk.GetArrayFromImage(itk_img) 
```
不过，对于NII类型的文件，SimpleITK在保存上会有一些问题（读取没问题保存上竟然有问题我真是服了），如果slice的数量很大（之前有碰到过300多个slice的），保存起来会直接报错，所以如果碰到这种情况我会选择保存成nrrd（用pynrrd库）

#### 保存

说到保存，有几个天坑一定要说一下。

首先，保存的通用代码是：

```
savedImg = sitk.GetImageFromArray(outputs3D) 
savedImg.SetSpacing(spacing)
savedImg.SetOrigin(origin) 
sitk.WriteImage(savedImg, input_nii[:-4]+'_liverSegResult.nii')

```

这个里面，SetOrigin和SetSpacing我常常会忘记，所以导致保存的CT用ITKsnap看会变形。这里面的spacing和origin均可以从之前ReadImage()返回的对象上通过GetOrigin()和GetSpacing()获取，千万别忘了。当然，除了这两个之外还有个direction也是可以get和set的，不过一般情况下只要你代码没有搞一些矩阵的翻转等操作这个是不用管的。

### 使用SimpleITK读取和保存Nii.gz文件

```python
## using simpleITK to load and save data.
import SimpleITK as sitk
itk_img = sitk.ReadImage('./nifti.nii.gz')
img = sitk.GetArrayFromImage(itk_img)
print("img shape:",img.shape)

## save 
out = sitk.GetImageFromArray(img)
# # out.SetSpacing(itk_img.GetSpacing())
# # out.SetOrigin(itk_img.GetOrigin())
sitk.WriteImage(out,'simpleitk_save.nii.gz')
```

### 可视化一层

下面的程序挑取一层进行可视化，并标注结节位置。

```python
a = image_array.transpose(1,2,0)[:,:,0]  # transpose是将(z,x,y)的三维矩阵转为(x,y,z)的矩阵
plt.gca().add_patch( plt.Rectangle((147,297), 24,24, fill=False,edgecolor='r', linewidth=3))
plt.imshow(a[:,:,1]*255)  # 在图中画框
plt.show()
```

