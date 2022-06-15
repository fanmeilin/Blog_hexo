---
title: CodeTop20 有效的括号
tags: [CodeTop,栈]
categories: [CodeTop,栈]
date: 2022-06-15 17:34:44
---

>有效的括号

## 题目

给定一个只包括 '('，')'，'{'，'}'，'['，']' 的字符串 s ，判断字符串是否有效。

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

使用栈来处理这类问题，当遇到反括号时，对栈顶元素进行判断，如果可以匹配就pop进行抵消，否则就压入栈中，最后只需要判断stack是否为空即可。如果是正确的括号形式，栈最后就会为空。

```python
class Solution:
    def isValid(self, s: str) -> bool:
        # 使用栈
        record = {')':'(',']':'[','}':'{'}
        stack = []
        for ch in s:
            if not stack : stack.append(ch) #为空时压栈
            elif (ch in record) and (stack[-1]==record[ch]):stack.pop(-1) #栈不为空并且ch和栈顶相抵消时
            else: stack.append(ch)
        return not stack
```

