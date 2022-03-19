---
title: CodeTop_Microsoft53 最大子数组和
tags: [CodeTop,Microsoft]
categories: [CodeTop,Microsoft]
date: 2022-03-19 14:34:57
---

>最大子数组和

## 题目

给你一个整数数组 nums ，请你找出一个具有最大和的连续子数组（子数组最少包含一个元素），返回其最大和。

子数组 是数组中的一个连续部分。

### 示例 1：

```
输入：nums = [-2,1,-3,4,-1,2,1,-5,4]
输出：6
解释：连续子数组 [4,-1,2,1] 的和最大，为 6 。
```

### 示例 2：

```
输入：nums = [1]
输出：1
```
### 示例 3：

```
输入：nums = [5,4,-1,7,8]
输出：23
```

### 提示：

- 1 <= nums.length <= 10^5
- -10^4 <= nums[i] <= 10^4

## 题解
记录动态规划的转移方程：
$$
dp[i] = max(nums[i],dp[i-1]+nums[i])
$$
根据「状态转移方程」，`dp[i]` 的值只和 `dp[i - 1]` 有关，因此可以使用「滚动变量」的方式将代码进行优化。

贪心算法是动态规划算法的一个特例。

使用贪心算法求解，时间复杂度为O(n)，空间复杂度为O(1);
设置一个变量tempsum来记录数组在当前元素为止，包含该元素的最大连续子数组和，如果加上item大于0就可以继续添加元素，否则为0继续向后查找。如果全是负数，就返回数组最大的负数，result是记录一个数组的最大子序列和。

```python
class Solution:
    def maxSubArray(self, nums: List[int]) -> int:
        #贪心算法1
        tempsum, tempmax, result= 0, -10000, 0
        for item in nums:
            if item>tempmax:tempmax = item
            tempsum += item
            if tempsum<0: tempsum = 0
            if result<tempsum:result = tempsum
        return result if result>0 else tempmax
```
这里实际上不需要tempmax，可以设置tempsum为包含当前元素的最大连续子序列和，使用result来更新最大的子序列和，初始化为数组的第一个元素。

```python
class Solution:
    def maxSubArray(self, nums: List[int]) -> int:
        #贪心算法2
        tempsum, result = 0, nums[0]
        for item in nums:
            tempsum = tempsum+item if tempsum+item>item else item 
            if result<tempsum:result = tempsum
        return result
```
