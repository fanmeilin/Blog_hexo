---
title: 剑指offer22 链表中倒数第k个节点
tags: [剑指,链表]
categories: [剑指,链表]
date: 2021-08-20 11:26:27
---

> 链表中倒数第k个节点

## 题目

输入一个链表，输出该链表中倒数第k个节点。为了符合大多数人的习惯，本题从1开始计数，即链表的尾节点是倒数第1个节点。

例如，一个链表有 6 个节点，从头节点开始，它们的值依次是 1、2、3、4、5、6。这个链表的倒数第 3 个节点是值为 4 的节点。

### 示例 1：

```
给定一个链表: 1->2->3->4->5, 和 k = 2.
返回链表 4->5.
```

## 题解

一种方法是先确定链表的长度，然后再移动对应的结点个数。那么就需要O(2n)

```python
class Solution:
    def getKthFromEnd(self, head: ListNode, k: int) -> ListNode:
        y = x = head
        cnt = 0
        while(x):
            cnt += 1
            x = x.next
        t = cnt - k
        while(t):
            y = y.next
            t -= 1
        return y
```

使用快慢指针，使得x与y相距k元素，然后x遍历到最后，y就可以得到对应的结果。此时只需要O(n)
```python
class Solution:
    def getKthFromEnd(self, head: ListNode, k: int) -> ListNode:
        y = x = head
        while(x):
            if(k<=0):y = y.next
            x = x.next
            k -= 1
        return y
```