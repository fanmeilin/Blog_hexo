---
title: 剑指offer36 二叉搜索树和双向链表
tags: [剑指,树]
categories: [剑指,树]
date: 2021-10-08 19:50:46
---

> 二叉搜索树和双向链表

## 题目
输入一棵二叉搜索树，将该二叉搜索树转换成一个排序的循环双向链表。要求不能创建任何新的节点，只能调整树中节点指针的指向
为了让您更好地理解问题，以下面的二叉搜索树为例：

![](https://picture.mulindya.com/leetcode-offer36-1.png)

我们希望将这个二叉搜索树转化为双向循环链表。链表中的每个节点都有一个前驱和后继指针。对于双向循环链表，第一个节点的前驱是最后一个节点，最后一个节点的后继是第一个节点。

下图展示了上面的二叉搜索树转化成的链表。“head” 表示指向链表中有最小元素的节点。

![](https://picture.mulindya.com/leetcode-offer36-2.png)

特别地，我们希望可以就地完成转换操作。当转化完成以后，树中节点的左指针需要指向前驱，树中节点的右指针需要指向后继。还需要返回链表中的第一个节点的指针。

### 提示：

- 注意：本题与主站 426 题相同：https://leetcode-cn.com/problems/convert-binary-search-tree-to-sorted-doubly-linked-list/

- 注意：此题对比原题有改动。


## 题解

本题的算法思想是在中序遍历的基础上，涉及对链表的处理，但是还是按照中序递归遍历的逻辑，使用self可以全局设置pre和head，pre是用来更新节点的左右指向，head是用于后续的头尾节点的处理，函数结束时的pre即为尾节点。

中序遍历代码结构：

```python
def dfs(root):
	if not root:
		return
	dfs(root.left)
	print(root)
	dfs(root.right)
```

注意边界条件的处理，以及self.pre和self.head的更新。

```python
"""
# Definition for a Node.
class Node:
    def __init__(self, val, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right
"""
class Solution:
    def treeToDoublyList(self, root: 'Node') -> 'Node':
        def mediumfunc(root):
            if not root:return
            mediumfunc(root.left)
            if(self.pre):
                self.pre.right = root
                root.left = self.pre
            else:
                self.head = root
            self.pre = root #注意在判断之后必须要更新pre
            mediumfunc(root.right)
        if not(root):
            return None
        self.head = root
        self.pre = None
        mediumfunc(root)
        self.head.left = self.pre
        self.pre.right = self.head
        return self.head
```

