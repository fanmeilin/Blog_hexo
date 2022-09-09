---
title: CodeTop46 全排列
tags: [CodeTop,中等]
categories: [CodeTop,中等]
date: 2022-09-09 15:23:59
---

>全排列

## 题目

给定一个不含重复数字的数组 `nums` ，返回其 *所有可能的全排列* 。你可以 **按任意顺序** 返回答案。

### 示例 1：

```
输入：nums = [1,2,3]
输出：[[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]
```

### 示例 2：

```
输入：nums = [0,1]
输出：[[0,1],[1,0]]
```

### 示例 3：

```
输入：nums = [1]
输出：[[1]]
```

### 提示：

- `1 <= nums.length <= 6`
- `-10 <= nums[i] <= 10`
- `nums` 中的所有整数 **互不相同**

## 题解

回溯法

带标记的方法

```python
class Solution:
    def permute(self, nums: List[int]) -> List[List[int]]:
        result, length = [], len(nums)
        def dfs(tmp,visited,depth):
            if depth>length:return
            if depth==length:result.append(tmp)
            for i in range(length):
                if not visited[i]:
                    visited[i] = True
                    dfs(tmp+[nums[i]],visited,depth+1)
                    visited[i] = False
		dfs([],[False for _ in range(length)],0)
        return result
```

更简洁的方法

```python
class Solution:
    def permute(self, nums: List[int]) -> List[List[int]]:
        result = []
        def dfs(nums,tmp): #现存tmp的情况下，对nums全排列
            if not nums: result.append(tmp)
            for i in range(len(nums)):
                dfs(nums[:i]+nums[i+1:],tmp+[nums[i]])
        dfs(nums,[])
        return result
```

