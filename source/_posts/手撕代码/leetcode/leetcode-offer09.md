---
title: 剑指offer09 用两个栈实现队列
date: 2021-08-10 10:46:28
tags: [剑指,栈]
categories: [剑指,栈]
---

> 用两个栈实现队列

## 题目

用两个栈实现一个队列。队列的声明如下，请实现它的两个函数 appendTail 和 deleteHead ，分别完成在队列尾部插入整数和在队列头部删除整数的功能。(若队列中没有元素，deleteHead 操作返回 -1 )

### 示例 1：

```
输入：
["CQueue","appendTail","deleteHead","deleteHead"]
[[],[3],[],[]]
输出：[null,null,3,-1]
```

### 示例 2：

```
输入：
["CQueue","deleteHead","appendTail","appendTail","deleteHead","deleteHead"]
[[],[],[5],[2],[],[]]
输出：[null,-1,null,null,5,2]
```

### 提示：

- 1 <= values <= 10000
- 最多会对 appendTail、deleteHead 进行 10000 次调用

## 题解

使用两个栈，*一个作为插入栈，一个作为删除栈*。`使用list进行相关操作（append，pop）`；在插入时直接对stack1进行append操作，删除时首先需要构建删除栈内容，再进行判断，最后同步到插入栈中（此时删除栈又为空）。

```python
class CQueue:

    def __init__(self):
        # stack1是insert栈 stack2是delete栈
        self.stack1 = [] #list作用和stack类似
        self.stack2 = []

    def appendTail(self, value: int) -> None:
        self.stack1.append(value) # 直接插入栈顶

    def deleteHead(self) -> int:
        while self.stack1: #首先更新delete栈
            self.stack2.append(self.stack1.pop())
        #进行deleteHead操作
        if not self.stack2: 
            return -1
        popitem = self.stack2.pop()
        # 将更新结果写回stack1中 保持一致
        while self.stack2:
            self.stack1.append(self.stack2.pop())
        return popitem

# Your CQueue object will be instantiated and called as such:
# obj = CQueue()
# obj.appendTail(value)
# param_2 = obj.deleteHead()
```

