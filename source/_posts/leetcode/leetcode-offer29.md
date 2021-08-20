---
title: 剑指offer29 顺时针打印矩阵
tags: [剑指,数组]
categories: [剑指,数组]
date: 2021-08-19 21:00:34
math: true
---

>  顺时针打印矩阵

## 题目

输入一个矩阵，按照从外向里以顺时针的顺序依次打印出每一个数字。

### 示例 1：

```
输入：matrix = [[1,2,3],[4,5,6],[7,8,9]]
输出：[1,2,3,6,9,8,7,4,5]
```

### 示例 2：

```
输入：matrix = [[1,2,3,4],[5,6,7,8],[9,10,11,12]]
输出：[1,2,3,4,8,12,11,10,9,5,6,7]
```

### 提示：

- `0 <= matrix.length <= 100`
- `0 <= matrix[i].length <= 100`

## 题解

一种是对数组进行常规操作，安装题目要求进行遍历判断。

```python
class Solution:
    def spiralOrder(self, matrix: List[List[int]]) -> List[int]:
        if not matrix: return []
        l, r, t, b, res = 0, len(matrix[0]) - 1, 0, len(matrix) - 1, []
        while True:
            for i in range(l, r + 1): res.append(matrix[t][i]) # left to right
            t += 1
            if t > b: break
            for i in range(t, b + 1): res.append(matrix[i][r]) # top to bottom
            r -= 1
            if l > r: break
            for i in range(r, l - 1, -1): res.append(matrix[b][i]) # right to left
            b -= 1
            if t > b: break
            for i in range(b, t - 1, -1): res.append(matrix[i][l]) # bottom to top
            l += 1
            if l > r: break
        return res

```
第二种是采用相关的方法，`pop(0)`可以弹出第一个元素。使用$zip(*)$相当于对矩阵转置。`list(zip(*matrix))[::-1]`就是对矩阵逆旋转90度。zip和zip(*)也是一对逆操作；前者表示压缩，后者表示解压。
```python
class Solution:
    def spiralOrder(self, matrix: List[List[int]]) -> List[int]:
        res = []
        while matrix:
            res += matrix.pop(0)
            matrix = list(zip(*matrix))[::-1]
        return res
```

> pop & zip知识参考
>
> https://blog.csdn.net/zhanshen112/article/details/90341177
>
> https://www.cnblogs.com/Aurora-Twinkle/p/8660778.html
