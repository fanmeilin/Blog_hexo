---
title: CodeTop121 买卖股票的最佳时机
tags: [CodeTop,动态规划]
categories: [CodeTop,动态规划]
date: 2022-06-16 12:29:12
---

> 买卖股票的最佳时机

## 题目

给定一个数组 prices ，它的第 i 个元素 prices[i] 表示一支给定股票第 i 天的价格。

你只能选择 某一天 买入这只股票，并选择在 未来的某一个不同的日子 卖出该股票。设计一个算法来计算你所能获取的最大利润。

返回你可以从这笔交易中获取的最大利润。如果你不能获取任何利润，返回 0 


### 示例 1：

```
输入：[7,1,5,3,6,4]
输出：5
解释：在第 2 天（股票价格 = 1）的时候买入，在第 5 天（股票价格 = 6）的时候卖出，最大利润 = 6-1 = 5 。
     注意利润不能是 7-1 = 6, 因为卖出价格需要大于买入价格；同时，你不能在买入前卖出股票。

```

### 示例 2：

```
输入：prices = [7,6,4,3,1]
输出：0
解释：在这种情况下, 没有交易完成, 所以最大利润为 0。
```

### 提示：

- `1 <= prices.length <= 105`
- `0 <= prices[i] <= 104`

## 题解

找寻抛售股票最佳时机实际上在找一个前后差值最大的结果。最暴力的解法就是对每个起止点找最佳的抛点，在取其最大，这种需要n平方的复杂度。

也可以理解为对相邻两天的差价做一个数组，对这个gap数组找寻最大子序列和。

求解最大子序列和的代码：

```python
resum,result = 0,0
for x in gap:
	resum = max(0,resum+x) #resum是当前为终止点的最大子序列和，如果为负数就恢复为0（不取用），也不采用当前点
	result = max(result,resum) #result记录数组中最大的子序列和
```

完整代码：

```python
class Solution:
    def maxProfit(self, prices: List[int]) -> int:
        gap = [prices[i+1]-prices[i] for i in range(len(prices)-1)]
        print(gap)
        resum,result = 0,0
        for x in gap:
            resum = max(0,resum+x)
            result = max(result,resum)
            print(resum)
        return result
```

此时遍历了数组两遍 也就是O(2n)

实际上无需建立数组gap，可以进一步提高时间，空间复杂度

```python
class Solution:
    def maxProfit(self, prices: List[int]) -> int:
        resum, result = 0, 0
        for i in range(len(prices)-1):
            gap = prices[i+1]-prices[i]
            resum = resum+gap if resum+gap>0 else 0 # resum = max(0,resum+gap)
            if resum>result: result = resum # result = max(result,resum)   
        return result
```

