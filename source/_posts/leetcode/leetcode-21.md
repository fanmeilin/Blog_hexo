---
title: 剑指offer 力扣-21
tags: [剑指,排序]
categories: [剑指,排序]
date: 2021-12-23 15:34:57
---

> 合并两个有序链表

## 题目
将两个升序链表合并为一个新的 升序 链表并返回。新链表是通过拼接给定的两个链表的所有节点组成的。


### 示例 1：

```
输入：l1 = [1,2,4], l2 = [1,3,4]
输出：[1,1,2,3,4,4]
```

### 示例 2：

```
输入：l1 = [], l2 = []
输出：[]
```

### 示例 2：

```
输入：l1 = [], l2 = [0]
输出：[0]
```

### 提示：

- 两个链表的节点数目范围是 [0, 50]
- -100 <= Node.val <= 100
- l1 和 l2 均按 非递减顺序 排列

## 题解

这里使用的是链表，使用两个变量p1，p2分别指向两个链表，通过比较大小确定p的next的指向。最后将剩余的元素添加至p后。

```python
# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, val=0, next=None):
#         self.val = val
#         self.next = next
class Solution:
    def mergeTwoLists(self, list1: Optional[ListNode], list2: Optional[ListNode]) -> Optional[ListNode]:
        p1,p2 = list1,list2
        l = ListNode()
        p = l
        while(p1 and p2):
            if p1.val<p2.val:
                p.next = p1
                p1 = p1.next
            else:
                p.next = p2
                p2 = p2.next
            p = p.next
        p.next = p1 if p1 else p2
        return l.next
```

