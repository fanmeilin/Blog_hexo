---
title: 剑指offer31 栈的压入，弹出序列
tags: [剑指,栈]
categories: [剑指,栈]
date: 2021-11-19 10:28:15
---

>栈的压入，弹出序列

## 题目

输入两个整数序列，第一个序列表示栈的压入顺序，请判断第二个序列是否为该栈的弹出顺序。假设压入栈的所有数字均不相等。例如，序列 {1,2,3,4,5} 是某栈的压栈序列，序列 {4,5,3,2,1} 是该压栈序列对应的一个弹出序列，但 {4,3,5,1,2} 就不可能是该压栈序列的弹出序列。

### 示例 1：

```
输入：pushed = [1,2,3,4,5], popped = [4,5,3,2,1]
输出：true
解释：我们可以按以下顺序执行：
push(1), push(2), push(3), push(4), pop() -> 4,
push(5), pop() -> 5, pop() -> 3, pop() -> 2, pop() -> 1
```

### 示例 2：

```
输入：pushed = [1,2,3,4,5], popped = [4,3,5,1,2]
输出：false
解释：1 不能在 2 之前弹出。
```

### 提示：

- 0 <= pushed.length == popped.length <= 1000
- 0 <= pushed[i], popped[i] < 1000
- pushed 是 popped 的排列。

## 题解

按照压入和弹出序列可以双向唯一确定栈的压入弹出的顺序，所以按照对应的此序列，可以模拟压出和弹出的场景，最终如果可以成立，那么栈中的数据应该全部弹出了。
具体的做法就是按照压入序列的顺序，每压入一个数值，就比对弹出序列的值，查看是否可以弹出，等到压入的数值都处理完成，查看栈是否为空，如果不是空就说明弹出序列时不能匹配的。

```python
class Solution:
    def validateStackSequences(self, pushed: List[int], popped: List[int]) -> bool:
        #模拟场景
        stack = []
        i = 0
        j = 0
        while(i<len(pushed)):
            stack.append(pushed[i])
            while(len(stack) and stack[len(stack)-1]==popped[j]):
                j += 1
                stack.pop()
            i += 1
        return not stack
```

