---
title: 剑指offer06 合并两个排序的链表
tags: [剑指,链表]
categories: [剑指,链表]
date: 2021-08-16 17:39:21
---

>合并两个排序的链表

## 题目

输入两个递增排序的链表，合并这两个链表并使新链表中的节点仍然是递增排序的。

### 示例 1：

```
输入：1->2->4, 1->3->4
输出：1->1->2->3->4->4
```

### 提示：

- 0 <= 链表长度 <= 1000

## 题解

如果直接用p = l.next  那么不能达到“指针”的效果。这样的操作对l没有影响，无法更新。

```python
class Solution:
    def mergeTwoLists(self, l1: ListNode, l2: ListNode) -> ListNode:
        l = ListNode(0) 
        p = l.next     
        while(l1 and l2):
            if(l1.val>l2.val):
                p = l2
                l2 = l2.next
            else:
                p = l1
                l1 = l1.next
            p = p.next
        p = l1 if l1 else l2
        return l.next
```

正确方式，不能使用 p = p.next， 因为next是一个None值，改变p值并不会修改l对应的next。所以首先浅拷贝l，然后再直接改变内部的next，才能对应的改变l的内容。

```python
# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    def mergeTwoLists(self, l1: ListNode, l2: ListNode) -> ListNode:
        p = l = ListNode(0) #先指向同一块空间
        #p = p.next      
        # 不能使用p = p.next  因为next是一个None值改变p值并不会修改l对应的next。
        # 所以首先浅拷贝，然后再直接改变内部的next，才能对应的改变l的内容
        while(l1 and l2):
            if(l1.val>l2.val):
                p.next = l2
                l2 = l2.next
            else:
                p.next = l1
                l1 = l1.next
            p = p.next
        p.next = l1 if l1 else l2
        return l.next
```

