---
title: 剑指offer859 亲密字符串
tags: [剑指,字符串]
categories: [剑指,字符串]
date: 2021-11-23 21:06:51
---

>亲密字符串

## 题目

给你两个字符串 s 和 goal ，只要我们可以通过交换 s 中的两个字母得到与 goal 相等的结果，就返回 true ；否则返回 false 。

交换字母的定义是：取两个下标 i 和 j （下标从 0 开始）且满足 i != j ，接着交换 s[i] 和 s[j] 处的字符。

- 例如，在 "abcd" 中交换下标 0 和下标 2 的元素可以生成 "cbad" 。


### 示例 1：

```
输入：s = "ab", goal = "ba"
输出：true
解释：你可以交换 s[0] = 'a' 和 s[1] = 'b' 生成 "ba"，此时 s 和 goal 相等。
```

### 示例 2：

```
输入：s = "ab", goal = "ab"
输出：false
解释：你只能交换 s[0] = 'a' 和 s[1] = 'b' 生成 "ba"，此时 s 和 goal 不相等。
```

### 示例 3：

```
输入：s = "aa", goal = "aa"
输出：true
解释：你可以交换 s[0] = 'a' 和 s[1] = 'a' 生成 "aa"，此时 s 和 goal 相等。
```

### 示例 4：

```
输入：s = "aaaaaaabc", goal = "aaaaaaacb"
输出：true
```


### 提示：

- 1 <= s.length, goal.length <= 2 * 104
- s 和 goal 由小写英文字母组成

## 题解

首先判断两个字符串的长度，如果长度不一致就直接返回False，diff用来存储两个字符串不同的字符的相应下标；然后判断diff的元素是否满足要求：

1，diff有两个元素并且这两个元素在列表中对应相等；

2，diff中元素为空（两个字符串相等），同时s中有重复字符（使用set来判断）；

```python
class Solution:
    def buddyStrings(self, s: str, goal: str) -> bool:
        if(len(s)!=len(goal)):return False
        # if(s==goal and len(set(s))!=len(s)): return True #放在前面会增加判断时间 相当于O(2N)
        diff = []
        for i in range(len(s)):
            if(s[i]!=goal[i]):diff.append(i)
        if(len(diff)==2 and s[diff[0]]==goal[diff[1]] and s[diff[1]]==goal[diff[0]]): return True
        if(len(diff)==0 and len(set(s))!=len(s)): return True
        return False
```

