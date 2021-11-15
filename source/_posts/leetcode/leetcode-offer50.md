---
title: 剑指offer50 第一个只出现一次的字符
tags: [剑指,哈希表]
categories: [剑指,哈希表]
date: 2021-11-15 16:55:46
---

>  第一个只出现一次的字符

## 题目

在字符串 s 中找出第一个只出现一次的字符。如果没有，返回一个单空格。 s 只包含小写字母。

### 示例 1：

```
输入：s = "abaccdeff"
输出：'b'
```

### 示例 2：

```
输入：s = "" 
输出：' '
```

### 提示：

- 0 <= s 的长度 <= 50000

## 题解

方法是使用哈希表记录字符状态。

```python
class Solution:
    def firstUniqChar(self, s: str) -> str:
        flag = {}
        for i in s:
            # if(i in flag):
            #     flag[i] += 1
            # else:
            #     flag[i] = 1
            flag[i] = not i in flag #可以直接标记 没出现则为真
        for x in flag:
            if(flag[x]): return x
        return ' '
```
在查看字典中是否存在k键时，python2可以使用`dict.has_key(k)`,但是python3已经删除此函数，直接使用`k in dict`，同时如果遍历dict，也是返回的key哦。
另外，这里无需记录每个字符的个数，只需要标记真假即可。
