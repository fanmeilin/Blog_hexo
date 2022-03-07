---
title: 剑指offer32-1 从上到下打印二叉树
tags: 剑指
categories: 剑指
date: 2021-11-21 17:39:52
---

>

## 题目

从上到下打印出二叉树的每个节点，同一层的节点按照从左到右的顺序打印。

### 示例 1：

```
例如:
给定二叉树: [3,9,20,null,null,15,7],
    3
   / \
  9  20
    /  \
   15   7
 返回：  
   [3,9,20,15,7]
```

### 提示：

- 节点总数 <= 1000

## 题解

常规的层序遍历

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    def levelOrder(self, root: TreeNode) -> List[int]:
        if not root:return []
        queue = deque()
        result = []
        queue.append(root)
        while(queue):
            top = queue.popleft()
            result.append(top.val)
            if top.left:queue.append(top.left)
            if top.right:queue.append(top.right)
        return result

#如果按照层数来打印，那么记录每次的queue长度（本层长度），按照现有队列中的元素来（本层）压入后续元素（下一层）。就可以分层次打印
```

