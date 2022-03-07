---
title: CodeTop microsoft3 无重复字符的最长子串
tags: [CodeTop,微软]
categories: [CodeTop,微软]
date: 2022-03-07 21:35:23
---

>无重复字符的最长子串

## 题目

给定一个字符串 `s` ，请你找出其中不含有重复字符的 **最长子串** 的长度。

### 示例 1：

```
输入: s = "abcabcbb"
输出: 3 
解释: 因为无重复字符的最长子串是 "abc"，所以其长度为 3。
```

### 示例 2：

```
输入: s = "bbbbb"
输出: 1
解释: 因为无重复字符的最长子串是 "b"，所以其长度为 1。
```

### 示例 3：

```
输入: s = "pwwkew"
输出: 3
解释: 因为无重复字符的最长子串是 "wke"，所以其长度为 3。
     请注意，你的答案必须是 子串 的长度，"pwke" 是一个子序列，不是子串。
```

### 提示：

- `0 <= s.length <= 5 * 104`
- `s` 由英文字母、数字、符号和空格组成

## 题解

这道题主要用到思路是：滑动窗口

- 什么是滑动窗口？


其实就是一个队列,比如例题中的 abcabcbb，进入这个队列（窗口）为 abc 满足题目要求，当再进入 a，队列变成了 abca，这时候不满足要求。所以，我们要移动这个队列！

- 如何移动？


我们只要把队列的左边的元素移出就行了，直到重复字符之后。

一直维持这样的队列，找出队列出现最长的长度时候，求出解！

> 这里要使用到python的set，添加元素使用add，去除元素使用remove，查找元素是否在其中使用in

时间复杂度：O(n)

```python
class Solution:
    def lengthOfLongestSubstring(self, s: str) -> int:
        #使用滑动窗口
        if not s:return 0
        left,maxLength,curLength = 0,0,0
        sset = set()
        for right in range(len(s)):
            while s[right] in sset: #判断是否在set中O(1)即可，如果在sset中将left移动到重复字符后面所以是while
                sset.remove(s[left]) # 移除该元素
                left += 1
                curLength -= 1
            sset.add(s[right]) #添加至set中
            curLength += 1
            maxLength = max(maxLength,curLength)
        return maxLength
```

- 什么类型的题目使用滑动窗口呢？

如果我们依次递增地枚举子串的起始位置，那么子串的结束位置也是递增的；这样一来，我们就可以使用「滑动窗口」来解决这个问题了

也可以使用`defaultdict`类，使用`from collections import defaultdict`,使用`defaultdict`的好处是如果不在该字典中会返回定义的默认值

```python
class Solution:
    def lengthOfLongestSubstring(self, s):
        """
        :type s: str
        :rtype: int
        """
        from collections import defaultdict
        lookup = defaultdict(int)
        start = 0
        end = 0
        max_len = 0
        counter = 0
        while end < len(s):
            if lookup[s[end]] > 0: #如果存在多个相同的元素使用counter记录
                counter += 1
            lookup[s[end]] += 1
            end += 1
            while counter > 0:
                if lookup[s[start]] > 1:
                    counter -= 1
                lookup[s[start]] -= 1
                start += 1
            max_len = max(max_len, end - start)
        return max_len
```

