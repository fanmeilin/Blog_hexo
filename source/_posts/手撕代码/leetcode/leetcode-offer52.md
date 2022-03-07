---
title: 剑指offer52 两个链表的第一个公共节点
tags: [剑指,双指针,idea]
categories: [剑指,双指针]
date: 2022-01-21 16:50:35
---

>两个链表的第一个公共节点

## 题目

输入两个链表，找出它们的第一个公共节点。

![](https://picture.mulindya.com/leetcode-offer52-1.png)

在节点 c1 开始相交。

### 示例 1：

![](https://picture.mulindya.com/leetcode-offer52-2.png)

```
输入：intersectVal = 8, listA = [4,1,8,4,5], listB = [5,0,1,8,4,5], skipA = 2, skipB = 3
输出：Reference of the node with value = 8
输入解释：相交节点的值为 8 （注意，如果两个列表相交则不能为 0）。从各自的表头开始算起，链表 A 为 [4,1,8,4,5]，链表 B 为 [5,0,1,8,4,5]。在 A 中，相交节点前有 2 个节点；在 B 中，相交节点前有 3 个节点。
```

### 示例 2：

![](https://picture.mulindya.com/leetcode-offer52-3.png)

```
输入：intersectVal = 2, listA = [0,9,1,2,4], listB = [3,2,4], skipA = 3, skipB = 1
输出：Reference of the node with value = 2
输入解释：相交节点的值为 2 （注意，如果两个列表相交则不能为 0）。从各自的表头开始算起，链表 A 为 [0,9,1,2,4]，链表 B 为 [3,2,4]。在 A 中，相交节点前有 3 个节点；在 B 中，相交节点前有 1 个节点。
```

### 示例 3：

![](https://picture.mulindya.com/leetcode-offer52-4.png)

```
输入：intersectVal = 0, listA = [2,6,4], listB = [1,5], skipA = 3, skipB = 2
输出：null
输入解释：从各自的表头开始算起，链表 A 为 [2,6,4]，链表 B 为 [1,5]。由于这两个链表不相交，所以 intersectVal 必须为 0，而 skipA 和 skipB 可以是任意值。
解释：这两个链表不相交，因此返回 null。
```

### 提示：

- 如果两个链表没有交点，返回 null.
- 在返回结果后，两个链表仍须保持原有的结构。
- 可假定整个链表结构中没有循环。
- 程序尽量满足 O(n) 时间复杂度，且仅用 O(1) 内存。
- 本题与主站 160 题相同：https://leetcode-cn.com/problems/intersection-of-two-linked-lists/


## 题解

这道题刚拿到觉得很简单，可以把数字用数组存下来，然后从后向前找寻公共节点。但是有一项要求`程序尽量满足 O(n) 时间复杂度，且仅用 O(1) 内存。`很难满足。

看大佬的题解真是妙不可言，甚至还被虐了

> 《你的名字》
>
> 你变成我，走过我走过的路。
> 我变成你，走过你走过的路。
> 然后我们便相遇了..

使用双指针A，B；当他们同时开始运动，A遍历完headA链表就遍历headB链表，而B遍历完headB链表就遍历A链表。A和B总会相遇要么是空，要么是公共节点。

背后的原理是：假设A链表的长度为a，B链表长度为b，公共部分为c；那么在相遇之前A会走a+b-c步，B会走b+a-c步，他们走的步数是相同的，所以只要他们同时开始运动，A指针按照A链表B链表，B指针按照B链表A链表，就会在节点处相遇！

```python
# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    def getIntersectionNode(self, headA: ListNode, headB: ListNode) -> ListNode:
        # 公共节点不仅值相等，实际上就是同一节点
        A,B = headA,headB
        while(A!=B):
            A = A.next if A else headB
            B = B.next if B else headA
        return A
```

