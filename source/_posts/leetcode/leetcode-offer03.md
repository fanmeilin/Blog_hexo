---
title: 剑指offer03 数组中重复的数字
tags: [剑指,数组,idea]
categories: [剑指,数组]
date: 2021-08-11 10:53:45
---

>数组中重复的数字

## 题目

找出数组中重复的数字。


在一个长度为 n 的数组 nums 里的所有数字都在 0～n-1 的范围内。数组中某些数字是重复的，但不知道有几个数字重复了，也不知道每个数字重复了几次。请找出数组中任意一个重复的数字。

### 示例 1：

```
输入：
[2, 3, 1, 0, 2, 5, 3]
输出：2 或 3 
```

### 提示：

- 2 <= n <= 100000

## 题解

创建一个flag数组进行标记；

指定大小的数组创建

- 一维

  a = [0 for _ in range(n)]  《=》  a = [0] * n 

- 二维

  a = [[0 for col in range(m)] for row in range(n)]  *# 创建一个n\*m的二维矩阵a，每个初值都是0*   《=》  a = [[0] \*m] \*n 

```python
class Solution:
    def findRepeatNumber(self, nums: List[int]) -> int:
        flag = [0 for _ in range(len(nums))] #创建长度为nums的数组 也可以用[0]*n
        for x in nums:
            flag[x] += 1
            if(flag[x]>1):
                return x
```

<font color=purple size=4>实际上无需构建新的数组进行标记，可以直接使用set的长度进行判断。或者使用sort，使用list的sort方法。判断相邻的元素是否相等。</font>

方法1：利用python set的无序不重复特性：利用Python中的set集合为无序不重复集合，通过判断temp_set的长度确定是否是重复数字。

```python
class Solution:
    def findRepeatNumber(self, nums: List[int]) -> int:
        temp_set = set()
        repeat = -1
        for i in range(len(nums)):
            temp_set.add(nums[i])
            if len(temp_set) < i + 1:
                repeat = nums[i]
                break
        return repeat
```

方法2：利用python的sort函数排序，然后计算相邻两个数据是否相等即可。

```python
class Solution:
    def findRepeatNumber(self, nums: List[int]) -> int:
        nums.sort()
        for i in range(len(nums)-1):
            if nums[i]==nums[i+1]:
                return nums[i]
```
