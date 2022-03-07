---
title: leetcode17 电话号码的字母组合
tags: [剑指,树]
categories: [剑指,树]
date: 2022-01-05 11:14:25
---

>电话号码的字母组合

## 题目

给定一个仅包含数字 2-9 的字符串，返回所有它能表示的字母组合。答案可以按 任意顺序 返回。

给出数字到字母的映射如下（与电话按键相同）。注意 1 不对应任何字母

![](https://picture.mulindya.com/leetcode17-1.png)

### 示例 1：

```
输入：digits = "23"
输出：["ad","ae","af","bd","be","bf","cd","ce","cf"]
```

### 示例 2：

```
输入：digits = ""
输出：[]
```

### 示例3

```
输入：digits = "2"
输出：["a","b","c"]
```

### 提示：

- `0 <= digits.length <= 4`
- `digits[i]` 是范围 `['2', '9']` 的一个数字。

## 题解

使用树的深度优先遍历算法，digit的字符串相当于给出每一层的节点值（数字对应的字符），按照深度优先算法，遍历到最后一个节点即可添加到result中。

去掉最后一个字符是`word[:-1]`，这里 word[-1]表示最后一个字符。

```python
class Solution:
    def letterCombinations(self, digits: str) -> List[str]:
        record = {'2':'abc','3':'def','4':'ghi','5':'jkl','6':'mno','7':'pqrs','8':'tuv','9':'wxyz'}
        if(not digits): return []
        def dfs(rindex):
            if rindex==len(digits): 
                self.result.append(self.word)
            if rindex>=len(digits): return
            for x in record[digits[rindex]]:
                self.word += x
                dfs(rindex+1)
                self.word = self.word[:-1] #切片去掉最后一个字符

        rindex = 0
        self.result,self.word = [],""
        dfs(rindex)
        return self.result
```

