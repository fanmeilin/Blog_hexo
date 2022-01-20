---
title: 剑指offer46 把数字翻译成字符串
tags: [剑指,动态规划]
categories: [剑指,动态规划]
date: 2022-01-20 22:15:30
---

>把数字翻译成字符串

## 题目

给定一个数字，我们按照如下规则把它翻译为字符串：0 翻译成 “a” ，1 翻译成 “b”，……，11 翻译成 “l”，……，25 翻译成 “z”。一个数字可能有多个翻译。请编程实现一个函数，用来计算一个数字有多少种不同的翻译方法。

### 示例 1：

```
输入: 12258
输出: 5
解释: 12258有5种不同的翻译，分别是"bccfi", "bwfi", "bczi", "mcfi"和"mzi"
```

### 提示：

- `0 <= num < 231`

## 题解

使用动态规划，record记录num的对应位的翻译数目，动态规划的转移方程如下：

```python
record[i+1] = record[i] if tempnum>25 or tempnum<10 else record[i]+record[i-1]
```

`tempnum`表示此位和前一位组成的数字，注意`tempnum`的范围，如果小于10，则还是等于前一位的record。

```python
class Solution:
    def translateNum(self, num: int) -> int:
        if num<10:
            return 1
        record = [1 for i in range(32)]
        s = str(num)
        for i,x in enumerate(s):
            if i==0: continue
            temp = s[i-1]+s[i]
            tempnum = int(temp)
            record[i+1] = record[i] if tempnum>25 or tempnum<10 else record[i]+record[i-1]
        return record[len(s)]
```

瞻仰一下大佬的代码：

```python
class Solution:
    def translateNum(self, num: int) -> int:
        s = str(num)
        a = b = 1
        for i in range(2, len(s) + 1):
            a, b = (a + b if "10" <= s[i - 2:i] <= "25" else a), a
        return a
```

实际上只需要两个信息就可以推断当前的record，a表示当前信息，b为前一位信息，使用a，b来更新后续信息。

