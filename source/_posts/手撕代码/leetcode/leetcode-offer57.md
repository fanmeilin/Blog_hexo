---
title: 剑指offer57 和为s的两个数字
tags: [剑指,双指针]
categories:  [剑指,双指针]
date: 2021-11-17 11:50:41
---

> 和为s的两个数字

## 题目
输入一个递增排序的数组和一个数字s，在数组中查找两个数，使得它们的和正好是s。如果有多对数字的和等于s，则输出任意一对即可。


### 示例 1：

```
输入：nums = [2,7,11,15], target = 9
输出：[2,7] 或者 [7,2]
```

### 示例 2：

```
输入：nums = [10,26,30,31,47,60], target = 40
输出：[10,30] 或者 [30,10]
```

### 提示：

- 1 <= nums.length <= 10^5
- 1 <= nums[i] <= 10^6

## 题解

因为时单调递增的数组，那么可以直接从两端找起，向中间收缩。可以用递归的双指针，也可以使用while循环遍历，时间复杂度为O(N)。

#### 递归

```python
class Solution:
    def twoSum(self, nums: List[int], target: int) -> List[int]:
        def find(left,right):
            if(left>=right): return
            if(nums[left]+nums[right]==target): 
                self.result = [nums[left],nums[right]]
                return
            if(nums[left]+nums[right]>target): find(left,right-1)
            else: find(left+1,right)
        self.result = []
        find(0,len(nums)-1)
        return self.result
```
#### 循环

使用while循环比使用递归的方法，空间复杂度更小，更快。
```python
class Solution:
    def twoSum(self, nums: List[int], target: int) -> List[int]:
        left,right = 0,len(nums)-1
        while(left<right):
            if(nums[left]+nums[right]==target): return [nums[left],nums[right]]
            elif(nums[left]+nums[right]<target): left+=1
            else: right -= 1
        return []
```
