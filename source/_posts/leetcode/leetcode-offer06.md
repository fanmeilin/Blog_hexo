---
title: 剑指offer06 从尾到头打印链表
tags: [剑指,链表,idea]
categories: [剑指,链表]
date: 2021-08-14 01:28:42
---

>从尾到头打印链表

## 题目

输入一个链表的头节点，从尾到头反过来返回每个节点的值（用数组返回）。

### 示例 1：

```
输入：head = [1,3,2]
输出：[2,3,1]
```

### 提示：

- 0 <= 链表长度 <= 10000

## 题解

遍历链表，直接插入到头位置。就可以直接输出了。或者采用递归，超级简洁，值得借鉴。注意if的条件和对应结果。（递归就从中间普适的节点开始考虑 然后补充边界细节）

<font color=orange>return self.reversePrint( head.next ) + [ head.val ] if head else []</font>

```python
# Definition for singly-linked list.
# class ListNode(object):
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution(object):
    def reversePrint(self, head):
        """
        :type head: ListNode
        :rtype: List[int]
        """
        p=head
        result = []
        while(p):
            result = [p.val]+result #直接添加到前面
            p = p.next
        return result
        #使用递归一条语句超级简洁 递归后一个元素+当前元素 如果当前为空则+【】 也是终止未知
        #return self.reversePrint(head.next) + [head.val] if head else []
```

