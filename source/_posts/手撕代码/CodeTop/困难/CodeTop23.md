---
title: CodeTop23 合并k个升序链表
tags: [CodeTop,中等]
categories: [CodeTop,中等]
date: 2022-09-13 14:23:15
---

>合并k个升序链表

## 题目

给你一个链表数组，每个链表都已经按升序排列。

请你将所有链表合并到一个升序链表中，返回合并后的链表。

### 示例 1：

```
输入：lists = [[1,4,5],[1,3,4],[2,6]]
输出：[1,1,2,3,4,4,5,6]
解释：链表数组如下：
[
  1->4->5,
  1->3->4,
  2->6
]
将它们合并到一个有序链表中得到。
1->1->2->3->4->4->5->6
```

### 示例 2：

```
输入：lists = []
输出：[]
```

### 示例 3：

```
输入：lists = [[]]
输出：[]
```

### 提示：

- k == lists.length
- 0 <= k <= 10^4
- 0 <= lists[i].length <= 500
- -10^4 <= lists[i][j] <= 10^4
- lists[i] 按 升序 排列
- lists[i].length 的总和不超过 10^4


## 题解

### 排序

对每个链表设置一个指针，对指针指向的k个元素，第一想法是可以使用优先队列（小顶堆）；

- 将K个元素放入优先队列；
- 每次取最小的元素，移动该指针；
- 插入此元素到优先队列。

时间复杂度为O(N*log(K))，N是所有元素总数，K是链表的个数（每一次插入元素需要logk复杂度）。

空间复杂度为O(K)

```python
# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, val=0, next=None):
#         self.val = val
#         self.next = next
class Solution:
    def mergeKLists(self, lists: List[Optional[ListNode]]) -> Optional[ListNode]:
        import heapq
        heap = []
        result = ListNode(0)
        q = result
        for i in range(len(lists)):
            if lists[i]: heapq.heappush(heap,(lists[i].val,i)) #以元组的形式存储
        while heap:
            tmp = heapq.heappop(heap)[1] #弹出最小值的index
            q.next = lists[tmp]
            q = q.next
            lists[tmp] = lists[tmp].next
            if lists[tmp]:heapq.heappush(heap,(lists[tmp].val,tmp))
        return result.next
```
代码中用到了heapq库，是为了维护优先队列

#### heapq的相关用法

##### 创建堆

heapq有两种方式创建堆， 一种是使用一个空列表，然后使用heapq.heappush()函数把值加入堆中，另外一种就是使用heap.heapify(list)转换列表成为堆结构

```python
import heapq

# 第一种
"""
函数定义：
heapq.heappush(heap, item)
    - Push the value item onto the heap, maintaining the heap invariant.
heapq.heappop(heap)
    - Pop and return the smallest item from the heap, maintaining the heap invariant.
    If the heap is empty, IndexError is raised. To access the smallest item without popping it, use heap[0].
"""
nums = [2, 3, 5, 1, 54, 23, 132]
heap = []
for num in nums:
    heapq.heappush(heap, num)  # 加入堆

print(heap[0])  # 如果只是想获取最小值而不是弹出，使用heap[0]
print([heapq.heappop(heap) for _ in range(len(nums))])  # 堆排序结果
# out: [1, 2, 3, 5, 23, 54, 132]


# 第二种
nums = [2, 3, 5, 1, 54, 23, 132]
heapq.heapify(nums)
print([heapq.heappop(nums) for _ in range(len(nums))])  # 堆排序结果
# out: [1, 2, 3, 5, 23, 54, 132]
```
##### 插入弹出元素

- `heapq.heappush(heap, num)`  在heap堆中插入元素num

- 堆创建好后，可以通过`heapq.heappop() `函数弹出堆中最小值。

```python
import heapq
nums = [2, 3, 5, 1, 54, 23, 132]
heap = []
for num in nums:
    heapq.heappush(heap, num)  # 加入堆

print(heapq.heappop(nums))
# out: 2

# 如果需要所有堆排序后的元素
result = [heapq.heappop(nums) for _ in range(len(nums))]
print(result)
# out: [12, 23, 43, 45]
```

##### 获取前k位

如果需要获取堆中最大或最小的范围值，则可以使用`heapq.nlargest()` 或`heapq.nsmallest()` 函数

```python
"""
函数定义：
heapq.nlargest(n, iterable[, key])¶
    - Return a list with the n largest elements from the dataset defined by iterable. 
    - key if provided, specifies a function of one argument that is used to extract a comparison key from each element in the iterable: key=str.lower
    - Equivalent to: sorted(iterable, key=key, reverse=True)[:n]
"""
import heapq

nums = [1, 3, 4, 5, 2]
print(heapq.nlargest(3, nums))
print(heapq.nsmallest(3, nums))

"""
输出：
[5, 4, 3]
[1, 2, 3]
"""
```

### 分治法

两两合并为一个长链表，再继续两两合并。

```python
class Solution:
    def mergeKLists(self, lists: List[Optional[ListNode]]) -> Optional[ListNode]:
        if not lists:return
        return self.merge(lists,0,len(lists)-1)
    def merge(self, lists, left, right):
        if left==right:return lists[left] #只可能有相等的情况，不会出现left>right
        mid = (left+right)//2
        l1 = self.merge(lists, left, mid) #合并左半部分
        l2 = self.merge(lists, mid+1, right) #合并右半部分
        return self.merge2lists(l1, l2) #合并两条长链表
    def merge2lists(self, l1, l2): #合并两个链表
        if not l1: return l2
        if not l2: return l1
        head = ListNode(0)
        p = head
        while l1 and l2:
            if l1.val<l2.val: p.next, l1 = l1, l1.next
            else:p.next, l2 = l2, l2.next
            p = p.next
        p.next = l1 if l1 else l2
        return head.next
```

时间复杂度：考虑递归「向上回升」的过程——第一轮合并$\frac{k}{2}$组链表，每一组的时间代价是O(2n)（n抽象表示一个链表的长度），第二轮合并$\frac{k}{4}$组链表，每一组的时间代价是O(4n)，所以总的时间代价是$O(\sum_{i=1}^{logk} \frac k{2^i} \times 2^in)=O(logk \times nk)$

空间复杂度：递归会使用到O(logK) 空间代价的栈空间。
