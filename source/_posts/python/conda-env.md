---
title: 虚拟环境构建和使用
tags: [python]
categories: [python]
date: 2022-04-14 10:29:28
---

>在anaconda中配置虚拟环境，现在需要使用grpc框架使用pytorch构建的模型和权重文件，

#### 创建虚拟环境

```python
conda create -n envname python=3.7
```

#### 查看虚拟环境

```python
conda env list
```

#### 删除虚拟环境

```python
conda remove -n envname --all
```

#### 激活虚拟环境

```python
conda activate envname
```

#### 退出当前虚拟环境

```python
conda deactivate
```

#### 显示，克隆虚拟环境

##### 显示安装过的所有虚拟环境

```python
conda info --envs
或
conda info -e
或
conda env list
```

2）复制/克隆环境

```python
conda create --name new_env_name --clone copied_env_name
```

备注：
copied_env_name即为被复制/克隆环境名。

new_env_name即为复制之后新环境的名称。

####  安装包

**进入虚拟环境**后：

```
# conda安装
conda install 要安装的包名
 
#pip安装
pip install 安装的包名
```

安装`pytorch`

```python
#cpu 版本
pip install torch==1.8.1 torchvision==0.9.1 torchaudio==0.8.1

# CUDA 10.2
conda install pytorch==1.8.1 torchvision==0.9.1 torchaudio==0.8.1 cudatoolkit=10.2 -c pytorch

# CUDA 10.2
pip install torch==1.8.1+cu102 torchvision==0.9.1+cu102 torchaudio==0.8.1 -f https://download.pytorch.org/whl/torch_stable.html
```

安装`nb_conda`

```python
#这样可以在jupyter notebook下指定内核
pip install nb_conda
```

如果报错无法找到动态源，则删除提示相应路径下的`pywintype37.dll`和`pythoncom37.dll`

安装`simpleITK`（医学影像常用包），`tqdm`

```
pip install simpleitk
pip install tqdm
```

