---
title: CodeTop25 K个一组翻转链表
tags: [CodeTop,字节,链表]
categories: [CodeTop,字节,链表]
date: 2022-04-08 21:45:18
---

>[K个一组翻转链表](https://leetcode-cn.com/problems/reverse-nodes-in-k-group/)
>
>频度227

## 题目

给你一个链表，每 k 个节点一组进行翻转，请你返回翻转后的链表。

k 是一个正整数，它的值小于或等于链表的长度。

如果节点总数不是 k 的整数倍，那么请将最后剩余的节点保持原有顺序。

进阶：

你可以设计一个只使用常数额外空间的算法来解决此问题吗？
你不能只是单纯的改变节点内部的值，而是需要实际进行节点交换。

### 示例 1：

```
输入：head = [1,2,3,4,5], k = 2
输出：[2,1,4,3,5]
```

### 示例 2：

```
输入：head = [1,2,3,4,5], k = 3
输出：[3,2,1,4,5]
```

### 示例 3：

```
输入：head = [1,2,3,4,5], k = 1
输出：[1,2,3,4,5]
```

### 示例 4：

```
输入：head = [1], k = 1
输出：[1]
```

### 提示：

- 列表中节点的数量在范围 `sz` 内
- `1 <= sz <= 5000`
- `0 <= Node.val <= 1000`
- `1 <= k <= sz`

## 题解

反转链表的套路

```python
cur, pre = head, None
while cur:
	temp, cur.next = cur.next, pre
	pre,cur = cur,temp
```

现在需要分组反转，就需要暂时记录本组的尾节点，同时在最后反转完成（反转了k个元素）后，将上一组的尾节点和当前的头节点“链接”上。

最本组反转完成后：

ptail指向上一组的尾节点；

pre指向当前组的头节点；

ptail_temp表示当前组的尾节点；

cur指向下一组等待反转的元素。

如果最后不足k个元素，就恢复反转，也就是说将当前组再反转一次即可。

```python
# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, val=0, next=None):
#         self.val = val
#         self.next = next
class Solution:
    def reverseKGroup(self, head: Optional[ListNode], k: int) -> Optional[ListNode]:
        cur,ptail = head,None
        flag = False
        while cur:
            count,pre = 0,None
            while cur and count<k: #小段处理
                temp,cur.next = cur.next,pre
                if not pre:ptail_temp = cur
                pre,cur = cur,temp
                count += 1
                if count==k:   
                    if flag:
                        ptail.next = pre
                    if not flag:
                        head, flag = pre, True
                    ptail = ptail_temp
        #恢复尾部信息
        if count<k:
            ptail.next = ptail_temp
            cur, pre = pre, None
            while cur:
                temp, cur.next = cur.next,pre
                pre,cur = cur,temp
        return head
#时间复杂度O(n) 空间复杂度O(1)
```

也可以封装一下函数：

```python
class Solution:
    # 翻转一个子链表，并且返回新的头与尾
    def reverse(self, head: ListNode, tail: ListNode):
        prev = tail.next
        p = head
        while prev != tail:
            nex = p.next
            p.next = prev
            prev = p
            p = nex
        return tail, head

    def reverseKGroup(self, head: ListNode, k: int) -> ListNode:
        hair = ListNode(0)
        hair.next = head
        pre = hair

        while head:
            tail = pre
            # 查看剩余部分长度是否大于等于 k
            for i in range(k):
                tail = tail.next
                if not tail:
                    return hair.next
            nex = tail.next
            head, tail = self.reverse(head, tail)
            # 把子链表重新接回原链表
            pre.next = head
            tail.next = nex
            pre = tail
            head = tail.next
        
        return hair.next
```

