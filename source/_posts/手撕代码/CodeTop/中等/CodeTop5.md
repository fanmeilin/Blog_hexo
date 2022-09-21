---
title: CodeTop5 最长回文子串
tags: [CodeTop,中等]
categories: [CodeTop,中等]
date: 2022-09-15 16:42:04
---

> 最长回文子串

## 题目

给你一个字符串 `s`，找到 `s` 中最长的回文子串。

### 示例 1：

```
输入：s = "babad"
输出："bab"
解释："aba" 同样是符合题意的答案。
```

### 示例 2：

```
输入：s = "cbbd"
输出："bb"
```

### 提示：

- `1 <= s.length <= 1000`
- `s` 仅由数字和英文字母组成

## 题解

暴力解法是对所有的组合可能进行判断是否为回文串，时间复杂度为O(n^3)；

### 动态规划

这一类的方法应该是使用动态规划，如果i，j区域指向的数据区域是回文串，那么dp[i+1]\[j-1]的区域也应该是回文串。只需要填充二维数据即可，时间复杂度为O(n^2);

- 设置dp[i]\[j]表示子字符串 i 到 j 是否为回文串，i,j表示下标；

- dp[i]\[i]初始化为1，单个元素必定为回文串；

- 遍历顺序从左到右，从下到上；
- 判断s[i]和s[j]， 如果两者相等，并且内部子串为回文串，那么dp[i][j] = j-i+1

```python
class Solution:
    def longestPalindrome(self, s: str) -> str:
        n = len(s)
        dp = [[0 for _ in range(n)] for _ in range(n)]
        max_len,indexi,indexj = 1,0,0
        for i in range(n):dp[i][i] = 1
        for j in range(1,n):
            for i in range(j-1,-1,-1):
                if s[i]==s[j] and (j-i==1 or dp[i+1][j-1]): dp[i][j] = j-i+1
                if dp[i][j]>max_len:
                    max_len = dp[i][j]
                    indexi,indexj = i,j
        return s[indexi:indexj+1]
```

- 时间复杂度为O(n^2);
- 空间复杂度为O(n^2);

### 中心扩散法

可以以元素 i 及元素 i 和 i+1 为中心向两边扩散寻找最长的回文串长度；前者所形成回文串为奇数，后者为偶数；

```python
class Solution: 
    def longestPalindrome(self, s: str) -> str:
        if not s:return ""
        def expend(l,r): #向外扩张
            while(l>=0 and r<len(s) and s[l]==s[r]):
                l -= 1
                r += 1
            return r-l-1 #注意是减去1
        max_len,end = 1,0
        for i in range(len(s)):
            ilen = max(expend(i,i),expend(i,i+1))
            if ilen > max_len:
                end = int(i+ilen/2)
                max_len = ilen
        return s[end-max_len+1:end+1]
```

- 时间复杂度：O(n^2)，其中 n 是字符串的长度。长度为 1 和 2 的回文中心分别有 n 和 n-1 个，每个回文中心最多会向外扩展 O(n)次。


- 空间复杂度：O(1)。


