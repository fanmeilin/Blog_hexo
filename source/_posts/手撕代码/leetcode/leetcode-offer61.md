---
title: 剑指offer61 扑克牌中的顺子
tags: [剑指,数组]
categories: [剑指,数组]
date: 2022-02-21 19:54:18
---

>扑克牌中的顺子

## 题目

从若干副扑克牌中随机抽 5 张牌，判断是不是一个顺子，即这5张牌是不是连续的。2～10为数字本身，A为1，J为11，Q为12，K为13，而大、小王为 0 ，可以看成任意数字。A 不能视为 14。

### 示例 1：

```
输入: [1,2,3,4,5]
输出: True
```

### 示例 2：

```
输入: [0,0,1,2,5]
输出: True
```

### 提示：

- 数组长度为 5 
- 数组的数取值为 [0, 13]

## 题解



```python
class Solution:
    def isStraight(self, nums: List[int]) -> bool:
        new_nums = sorted(nums)
        target = -1
        for i in range(5):
            if new_nums[i]!=0 and target==-1: #更新0个数 也是起始非0index
                target = i
            if i>0 and new_nums[i]!=0 and new_nums[i]==new_nums[i-1]:
                return False
        need = (new_nums[4]-new_nums[target]-(5-target)+1)
        return need<=target
```

