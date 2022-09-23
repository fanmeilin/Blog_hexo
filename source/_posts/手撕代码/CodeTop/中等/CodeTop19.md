---
title: CodeTop19 删除链表的倒数第N个节点
tags: [CodeTop,中等]
categories: [CodeTop,中等]
date: 2022-09-23 11:39:24
---

> 删除链表的倒数第N个节点

## 题目

给你一个链表，删除链表的倒数第 `n` 个结点，并且返回链表的头结点。

### 示例 1：

```
输入：head = [1,2,3,4,5], n = 2
输出：[1,2,3,5]
```

### 示例 2：

```
输入：head = [1], n = 1
输出：[]
```

### 示例 3：

```
输入：head = [1,2], n = 1
输出：[1]
```

### 提示：

- 链表中结点的数目为 `sz`
- `1 <= sz <= 30`
- `0 <= Node.val <= 100`
- `1 <= n <= sz`

**进阶：**你能尝试使用一趟扫描实现吗？

## 题解

常规想法，遍历两次链表，第一次记录链表的长度N，第二次删除第N-n+1个节点。

```python
class Solution:
    def removeNthFromEnd(self, head: ListNode, n: int) -> ListNode:
        def getLength(head: ListNode) -> int:
            length = 0
            while head:
                length += 1
                head = head.next
            return length
        
        dummy = ListNode(0, head)
        length = getLength(head)
        cur = dummy
        for i in range(1, length - n + 1):
            cur = cur.next
        cur.next = cur.next.next
        return dummy.next
```

- 时间复杂度：O(L)，其中 L是链表的长度。
- 空间复杂度：O(1)。

#### 栈

也可以在遍历链表的同时将所有节点依次入栈。根据栈「先进后出」的原则，我们弹出栈的第 n个节点就是需要删除的节点，并且目前栈顶的节点就是待删除节点的前驱节点。这样一来，删除操作就变得十分方便了。

```python
class Solution:
    def removeNthFromEnd(self, head: ListNode, n: int) -> ListNode:
        dummy = ListNode(0, head)
        stack = list()
        cur = dummy
        while cur:
            stack.append(cur)
            cur = cur.next
        for i in range(n):
            stack.pop()
        prev = stack[-1]
        prev.next = prev.next.next
        return dummy.next
```

- 时间复杂度：O(L)，其中 L是链表的长度。
- 空间复杂度：O(L)，其中 L是链表的长度。主要为栈的开销。

#### 双指针

更简单的方法，可以使用双指针可以实现一趟扫描，维持两个指针的距离为n+1,同步前移；

 - 使用**头节点**规范所有边界情况；
 - l和r的距离为n+1，同时后移；
 - 当r为空指针时，l正好是目标元素前驱节点，直接删除目标节点即可

```python
# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, val=0, next=None):
#         self.val = val
#         self.next = next
class Solution:
    def removeNthFromEnd(self, head: Optional[ListNode], n: int) -> Optional[ListNode]:
        #双指针实现一趟扫描,使用头节点规范所有边界情况，l和r的距离为n+1,当r为空指针时，l正好是目标元素前驱节点，直接删除目标节点即可
        dummy = ListNode(0,head)
        l, r = dummy, head
        for _ in range(n): r = r.next
        while r: l,r = l.next, r.next
        l.next = l.next.next
        return dummy.next
```

- 时间复杂度：O(L)，其中 L是链表的长度。
- 空间复杂度：O(1)。
