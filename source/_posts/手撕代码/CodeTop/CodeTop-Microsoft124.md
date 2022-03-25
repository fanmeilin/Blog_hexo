---
title: CodeTop_Microsoft124 二叉树的最大路径和
tags: [CodeTop,微软,树]
categories: [CodeTop,微软,树]
date: 2022-03-25 16:04:48
---

> 二叉树的最大路径和

## 题目
路径 被定义为一条从树中任意节点出发，沿父节点-子节点连接，达到任意节点的序列。同一个节点在一条路径序列中 至多出现一次 。该路径 至少包含一个 节点，且不一定经过根节点。

路径和 是路径中各节点值的总和。

给你一个二叉树的根节点 root ，返回其 最大路径和 。

### 示例 1：

![](https://picture.mulindya.com/Aleetcode/CodeTop124-1.png)

```
输入：root = [1,2,3]
输出：6
解释：最优路径是 2 -> 1 -> 3 ，路径和为 2 + 1 + 3 = 6
```

### 示例 2：

![](https://picture.mulindya.com/Aleetcode/CodeTop124-2.png)

```
输入：root = [-10,9,20,null,null,15,7]
输出：42
解释：最优路径是 15 -> 20 -> 7 ，路径和为 15 + 20 + 7 = 42
```

### 提示：

- 树中节点数目范围是 [1, 3 * 104]
- -1000 <= Node.val <= 1000

## 题解

使用后序遍历和递归，同时剪枝。和最大子序列和类似，只是把数组换成了树的形式。所以要注意到后序遍历。

```python
class Solution:
    def maxPathSum(self, root: Optional[TreeNode]) -> int:
        # def getMax(root): #更新节点的值，设置为包含该节点的情况下的最优路径和
        #     if not root:return 0
        #     leftsum = root.left.val if root.left else 0 
        #     rightsum = root.right.val if root.right else 0
        #     # print(root.val, max(root.val,root.val+leftsum,root.val+rightsum,root.val+leftsum+rightsum))
        #     if self.result<(root.val+leftsum+rightsum):  self.result = (root.val+leftsum+rightsum)
        #     root.val =  max(root.val,root.val+leftsum,root.val+rightsum)
        #     return root.val

        # def backdfs(root):
        #     if not root: return
        #     backdfs(root.left)
        #     backdfs(root.right)
        #     ret = getMax(root)
        #     if self.result<ret: self.result = ret
        def getMax(root): #更新节点的值，设置为包含该节点的情况下的最优路径和
            if not root:return 0
            leftsum = max(getMax(root.left),0) #剪枝
            rightsum = max(getMax(root.right),0)
            if self.result<(root.val+leftsum+rightsum):  self.result = (root.val+leftsum+rightsum) #以该节点位根节点的双边判断来更新result
            return root.val + max(leftsum,rightsum) #返回包含该节点的单边
        if not root: return 0
        self.result = -1000
        getMax(root)
        return self.result
```

> max( x, y, z, .... )可以填入多个值

##### 对比

数组的最大子序列和

```python
class Solution:
    def maxSubArray(self, nums: List[int]) -> int:
        #贪心算法1
        tempsum, tempmax, result= 0, -10000, 0
        for item in nums:
            if item>tempmax:tempmax = item
            tempsum += item
            if tempsum<0: tempsum = 0 #剪枝
            if result<tempsum:result = tempsum
        return result if result>0 else tempmax
```

设置tempsum为包含当前元素的最大连续子序列和，使用result来更新最大的子序列和，初始化为数组的第一个元素。

```python
class Solution:
    def maxSubArray(self, nums: List[int]) -> int:
        #贪心算法2
        tempsum, result = 0, nums[0]
        for item in nums:
            tempsum = tempsum+item if tempsum+item>item else item  
            if result<tempsum:result = tempsum
        return result
```

