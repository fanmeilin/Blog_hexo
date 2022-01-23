---
title: 剑指offer58-2 左旋转字符串
tags: 剑指
categories: 剑指
date: 2022-01-23 14:49:37
---

>左旋转字符串

## 题目

字符串的左旋转操作是把字符串前面的若干个字符转移到字符串的尾部。请定义一个函数实现字符串左旋转操作的功能。比如，输入字符串"abcdefg"和数字2，该函数将返回左旋转两位得到的结果"cdefgab"。

### 示例 1：

```
输入: s = "abcdefg", k = 2
输出: "cdefgab"
```

### 示例 2：

```
输入: s = "lrloseumgh", k = 6
输出: "umghlrlose"
```

### 提示：

- `1 <= k < s.length <= 10000`

## 题解

直接使用切片

```python
class Solution:
    def reverseLeftWords(self, s: str, n: int) -> str:
        return s[n:]+s[:n]
```

如果不允许使用切片可以使用字符串的拼接

```python
class Solution:
    def reverseLeftWords(self, s: str, n: int) -> str:
        res = ""
        for i in range(n, len(s)):
            res += s[i]
        for i in range(n):
            res += s[i]
        return res
```

代码简洁可以直接求余运算

```python
class Solution:
    def reverseLeftWords(self, s: str, n: int) -> str:
        res = ""
        for i in range(n, n + len(s)):
            res += s[i % len(s)]
        return res
```

