---
title: 剑指offer38 字符串的排列
tags: [剑指,递归]
categories: [剑指,递归]
date: 2021-11-20 15:10:23
---

>字符串的排列

## 题目

输入一个字符串，打印出该字符串中字符的所有排列。

你可以以任意顺序返回这个字符串数组，但里面不能有重复元素。

### 示例 1：

```
输入：s = "abc"
输出：["abc","acb","bac","bca","cab","cba"]
```

### 提示：

- 1 <= s 的长度 <= 8

## 题解

#### 思路一

固定s的第一个元素,得到去掉这个元素的后续元素的全排列情况（递归调用）;

第一个元素的确定方法使用循环遍历，但是这里要s中可能存在重复元素，因此需要使用set去掉重复元素，也有剪枝的作用；

> 去掉字符串的某元素（或者字符串）的方法 
>
> 使用replace函数替换字符为空--**`s.replace(x,'',1)`**
>
>  - replace方法
>
>    `str.replace(old,new,max=string.count(old)）`
> 
>   最多替换max个old字符为new字符，默认全部替换，这里只替换1个哦~
>    

```python
class Solution:
    def permutation(self, s: str) -> List[str]:
        if(not s): return [] 
        if(len(s)==1): return [s]
        result = []
        sset = set(s)
        for x in sset:
           temp = [x + item for item in self.permutation(s.replace(x,'',1))]
           result += temp
        return result
```

#### 思路二

使用深度优先遍历的思想，模拟为树的遍历节点，遍历x位置处为x及x之后索引元素的情况，dfs(x) 是固定前面0到x，来深优x此元素情况。

```python
class Solution:
    def permutation(self, s: str) -> List[str]:
        c, res = list(s), []
        def dfs(x):
            if x == len(c) - 1:
                res.append(''.join(c))   # 添加排列方案
                return
            dic = set()
            for i in range(x, len(c)):
                if c[i] in dic: continue # 重复，因此剪枝
                dic.add(c[i])
                c[i], c[x] = c[x], c[i]  # 交换，将 c[i] 固定在第 x 位
                dfs(x + 1)               # 开启固定第 x + 1 位字符
                c[i], c[x] = c[x], c[i]  # 恢复交换
        dfs(0)
        return res

```

