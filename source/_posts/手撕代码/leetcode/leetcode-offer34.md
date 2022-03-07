---
title: 剑指offer34 二叉树中和为某一值的路径
tags: [剑指,树]
categories: [剑指,树]
date: 2021-12-06 16:50:08
---

>二叉树中和为某一值的路径

## 题目

给你二叉树的根节点 root 和一个整数目标和 targetSum ，找出所有 从根节点到叶子节点 路径总和等于给定目标和的路径。

叶子节点 是指没有子节点的节点。



### 示例 1：

![](https://picture.mulindya.com/leetcode34-1.jpg)

```
输入：root = [5,4,8,11,null,13,4,7,2,null,null,5,1], targetSum = 22
输出：[[5,4,11,2],[5,8,4,5]]
```

### 示例 2：

![](https://picture.mulindya.com/leetcode34-2.jpg)

```
输入：root = [1,2,3], targetSum = 5
输出：[]
```

### 示例4：

```
输入：root = [1,2], targetSum = 0
输出：[]
```

### 提示：

- 树中节点总数在范围 `[0, 5000]` 内
- `-1000 <= Node.val <= 1000`
- `-1000 <= targetSum <= 1000`

## 题解

注存在节点的值是负数，因此**不能按照当前得到的和进行剪枝操作**，另一个需要注意的点是**不能将对象append**，对象的append直接引用的，再后续修改会影响到result的内容，所以可以将其进行copy，深拷贝，或者list实例化一下。

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
class Solution:
    def pathSum(self, root: TreeNode, target: int) -> List[List[int]]:
        if(not root): return []
        result,nowlist = [],[]

        def findPath(root,nowsum):
            # if(not root or (root and root.val + nowsum>target)): return #还存在负数的情况因此不能剪枝
            if(not root): return
            tsum = root.val + nowsum
            nowlist.append(root.val)
            if(not root.left and not root.right and tsum==target):
                result.append(nowlist.copy()) #不能随便将一个对象append进去，后续此对象出现变化，会影响到result
            findPath(root.left,tsum)
            findPath(root.right,tsum)
            nowlist.pop()
               
        findPath(root,0)
        return result
```

