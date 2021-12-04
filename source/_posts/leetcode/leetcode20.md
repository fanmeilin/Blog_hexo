---
title: 剑指offer20 有效的括号
tags: [剑指,栈]
categories: [剑指,栈]
date: 2021-11-24 16:10:30
---

> 有效的括号

## 题目

给定一个只包括 '('，')'，'{'，'}'，'['，']' 的字符串 s ，判断字符串是否有效。

有效字符串需满足：

左括号必须用相同类型的右括号闭合。
左括号必须以正确的顺序闭合。

### 示例 1：

```
输入：s = "()"
输出：true
```

### 示例 2：

```
输入：s = "()[]{}"
输出：true
```

### 示例 3：

```
输入：s = "(]"
输出：false
```

### 示例 4：

```
输入：s = "([)]"
输出：false
```

### 示例 5：

```
输入：s = "{[]}"
输出：true
```

### 提示：

- 1 <= s.length <= 104
- s 仅由括号 '()[]{}' 组成

## 题解

使用`栈和字典`辅助判断，如果字符是对应括号的右括号，就弹出，否则压入，最后查看栈中是否还剩元素。

```python
class Solution:
    def isValid(self, s: str) -> bool:
        stack = []
        mmap = {'(':')',')':'a','{':'}','}':'b','[':']',']':'c'}
        for ch in s:
            if(stack):
                top = stack[len(stack)-1]
            if(not stack or mmap[top] != ch):
                stack.append(ch)
            elif(stack and  mmap[top] == ch):
                stack.pop()
        return not stack
```

