---
title: CodeTop48 旋转图像
tags: [CodeTop,中等]
categories: [CodeTop,中等]
date: 2022-09-22 11:41:55
---

> 旋转图像

## 题目

给定一个 n × n 的二维矩阵 matrix 表示一个图像。请你将图像顺时针旋转 90 度。

你必须在 原地 旋转图像，这意味着你需要直接修改输入的二维矩阵。请不要 使用另一个矩阵来旋转图像。

### 示例 1：

```
输入：matrix = [[1,2,3],[4,5,6],[7,8,9]]
输出：[[7,4,1],[8,5,2],[9,6,3]]
```

### 示例 2：

```
输入：matrix = [[5,1,9,11],[2,4,8,10],[13,3,6,7],[15,14,12,16]]
输出：[[15,13,2,5],[14,3,4,1],[12,6,8,9],[16,7,10,11]]
```

### 提示：

- n == matrix.length == matrix[i].length
- 1 <= n <= 20
- -1000 <= matrix[i][j] <= 1000

## 题解

原地旋转，可以使用将“转置”和倒置结合处理。

先按照负对角线转置，再水平倒置：

```python
class Solution:
    def rotate(self, matrix: List[List[int]]) -> None:
        #按照副对角线 转置
        n = len(matrix)
        for i1 in range(1,n):
            i2 = n-i1-1
            for x in range(0,i1):
                matrix[x][i2], matrix[i1][n-x-1] = matrix[i1][n-x-1], matrix[x][i2]
        #上下交换
        for i in range(n//2):
            matrix[i], matrix[n-i-1] = matrix[n-i-1], matrix[i]
```

先水平倒置，再主对角线转置：

```python
class Solution:
    def rotate(self, matrix: List[List[int]]) -> None:
        n = len(matrix)
        # 水平翻转
        for i in range(n // 2):
            matrix[i], matrix[n-i-1] = matrix[n-i-1], matrix[i]
        # 主对角线翻转
        for i in range(n):
            for j in range(i):
                matrix[i][j], matrix[j][i] = matrix[j][i], matrix[i][j]
```

