---
title: 剑指offer27 二叉树的镜像
tags: [剑指,树]
categories: [剑指,树]
date: 2021-08-16 21:01:18
---

>二叉树的镜像

## 题目

请完成一个函数，输入一个二叉树，该函数输出它的镜像。

例如输入：

​     4
  2     7
1   3  6   9
镜像输出：

​     4
  7     2
9   6 3   1

### 示例 1：

```
输入：root = [4,2,7,1,3,6,9]
输出：[4,7,2,9,6,3,1]
```

### 提示：

- 0 <= 节点个数 <= 1000

## 题解

如果为空树就返回空。然后保存左子树，翻转右子树后赋值为左节点，翻转左子树赋值为右节点。

**if not(root.left or root.right): return root #为单一节点就直接返回 可以省略，因为已经包含在内**

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    def mirrorTree(self, root: TreeNode) -> TreeNode:
        if not(root): return None
        x = root.left
        root.left = self.mirrorTree(root.right)
        root.right = self.mirrorTree(x)
        return root
```

