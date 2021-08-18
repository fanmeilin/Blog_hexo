---
title: 剑指offer28 对称的二叉树
tags: [剑指,树]
categories: [剑指,树]
date: 2021-08-18 17:58:39
---

>对称的二叉树

## 题目
请实现一个函数，用来判断一棵二叉树是不是对称的。如果一棵二叉树和它的镜像一样，那么它是对称的。

例如，二叉树 [1,2,2,3,4,4,3] 是对称的。

    1
   / \
  2   2
 / \ / \
3  4 4  3
但是下面这个 [1,2,2,null,3,null,3] 则不是镜像对称的:

    1
   / \
  2   2
   \   \
   3    3

### 示例 1：

```
输入：root = [1,2,2,3,4,4,3]
输出：true
```

### 示例 2：

```
输入：root = [1,2,2,null,3,null,3]
输出：false
```

### 提示：

- 0 <= 节点个数 <= 1000

## 题解

如果root为空就直接返回True，然后判断其左右子树是否为镜像结构。如果两个子节点为空则为真，如果一空则为假，然后分别判断其对称结构。 `judge(A.left,B.right) and judge(A.right,B.left)` 注意是镜像因此左右时相反的呢

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    def isSymmetric(self, root: TreeNode) -> bool:
        if not root: return True
        def judge(A,B):
            if not (A or B): return True
            if not (A and B) or (A.val!=B.val): return False
            return judge(A.left,B.right) and judge(A.right,B.left) 
        return judge(root.left,root.right)
```

