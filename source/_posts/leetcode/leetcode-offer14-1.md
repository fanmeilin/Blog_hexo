---
title: 剑指offer14.1 剪绳子1
tags: [剑指,动态规划,idea]
categories: [剑指,动态规划]
date: 2021-08-17 23:46:41
---

>剪绳子

## 题目

给你一根长度为 n 的绳子，请把绳子剪成整数长度的 m 段（m、n都是整数，n>1并且m>1），每段绳子的长度记为 k[0],k[1]...k[m-1] 。请问 k[0]*k[1]*...*k[m-1] 可能的最大乘积是多少？例如，当绳子的长度是8时，我们把它剪成长度分别为2、3、3的三段，此时得到的最大乘积是18。

#### 示例 1：

```
输入: 2
输出: 1
解释: 2 = 1 + 1, 1 × 1 = 1
```

#### 示例 2：

```
输入: 10
输出: 36
解释: 10 = 3 + 3 + 4, 3 × 3 × 4 = 36
```

##### 提示：

- `2 <= n <= 58`

#### 题解

该题采用动态规划比较好理解，dp[i]表示长度为i的绳子分成m的最大乘积。j表示第一段的长度，遍历j的取值（可以直接从2开始），在剩余的i-j（**缩小范围**）的长度选择不切分或者最大乘积，即dp\[i][j] = max(j\*(i-j),j\*dp[i-j])。**但是实际上“【j】”并不关心**，因此可以与dp[i]比较,选择最大的更新dp[i]即可。

```python
class Solution:
    def cuttingRope(self, n: int) -> int:
        dp = [1 for _ in range(n+1)]  # 表示长度为n的绳子得到的最大乘积
        dp[2] = 1
        for i in range(3,n+1):
            for j in range(2,i): # 第一段
                dp[i] = max(dp[i],max(j*(i-j),j*dp[i-j])) 
                #向前获取信息，在选定j之后，注意还要比较dp[i]本身，以及在第一段j的基础上剩下的是否切
        return dp[n]

```
