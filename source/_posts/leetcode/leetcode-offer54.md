---
title: 剑指offer54 二叉搜索树的第k大节点
tags: [剑指,树]
categories: [剑指,树]
date: 2022-02-04 18:31:45
---

>二叉搜索树的第k大节点

## 题目

给定一棵二叉搜索树，请找出其中第 `k` 大的节点的值。

### 示例 1：

```
输入: root = [3,1,4,null,2], k = 1
   3
  / \
 1   4
  \
   2
输出: 4
```

### 示例 2：

```
输入: root = [5,3,6,2,4,null,null,1], k = 3
       5
      / \
     3   6
    / \
   2   4
  /
 1
输出: 4
```

### 提示：

- 1 ≤ k ≤ 二叉搜索树元素个数 

## 题解

按照中序遍历可以得到二叉搜索树的顺序的序列，这里用全局遍历res来记录序号，因为这里是第K大因此是先遍历右子树再遍历左子树。

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    def kthLargest(self, root: TreeNode, k: int) -> int:
        self.res = 0

        def funcMid(root):
            if not root or self.res>=k :return
            funcMid(root.right)
            self.res += 1
            if self.res==k:self.result = root.val
            funcMid(root.left)
        #中序遍历 得到有顺序的序列
        
        self.result = 0
        funcMid(root)
        return self.result
```

