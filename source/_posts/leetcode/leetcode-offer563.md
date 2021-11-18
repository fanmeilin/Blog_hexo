---
title: 剑指offerleetcode-offer563 二叉树的坡度
tags: [剑指,树]
categories: [剑指,树]
date: 2021-11-18 15:06:37
---

> 二叉树的坡度

## 题目

给定一个二叉树，计算 整个树 的坡度 。
一个树的 节点的坡度 定义即为，该节点左子树的节点之和和右子树节点之和的 差的绝对值 。如果没有左子树的话，左子树的节点之和为 0 ；没有右子树的话也是一样。空结点的坡度是 0 。

整个树 的坡度就是其所有节点的坡度之和。

### 示例 1：

![img](https://assets.leetcode.com/uploads/2020/10/20/tilt1.jpg)



```
输入：root = [1,2,3]
输出：1
解释：
节点 2 的坡度：|0-0| = 0（没有子节点）
节点 3 的坡度：|0-0| = 0（没有子节点）
节点 1 的坡度：|2-3| = 1（左子树就是左子节点，所以和是 2 ；右子树就是右子节点，所以和是 3 ）
坡度总和：0 + 0 + 1 = 1

```

### 示例 2：

![img](https://assets.leetcode.com/uploads/2020/10/20/tilt1.jpg)



```
输入：root = [4,2,9,3,5,null,7]
输出：15
解释：
节点 3 的坡度：|0-0| = 0（没有子节点）
节点 5 的坡度：|0-0| = 0（没有子节点）
节点 7 的坡度：|0-0| = 0（没有子节点）
节点 2 的坡度：|3-5| = 2（左子树就是左子节点，所以和是 3 ；右子树就是右子节点，所以和是 5 ）
节点 9 的坡度：|0-7| = 7（没有左子树，所以和是 0 ；右子树正好是右子节点，所以和是 7 ）
节点 4 的坡度：|(3+5+2)-(9+7)| = |10-16| = 6（左子树值为 3、5 和 2 ，和是 10 ；右子树值为 9 和 7 ，和是 16 ）
坡度总和：0 + 0 + 0 + 2 + 7 + 6 = 15


```

### 示例 3：

![img](https://assets.leetcode.com/uploads/2020/10/20/tilt3.jpg)

```
输入：root = [21,7,14,1,1,2,2,3,3]
输出：9
```

### 提示：

- 树中节点数目的范围在 `[0, 104]` 内
- `-1000 <= Node.val <= 1000`

## 题解

可以使用两个函数，一个计算树的各个节点的子树之和，一个用于计算对应的差值之和。在计算子树之和时可以直接用后序遍历，**更新节点的val值为子树和**。此时的时间复杂度为O(2N)。

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
class Solution:
    def findTilt(self, root: TreeNode) -> int:
        def setaddTree(root): #后序遍历
            if(not root):return 
            setaddTree(root.left)
            setaddTree(root.right)
            Tleft = root.left.val if root.left else 0
            Tright = root.right.val if root.right else 0
            root.val = root.val + Tleft + Tright
        def minasTree(root):
            if(not root): return 
            Tleft = root.left.val if root.left else 0
            Tright = root.right.val if root.right else 0
            self.sumResult += abs(Tleft - Tright)
            minasTree(root.left)
            minasTree(root.right)
        self.sumResult = 0
        setaddTree(root)
        minasTree(root)
        return self.sumResult
```

实际上无需两个函数，**在后序遍历求和的时候就可以得到子树的差值**，将其累加即可。时间复杂度为O(N)，空间复杂度为O(1)。

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
class Solution:
    def findTilt(self, root: TreeNode) -> int:
        def setaddTree(root): #后序遍历
            if(not root):return 
            setaddTree(root.left)
            setaddTree(root.right)
            Tleft = root.left.val if root.left else 0
            Tright = root.right.val if root.right else 0
            root.val = root.val + Tleft + Tright
            self.sumResult += abs(Tleft - Tright)

        self.sumResult = 0
        setaddTree(root)
        return self.sumResult
```

