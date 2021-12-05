---
title: 剑指offerleetcode-offer372
tags: 剑指
categories: 剑指
date: 2021-12-05 21:29:30
---

>超级次方

## 题目

你的任务是计算 ab 对 1337 取模，a 是一个正整数，b 是一个非常大的正整数且会以数组形式给出。

### 示例 1：

```
输入：a = 2, b = [3]
输出：8
```

### 示例 2：

```
输入：a = 2, b = [1,0]
输出：1024
```

### 示例 3：

```
输入：a = 1, b = [4,3,3,8,5,2]
输出：1
```

### 示例 4：

```
输入：a = 2147483647, b = [2,0,0]
输出：1198
```

### 提示：

- 1 <= a <= 231 - 1
- 1 <= b.length <= 2000
- 0 <= b[i] <= 9
- b 不含前导 0

## 题解

使用math模块

```python
import math
math.pow( x, y )
```

内置的pow方法
`pow(x, y[, z])`

函数是计算 x 的 y 次方，如果 z 在存在，则再对结果进行取模，其结果等效于 pow(x,y) %z。

**注意：pow() 通过内置的方法直接调用，内置方法会把参数作为整型，而 math 模块则会把参数转换为 float。**
```python
class Solution:
    def superPow(self, a: int, b: List[int]) -> int:
        result = 1
        mod = 1337
        for i,x in enumerate(b):
            temp = pow(a,x,mod)
            result = result*temp%mod 
            if(i<len(b)-1):result = pow(result,10,mod)
        return result
```

和二进制求十进制的思想类似，当前位求得之后再乘以10的基底，继续重复,,,
