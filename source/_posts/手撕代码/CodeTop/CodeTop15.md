---
title: CodeTop15 三数之和
tags: [CodeTop,微软,双指针]
categories: [CodeTop,微软,双指针]
date: 2022-04-01 16:59:36
---

> 三数之和 频度为209
> https://leetcode-cn.com/problems/3sum/

## 题目
给你一个包含 n 个整数的数组 nums，判断 nums 中是否存在三个元素 a，b，c ，使得 a + b + c = 0 ？请你找出所有和为 0 且不重复的三元组。

注意：答案中不可以包含重复的三元组。

### 示例 1：

```
输入：nums = [-1,0,1,2,-1,-4]
输出：[[-1,-1,2],[-1,0,1]]
```

### 示例 2：

```
输入：nums = []
输出：[]
```
### 示例3：

```python
输入：nums = [0]
输出：[]
```

### 提示：

- `0 <= nums.length <= 3000`
- `-105 <= nums[i] <= 105`

## 题解

第一想法是使用字典存储

```python
class Solution:
    def threeSum(self, nums: List[int]) -> List[List[int]]:
        nums = sorted(nums)
        result = []
        for i in range(len(nums)-2):
            if nums[i] > 0: break 
            if i>0 and nums[i]==nums[i-1]:continue 
            left,right = i+1,len(nums)-1
            while left<right:
                if nums[i]+nums[left]+nums[right]==0: 
                    result.append([nums[i],nums[left],nums[right]])
                    #避免重复添加元素
                    while(left<right and nums[left+1]==nums[left]):left+=1
                    while(left<right and nums[right-1]==nums[right]):right-=1
                    left,right = left+1,right-1
                elif nums[i]+nums[left]+nums[right]>0: right -= 1
                else: left +=1
        return result
                
```

