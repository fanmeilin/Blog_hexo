---
title: 剑指leetcode14 最长公共前缀
tags: [剑指,方法]
categories: [剑指,方法]
date: 2021-12-26 14:19:08
---

>最长公共前缀

## 题目

编写一个函数来查找字符串数组中的最长公共前缀。

如果不存在公共前缀，返回空字符串 `""`。

### 示例 1：

```
输入：strs = ["flower","flow","flight"]
输出："fl"
```

### 示例 2：

```
输入：strs = ["dog","racecar","car"]
输出：""
解释：输入不存在公共前缀。
```

### 提示：

- `1 <= strs.length <= 200`
- `0 <= strs[i].length <= 200`
- `strs[i]` 仅由小写英文字母组成

## 题解

对每一列进行核对是否是相同，如果不是相同的直接return前面的字符串。

```python
class Solution:
    def longestCommonPrefix(self, strs: List[str]) -> str:
        if len(strs) == 0:
           return ""

        rows, cols = len(strs), len(strs[0])
        for i in range(cols):
            for j in range(rows):
                if len(strs[j]) == i or strs[j][i] != strs[0][i]:
                    return strs[0][:i]

        return strs[0]
```

