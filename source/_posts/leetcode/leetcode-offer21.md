---
title: 剑指offer21 调整数组顺序使奇数位于偶数前面
tags: [剑指,数组]
categories: [剑指,数组]
date: 2021-08-18 18:18:43
---

> 调整数组顺序使奇数位于偶数前面

## 题目

输入一个整数数组，实现一个函数来调整该数组中数字的顺序，使得所有奇数位于数组的前半部分，所有偶数位于数组的后半部分。

### 示例 1：

```
输入：nums = [1,2,3,4]
输出：[1,3,2,4] 
注：[3,1,2,4] 也是正确的答案之一。
```

### 提示：

- 0 <= nums.length <= 50000
- 1 <= nums[i] <= 10000

## 题解

python的list的常规操作。

```python
class Solution:
    def exchange(self, nums: List[int]) -> List[int]:
        odd = []
        even = []
        for x in nums:
            if(x%2):
                odd.append(x)
            else:
                even.append(x)
        return odd+even
```

