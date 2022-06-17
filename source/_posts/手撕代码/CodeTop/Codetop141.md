---
title: Codetop141 环形链表
tags: [CodeTop,链表]
categories: [CodeTop,链表]
date: 2022-06-17 10:42:06
---

> 环形链表

## 题目
给你一个链表的头节点 head ，判断链表中是否有环。

如果链表中有某个节点，可以通过连续跟踪 next 指针再次到达，则链表中存在环。 为了表示给定链表中的环，评测系统内部使用整数 pos 来表示链表尾连接到链表中的位置（索引从 0 开始）。注意：pos 不作为参数进行传递 。仅仅是为了标识链表的实际情况。

如果链表中存在环 ，则返回 true 。 否则，返回 false 。

### 示例 1：

![](https://picture.mulindya.com/Aleetcode/CodeTop141-1.png)

```
输入：head = [3,2,0,-4], pos = 1
输出：true
解释：链表中有一个环，其尾部连接到第二个节点。
```

### 示例 2：

![](https://picture.mulindya.com/Aleetcode/CodeTop141-2.png)

```
输入：head = [1,2], pos = 0
输出：true
解释：链表中有一个环，其尾部连接到第一个节点。
```
### 示例3

![](https://picture.mulindya.com/Aleetcode/CodeTop141-3.png)

```
输入：head = [1], pos = -1
输出：false
解释：链表中没有环。
```

### 提示：

- 链表中节点的数目范围是 [0, 10^4]
- -10^5 <= Node.val <= 10^5
- pos 为 -1 或者链表中的一个 有效索引 。

## 题解

#### 标号

选择一个不出现的记号作为是否visit，选用浮点数1.5作为标记。但是有投机取巧之嫌。

- 时间复杂度为O(N)，空间复杂度为O(1)

```python
# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    def hasCycle(self, head: Optional[ListNode]) -> bool:
        while(head):
            head.val = 1.5
            pnext = head.next
            if pnext and pnext.val==1.5:return True
            head = pnext
        return False
```

#### 哈希表

使用哈希表来存储所有已经访问过的节点。每次我们到达一个节点，如果该节点已经存在于哈希表中，则说明该链表是环形链表，否则就将该节点加入哈希表中。重复这一过程，直到我们遍历完整个链表即可。

可以使用set来记录出现的各个节点。

- 时间复杂度为O(N)，空间复杂度为O(N)

```python
class Solution:
    def hasCycle(self, head: ListNode) -> bool:
        seen = set()
        while head:
            if head in seen: #in 查找 O(1) set本身是一个哈希表           
                return True
            seen.add(head)
            head = head.next
        return False
```

#### 快慢指针 ⭐

这里使用快慢指针，**快指针表示每次移动两个节点，慢指针表示每次移动一个节点。**

如果链表没有环时，最终快指针先于慢指针达到链表尾部，每个节点最多被访问两次。

如果存在环形，快指针原本先于慢指针，但是当进入环形之后（快指针先进入环形），快指针变成追赶慢指针，并且在每一次移动之后，两个指针的距离就会减少一个节点，最终肯定会相遇。

- 时间复杂度为O(N)，空间复杂度为O(1)

```python
class Solution:
    def hasCycle(self, head: ListNode) -> bool:
        fast = slow = head
        while fast and fast.next:
            fast = fast.next.next #两步
            slow = slow.next
            if fast == slow:
                return True
        return False
```

