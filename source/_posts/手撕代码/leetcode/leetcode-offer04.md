---
title: 剑指offer04 二维数组中的查找
tags: [剑指,数组查找,idea]
categories: [剑指,数组]
date: 2021-08-11 18:07:12
---

>二维数组中的查找

## 题目

在一个 n * m 的二维数组中，每一行都按照从左到右递增的顺序排序，每一列都按照从上到下递增的顺序排序。请完成一个高效的函数，输入这样的一个二维数组和一个整数，判断数组中是否含有该整数。

### 示例 1：

现有矩阵 matrix 如下：

```
[
  [1,   4,  7, 11, 15],
  [2,   5,  8, 12, 19],
  [3,   6,  9, 16, 22],
  [10, 13, 14, 17, 24],
  [18, 21, 23, 26, 30]
]
```

给定 target = `5`，返回 `true`。

给定 target = `20`，返回 `false`。

### 提示：

- 0 <= n <= 1000
- 0 <= m <= 1000

## 题解

当开始想要采用二分法的思想进行判断。但是发现二分只能考虑到左上和右下块的内容。右上和左下的内容无法判断其大小划分。所以会有视觉盲区无法二分缩小区域。

<font color=purple>二维数组无法用二分法，因为其“二分”是分为4份，无法充分涵盖进行判断，会出现错误。</font>

```python
class Solution:
    def findNumberIn2DArray(self, matrix: List[List[int]], target: int) -> bool:
        if not(matrix): return False
        si,sj = 0,0
        ei,ej = len(matrix)-1,len(matrix[0])-1
        def isExit(matrix: List[List[int]], si, sj, ei, ej, target: int):
            if not (si<=ei and sj<=ej): #先判断范围
                return False
            if(target<matrix[si][sj] or target>matrix[ei][ej]): return False
            if(target==matrix[si][sj] or target==matrix[ei][ej]): return True
            mi,mj = int((si+ei)/2),int((sj+ej)/2)
            if(target==matrix[mi][mj]):
                return True
            elif (target>matrix[mi][mj]):
                return isExit(matrix,mi+1,mj,ei,ej,target) or isExit(matrix,mi,mj+1,ei,ej,target)
            else:
                return isExit(matrix,si,sj,mi-1,mj,target) or isExit(matrix,si,sj,mi,mj-1,target)
        return isExit(matrix,si,sj,ei,ej,target)
```
使用线性查找的方法，可以使得复杂度从暴力的O(n*m)到O(n+m)
思想是选取左下角或者右上角，周围不均衡的点开始进行判断，这样才知道应该向哪个方向缩小区域.

<font color=hotpink>例如此处是选取左下角作为初始，向上此列逐渐变小，向右此行逐渐变大。因此target如果比此点小，就向上移动查找，如果比此点大，就向右查找。</font>

```python
class Solution:
    def findNumberIn2DArray(self, matrix: List[List[int]], target: int) -> bool:
        if not(matrix): return False
        i,j = len(matrix)-1,0
        while(i>=0 and j<=len(matrix[0])-1):
            if(target==matrix[i][j]):return True
            elif(target>matrix[i][j]):j += 1
            else:i -= 1
        return False
```

