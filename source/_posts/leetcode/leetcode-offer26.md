---
title: 剑指offer26 树的子结构
tags: [剑指,树,idea]
categories: [剑指,树]
date: 2021-08-18 17:13:56
---

> 树的子结构

## 题目
输入两棵二叉树A和B，判断B是不是A的子结构。(约定空树不是任意一个树的子结构)
B是A的子结构， 即 A中有出现和B相同的结构和节点值。

例如:
给定的树 A:

     3
    / \
   4   5
  / \
 1   2
给定的树 B：

   4 
  /
 1
返回 true，因为 B 与 A 的一个子树拥有相同的结构和节点值。

### 示例 1：

```
输入：A = [1,2,3], B = [3,1]
输出：false
```

### 示例 2：

```
输入：A = [3,4,5,1,2], B = [4,1]
输出：true
```

### 提示：

- 0 <= 节点个数 <= 10000

## 题解

python代码真的！好！简洁！

`isSubStructure`的作用是先序查找A，B的匹配情况。而在内部会对匹配的`judgechildren(A,B)`进行判断，查看是否为其子结构。

如果B为空了则表示匹配成功。如果根节点不匹配或者A为空了就直接返回失败。如果可以继续判断，就继续判断对应的左右子树。

`(judgechildren(A,B) or self.isSubStructure(A.left,B) or self.isSubStructure(A.right,B))` 判断AB两子树；先序判断左右子树，`注意这里是self.isSubStructure`进行递归哦~~

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    def isSubStructure(self, A: TreeNode, B: TreeNode) -> bool:
        def judgechildren(A,B): #判断以AB为根节点的条件下，B是否为A的子结构
            if not(B): return True
            if (not A) or (A.val!=B.val): return False
            return judgechildren(A.right,B.right) and judgechildren(A.left,B.left)
        return bool(A and B) and (judgechildren(A,B) or self.isSubStructure(A.left,B) or self.isSubStructure(A.right,B))
```

> bool(A and B)注意要转换为bool变量

- 时间复杂度为O(MN)

- 空间复杂度 O(M)： 当树 A和树 B 都退化为链表时，递归调用深度最大。当 M≤N 时，遍历树 A 与递归判断的总递归深度为 M ；当 M>N 时，最差情况为遍历至树 A叶子节点，此时总递归深度为 M。


