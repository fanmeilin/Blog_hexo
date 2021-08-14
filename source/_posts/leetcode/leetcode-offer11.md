---
title: 剑指offer11 旋转数组的最小数字
tags: [剑指,数组,idea]
categories: [剑指,数组]
date: 2021-08-13 17:40:06
---

>旋转数组的最小数字

## 题目

把一个数组最开始的若干个元素搬到数组的末尾，我们称之为数组的旋转。输入一个递增排序的数组的一个旋转，输出旋转数组的最小元素。例如，数组 [3,4,5,1,2] 为 [1,2,3,4,5] 的一个旋转，该数组的最小值为1。

### 示例 1：

```
输入：[3,4,5,1,2]
输出：1
```

### 示例 2：

```
输入：[2,2,2,0,1]
输出：0
```

## 题解

将数组遍历一遍，遇到第一个非增序的元素即为最小值。复杂度为线性级别。

```python
class Solution:
    def minArray(self, numbers: List[int]) -> int:
        if not(numbers):return 0
        minitem = numbers[0]
        for i in range(1,len(numbers)):
            if numbers[i]<numbers[i-1]:
                return min(minitem,numbers[i])
        return minitem
```

还可以使用二分法，将线性级别的复杂度降低到对数级别。

![Picture1.png](https://pic.leetcode-cn.com/1599404042-JMvjtL-Picture1.png)

最低点有特性：左边的所有元素都要比右边所有元素大。利用这个特性可以逐渐缩小范围。

中间元素和某个边界元素比较大小，来确定范围，<u>但是要注意两者相等时就没有确切的判断了</u>。可以直接用线性比较来替代。

```python
class Solution:
    def minArray(self, numbers: [int]) -> int:
        i, j = 0, len(numbers) - 1
        while i < j:
            m = (i + j) // 2
            if numbers[m] > numbers[j]: i = m + 1
            elif numbers[m] < numbers[j]: j = m
            else: j -= 1
        return numbers[i]
```

实际上，当出现 nums[m] = nums[j] 时，一定有区间[i,m]内所有元素相等 或 区间 [m,j] 内所有元素相等（或两者皆满足）。对于寻找此类数组的最小值问题，可直接放弃二分查找，而使用线性查找替代。

```python
class Solution:
    def minArray(self, numbers: [int]) -> int:
        i, j = 0, len(numbers) - 1
        while i < j:
            m = (i + j) // 2
            if numbers[m] > numbers[j]: i = m + 1
            elif numbers[m] < numbers[j]: j = m
            else: return min(numbers[i:j])
        return numbers[i]
```

