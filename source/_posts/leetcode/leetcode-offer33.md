---
title: 剑指offer33
tags: [剑指,树]
categories: [剑指,树]
date: 2021-12-04 21:59:06
---

>二叉搜索树的后续遍历序列

## 题目

输入一个整数数组，判断该数组是不是某二叉搜索树的后序遍历结果。如果是则返回 `true`，否则返回 `false`。假设输入的数组的任意两个数字都互不相同。



参考以下这颗二叉搜索树

```
     5
    / \
   2   6
  / \
 1   3
```

### 示例 1：


```
输入: [1,6,3,2,5]
输出: false
```

### 示例 2：

```
输入: [1,3,2,6,5]
输出: true
```

### 提示：

- `数组长度 <= 1000`

## 题解

采用递归的方式，最后一个元素作为root，找到第一个比root大的值，作为左子树的区域，比较左子树区域的值核对是否大于root即可，然后比较左右子树。

```python
class Solution:
    def verifyPostorder(self, postorder: List[int]) -> bool:
        if(not postorder or len(postorder)==1): return True
        root = postorder[len(postorder)-1]
        result,flag = True,True
        index = len(postorder)-1
        for i,x in enumerate(postorder):
            result = x>=root if not flag and result else result
            # if(not flag and x<root):
            #     result = False
            #     break
            # result = x>root if not flag else True
            if(flag and x>root):
                index = i
                flag = False
        return result and self.verifyPostorder(postorder[:index-1]) and self.verifyPostorder(postorder[index:len(postorder)-1])
```

