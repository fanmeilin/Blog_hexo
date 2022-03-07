---
title: 剑指offer39 数组中出现次数超过一半的数字
tags: [剑指,字典]
categories: [剑指,字典]
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
            if countlist.get(x): #可以用内置的get方法或者用has_key()
                countlist[x]+=1
            else:
                countlist[x] = 1
            if(countlist[x]>length/2):
                return x
        return 0
```
字典的相关方法：

```python
dict = {'Name': 'Zara', 'Age': 7, 'Class': 'First'}
 
del dict['Name']  # 删除键是'Name'的条目
dict.clear()      # 清空字典所有条目
del dict          # 删除字典
```

Python字典包含了以下内置方法：

| 序号 | 函数及描述                                                   |
| :--- | :----------------------------------------------------------- |
| 1    | [dict.clear()](https://www.runoob.com/python/att-dictionary-clear.html) 删除字典内所有元素 |
| 2    | [dict.copy()](https://www.runoob.com/python/att-dictionary-copy.html) 返回一个字典的浅复制 |
| 3    | [dict.fromkeys(seq[, val\])](https://www.runoob.com/python/att-dictionary-fromkeys.html) 创建一个新字典，以序列 seq 中元素做字典的键，val 为字典所有键对应的初始值 |
| 4    | **[dict.get(key, default=None)](https://www.runoob.com/python/att-dictionary-get.html) 返回指定键的值，如果值不在字典中返回default值** |
| 5    | **[dict.has_key(key)](https://www.runoob.com/python/att-dictionary-has_key.html) 如果键在字典dict里返回true，否则返回false** |
| 6    | [dict.items()](https://www.runoob.com/python/att-dictionary-items.html) 以列表返回可遍历的(键, 值) 元组数组 |
| 7    | [dict.keys()](https://www.runoob.com/python/att-dictionary-keys.html) 以列表返回一个字典所有的键 |
| 8    | [dict.setdefault(key, default=None)](https://www.runoob.com/python/att-dictionary-setdefault.html) 和get()类似, 但如果键不存在于字典中，将会添加键并将值设为default |
| 9    | [dict.update(dict2)](https://www.runoob.com/python/att-dictionary-update.html) 把字典dict2的键/值对更新到dict里 |
| 10   | [dict.values()](https://www.runoob.com/python/att-dictionary-values.html) 以列表返回字典中的所有值 |
| 11   | [pop(key[,default\])](https://www.runoob.com/python/python-att-dictionary-pop.html) 删除字典给定键 key 所对应的值，返回值为被删除的值。key值必须给出。 否则，返回default值。 |
| 12   | [popitem()](https://www.runoob.com/python/python-att-dictionary-popitem.html) 返回并删除字典中的最后一对键和值。 |

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

