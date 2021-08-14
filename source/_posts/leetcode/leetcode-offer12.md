---
title: 剑指offer12 矩阵中的路径
tags: [剑指,DFS,idea]
categories: [剑指,DFS]
date: 2021-08-14 01:04:59
---

>矩阵中的路径

## 题目

给定一个 m x n 二维字符网格 board 和一个字符串单词 word 。如果 word 存在于网格中，返回 true ；否则，返回 false 。

单词必须按照字母顺序，通过相邻的单元格内的字母构成，其中“相邻”单元格是那些水平相邻或垂直相邻的单元格。同一个单元格内的字母不允许被重复使用。

例如，在下面的 3×4 的矩阵中包含单词 "ABCCED"（单词中的字母已标出）。

![img](https://assets.leetcode.com/uploads/2020/11/04/word2.jpg)

### 示例 1：

```
输入：board = [["A","B","C","E"],["S","F","C","S"],["A","D","E","E"]], word = "ABCCED"
输出：true
```

### 示例 2：

```
输入：board = [["a","b"],["c","d"]], word = "abcd"
输出：false
```

### 提示：

- `1 <= board.length <= 200`
- `1 <= board[i].length <= 200`
- `board` 和 `word` 仅由大小写英文字母组成

## 题解

循环遍历二维数组，以此为起点判断是否存在连续的字符串。在dfs中首先进行边界范围判断，以及此点是否满足要求，如果不满足要求直接返回假，为真则继续word判断之后的字符。如果以及是最后的字符就可以直接返回结果。<font color=purple>注意在判断k+1之前需要先mask掉自身的值，防止后续“路线返回”</font>

```python
class Solution(object):
    def exist(self, board, word):
        """
        :type board: List[List[str]]
        :type word: str
        :rtype: bool
        """
        def dfs(i,j,k):
            if (not len(board)>i>=0) or (not len(board[0])>j>=0) or board[i][j]!=word[k]: return False 
            #不匹配的情况
            if k == len(word)-1: return True #不用继续判断
            board[i][j] = ' '
            # #注意不能直接返回 因为在处理邻近的内容会判断到自身，这是不允许的，所以先mask
            # return dfs(i+1,j,k+1) or dfs(i-1,j,k+1) or dfs(i,j+1,k+1) or dfs(i,j-1,k+1) 
            res = dfs(i+1,j,k+1) or dfs(i-1,j,k+1) or dfs(i,j+1,k+1) or dfs(i,j-1,k+1) 
            board[i][j] = word[k]
            return res
        for i in range(len(board)):
            for j in range(len(board[0])):
                if dfs(i,j,0): return True #如果从ij开始找0之后的字符串找到则为真
        return False
```

