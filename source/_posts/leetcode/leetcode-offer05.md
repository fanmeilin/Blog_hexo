---
title: 剑指offer05 替换空格
tags: [剑指,字符串]
categories: 剑指
date: 2021-08-11 18:36:13
---

>替换空格

## 题目

请实现一个函数，把字符串 `s` 中的每个空格替换成"%20"。

#### 示例 1：

```
输入：s = "We are happy."
输出："We%20are%20happy."
```

##### 提示：

- 0 <= s 的长度 <= 10000

#### 题解

直接替换即可。相当于使用replace方法

```python
class Solution:
    def replaceSpace(self, s: str) -> str:
       #相当于现成函数 return s.replace(" ","%20")
        result = ""
        for x in s:
            if x==' ':
                x = "%20"
            result += x
        return result
```

