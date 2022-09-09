---
title: CodeTop69
tags: [CodeTop,简单]
categories: [CodeTop,简单]
date: 2022-09-08 15:01:34
---

> x的平方根

## 题目

给你一个非负整数 x ，计算并返回 x 的 算术平方根 。

由于返回类型是整数，结果只保留 整数部分 ，小数部分将被 舍去 。

注意：不允许使用任何内置指数函数和算符，例如 pow(x, 0.5) 或者 x ** 0.5 。

### 示例 1：

```
输入：x = 4
输出：2
```

### 示例 2：

```
输入：x = 8
输出：2
解释：8 的算术平方根是 2.82842..., 由于返回类型是整数，小数部分将被舍去。
```

### 提示：

- `0 <= x <= 231 - 1`

## 题解

### 循环查找

直接循环查找，如果i平方大于x即可停止。时间复杂度为O(n)，空间复杂度为O(1)。

```python
class Solution:
    def mySqrt(self, x: int) -> int:
        if x==0 or x==1:return x
        for i in range(x+1):
            if i*i>x:break
        return i-1
```

### 二分查找

二分查找方法，从0到x的闭区间二分查找可以缩短时间复杂度。时间复杂度为O(log n)，空间复杂度为O(1)。

```python
class Solution:
    def mySqrt(self, x: int) -> int:
        l,r = 0,x
        while l<=r: #注意l=r时仍需判断
            mid = (l+r)//2
            if mid*mid==x:return mid
            if mid*mid>x:r=mid-1
            else:l=mid+1
        return r #向下取整
```

> 本次的判断最好不用`mid * mid== x`而是用`mid== x / mid`来避免数据溢出。

```python
class Solution:
    def mySqrt(self, x: int) -> int:
        if x==0 :return 0
        l,r = 1,x
        while l<=r:
            mid = (l+r)//2
            if mid== x / mid:return mid
            if mid*mid>x:r=mid-1
            else:l=mid+1
        return r
```

