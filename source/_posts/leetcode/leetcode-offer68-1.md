---
title: 剑指offer68-1 二叉搜索树的最近公共祖先
tags: [剑指,树]
categories: [剑指,树]
date: 2022-02-06 21:54:24
---

>二叉搜索树的最近公共祖先

## 题目

给定一个二叉搜索树, 找到该树中两个指定节点的最近公共祖先。

百度百科中最近公共祖先的定义为：“对于有根树 T 的两个结点 p、q，最近公共祖先表示为一个结点 x，满足 x 是 p、q 的祖先且 x 的深度尽可能大（一个节点也可以是它自己的祖先）。”

例如，给定如下二叉搜索树:  root = [6,2,8,0,4,7,9,null,null,3,5]

```
    6
  /   \ 
 2     8
/ \   / \
0  4  7  9
```

### 示例 1：

```
输入: root = [6,2,8,0,4,7,9,null,null,3,5], p = 2, q = 8
输出: 6 
解释: 节点 2 和节点 8 的最近公共祖先是 6。
```

### 示例 2：

```
输入: root = [6,2,8,0,4,7,9,null,null,3,5], p = 2, q = 4
输出: 2
解释: 节点 2 和节点 4 的最近公共祖先是 2, 因为根据定义最近公共祖先节点可以为节点本身。
```

### 提示：

- 所有节点的值都是唯一的。
- p、q 为不同节点且均存在于给定的二叉搜索树中。

## 题解

这里是二叉搜索树，只需要这两个节点在左右即可，如果两个在左子树就搜索左子树，如果两个节点在右子树就搜索右子树。只用根据大小比较即可。

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None
```

- 定义闭包函数来查找root。

```python
class Solution:
    def lowestCommonAncestor(self, root: 'TreeNode', p: 'TreeNode', q: 'TreeNode') -> 'TreeNode':
        x,y = p.val,q.val
        if x>y:
            x,y = y,x
        self.parent = 0
        self.find = False
        def func(root):
            if not root or self.find:return
            if (root.val==x or root.val==y) or (x<root.val and y>root.val):
                self.parent = root
                self.find = True
                return 
            print()
            if x>root.val:func(root.right)
            else:func(root.left)
        func(root)
        return self.parent
```

- 直接使用递归

```python
class Solution:
    def lowestCommonAncestor(self, root: 'TreeNode', p: 'TreeNode', q: 'TreeNode') -> 'TreeNode':
        if root.val < p.val and root.val < q.val:
            return self.lowestCommonAncestor(root.right, p, q)
        if root.val > p.val and root.val > q.val:
            return self.lowestCommonAncestor(root.left, p, q)
        return root
```

- 使用循环函数

```python
class Solution:
    def lowestCommonAncestor(self, root: 'TreeNode', p: 'TreeNode', q: 'TreeNode') -> 'TreeNode':
        if p.val > q.val: p, q = q, p # 保证 p.val < q.val
        while root:
            if root.val < p.val: # p,q 都在 root 的右子树中
                root = root.right # 遍历至右子节点
            elif root.val > q.val: # p,q 都在 root 的左子树中
                root = root.left # 遍历至左子节点
            else: break
        return root
```

