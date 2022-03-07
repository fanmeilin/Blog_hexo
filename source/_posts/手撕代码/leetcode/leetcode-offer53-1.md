---
title: 剑指offer53-1 在排序数组中查找数字Ⅰ
tags: [剑指,二分法]
categories: [剑指,查找]
date: 2022-01-22 23:27:42
---

>在排序数组中查找数字Ⅰ

## 题目

统计一个数字在排序数组中出现的次数。

### 示例 1：

```
输入: nums = [5,7,7,8,8,10], target = 8
输出: 2
```

### 示例 2：

```
输入: nums = [5,7,7,8,8,10], target = 6
输出: 0
```

### 提示：

- 0 <= nums.length <= 105
- -109 <= nums[i] <= 109
- nums 是一个非递减数组
- -109 <= target <= 109

## 题解

第一种方法是直接遍历：

```python
class Solution:
    def search(self, nums: List[int], target: int) -> int:
        result = 0
        for item in nums:
            if item==target:
                result += 1
        return result

```

注意到这里是排序好的数组可以直接找寻两个数字的最左边或者最右边再求差

求最左侧的index，可以用`func(target)- func(target-1)`

```python
class Solution:
    def search(self, nums: List[int], target: int) -> int:
        #二分法
        def func(tar):
            i, j = 0,len(nums)-1
            while i<=j: #当数组只有一个数字时 [1] 找寻0 
                m = (i+j)//2
                if nums[m]<=tar: #找寻最右点
                    i = m+1
                else:j = m-1  
            print(i,j) 
            return j
        return func(target)- func(target-1)

```

注意模板，`i<=j`,返回`j`

求最右侧的index，可以用`func(target+1)- func(target)`

```python
class Solution:
    def search(self, nums: List[int], target: int) -> int:
        #二分法
        def func(tar):
            i, j = 0,len(nums)-1
            while i<=j: #当数组只有一个数字时 [1] 找寻0 
                m = (i+j)//2
                if nums[m]<=tar: #找寻最右点
                    i = m+1
                else:j = m-1  
            print(i,j) 
            return j
        return func(target)- func(target-1)
```

