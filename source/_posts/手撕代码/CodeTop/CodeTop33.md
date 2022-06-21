---
title: CodeTop33 搜索旋转排序数组
tags: [CodeTop,查找]
categories: [CodeTop,查找]
date: 2022-06-21 10:21:04
---

>搜索旋转排序数组

## 题目

整数数组 nums 按升序排列，数组中的值 互不相同 。

在传递给函数之前，nums 在预先未知的某个下标 k（0 <= k < nums.length）上进行了 旋转，使数组变为 [nums[k], nums[k+1], ..., nums[n-1], nums[0], nums[1], ..., nums[k-1]]（下标 从 0 开始 计数）。例如， [0,1,2,4,5,6,7] 在下标 3 处经旋转后可能变为 [4,5,6,7,0,1,2] 。

给你 旋转后 的数组 nums 和一个整数 target ，如果 nums 中存在这个目标值 target ，则返回它的下标，否则返回 -1 。

你必须设计一个时间复杂度为 O(log n) 的算法解决此问题

### 示例 1：

```
输入：nums = [4,5,6,7,0,1,2], target = 0
输出：4
```

### 示例 2：

```
输入：nums = [4,5,6,7,0,1,2], target = 3
输出：-1
```

### 示例3：

```
输入：nums = [1], target = 0
输出：-1
```

### 提示：

- 1 <= nums.length <= 5000
- -10^4 <= nums[i] <= 10^4
- nums 中的每个值都 独一无二
- 题目数据保证 nums 在预先未知的某个下标上进行了旋转
- -10^4 <= target <= 10^4

## 题解

### 二分查找

这道题本身不是有序的，但是旋转后可以保证局部有序。如何进行二分查找？

- 传统的二分法是当选定mid元素后与target对比大小，按照情况再对左侧或者右侧数组进行递归查找。

- 局部有序时需要判断mid划分后的有序数组在左侧还是右侧，再根据有序的数组的数值范围判断是在有序中查找，还是非有序的数组中查找。

问题关键在于：

如何判断mid划分的两侧哪一侧是有序？

原本的数组是单调递增的，旋转后，有两段单调递增的区间，但是它们是没有重复值的。只需要和第一个元素比较，如果mid的值大于全局首元素，那么左侧是有序的，如果小于全局首元素，那么右侧是有序的。

```python
class Solution:
    def search(self, nums: List[int], target: int) -> int:
        l, r = 0, len(nums)-1
        while l<=r:
            mid = l+(r-l)//2
            if nums[mid]==target:return mid
            if nums[0]<nums[mid]: #左侧有序
                if mid-1>=0 and nums[l]<= target <= nums[mid-1]:r = mid-1  #target在左侧范围内
                else:l = mid+1
            if nums[0]>=nums[mid]: #右侧有序 mid为首元素时看作右侧有序 注意细节
                if mid+1<=len(nums)-1 and nums[mid+1]<= target <= nums[r]:l = mid+1 #target在右侧范围内
                else: r = mid-1  
        return -1
```

时间复杂度： O(logn)，其中 n 为nums 数组的大小。整个算法时间复杂度即为二分查找的时间复杂度 O(logn)。

空间复杂度： O(1)。我们只需要常数级别的空间存放变量。

