---
title: 剑指offer45 把数组排成最小的数
tags: [剑指,排序]
categories:  [剑指,排序]
date: 2021-12-28 14:07:37
---

> 把数组排成最小的数

## 题目
输入一个非负整数数组，把数组里所有数字拼接起来排成一个数，打印能拼接出的所有数字中最小的一个。


### 示例 1：

```
输入: [10,2]
输出: "102"
```

### 示例 2：

```
输入: [3,30,34,5,9]
输出: "3033459"
```

### 提示：

- 0 < nums.length <= 100
- 输出结果可能非常大，所以你需要返回一个字符串而不是整数
- 拼接起来的数字可能会有前导 0，最后结果不需要去掉前导 0

## 题解

方法主要是用到自定义排序；
在`python3`中的自定义排序要重载`functools.cmp_to_key`函数，但是这里的规则是**默认小的在前面**；所以在比较的时候重载`mycmp`方法，a,b顺序满足条件时返回-1(num<0)
```python
def cmp_to_key(mycmp):
    """Convert a cmp= function into a key= function"""
    class K(object):
        __slots__ = ['obj']
        def __init__(self, obj):
            self.obj = obj
        def __lt__(self, other):
            return mycmp(self.obj, other.obj) < 0
        def __gt__(self, other):
            return mycmp(self.obj, other.obj) > 0
        def __eq__(self, other):
            return mycmp(self.obj, other.obj) == 0
        def __le__(self, other):
            return mycmp(self.obj, other.obj) <= 0
        def __ge__(self, other):
            return mycmp(self.obj, other.obj) >= 0
        __hash__ = None
    return K
```

另外，直接将ab拼接进行比较大小，这里直接使用字符串比较大小更快哦~
```python
class Solution:
    def minNumber(self, nums: List[int]) -> str:
        def funccmp(a,b):
            x,y = a+b,b+a
            if int(x)<int(y): return -1
            else: return 1

        def sort_rule(x, y):
            a, b = x + y, y + x #可以直接对字符串比较，更快
            if a > b: return 1
            elif a < b: return -1
            else: return 0

        s = [str(x) for x in nums]
        t = sorted(s,key = functools.cmp_to_key(sort_rule))    
        #重载比较函数，在python的重载cmp_to_key时默认是小的元素排在前面，所以在满足条件时返回-1，其他情况大于-1即可
        return ''.join(t)
```

