---
title: 剑指offer56-2 数组中数字出现的次数Ⅱ
tags: [剑指,数组]
categories: [剑指,数组]
date: 2021-12-08 13:43:59
---

>数组中数字出现的次数Ⅱ

## 题目

在一个数组 `nums` 中除一个数字只出现一次之外，其他数字都出现了三次。请找出那个只出现一次的数字。

### 示例 1：

```
输入：nums = [3,4,3,3]
输出：4
```

### 示例 2：

```
输入：nums = [9,1,7,9,7,9,7]
输出：1
```

### 提示：

- `1 <= nums.length <= 10000`

- `1 <= nums[i] < 2^31`


## 题解

使用哈希表记录次数，然后再寻找次数为1的数字。此时的时间复杂度为O(N),空间复杂度为O(N)。

```python
class Solution:
    def singleNumber(self, nums: List[int]) -> int:
        tmap = {}
        for num in nums:
            tmap[num] = tmap[num]+1 if num in tmap else 1
        for num in tmap:
            if tmap[num] == 1:
                return num
```

还有一种方法可以达到时间复杂度为O(N),空间复杂度为O(1);

其思想是每一位的二进制位对于出现3次的数字相加是3的倍数。这样可以把每一位相加对 3 除余数，可以得到出现一次的数字。

![](https://picture.mulindya.com/leetcode-offer56-2.png)

实际上修改余数m，可以得到通用解法：**除了一个数字以外，其余数字都出现 m 次 **
```python
class Solution:
    def singleNumber(self, nums: List[int]) -> int:
        counts = [0] * 32 #记录每一位的和
        for num in nums:
            for j in range(32):
                counts[j] += num & 1
                num >>= 1 #右移1位
        res, m = 0, 3
        for i in range(32):
            res <<= 1
            res |= counts[31 - i] % m  # 位或运算 从高位开始然后左移运算
        return res # if counts[31] % m == 0 else ~(res ^ 0xffffffff) #最高位为0则为正数，否则为负数
```

负数此处的操作没有看懂。经测试，直接return res即可。

> 由于 Python 的存储负数的特殊性，需要先将 0 - 32 位取反（即 res ^ 0xffffffff ），再将所有位取反（即 ~ ）。**^表示二进制异或运算**
> 两个组合操作实质上是将数字 32 以上位取反， 0 - 32 位不变。

