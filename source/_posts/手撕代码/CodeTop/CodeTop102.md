---
title: CodeTop102
tags: [CodeTop,树]
categories: [CodeTop,树]
date: 2022-06-13 14:54:15
---

> 二叉树的层序遍历

## 题目
给你二叉树的根节点 root ，返回其节点值的 层序遍历 。 （即逐层地，从左到右访问所有节点）。


### 示例 1：

```
输入：root = [3,9,20,null,null,15,7]
输出：[[3],[9,20],[15,7]]
```

### 示例 2：

```
输入：root = [1]
输出：[[1]]
```
### 示例 3：

```
输入：root = []
输出：[]
```
### 提示：

- 树中节点数目在范围 [0, 2000] 内
- -1000 <= Node.val <= 1000

## 题解

层序遍历标配队列。
这里需要按照每一层创建数组，将队列元素append到数组中直到队列为空，那么这一层的数据则记录完整。

```python
class Solution:
    def levelOrder(self, root: TreeNode) -> List[List[int]]:
        if not root: return[]
        queue,result = [],[]
        queue.append(root)
        while queue:
            tmp,nextlayer = [],[]
            while queue:
                top = queue.pop(0)
                tmp.append(top.val)
                if top.left:nextlayer.append(top.left)
                if top.right:nextlayer.append(top.right)
            queue = nextlayer
            result.append(tmp)
        return result
```

