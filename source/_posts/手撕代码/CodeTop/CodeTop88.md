---
title: CodeTop88 合并两个有序数组
tags: [CodeTop,指针]
categories: [CodeTop,指针]
date: 2022-06-18 16:12:41
---

> 合并两个有序数组

## 题目

给你两个按 非递减顺序 排列的整数数组 nums1 和 nums2，另有两个整数 m 和 n ，分别表示 nums1 和 nums2 中的元素数目。

请你 合并 nums2 到 nums1 中，使合并后的数组同样按 非递减顺序 排列。

注意：最终，合并后数组不应由函数返回，而是存储在数组 nums1 中。为了应对这种情况，nums1 的初始长度为 m + n，其中前 m 个元素表示应合并的元素，后 n 个元素为 0 ，应忽略。nums2 的长度为 n 。

### 示例 1：

```
输入：nums1 = [1,2,3,0,0,0], m = 3, nums2 = [2,5,6], n = 3
输出：[1,2,2,3,5,6]
解释：需要合并 [1,2,3] 和 [2,5,6] 。
合并结果是 [1,2,2,3,5,6] ，其中斜体加粗标注的为 nums1 中的元素。

```

### 示例 2：

```
输入：nums1 = [1], m = 1, nums2 = [], n = 0
输出：[1]
解释：需要合并 [1] 和 [] 。
合并结果是 [1] 。
```

### 示例3：

```
输入：nums1 = [0], m = 0, nums2 = [1], n = 1
输出：[1]
解释：需要合并的数组是 [] 和 [1] 。
合并结果是 [1] 。
注意，因为 m = 0 ，所以 nums1 中没有元素。nums1 中仅存的 0 仅仅是为了确保合并结果可以顺利存放到 nums1 中。

```
### 提示：

- nums1.length == m + n
- nums2.length == n
- 0 <= m, n <= 200
- 1 <= m + n <= 200
- -109 <= nums1[i], nums2[j] <= 109


## 题解

#### 双指针顺序搜索

这里按照常规方法会新建一个数组，逐个元素添加，但是题目的要求是直接对nums修改。因此会存在覆盖的问题，这里可以使用一个临时数组，最后**赋值**到nums1。

```python
class Solution:
    def merge(self, nums1: List[int], m: int, nums2: List[int], n: int) -> None:
        """
        Do not return anything, modify nums1 in-place instead.
        """
        #从前向后 使用临时数组
        result = []
        i, j = 0, 0
        while(i<m and j<n):
            if nums1[i]<nums2[j]:
                result.append(nums1[i])
                i += 1
            else:
                result.append(nums2[j])
                j += 1
        result += nums1[i:m] if i<m else nums2[j:n]
        nums1[:] = result #[:] 赋值 如果直接等于就会创建新变量

```

#### 双指针逆序搜索

从后向前更新nums1的值，每次取最大的值填入。这样nums1的有效数字不会被覆盖。循环只需要针对nums2的遍历，如果数组2被遍历完成，则nums1的结果（已经顺序填好）也就是最终的结果。

这样空间复杂度会进一步降低。

```python
class Solution:
    def merge(self, nums1: List[int], m: int, nums2: List[int], n: int) -> None:
        #从后向前
        p1, p2 = m - 1, n - 1
        tail = len(nums1) - 1
        while p2 >= 0: #nums2未放完
            if p1 < 0 or nums1[p1] < nums2[p2]: # p1放完 或者 p2对应更大
                nums1[tail] = nums2[p2]
                p2 -= 1
            else:  #否则填入p1内容
                nums1[tail] = nums1[p1]
                p1 -= 1
            tail -= 1
```

