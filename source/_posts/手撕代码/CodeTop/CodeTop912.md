---
title: CodeTop912 排序数组
tags: [CodeTop,排序]
categories: [CodeTop,排序]
date: 2022-04-10 13:12:01
---

>[排序数组](https://leetcode-cn.com/problems/sort-an-array/)
>
>频度206

## 题目

给你一个整数数组 `nums`，请你将该数组升序排列。

### 示例 1：

```
输入：nums = [5,2,3,1]
输出：[1,2,3,5]
```

### 示例 2：

```
输入：nums = [5,1,1,2,0,0]
输出：[0,0,1,1,2,5]
```

### 提示：

- `1 <= nums.length <= 5 * 104`
- `-5 * 104 <= nums[i] <= 5 * 104`

## 题解

快速排序，在partition中使用随机选择pivot，到末尾位置，再使用循环遍历调整位置，i是定位所有小于等于pivot的数到前方即可。再使用qsort递归。在这两个函数中，**传入nums数组，这里的传入和返回数组对象时都是直接的引用传递。**

```python
class Solution:
    def sortArray(self, nums: List[int]) -> List[int]:
        #手撕快排
        def partition(nums,left,right):
            tindex = random.randint(left,right)
            nums[right], nums[tindex] = nums[tindex], nums[right] 
            pivot,i = nums[right], left-1 #注意i初始化left-1 而非-1哦
            for j in range(left,right+1):
                if nums[j]<=pivot:
                    i+=1
                    nums[i],nums[j] = nums[j],nums[i]
            return i
        def qsort(nums,left,right):
            if left>=right: return
            index = partition(nums,left,right)
            qsort(nums,left,index-1)
            qsort(nums,index+1,right)
            
        qsort(nums,0,len(nums)-1) #nums作为参数传入，对于python而言，是指针传入，会直接修改
        return nums
```

