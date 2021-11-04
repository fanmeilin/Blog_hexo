---
title: 剑指offer39 数组中出现次数超过一半的数字
tags: [剑指,数组]
categories: [剑指,数组]
date: 2021-11-04 16:53:43
---

>数组中出现次数超过一半的数字

## 题目

数组中有一个数字出现的次数超过数组长度的一半，请找出这个数字。

你可以假设数组是非空的，并且给定的数组总是存在多数元素。

### 示例 1：

```
输入: [1, 2, 3, 2, 2, 2, 5, 4, 2]
输出: 2
```

### 提示：

- 1 <= 数组长度 <= 50000

## 题解

本题可以遍历数组哈希表统计时间和空间复杂度均为O(N)。

```python
class Solution:
    def majorityElement(self, nums: List[int]) -> int:
        countlist = {}
        length = len(nums)
        for x in nums:
            if countlist.get(x):
                countlist[x]+=1
            else:
                countlist[x] = 1
            if(countlist[x]>length/2):
                return x
        return 0
```
##### 摩尔投票法：核心理念为票数正负抵消，时间复杂度为O(N),空间复杂度为O(1)。

- 推论1：将指定的众数元素标记为+1，其他元素标记为-1，则所有数字的票数和大于0.
- 推论2:  若数组的前a个数字的票数和为0，则剩余的n-a个数字的票数之和一定大于0，即（n-a）个数字的众数仍为x，可以直接不考虑前面a个数字了。

```python

class Solution:
    def majorityElement(self, nums: List[int]) -> int:
        votes = 0
        for num in nums:
            if votes == 0: x = num
            votes += 1 if num == x else -1
        return x

```

**拓展**： 由于题目说明 给定的数组总是存在多数元素 ，因此本题不用考虑 数组不存在众数 的情况。若考虑，需要加入一个 “验证环节” ，遍历数组 nums 统计 x 的数量。

**若 x 的数量超过数组长度一半，则返回 x ；**
否则，返回未找到众数；
时间和空间复杂度不变，仍为 O(N) 和 O(1) 。

```python
class Solution:
    def majorityElement(self, nums: List[int]) -> int:
        votes, count = 0, 0
        for num in nums:
            if votes == 0: x = num
            votes += 1 if num == x else -1
        # 验证 x 是否为众数
        for num in nums:
            if num == x: count += 1
        return x if count > len(nums) // 2 else 0 # 当无众数时返回 0
```

