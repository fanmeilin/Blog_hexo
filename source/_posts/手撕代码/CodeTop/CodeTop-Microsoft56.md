---
title: CodeTop_Microsoft56 合并区间
tags: [CodeTop,微软]
categories: [CodeTop,微软]
date: 2022-03-08 16:04:41
---

>合并区间

## 题目

以数组 intervals 表示若干个区间的集合，其中单个区间为 intervals[i] = [starti, endi] 。请你合并所有重叠的区间，并返回 一个不重叠的区间数组，该数组需恰好覆盖输入中的所有区间 。

### 示例 1：

```
输入：intervals = [[1,3],[2,6],[8,10],[15,18]]
输出：[[1,6],[8,10],[15,18]]
解释：区间 [1,3] 和 [2,6] 重叠, 将它们合并为 [1,6].
```

### 示例 2：

```
输入：intervals = [[1,4],[4,5]]
输出：[[1,5]]
解释：区间 [1,4] 和 [4,5] 可被视为重叠区间。
```

### 提示：

- 1 <= intervals.length <= 104
- intervals[i].length == 2
- 0 <= starti <= endi <= 104

## 题解

首先对list排序（根据每个间隔的start）然后使用双指针判断是否合并区间即可。使用`key=lambda x:x[0]`来指定排序的根据。

```python
class Solution:
    def merge(self, intervals: List[List[int]]) -> List[List[int]]:
        intervals = sorted(intervals,key=lambda x:x[0])
        result = []
        start,end = intervals[0] #可以直接赋值到两个变量
        for item in intervals:
            if item[0]<=end and item[1]>end:
                end = item[1]
            elif item[0]>end:
                result.append([start,end])
                start,end = item[0],item[1]
        result.append([start,end])
        return result
```

