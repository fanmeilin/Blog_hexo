---
title: 剑指offer57-2 和为s的连续正数序列
tags: [剑指,滑动窗口]
categories: [剑指,滑动窗口]
date: 2021-12-30 13:08:25
---

> 和为s的连续正数序列

## 题目
输入一个正整数 target ，输出所有和为 target 的连续正整数序列（至少含有两个数）。

序列内的数字由小到大排列，不同序列按照首个数字从小到大排列。


### 示例 1：

```
输入：target = 9
输出：[[2,3,4],[4,5]]
```

### 示例 2：

```
输入：target = 15
输出：[[1,2,3,4,5],[4,5,6],[7,8]]
```

### 提示：

- 1 <= target <= 10^5

## 题解

### 遍历解法
从1到`target//2`为首遍历是否存在连续的序列为target。使用两层循环，外层循环确定首元素，内层循环确定尾元素，如果遍历到的和大于target就终止；
```python
class Solution:
    def findContinuousSequence(self, target: int) -> List[List[int]]:
        limit = int(target/2)
        result = []
        for head in range(1,limit+1):
            temp,t,sumt = [head],head+1,head
            while(1):
                sumt += t
                temp.append(t)  
                if sumt==target:
                    result.append(temp)
                    break
                if sumt>target: break
                if sumt<target: t += 1
        return result

```
### 滑动窗口
使用滑动窗口来确定序列首尾位置；
在这里i，j分别表示首尾元素；
- 序列元素和sumt小于target，就右移j；
- 序列元素和大于target，就右移i；

这里不存在左移的情况，不左移i好理解，因为i是从头开始查找的嘛，左移不是重复了嘛，何况还要保证首元素的顺序；那么不左移j的原因是什么呢。也是同样的道理，这个窗口只是负责尾节点右移扩大和首节点右移缩小，是可以遍历所有的情况哒。比如`1,2,3,4,5...`,target为5，开始就会到`1,2,3`,然后再到`2,3`;即尾节点只负责增大序列和，首节点只负责缩小序列和。:wink:
```python
class Solution:
    def findContinuousSequence(self, target: int) -> List[List[int]]:
        #滑动窗口
        i,j,sumt,result = 1,1,1,[]
        while(i<=target//2):
            if(sumt<target):
                j += 1
                sumt += j
                continue
            if(sumt==target):result.append(list(range(i,j+1))) #需要list转换
            sumt -= i
            i += 1
        return result
```

