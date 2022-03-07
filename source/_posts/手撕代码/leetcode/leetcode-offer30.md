---
title: 剑指offer30 包含min函数的栈
tags: [剑指,栈]
categories: [剑指,栈]
date: 2021-09-17 17:07:11
---

> 包含min函数的栈

## 题目
定义栈的数据结构，请在该类型中实现一个能够得到栈的最小元素的 min 函数在该栈中，调用 min、push 及 pop 的时间复杂度都是 O(1)。

### 示例 1：

```
MinStack minStack = new MinStack();
minStack.push(-2);
minStack.push(0);
minStack.push(-3);
minStack.min();   --> 返回 -3.
minStack.pop();
minStack.top();      --> 返回 0.
minStack.min();   --> 返回 -2.
```


### 提示：

- 各函数的调用总次数不超过 20000 次

## 题解

emm这样子使用min函数，不太科学，时间复杂度为O(N)
```python
class MinStack:

    def __init__(self):
        """
        initialize your data structure here.
        """
        self.stack = []
        self.minnum = sys.maxsize #float("inf")

    def push(self, x: int) -> None:
        if(self.minnum>x): self.minnum = x
        self.stack.append(x)

    def pop(self) -> None:
        item = self.top()
        self.stack.pop()
        if(len(self.stack) == 0): 
            self.minnum = sys.maxsize #float("inf")
        elif(item==self.minnum):
            self.minnum = min(self.stack)
    def top(self) -> int:
        return self.stack[-1]

    def min(self) -> int:
        return self.minnum

# Your MinStack object will be instantiated and called as such:
# obj = MinStack()
# obj.push(x)
# obj.pop()
# param_3 = obj.top()
# param_4 = obj.min()
```
-实际上应该创建两个栈，一个作为普通的栈A记录数据，另一个B用于辅助栈min的实现；使得A中的最小元素始终对应于B的栈顶元素。**栈B的主要目的是记录最小值，所以不一定是需要所有完整的数据。**

- 在调用push函数时，注意要维护好栈B，也就是说判断x时小于等于栈顶元素，才压入栈B；
- 在调用pop函数时，要保持A，B元素的一致性，在A中pop的元素是B的栈顶元素就要同步删除掉栈B的栈顶元素；

这种方式可以保证在删除掉A和B的栈顶元素（最小值）之后，B的栈顶元素依然还是A的最小值。

嗯厉害~ o(*￣▽￣*)o

```python
class MinStack:

    def __init__(self):
        """
        initialize your data structure here.
        """
        self.A,self.B = [],[]

    def push(self, x: int) -> None:
		self.A.append(x)
        if not self.B or self.B[-1]>=x: #注意是大于等于，因为需要记录避免后续弹出导致元素不同步
            self.B.append(x)

    def pop(self) -> None:
		if(self.A.pop() == self.B[-1]): #如果是相同元素就注意同步删除
            self.B.pop()
    def top(self) -> int:
        return self.A[-1]

    def min(self) -> int:
        return self.B[-1]
```

