---
title: 剑指offer55-2 平衡二叉树
tags: [剑指,树]
categories: [剑指,树]
date: 2022-03-02 16:39:12
---

> 平衡二叉树

## 题目
输入一棵二叉树的根节点，判断该树是不是平衡二叉树。如果某二叉树中任意节点的左右子树的深度相差不超过1，那么它就是一棵平衡二叉树。


### 示例 1：

```
给定二叉树 [3,9,20,null,null,15,7]

    3
   / \
  9  20
    /  \
   15   7
返回 true 。
```

### 示例 2：

```
给定二叉树 [1,2,2,3,3,null,null,4,4]

       1
      / \
     2   2
    / \
   3   3
  / \
 4   4
返回 false 。
```

### 提示：

- `0 <= 树的结点个数 <= 10000`

## 题解

中序遍历的思想得到一棵树的深度为`max(left,right)+1`，首先得到左右子树的深度，在此基础上取最大值加一即为此根的树深度。同时注意剪枝！

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    def isBalanced(self, root: TreeNode) -> bool:
        def func(root): #判断深度，如果子树不平衡就返回-1
            if not root:return 0 #为空时深度为0
            left = func(root.left)
            if left==-1:return -1 #剪枝
            right = func(root.right)
            if right == -1: return -1 #剪枝
            return max(left,right)+1 if abs(left-right)<=1 else -1
        
        if func(root)==-1:return False
        else:return True
```

