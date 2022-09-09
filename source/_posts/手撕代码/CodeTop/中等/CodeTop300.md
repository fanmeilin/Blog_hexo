---
title: CodeTop300 最长递增子序列
tags: [CodeTop,中等]
categories: [CodeTop,中等]
date: 2022-09-09 09:55:58
math: true
---

>最长递增子序列

## 题目

给你一个整数数组 nums ，找到其中最长严格递增子序列的长度。

子序列 是由数组派生而来的序列，删除（或不删除）数组中的元素而不改变其余元素的顺序。例如，[3,6,2,7] 是数组 [0,3,1,6,2,2,7] 的子序列。

### 示例 1：

```
输入：nums = [10,9,2,5,3,7,101,18]
输出：4
解释：最长递增子序列是 [2,3,7,101]，因此长度为 4 。
```

### 示例 2：

```
输入：nums = [0,1,0,3,2,3]
输出：4
```

### 示例 3：

```
输入：nums = [7,7,7,7,7,7,7]
输出：1
```

### 提示：

- 1 <= nums.length <= 2500
- -104 <= nums[i] <= 104

### 进阶：

你能将算法的时间复杂度降低到 O(n log(n)) 吗?

## 题解

注意这里是子序列，数组派生而来的序列，删除（或不删除）数组中的元素而不改变其余元素的顺序。元素间不一定是连续。

#### 动态规划

主思路是动态规划。

- 用dp[i]来表示以nums[i]为结尾的最长递增子序列的长度；
- 在处理dp[i]时，需要遍历前面的i-1个元素，查找比nums[i]小的元素对应的dp，选择最大的dp+1，即：

$$
dp[i] = max(dp[j]+1) \quad 其中{0<=j<i}且nums[i]>nums[j]
$$

此时的时间复杂度为$O(n^2)$。

```python
class Solution:
    def lengthOfLIS(self, nums: List[int]) -> int:
        dp = [1 for _ in range(len(nums))] #表示结尾为nums[i]的最长递增子序列的长度
        for i,num in enumerate(nums):
            for j in range(0,i):
                if num>nums[j] and dp[j]+1>dp[i]:dp[i] = dp[j]+1
        return max(dp)
```

#### 二分法+动态规划

在上述方法中，确定dp[i]大小时需要顺序遍历前面的所有元素，所以内层循环需要O(n)，如果是采用二分查找法就可以降到O(logn)。关键问题是需要构建一个有序数组，同时，查找比num小的数据且长度最长。我们可以构造一个tails数组，tails[i]表示能够构成最长递增子序列长度为i的最小元素。这样tails一定是递增的，用res来表示当前tails的长度，也就是此时能够构成递增子序列的最长长度，二分法查找可以在1-res之间进行。

```python
class Solution:
    def lengthOfLIS(self, nums: List[int]) -> int:
        tails, res = [0 for _ in range(len(nums)+1)], 1 #res可以直接得到最长的序列长度
        tails[1] = nums[0]
        for num in nums[1:]:
            i,j = 1,res
            while i<=j:
                mid = (i+j)//2
                if tails[mid]>=num:j=mid-1 #j最后指向小于num的元素，i指向大于等于num的元素
                else:i=mid+1
            tails[i] = num #比num大的最近的元素替换为num
            if i>res:res = i #等价res+=1
            # if j==res:
            #     tails[res+1],res = num, res+1
            # elif tails[j+1]>num: tails[j+1] = num
        return res
```

此时的时间复杂度为O(nlogn)
