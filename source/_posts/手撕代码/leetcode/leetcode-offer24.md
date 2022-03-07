---
title: 剑指offer24 反转链表
tags: [剑指,链表]
categories: [剑指,链表]
date: 2021-08-21 11:51:30
---

> 反转链表

## 题目

定义一个函数，输入一个链表的头节点，反转该链表并输出反转后链表的头节点。

### 示例 1：

```
输入: 1->2->3->4->5->NULL
输出: 5->4->3->2->1->NULL
```

### 提示：

- 0 <= 节点个数 <= 5000

## 题解

比较常规，遍历链表把元素移动到头节点。

```python
# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    def reverseList(self, head: ListNode) -> ListNode:
        if not(head):return head
        p = head.next
        head.next = None
        while(p):
            t = p.next
            p.next = head
            head = p
            p = t
        return head
```

