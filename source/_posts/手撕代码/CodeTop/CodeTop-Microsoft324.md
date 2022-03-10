---
title: CodeTop_Microsoft324 摆动排序Ⅱ
tags: [CodeTop,微软]
categories: [CodeTop,微软]
date: 2022-03-10 10:20:29
---

> 摆动排序Ⅱ

## 题目

给你一个整数数组 nums，将它重新排列成 nums[0] < nums[1] > nums[2] < nums[3]... 的顺序。

你可以假设所有输入数组都可以得到满足题目要求的结果。

奇数index的数字大于左右的偶数index数字

### 示例 1：

```
输入：nums = [1,5,1,1,6,4]
输出：[1,6,1,5,1,4]
解释：[1,4,1,5,1,6] 同样是符合题目要求的结果，可以被判题程序接受。
```

### 示例 2：

```
输入：nums = [1,3,2,2,3,1]
输出：[2,3,1,3,1,2]
```

### 提示：

- 1 <= nums.length <= 5 * 104
- 0 <= nums[i] <= 5000
- 题目数据保证，对于给定的输入 nums ，总能产生满足题目要求的结果

**进阶：**你能用 O(n) 时间复杂度和 / 或原地 O(1) 额外空间来实现吗？

## 题解

首先排序数组，对于排序后的数组的前部分是必然小于等于数组的后部分，中间可能有相等的情况，只需要将数组后半部分插入奇数，前半部分插入偶数位置即可；但是要注意中间相等的部分，使用逆序穿插把中间位置的数字穿插放到两边。

```python
class Solution:
    def wiggleSort(self, nums: List[int]) -> None:
        """
        Do not return anything, modify nums in-place instead.
        """
        Cnums = sorted(nums)
        n = len(nums)
        for i in range(1,len(nums),2): #奇数大于偶数位置 先放置奇数
            n -= 1
            nums[i] = Cnums[n]
        for i in range(0,len(nums),2): #后放置偶数 因为中间的数据一部分在数组头，一部分在数组尾部，所以中间出现相等的情况就不会影响
            n -= 1
            nums[i] = Cnums[n] 
        return nums
```

但是实际上不需要排序，因为只需要找到中位数即可，无需保证中位数的左右部分是顺序的。

- 首先找到中位数，准确说是第k个数（使用快速排序法）
- 使用三分法将数组分成三个部分小于中位数，等于中位数，大于中位数的部分
- 逆序穿插

这样时间复杂度为O(logn)+O(n),即为O(N)

#### 总体函数

```python
def wiggleSort(nums):
    n = len(nums)
    if n<=1: return nums
    k = (n+1)//2-1
    mid_value = partition(nums, k, 0, n-1)
    three_way_partition(nums, mid_value)
    nums0 = nums.copy()
    for k in range(n):
        nums[k] = nums0[(n+1)//2-1-k//2] if (not k%2) else nums0[(n-1)-k//2]
```

#### 寻找中位数

```python
def partition(nums, k, start, end):
    key = nums[start]
    left, right = start, end
    # print('nums={}, start={}, end={}'.format(nums,start,end))
    # 循环中的不变量: left<right and nums[right]>=key and nums[left]<=key
    while left < right:
        while left < right and nums[right] >= key:
            right = right - 1
        if left < right: nums[left],nums[right] = nums[right],nums[left]
        while left < right and nums[left] <= key:
            left = left + 1
        if left < right: nums[left],nums[right] = nums[right],nums[left]

    if left == k:
        return nums[left]
    elif left > k:
        return partition(nums, k, start, left-1)
    else:
        return partition(nums, k, left+1, end)
```

#### 三分法

```python
#三分法实现 {左侧}<=value<={右侧} 为使得左右两侧长度近似
#我们取 value = nums的第(n+1)//2 个数 同排序方法中前半段的最后一个数字
#参数l, r是小于/大于value的左右下标边界, 即nums[k]<=value for k<=l,nums[k]>=value for k>=r
#参数 i 是当前遍历到的数字的下标 根据它和value的关系 我们确定 nums[i]是和 l 还是和 r 交换
#两个细节 【1】 while i<=r【2】 只有nums[i]<=value 交换之后i+=1
nums = [2,1,0,2,2,4] # mid=2
value = 2
def three_way_partition(nums, value):
    n=len(nums)
    l, r = 0, n-1
    i = 0
    #不能让i越过r 否则如果nums[l]<=nums[r]<nums[i] 会在下一次中让右侧更大的数字被换到左侧
    while i<=r: 
        if nums[i]<value:
            nums[l],nums[i]=nums[i],nums[l]
            l+=1
            i+=1
        elif nums[i]>value: #在这种情况下i不要移动 因为交换过来的数字nums[r]可能仍是>value
            nums[r],nums[i]=nums[i],nums[r]
            r-=1
        else:
            i+=1
```

#### 逆序穿插

逆序之后的顺序: (n+1)//2-1 ....1 || (n-1)....(n+1)//2
穿插之后的顺序: (n+1)//2-1, (n-1), (n+1)//2-1, (n-2),..., 1, (n+1)//2
(最后两个元素也可能是(n+1)//2，1）
k偶数：ind[0] - ind[k] = k//2 所以 ind[k] = ind[0]-k//2 = (n+1)//2-1-k//2
k奇数: ind[1] - ind[k] = k//2 所以 ind[k] = ind[1]-k//2 = (n-1)-k//2

