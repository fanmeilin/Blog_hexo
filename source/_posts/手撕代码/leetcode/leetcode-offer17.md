---
title: 剑指offer17 打印从1到最大的n位数
tags: [剑指,大数]
categories: [剑指,大数]
date: 2021-08-20 17:11:58
---

> 打印从1到最大的n位数

## 题目

输入数字 n，按顺序打印出从 1 到最大的 n 位十进制数。比如输入 3，则打印出 1、2、3 一直到最大的 3 位数 999。

### 示例 1：

```
输入: n = 1
输出: [1,2,3,4,5,6,7,8,9]
```

### 提示：

- 用返回一个整数列表来代替打印
- n 为正整数

## 题解

借用python的类型转换的包容性，直接可以返回列表

```python
class Solution:
    def printNumbers(self, n: int) -> List[int]:
        return [i for i in range(1,pow(10,n))] #或者10**n
```
实际上，考点是大数越界情况下的打印。
解决思路，用字符串的全排列来解决数字的越界情况。基于分治算法的思想，先固定高位，向低位递归，当个位已被固定时，添加数字的字符串。例如当 n = 2时（数字范围 1 - 99 ），固定十位为 0- 9 ，按顺序依次开启递归，固定个位 0 - 9 ，终止递归并添加数字字符串。

```python
class Solution:
    def printNumbers(self, n: int) -> [int]:
        def dfs(x):
            if x == n:
                s = ''.join(num[self.start:])
                if s != '0': res.append(int(s))
                if n - self.start == self.nine: self.start -= 1
                return
            for i in range(10):
                if i == 9: self.nine += 1
                num[x] = str(i)
                dfs(x + 1)
            self.nine -= 1
        
        num, res = ['0'] * n, []
        self.nine = 0
        self.start = n - 1
        dfs(0)
        return res
```

- 字符串左边界定义： 声明变量 start 规定字符串的左边界，以保证添加的数字字符串 num[start:] 中无高位多余的 0 。例如当 n = 2 时, 1 - 9时 start = 1， 10 - 99 时 start = 0。
- 左边界 start 变化规律： 观察可知，当输出数字的所有位都是 9 时，则下个数字需要向更高位进 11 ，此时左边界 start 需要减11 （即高位多余的 0 减少一个）。例如当 n = 3（数字范围 1 - 999 ）时，左边界 start 需要减 1 的情况有： "009" 进位至 "010" ， "099" 进位至 "100" 。设数字各位中 9 的数量为 nine ，所有位都为 9 的判断条件可用以下公式表示：n - start = nine统计 nine 的方法： 固定第 x 位时，当 i = 9则执行 nine = nine + 1 ，并在回溯前恢复 nine = nine - 1

