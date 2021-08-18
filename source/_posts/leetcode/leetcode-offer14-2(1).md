---
title: 剑指offer14.2 剪绳子2
tags: [剑指,动态规划]
categories: [剑指,动态规划]
date: 2021-08-18 00:20:17
---

> 剪绳子2

## 题目

给你一根长度为 n 的绳子，请把绳子剪成整数长度的 m 段（m、n都是整数，n>1并且m>1），每段绳子的长度记为 k[0],k[1]...k[m - 1] .请问 k[0]*k[1]*...*k[m - 1] 可能的最大乘积是多少？例如，当绳子的长度是8时，我们把它剪成长度分别为2、3、3的三段，此时得到的最大乘积是18。

答案需要取模 1e9+7（1000000007），如计算初始结果为：1000000008，请返回 1。

### 示例 1：

```
输入: 2
输出: 1
解释: 2 = 1 + 1, 1 × 1 = 1
```

### 示例 2：

```
输入: 10
输出: 36
解释: 10 = 3 + 3 + 4, 3 × 3 × 4 = 36
```

### 提示：

- `2 <= n <= 1000`

## 题解

使用动态规划具体参照剪绳子1

```python
class Solution:
    def cuttingRope(self, n: int) -> int:
        dp = [0 for i in range(n+1)]
        dp[2] = 1
        for i in range(3,n+1):
            for j in range(2,i):
                dp[i] = max(dp[i],max(j*(i-j),j*dp[i-j]))
        return dp[n]%1000000007
```

但是这种方式时间复杂度较大。

步骤如下：(数学可以证明尽量分成多的3)[参见题解](https://leetcode-cn.com/problems/jian-sheng-zi-lcof/solution/mian-shi-ti-14-i-jian-sheng-zi-tan-xin-si-xiang-by/)

- 如果 n == 2，返回1，如果 n == 3，返回2，两个可以合并成n小于4的时候返回n - 1
- 如果 n == 4，返回4
- 如果 n > 4，分成尽可能多的长度为3的小段，每次循环长度n减去3，乘积res乘以3；最后返回时乘以小于等于4的最后一小段；每次乘法操作后记得取余就行
以上2和3可以合并

```python
class Solution:
    def cuttingRope(self, n: int) -> int:
        if n < 4:
            return n - 1
        res = 1
        while n > 4: # 找寻尽量多的3
            res = res * 3 % 1000000007
            n -= 3
        return res * n % 1000000007 #乘以剩余的
```

