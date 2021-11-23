---
title: 剑指offer32-3 从上到下打印二叉树 Ⅲ
tags: [剑指,树]
categories: [剑指,树]
date: 2021-11-22 20:15:15
---

>从上到下打印二叉树 Ⅲ

## 题目

请实现一个函数按照之字形顺序打印二叉树，即第一行按照从左到右的顺序打印，第二层按照从右到左的顺序打印，第三行再按照从左到右的顺序打印，其他行以此类推。

### 示例 1：

例如:
给定二叉树: `[3,9,20,null,null,15,7]`,

```
    3
   / \
  9  20
    /  \
   15   7
```

返回其层次遍历结果：

```
[
  [3],
  [20,9],
  [15,7]
]
```

### 提示：

- `节点总数 <= 1000`

## 题解

#### 解法一

记录本层的数字个数，将本层的元素全部弹出到列表中，同时将下层元素压进队列中；只是要根据flag，来将列表倒序 。

> 列表倒叙的方法：
>
> 1，temp.reverse()  直接原地修改哦~
>
> 2，temp = temp[::-1]

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    def levelOrder(self, root: TreeNode) -> List[List[int]]:
        if(not root):return []
        queue ,result,flag = deque(),[],False
        queue.append(root)
        while(queue):
            tmp = []
            num = len(queue)
            for i in range(num):
                top = queue.popleft()
                tmp.append(top.val)
                if(top.left): queue.append(top.left)
                if(top.right): queue.append(top.right)
            if flag: tmp = tmp[::-1] #tmp.reverse() # tmp = tmp[::-1]
            flag = not flag
            result.append(list(tmp))
        return result
```

#### 解法二

去掉倒叙的操作，根据flag的值更改tmp的插入方向，将tmp声明为`deque()`，右插为`append`,左插为`appendleft`；

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    def levelOrder(self, root: TreeNode) -> List[List[int]]:
        if(not root):return []
        queue ,result,flag = deque(),[],False
        queue.append(root)
        while(queue):
            tmp = deque()
            num = len(queue)
            for i in range(num):
                top = queue.popleft()
                if flag: tmp.appendleft(top.val)
                else:tmp.append(top.val)
                if(top.left): queue.append(top.left)
                if(top.right): queue.append(top.right)
            flag = not flag
            result.append(list(tmp))
        return result
```

