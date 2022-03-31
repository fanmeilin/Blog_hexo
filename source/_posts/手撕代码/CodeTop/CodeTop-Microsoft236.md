---
title: CodeTop_Microsoft236 二叉树的最近公共祖先
tags: [CodeTop,微软,树]
categories: [CodeTop,微软,树]
date: 2022-03-29 09:59:33
---

>二叉树的最近公共祖先
>
>可以对比[二叉搜索树的最近公共祖先]( https://www.mulindya.com/2022/02/06/%E6%89%8B%E6%92%95%E4%BB%A3%E7%A0%81/leetcode/leetcode-offer68-1/)

## 题目

给定一个二叉树, 找到该树中两个指定节点的最近公共祖先。

百度百科中最近公共祖先的定义为：“对于有根树 T 的两个节点 p、q，最近公共祖先表示为一个节点 x，满足 x 是 p、q 的祖先且 x 的深度尽可能大（一个节点也可以是它自己的祖先）。”

### 示例 1：

![](https://picture.mulindya.com/Aleetcode/CodeTop236-1.png)

```
输入：root = [3,5,1,6,2,0,8,null,null,7,4], p = 5, q = 1
输出：3
解释：节点 5 和节点 1 的最近公共祖先是节点 3 。
```

### 示例 2：

![](https://picture.mulindya.com/Aleetcode/CodeTop236-2.png)

```
输入：root = [3,5,1,6,2,0,8,null,null,7,4], p = 5, q = 4
输出：5
解释：节点 5 和节点 4 的最近公共祖先是节点 5 。因为根据定义最近公共祖先节点可以为节点本身。
```

### 示例3：

```
输入：root = [1,2], p = 1, q = 2
输出：1
```

### 提示：

- 树中节点数目在范围 [2, 105] 内。
- -109 <= Node.val <= 109
- 所有 Node.val 互不相同 。
- p != q
- p 和 q 均存在于给定的二叉树中。

## 题解

如果两个节点分别在根节点root的左右子树中，则该节点就是最近公共祖先。先序遍历的思想来递归：

- 该节点为p或者q就返回该节点（根节点本身为其中一个），如果为空节点也返回空。

- 如果不是根节点，就查找左右子树是否存在最近公共祖先。

  - 左子树返回为空就说明最近公共祖先在右子树中

  - 右子树返回为空就说明最近公共祖先在左子树中
  - 左右子树都不为空说明左右子树中不存在最近公共祖先，说明该根节点即为最近公共祖先

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    def lowestCommonAncestor(self, root: 'TreeNode', p: 'TreeNode', q: 'TreeNode') -> 'TreeNode':
        if not root or q==root or p==root: return root #pq有一个是该节点 返回该节点
        left = self.lowestCommonAncestor(root.left,p,q) #查找公共祖先是否存在于左子树中
        right = self.lowestCommonAncestor(root.right,p,q) #查找公共祖先是否存在于右子树中
        if not left: return right
        if not right: return left
        return root
```

### 类比

最小搜索树中查找无需考虑空节点的情况是因为按照规律查找不会碰到空节点回溯，因此也可以用循环遍历。

```python
class Solution:
    def lowestCommonAncestor(self, root: 'TreeNode', p: 'TreeNode', q: 'TreeNode') -> 'TreeNode':
        if root.val < p.val and root.val < q.val:
            return self.lowestCommonAncestor(root.right, p, q)
        if root.val > p.val and root.val > q.val:
            return self.lowestCommonAncestor(root.left, p, q)
        return root
```

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

