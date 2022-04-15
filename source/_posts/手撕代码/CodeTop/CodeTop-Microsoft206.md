---
title: CodeTop_Microsoft53 反转链表
tags: [CodeTop,微软,链表]
categories: [CodeTop,微软,链表]
date: 2022-03-23 16:49:01
---

>反转链表

## 题目

给你单链表的头节点 `head` ，请你反转链表，并返回反转后的链表。

### 示例 1：

```
输入：head = [1,2,3,4,5]
输出：[5,4,3,2,1]
```

### 示例 2：

```
输入：head = [1,2]
输出：[2,1]
```

### 示例 2：

```
输入：head = []
输出：[]
```

### 提示：

- 链表中节点的数目范围是 `[0, 5000]`
- `-5000 <= Node.val <= 5000`

**进阶：**链表可以选用迭代或递归方式完成反转。你能否用两种方法解决这道题？

## 题解

#### 迭代

第一个想法是使用迭代遍历的方法反转链表，记录phead是反转链表的头节点，移动head，使用temp记录当前元素的后一个元素。

时间复杂度O(n)，空间复杂度O(1)

```python
class Solution:
    def reverseList(self, head: ListNode) -> ListNode:
        # 迭代方法 时间复杂度O(n)，空间复杂度O(1)
        if not head: return None
        phead = None
        while head:
            temp = head.next
            head.next = phead
            phead,head = head,temp
        return phead
```

#### 递归

使用递归的方法，如果该链表为空或者为单一元素则返回head。反转head之后的链表得到ret，ret即为反转后的头节点，然后将head的下一节点的指向修改为head，最后将head的指向修改为None。

时间复杂度O(n)，空间复杂度O(n)

- 使用递归函数，一直递归到链表的最后一个结点，该结点就是反转后的头结点，记作 ret.
- 此后，每次函数在返回的过程中，让当前结点的下一个结点的 next 指针指向当前节点。
- 同时让当前结点的 next 指针指向 NULL ，从而实现从链表尾部开始的局部反转
- 当递归函数全部出栈后，链表反转完成。

```python
class Solution:
    def reverseList(self, head: ListNode) -> ListNode:
        #递归方法
        if not head or not head.next: #为空或者是单元素
            return head
        ret = self.reverseList(head.next) #反转head之后的元素
        head.next.next = head
        head.next = None
        return ret    
```

