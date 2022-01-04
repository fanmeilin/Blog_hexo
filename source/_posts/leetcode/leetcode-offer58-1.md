---
title: 剑指offer58-1 翻转单词的顺序
tags: [剑指,双指针]
categories: [剑指,双指针]
date: 2022-01-04 10:43:22
---

>翻转单词的顺序

## 题目

输入一个英文句子，翻转句子中单词的顺序，但单词内字符的顺序不变。为简单起见，标点符号和普通字母一样处理。例如输入字符串"I am a student. "，则输出"student. a am I"。

### 示例 1：

```
输入: "the sky is blue"
输出: "blue is sky the"
```

### 示例 2：

```
输入: "  hello world!  "
输出: "world! hello"
解释: 输入字符串可以在前面或者后面包含多余的空格，但是反转后的字符不能包括。
```

### 示例 3：

```
输入: "a good   example"
输出: "example good a"
解释: 如果两个单词间有多余的空格，将反转后单词间的空格减少到只含一个。
```

### 提示：

- 无空格字符构成一个单词。
- 输入字符串可以在前面或者后面包含多余的空格，但是反转后的字符不能包括。
- 如果两个单词间有多余的空格，将反转后单词间的空格减少到只含一个。

## 题解

使用双指针来定位词首尾位置，由于是倒序因此需要从后往前来搜索，先定位词的起始位置再跳过空格定位j的位置，截取单词到列表中，最后使用join连接字符串。

```python
class Solution:
    def reverseWords(self, s: str) -> str:
        #从后往前 利用双指针来判断单词块
        s = s.strip() # 删除首尾空格
        # Python strip() 方法用于移除字符串头尾指定的字符（默认为空格或换行符）或字符序列。
        # 注意：该方法只能删除开头或是结尾的字符，不能删除中间部分的字符。
        i,j = len(s)-1,len(s)-1
        res = []
        while(i>=0):
            while(i>=0 and s[i]!=' '): i -= 1 #确定词的起始位置
            res.append(s[i+1:j+1])
            while(i>=0 and s[i]==' '): i -= 1 #确定j的位置
            j = i
        return ' '.join(res)
```

使用内置函数split的话这里直接使用`split()`

因为`s.split(" ")`解决不了单词间多空格的问题，`s.split()`可以解决。

```python
class Solution:
    def reverseWords(self, s: str) -> str:
        return ' '.join(s.strip().split()[::-1])
```

