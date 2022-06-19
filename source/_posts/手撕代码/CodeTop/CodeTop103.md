---
title: CodeTop103 二叉树的锯齿形层序遍历
tags: [CodeTop,队列]
categories: [CodeTop,队列]
date: 2022-06-19 11:45:26
---

>二叉树的锯齿形层序遍历

## 题目

给你二叉树的根节点 `root` ，返回其节点值的 **锯齿形层序遍历** 。（即先从左往右，再从右往左进行下一层遍历，以此类推，层与层之间交替进行）。

### 示例 1：

```
输入：root = [3,9,20,null,null,15,7]
输出：[[3],[20,9],[15,7]]
```

### 示例 2：

```
输入：root = [1]
输出：[[1]]
```

### 示例3

```python
输入：root = []
输出：[]
```

### 提示：

- 树中节点数目在范围 `[0, 2000]` 内
- `-100 <= Node.val <= 100`

## 题解

在层序遍历的基础上，将每一层的数据根据seq标记来处理是否逆序即可。

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
class Solution:
    def zigzagLevelOrder(self, root: TreeNode) -> List[List[int]]:
        if not root: return []
        queue, result = [], []
        seq = True
        queue.append(root)
        while queue:
            length = len(queue)
            tmp = []
            for _ in range(length):
                top = queue.pop(0)
                if top.left:queue.append(top.left)
                if top.right:queue.append(top.right)
                tmp.append(top.val)
            if not seq:result.append(tmp[::-1])
            else:result.append(tmp)
            seq = not seq
        return result
```

