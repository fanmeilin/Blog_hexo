---
title: CodeTop239 滑动窗口最大值
tags: [CodeTop,困难]
categories: [CodeTop,困难]
date: 2022-09-21 14:58:16
---

>滑动窗口最大值

## 题目

给你一个整数数组 nums，有一个大小为 k 的滑动窗口从数组的最左侧移动到数组的最右侧。你只可以看到在滑动窗口内的 k 个数字。滑动窗口每次只向右移动一位。

返回 滑动窗口中的最大值 。

### 示例 1：

```
输入：nums = [1,3,-1,-3,5,3,6,7], k = 3
输出：[3,3,5,5,6,7]
解释：
滑动窗口的位置                最大值
---------------               -----
[1  3  -1] -3  5  3  6  7       3
 1 [3  -1  -3] 5  3  6  7       3
 1  3 [-1  -3  5] 3  6  7       5
 1  3  -1 [-3  5  3] 6  7       5
 1  3  -1  -3 [5  3  6] 7       6
 1  3  -1  -3  5 [3  6  7]      7
```

### 示例 2：

```
输入：nums = [1], k = 1
输出：[1]
```

### 提示：

- `1 <= nums.length <= 105`
- `-104 <= nums[i] <= 104`
- `1 <= k <= nums.length`

## 题解

如果直接遍历元素找最大值那么就需要O((n-k+1)*k)，即O(nk)会超出时间限制。

### 优先队列

通过优先队列维护滑动窗口，每次取最大值，但是要对最大值的下标进行核对，确保在当前的滑动窗口中，如果不存在，那么直接pop继续搜索。

```python
class Solution:
    def maxSlidingWindow(self, nums: List[int], k: int) -> List[int]:
        q = [(-nums[i],i) for i in range(k)]  #默认小顶堆，因此使用相反数
        heapq.heapify(q)
        result = [-q[0][0]]
        for i in range(k,len(nums)): 
            heapq.heappush(q,(-nums[i],i))
            while q[0][1]<i-k+1:heapq.heappop(q)
            result.append(-q[0][0])
        return result
```

> 如何不pop获取堆顶元素呢？ 直接可以通过q\[0]就可以。

- 时间复杂度：此时如果nums中的元素是单调递增的话，最终优先队列中包含了所有的元素，将一个元素发入优先队列的时间复杂度为O(logn)，因此总时间复杂度为O(nlogn).

- 空间复杂度：O(n)，优先队列需要的空间。

### 双端队列

双端队列，队列中存下标，对应数字在队列中从大到小递减，对于新元素，从后向前挤出元素，淘汰那些比新元素早还小的元素

```python
class Solution:
    def maxSlidingWindow(self, nums: List[int], k: int) -> List[int]:
        q = collections.deque()
        for i in range(k):  
            while q and nums[i]>=nums[q[-1]]:q.pop()
            q.append(i)
        result = [nums[q[0]]]
        for i in range(k,len(nums)):
            while q and nums[i]>=nums[q[-1]]:q.pop()
            q.append(i)
            while q[0] < i-k+1: q.popleft()
            result.append(nums[q[0]])
        return result
```

每个元素都会压入一次，压到他合适的位置（递减）；

每个元素都会弹出一次，要么是在压入新元素的时候被弹出，要么实在选择最大值作为滑动窗口的时候被弹出

- 时间复杂度为O(n)，其中 n 是数组 nums 的长度。每一个下标恰好被放入队列一次，并且最多被弹出队列一次，因此时间复杂度为 O(n)。

- 空间复杂度为O(K)，这里每次的压入选择最大值这两个操作都会保证双端队列的元素不会超过k+1,因此使用空间为O(k).

