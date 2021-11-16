---
title: 剑指offer55-Ⅰ 二叉树的深度
tags: [剑指,树]
categories:  [剑指,树]
date: 2021-11-16 16:47:38
---

> 二叉树的深度

## 题目

输入一棵二叉树的根节点，求该树的深度。从根节点到叶节点依次经过的节点（含根、叶节点）形成树的一条路径，最长路径的长度为树的深度。

### 示例 1：
例如：

给定二叉树` [3,9,20,null,null,15,7]`,

```
   3
   / \
  9  20
    /  \
   15   7
```
返回它的最大深度 3 。


### 提示：

- 节点总数 <= 10000

## 题解

#### 解法一

直接深度优先遍历即可，直接利用`maxDepth`函数，注意在内部调用`maxDepth`函数时要使用`self`来调用本函数。

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    def maxDepth(self, root: TreeNode) -> int:
        if not root:
            return 0
        return 1 + max(self.maxDepth(root.left),self.maxDepth(root.right))

```
#### 解法二

直接使用层序遍历得到深度。使用两个列表`tmp`和`queue`结合实现“队列”的作用。

```python
class Solution:
    def maxDepth(self, root: TreeNode) -> int:
        if not root: return 0
        queue, res = [root], 0        #使用列表实现queue
        while queue:
            tmp = []                  #初始化 保存一层的信息
            for node in queue:        #将queue的下一层都添加到tmp中
                if node.left: tmp.append(node.left)
                if node.right: tmp.append(node.right)
            queue = tmp               #更新
            res += 1
        return res
```

