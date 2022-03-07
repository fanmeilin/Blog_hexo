---
title: 剑指offer2_085 生成匹配的括号
tags: [剑指,树,idea]
categories: [剑指,树]
date: 2021-12-09 15:46:53
---

> 生成匹配的括号

## 题目

正整数 `n` 代表生成括号的对数，请设计一个函数，用于能够生成所有可能的并且 **有效的** 括号组合。

### 示例 1：

```
输入：n = 3
输出：["((()))","(()())","(())()","()(())","()()()"]
```

### 示例 2：

```
输入：n = 1
输出：["()"]
```

### 提示：

- 1 <= n <= 8

## 题解

巧妙的深度优先算法，记录生成当前的字符串，左括号，右括号的数目；
如果左括号个数不超，就增加左括号，如果可以增加右括号（**现有的右括号小于左括号数目**），那么增加右括号。

```python
class Solution:
    def generateParenthesis(self, n: int) -> List[str]:
        def dfs(s,left,right):
            if(len(s)==2*n):
                result.append(s)
            if(left<n):dfs(s+"(",left+1,right) #如果left数组少于n个就增加左括号
            if(left>right):dfs(s+")",left,right+1) #如果可以匹配左括号，可以增加右括号区匹配
        result = []
        dfs("",0,0)
        return result
```

