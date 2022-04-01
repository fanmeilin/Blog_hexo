---
title: CodeTop_Microsoft106 从中序与后序遍历序列构造二叉树
tags: [CodeTop,微软,树]
categories: [CodeTop,微软,树]
date: 2022-04-01 09:38:02
---

>[从中序与后序遍历序列构造二叉树](https://leetcode-cn.com/problems/construct-binary-tree-from-inorder-and-postorder-traversal/)

## 题目

给定两个整数数组 inorder 和 postorder ，其中 inorder 是二叉树的中序遍历， postorder 是同一棵树的后序遍历，请你构造并返回这颗 二叉树 。

### 示例 1：

```
输入：inorder = [9,3,15,20,7], postorder = [9,15,7,20,3]
输出：[3,9,20,null,null,15,7]
```

### 示例 2：

```
输入：inorder = [-1], postorder = [-1]
输出：[-1]
```

### 提示：

- 1 <= inorder.length <= 3000
- postorder.length == inorder.length
- -3000 <= inorder[i], postorder[i] <= 3000
- inorder 和 postorder 都由 不同 的值组成
- postorder 中每一个值都在 inorder 中
- inorder 保证是树的中序遍历
- postorder 保证是树的后序遍历

## 题解

根据后序遍历中的节点定位根节点，在中序遍历序列查找该节点，以此可知左右子树的个数。从而确定后序序列中相应的左右子树的区间来递归左右子树根节点。

建立根节点，递归左子树和右子树返回左右子树根节点，返回根节点。

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
class Solution:
    def buildTree(self, inorder: List[int], postorder: List[int]) -> TreeNode:
        def buildfunc(posindex,start,end):
            if start>end: return None
            root = TreeNode(postorder[posindex])
            index = inorder.index(postorder[posindex],start,end+1)
            root.left = buildfunc(posindex-(end-index+1),start,index-1)
            root.right =  buildfunc(posindex-1,index+1,end)
            return root
        return buildfunc(len(postorder)-1,0,len(inorder)-1)
```

