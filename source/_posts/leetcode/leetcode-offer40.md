---
title: 剑指offer40 最小的k个数
tags: [剑指,快速排序]
categories: [剑指,快速排序]
date: 2021-08-24 21:17:18
---

> 最小的k个数

## 题目

输入整数数组 arr ，找出其中最小的 k 个数。例如，输入4、5、1、6、2、7、3、8这8个数字，则最小的4个数字是1、2、3、4。

### 示例 1：

```
输入：arr = [3,2,1], k = 2
输出：[1,2] 或者 [2,1]
```

### 示例 2：

```
输入：arr = [0,1,2,1], k = 1
输出：[0]
```

### 提示：

- 0 <= k <= arr.length <= 10000
- 0 <= arr[i] <= 10000

## 题解

使用封装的sorted函数，这种方法需要排序O(NlogN)

```python
class Solution:
    def getLeastNumbers(self, arr: List[int], k: int) -> List[int]:
         return sorted(arr)[0:k]
```

还有一种方法是采取快速排序的思想，可以将复杂度降到O(N)
首先复习一下快速排序的代码。K神的方法是i<j的情况下就进行比对，这种方式要注意j的收缩要在i的扩张之前；这样可以保证最后停止的时候i，j指向都是比较小的那个数值。(最后交换时i,j都可以，因为结束时一定有i和j相等)

```python
def quicksort(l,r):
    if l>=r: return
    pivot = arr[l]
    i,j = l,r
    while (i<j):
        while i<j and arr[j]>=pivot:j -= 1 #在i<j的约束下 j在i的移动前面
        while i<j and arr[i]<=pivot:i += 1         
        arr[i],arr[j] = arr[j],arr[i]
    arr[l], arr[j] = arr[j], arr[l]
    quicksort(l,j-1)
    quicksort(j+1,r)
```

最后交换的时候只能是j并且一定要保证i和j不可越界，也就是说在i和j到临界值的时候就不用移动了

```python
def quicksort(l,r):
    if l>=r: return
    pivot = arr[l]
    i,j = l,r
    while (True):
        while j>l and arr[j]>=pivot:j -= 1 
        while i<r and arr[i]<=pivot:i += 1   
        if(i>=j):break
        arr[i],arr[j] = arr[j],arr[i]
    arr[l], arr[j] = arr[j], arr[l]
    quicksort(l,j-1)
    quicksort(j+1,r)
```

那么这个题目借用这种思想只要找到这个pivot他原本所在的位置下标为k，那么他的左边的部分就是要找的部分哦~~:wink:

```python
class Solution:
    def getLeastNumbers(self, arr: List[int], k: int) -> List[int]:
        def quicksort(l,r):
            if l>=r: return
            pivot = arr[l]
            i,j = l,r
            while (i<j):
                while i<j and arr[j]>=pivot:j -= 1 #在i<j的约束下 j在i的移动前面
                while i<j and arr[i]<=pivot:i += 1         
                arr[i],arr[j] = arr[j],arr[i]
            arr[l], arr[j] = arr[j], arr[l]
            if(k>j):quicksort(j+1,r)
            if(k<j):quicksort(l,j-1)            
        quicksort(0,len(arr)-1)
        return arr[:k]
```

这种方法的复杂度是N+N/2+N/4+N/8+.... = N(1/2+1/4+1/8+....) ~ 2N
