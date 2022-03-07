---
title: 剑指offer07 重建二叉树
tags: [剑指,树]
categories: [剑指,树]
date: 2021-08-17 20:59:06
---

>重建二叉树

## 题目
输入某二叉树的前序遍历和中序遍历的结果，请构建该二叉树并返回其根节点。

假设输入的前序遍历和中序遍历的结果中都不含重复的数字。

### 示例 1：

![img](https://picture.mulindya.com/leetcode-offer07-tree.jpg)

```
Input: preorder = [3,9,20,15,7], inorder = [9,3,15,20,7]
Output: [3,9,20,null,null,15,7]
```

### 示例 2：

```
Input: preorder = [-1], inorder = [-1]
Output: [-1]
```

### 提示：

- 0 <= 节点个数 <= 5000

## 题解

使用闭包函数，构建对应区域的树，返回根节点。关键步骤是查找到rootindex在中序遍历中的位置，然后分别构建对应的子树。在查找时可以先建立哈希表，使用字典和枚举结合构建flag `flag = {ele:i for i,ele in enumerate(inorder)}`。可以减少执行时间的开销。

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    def buildTree(self, preorder: List[int], inorder: List[int]) -> TreeNode:
        def func(rootindex,ins,ine):
            if(ins>ine): return None
            root = TreeNode(preorder[rootindex])
            # t = ins
            # while(inorder[t]!=preorder[rootindex]):t+=1
            t = flag[preorder[rootindex]]
            root.left = func(rootindex+1,ins,t-1)
            root.right = func(rootindex+t-ins+1,t+1,ine)
            return root
        # 构建哈希表 在查找时更方便
        flag = {ele:i for i,ele in enumerate(inorder)} #使用字典构建
        root = func(0,0,len(inorder)-1)
        return root
```

