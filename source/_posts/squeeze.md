---
title: np.squeeze的用法
tags: python
categories: python
date: 2021-10-29 10:40:22
---

> 记录squeeze() 的相关用法，以及pytorch学习 中 torch.squeeze() 和torch.unsqueeze()的用法。

### numpy的squeeze函数

#### 函数说明

适用于一处数组中的单一维度，也就是去掉数组轴中维度为1的维度，函数说明如下：

```python
np.squeeze()
---------------------------------------------------------------------------
TypeError                                 Traceback (most recent call last)
<ipython-input-3-c5986a7939bf> in <module>
----> 1 np.squeeze()

<__array_function__ internals> in squeeze(*args, **kwargs)

TypeError: _squeeze_dispatcher() missing 1 required positional argument: 'a'

​
Signature: np.squeeze(a, axis=None)
Docstring:
Remove single-dimensional entries from the shape of an array.

Parameters
----------
a : array_like
    Input data.
axis : None or int or tuple of ints, optional
    .. versionadded:: 1.7.0

    Selects a subset of the single-dimensional entries in the
    shape. If an axis is selected with shape entry greater than
    one, an error is raised.

Returns
-------
squeezed : ndarray
    The input array, but with all or a subset of the
    dimensions of length 1 removed. This is always `a` itself
    or a view into `a`.

Raises
------
ValueError
    If `axis` is not None, and an axis being squeezed is not of length 1

See Also
--------
expand_dims : The inverse operation, adding singleton dimensions
reshape : Insert, remove, and combine dimensions, and resize existing ones

Examples
--------
>>> x = np.array([[[0], [1], [2]]])
>>> x.shape
(1, 3, 1)
>>> np.squeeze(x).shape
(3,)
>>> np.squeeze(x, axis=0).shape
(3, 1)
>>> np.squeeze(x, axis=1).shape
Traceback (most recent call last):
...
ValueError: cannot select an axis to squeeze out which has size not equal to one
>>> np.squeeze(x, axis=2).shape
(1, 3)
```

#### 举例

指定轴进行压缩单一的维度，如果指定轴维度不为1，就会返回ValueError。

```python
b = a.reshape(5,1,2,1) #axis 分别为0，1，2，3
b
array([[[[ 1],
         [ 2]]],


       [[[ 3],
         [ 4]]],


       [[[ 5],
         [ 6]]],


       [[[ 7],
         [ 8]]],


       [[[ 9],
         [10]]]])
np.squeeze(b,axis=3) #指定维度为1的axis进行squeeze
array([[[ 1,  2]],

       [[ 3,  4]],

       [[ 5,  6]],

       [[ 7,  8]],

       [[ 9, 10]]])

np.squeeze(b,axis=1)
array([[[ 1],
        [ 2]],

       [[ 3],
        [ 4]],

       [[ 5],
        [ 6]],

       [[ 7],
        [ 8]],

       [[ 9],
        [10]]])
        
```

```python
如果指定轴为1，就会报错ValueError
ValueError                                Traceback (most recent call last)
<ipython-input-27-5187bab4a1cf> in <module>
----> 1 np.squeeze(b,axis=0)

<__array_function__ internals> in squeeze(*args, **kwargs)

D:\Anaconda3\lib\site-packages\numpy\core\fromnumeric.py in squeeze(a, axis)
   1481         return squeeze()
   1482     else:
-> 1483         return squeeze(axis=axis)
   1484 
   1485 

ValueError: cannot select an axis to squeeze out which has size not equal to one
```

### pytorch中的squeeze和unsqueeze函数

在pytorch中也有相关的函数，与numpy中的函数类似。

squeeze的用法主要就是对数据的维度进行压缩或者解压。

先看`torch.squeeze()` 这个函数主要对数据的维度进行压缩，**去掉维数为1的的维度**，比如是一行或者一列这种，一个一行三列（1,3）的数去掉第一个维数为一的维度之后就变成（3）行。squeeze(a)就是将a中所有为1的维度删掉。不为1的维度没有影响。a.squeeze(N) 就是去掉a中指定的维数为一的维度。还有一种形式就是b=torch.squeeze(a，N) a中去掉指定的定的维数为一的维度。

再看`torch.unsqueeze()`这个函数主要是对数据维度进行扩充。**给指定位置加上维数为一的维度**，比如原本有个三行的数据（3），在0的位置加了一维就变成一行三列（1,3）。a.squeeze(N) 就是在a中指定位置N加上一个维数为1的维度。还有一种形式就是b=torch.squeeze(a，N) a就是在a中指定位置N加上一个维数为1的维度


