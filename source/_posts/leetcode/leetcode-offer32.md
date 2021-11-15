---
title: 剑指leetcode-offer32-Ⅱ 从上到下打印二叉树Ⅱ
tags: [剑指,队列]
categories: [剑指,队列]
date: 2021-11-12 20:59:54
---

> 从上到下打印二叉树Ⅱ

## 题目
从上到下按层打印二叉树，同一层的节点按从左到右的顺序打印，每一层打印到一行。


### 示例 1：

```
例如:
给定二叉树: [3,9,20,null,null,15,7],
    3
   / \
  9  20
    /  \
   15   7
```



```
返回其层次遍历结果：

[
  [3],
  [9,20],
  [15,7]
]
```

### 提示：

- 节点总数 <= 1000

## 题解

#### 解法一

其实是层序遍历，注意是按照深度标识的层序遍历。在python中是使用deque这个数据结构实现的，是一个双向队列。
在右端输出输出是采用`append` 和`pop`，在左端输入输出采用的是`appendleft`和`popleft`。

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    def levelOrder(self, root: TreeNode) -> List[List[int]]:
        if(not root):
            return []
        x = deque()
        result = []
        temp = []
        depth = -1
        x.append((root,0))
        while(len(x)):
            item = x.popleft()
            if(depth!=-1 and depth!=item[1]):
                result.append(temp)
                temp = []
                # temp.clear() # temp.clear()很危险，append就应该使用result.append(temp.copy()) 因为append进去的是引用格式的 或者重新初始化temp
            temp.append(item[0].val)  
            depth = item[1]
            if item[0].left: x.append((item[0].left,item[1]+1))
            if item[0].right: x.append((item[0].right,item[1]+1))
        if(temp):
            result.append(temp)
        return result

```
python要注意的坑点是在如果将temp加到列表之后，将temp清空，随之list中的列表内容也会清空，相当于说在两个temp是指向同一个地址块，所以需要重新temp初始化，或者在append时使用copy函数进行深拷贝。

#### 解法二

更简便的方法是可以直接把每一轮的输出到result中。
```python
class Solution:
    def levelOrder(self, root: TreeNode) -> List[List[int]]:
        if not root: return []
        res, queue = [], collections.deque()
        queue.append(root)
        while queue:
            tmp = []
            for _ in range(len(queue)):
                node = queue.popleft()
                tmp.append(node.val)
                if node.left: queue.append(node.left)
                if node.right: queue.append(node.right)
            res.append(tmp)
        return res

```
