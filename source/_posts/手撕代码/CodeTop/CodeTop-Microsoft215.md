---
title: CodeTop_Microsoft215数组中的第K个最大元素
tags: [CodeTop,微软,排序]
categories: [CodeTop,微软,排序]
date: 2022-03-24 15:27:18
---

> 数组中的第K个最大元素

## 题目
给定整数数组 nums 和整数 k，请返回数组中第 k 个最大的元素。

请注意，你需要找的是数组排序后的第 k 个最大的元素，而不是第 k 个不同的元素。


### 示例 1：

```
输入: [3,2,1,5,6,4] 和 k = 2
输出: 5
```

### 示例 2：

```
输入: [3,2,3,1,2,4,5,5,6] 和 k = 4
输出: 4
```

### 提示：

- 1 <= k <= nums.length <= 104
- -104 <= nums[i] <= 104

## 题解

该题有三种解法：
- 排序
- 分而治之（使用快排的pivot）
- 优先队列

重点应该理解第二种方法，还有要注意这里题目的意思是**第K大**。

### 排序

使用排序是效率最低的方法，其空间复杂度为O(N),时间复杂度为O(NlogN)

```python
class Solution:
    def findKthLargest(self, nums: List[int], k: int) -> int:
        nums = sorted(nums)
        return nums[len(nums)-k]
```

### 分治法

主要就是对快速排序中的`partition`的理解，将pivot放到其正确的位置，使其左右的元素要么大于pivot，要么小于pivot(等于的情况在任意一边即可)。

对于归位好的pivot可以得到它的下标，根据其下标和k进行比较，判断继续对pivot的左半部分还是右半部分继续查找。

> 这里又分为递归的方法，循环的方法。递归时空间复杂度为O(logN),时间复杂度为O(N)【O(2N-1)】,每次将pivot位的时间复杂度位O(N)
>

#### partition

先总结以下pivot的partition的方法：

##### exchange

注意首元素作为`pivot`，**先移动`j`指针到需要交换的元素，再移动`i`指针到需要交换的元素。**用于约束`i`的范围，最后交换首元素和停止的位置。

```python
def getIndex(Istart, Iend, nums):     
    if Istart>Iend: return
    pivot = nums[Istart]
    i,j = Istart,Iend
    while i<j: 
        while i<j and nums[j]>pivot: j-=1  #先j后i，约束i
        while i<j and nums[i]<=pivot:i+=1
        nums[i],nums[j] = nums[j],nums[i]
    nums[j],nums[Istart] = pivot,nums[j] #最后ij都会指向同一元素
	return j
```

也可以不采用交换的方法，将pivot移到对应的位置

```python
def getIndex(Istart, Iend, nums):     
    if Istart>Iend: return
    pivot = nums[Istart]
    i,j = Istart,Iend
    while i<j: 
        while i<j and nums[j]>pivot: j-=1  #先j后i，约束i
        nums[i] = nums[j] 
        while i<j and nums[i]<=pivot:i+=1
        nums[j] = nums[i]
    nums[j] = pivot #最后ij都会指向同一元素
	return j
```

##### 荷兰国旗的变种

不采用交换的方法，遍历数组，将小于等于pivot的元素都放置到数组的前方就好了，这样之后的元素自然是大于pivot的数字，代码更加简洁易懂。这里将最后的元素作为pivot，使用j来遍历数组。它在最后被赋值时，这里要注意不包含最后的元素。

```python
def getIndex(Istart,Iend): #快排partition的变形
    if Istart > Iend: return
    pivot,i = nums[Iend],Istart #末尾元素作为pivot
    for j in range(Istart,Iend): #j遍历 注意不包括最后的数字pivot 
        if nums[j]<=pivot: 
            nums[i],nums[j] = nums[j],nums[i]
            i += 1
    nums[i],nums[Iend] = nums[Iend],nums[i]
    return i 
```

也可以在循环遍历的过程中将pivot归位。此时将`i`初始化为`Istart-1`，每次指向待交换的下标。

```python
def getIndex(Istart,Iend): #快排partition的变形
    if Istart > Iend: return
    pivot,i = nums[Iend],Istart-1 #末尾元素作为pivot
    for j in range(Istart,Iend+1): 
        if nums[j]<=pivot: 
            i += 1
            nums[i],nums[j] = nums[j],nums[i] #交换i和j的元素
    return i 
```

#### 完整代码

```python
class Solution:
    def findKthLargest(self, nums: List[int], k: int) -> int:
        def getIndex(Istart,Iend): #快排partition的变形
            if Istart > Iend: return
            pivot,i = nums[Iend],Istart-1 #末尾元素作为pivot
            for j in range(Istart,Iend+1): 
                if nums[j]<=pivot: 
                    i += 1
                    nums[i],nums[j] = nums[j],nums[i] #交换i和j的元素
            return i    
        left,right = 0,len(nums)-1
        while True:
            index = getIndex(left,right) #使用循环比使用递归的内存消耗要少 这样空间复杂度为O(1)
            if index==len(nums)-k:return nums[index]
            elif index>len(nums)-k:  right = index-1  #j表示第j-1大的数字
            else: left = index+1
```

此时的时间复杂度为O(N)【每一次查找的时间复杂度为N，但是不需要logn次,O(2N-1)】空间复杂度为O(1)。如果使用递归那么空间复杂度为O(logN)。

### 优先队列

使用java的PriorityQueue，默认是小根堆，选出第k大的元素，如果说大于k元素就弹出堆顶元素，最后只剩下k个元素返回堆顶。

```java
class Solution {
    public int findKthLargest(int[] nums, int k) {
        PriorityQueue<Integer> heap = new PriorityQueue<>();
        for (int num : nums) {
            heap.add(num);
            if (heap.size() > k) {
                heap.poll();
            }
        }
        return heap.peek();
    }
}
```

> peek()	//返回队首元素
>
> poll()	//返回队首元素，队首元素出队列
>
> add()	//添加元素
>
> size()	//返回队列元素个数
>
> isEmpty()	//判断队列是否为空，为空返回true,不空返回false

时间复杂度：O(NlogK)，遍历数据 O(N)，堆内元素调整 O(logK)；
空间复杂度：O(K)。

