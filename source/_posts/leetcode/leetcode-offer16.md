---
title: 剑指offer16  数值的整数次方
tags: [剑指,快速幂,idea]
categories: [剑指,快速幂]
date: 2021-08-21 11:08:18
math: true
---

> 数值的整数次方

## 题目

实现 pow(x, n) ，即计算 x 的 n 次幂函数（即，xn）。不得使用库函数，同时不需要考虑大数问题。

### 示例 1：

```
输入：x = 2.00000, n = 10
输出：1024.00000
```

### 示例 2：

```
输入：x = 2.10000, n = 3
输出：9.26100
```

### 提示：

- -100.0 < x < 100.0
- $-2^{31}$ <= n <= $2^{31}-1$
- $-10^4$ <= $x^n$ <= $10^4$

## 题解

一种方法是将x乘以n次，但是这种时间复杂度是O(n)。判题时时间超出限制。

```python
class Solution:
    def myPow(self, x: float, n: int) -> float:
        if(n==0):return 1
        result=1
        if(n<0):
            n = -n
            x = 1/x
        while(n):
            result *= x
            n -=1
        return result
```

实际上可以利用x *= x 和对n右移操作可以得到$x,x^2,x^4,x^8,x^{16}.....$，而$x^{11}$可以二进制指数表示为$x^{1011}$也就是$x \times x^2 \times x^8$。这样原本需要循环11次就只需要循环4次

根据提示条件，循环最多不会超过32次。就很棒！

```python
class Solution:
    def myPow(self, x: float, n: int) -> float:
        if(n==0):return 1
        result=1
        if(n<0):
            n = -n
            x = 1/x
        while(n): #时间复杂度大大降低 不超过32次 O(logn)
            if(n & 1):result *= x #看最后一位是否为1
            x *= x
            n = n>>1 #n右移 1011-》101
        return result
```

