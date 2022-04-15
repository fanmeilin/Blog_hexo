---
title: CodeTop_Microsoft450 删除二叉搜索树中的节点
tags: [CodeTop,微软,树]
categories: [CodeTop,微软,树]
date: 2022-04-12 10:21:46
---

>删除二叉搜索树中的节点
>https://leetcode-cn.com/problems/delete-node-in-a-bst/

## 题目

给定一个二叉搜索树的根节点 root 和一个值 key，删除二叉搜索树中的 key 对应的节点，并保证二叉搜索树的性质不变。返回二叉搜索树（有可能被更新）的根节点的引用。

一般来说，删除节点可分为两个步骤：

首先找到需要删除的节点；
如果找到了，删除它。

### 示例 1：

![](https://picture.mulindya.com/Aleetcode/leetcode450-1.jpg)

```
输入：root = [5,3,6,2,4,null,7], key = 3
输出：[5,4,6,2,null,null,7]
解释：给定需要删除的节点值是 3，所以我们首先找到 3 这个节点，然后删除它。
一个正确的答案是 [5,4,6,2,null,null,7], 如下图所示。
另一个正确答案是 [5,2,6,null,4,null,7]。
```

### 示例 2：

```
输入: root = [5,3,6,2,4,null,7], key = 0
输出: [5,3,6,2,4,null,7]
解释: 二叉树不包含值为 0 的节点。
```

### 示例 3：

```
输入: root = [], key = 0
输出: []
```

### 提示：

- 节点数的范围 [0, 104].
- -105 <= Node.val <= 105
- 节点值唯一
- root 是合法的二叉搜索树
- -105 <= key <= 105

## 题解

开始的想法是先找到这个节点和他的父节点再进行删除操作，后来发现其实使用递归就好了，返回该子树的根节点；

利用搜索树的性质，搜索待删除的节点，找到后进行删除操作：

- 如果左子树是空，直接将右子树接入

- 如果右子树是空，直接将左子树接入
- 如果两者皆非空，可以选择左子树或者右子树根节点代替该删除节点，需要考虑如果融合左右子树，也就是要**融合左子树的右分支和右子树的左分支**。
  - 选择左子树根节点代替，就意味左子树的右分支需要融合到右子树中，此时右分支应该接入右子树节点的最左侧
  - 选择右子树根节点代替，就意味右子树的左分支需要融合到左子树中，此时左分支应该接入左子树节点的最右侧

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
class Solution:
    def deleteNode(self, root: Optional[TreeNode], key: int) -> Optional[TreeNode]:
        if not root: return None
        if root.val>key: root.left = self.deleteNode(root.left,key) #如果当前节点小于key，就在左子树中找，同时更新左子树
        elif root.val<key: root.right = self.deleteNode(root.right,key) #如果当前节点大于key，就在右子树中找，同时更新右子树
        else:
            if not root.left: return root.right #如果左子树为空树则直接返回右子树
            elif not root.right: return root.left
            else:
                cur = root.right #cur用于找寻右子树的最左侧
                while cur.left:cur = cur.left
                cur.left = root.left.right #将左子树右分支接入右子树中
                root.left.right = root.right #更新左子树的右分支
                return root.left #使用左子树代替删除节点
        return root #返回根节点
```

