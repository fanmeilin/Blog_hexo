---
title: 算法题复习
tags: [CodeTop,bytedance]
categories: [CodeTop,bytedance]
date: 2022-07-06 15:36:47
---

> 记录以下最近的算法笔试题。

### 题目

时间：发表于 2022-05-23

给一个数组,统计数组里面单词出现的频率,不区分大小写,忽略单词空格
Input: strings = ['I','Love','you ','and',' you','love','me']
Output: {'i': 1, 'love': 2, 'you': 2, 'and': 1, 'me': 1}

```python
#如果input为 I Love You and you love me
from sys import stdin
result = {}
strings = stdin.readline().strip().split()
for chars in strings:
    chars = chars.strip().lower()
    if chars in result:result[chars] = 1
    else:result[chars] += 1
return result
```

### 树

#### dfs

##### 二叉树中和为某一值的路径(二)

输入一颗二叉树的根节点root和一个整数expectNumber，找出二叉树中结点值的和为expectNumber的所有路径。

1.该题路径定义为从树的根结点开始往下一直到叶子结点所经过的结点

2.叶子节点是指没有子节点的节点

3.路径只能从父节点到子节点，不能从子节点到父节点

4.总节点数目为n

```python
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None
#
# 代码中的类名、方法名、参数名已经指定，请勿修改，直接返回方法规定的值即可
#
# 
# @param root TreeNode类 
# @param target int整型 
# @return int整型二维数组
#
class Solution:
    def FindPath(self , root: TreeNode, target: int) -> List[List[int]]:
        # write code here
        self.result = []
        def dfs(root,tmppath,tmpsum):
            if not root:return
            if not root.left and not root.right and tmpsum+root.val==target:
                self.result.append(tmppath.copy()+[root.val])
            #if tmpsum+root.val>=target:return #不可 因为题目并没有说明是非负整数
			tmppath.append(root.val)
            tmpsum += root.val
            dfs(root.left,tmppath,tmpsum)
            dfs(root.right,tmppath,tmpsum)
            tmppath.pop()
            tmpsum -= root.val
        dfs(root,[],0)
        return self.result
```

```python
# 简洁写法
class Solution:
    def FindPath(self , root: TreeNode, target: int) -> List[List[int]]:
        # write code here
        res, path = [], [] #可以直接定义全局变量
        def recur(root, tar):
            if not root: return
            path.append(root.val) #在闭包内直接修改
            tar -= root.val #使用减法代替加法判断避免使用临时变量tmpsum
            if tar == 0 and not root.left and not root.right:
                res.append(list(path)) #list初始化列表 避免覆盖
            recur(root.left, tar)
            recur(root.right, tar)
            path.pop()
        recur(root,target)
        return res
```

#### 二分法，模拟

##### 第N位数字(中等)

最近考察时间2022-06-08

给你一个整数 `n` ，请你在无限的整数序列 `[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, ...]` 中找出并返回第 `n` 位上的数字。

###### 示例：

```
输入：n = 11
输出：0
解释：第 11 位数字在序列 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, ... 里是 0 ，它是 10 的一部分。
```

```python
# 直接找到n存在的位数 d
class Solution:
    def findNthDigit(self, n: int) -> int:
        d, count = 1, 9
        while n > d * count: #计算位数区域 1-9,10-99,100-999对应各位的总数9,90,900
            n -= d * count
            d += 1
            count *= 10
        index = n - 1
        start = 10 ** (d - 1)
        num = start + index // d #得到数字
        digitIndex = index % d
        return int(str(num)[digitIndex])    #num // 10 ** (d - digitIndex - 1) % 10
        
# 二分法
class Solution:
    def totalDigits(self, length: int) -> int:
        digits = 0
        curCount = 9
        for curLength in range(1, length + 1):
            digits += curLength * curCount
            curCount *= 10
        return digits

    def findNthDigit(self, n: int) -> int:
        low, high = 1, 9
        while low < high: #找到对应的位数d
            mid = (low + high) // 2
            if self.totalDigits(mid) < n: #mid时数字的总数
                low = mid + 1
            else:
                high = mid
        d = low
        prevDigits = self.totalDigits(d - 1)
        index = n - prevDigits - 1 # 在d位数的区间的index个数
        start = 10 ** (d - 1)
        num = start + index // d
        digitIndex = index % d
        return num // 10 ** (d - digitIndex - 1) % 10
```



