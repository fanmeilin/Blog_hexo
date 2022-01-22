---
title: 剑指53-1 数组中数字出现的次数
tags: [剑指,数组]
categories: [剑指,数组]
date: 2021-12-07 18:12:52
---

>数组中数字出现的次数

## 题目

一个整型数组 `nums` 里除两个数字之外，其他数字都出现了两次。请写程序找出这两个只出现一次的数字。要求时间复杂度是O(n)，空间复杂度是O(1)。

### 示例 1：

```
输入：nums = [4,1,4,6]
输出：[1,6] 或 [6,1]
```

### 示例 2：

```
输入：nums = [1,2,10,4,1,4,3,3]
输出：[2,10] 或 [10,2]
```

### 提示：

- `2 <= nums.length <= 10000`

## 题解

利用map来记录每个数出现的次数，再遍历map得到次数为1的数，这样的时间复杂度为O(N),空间复杂度为O(N)；

```python
class Solution:
    def singleNumbers(self, nums: List[int]) -> List[int]:
        info = {}
        result = []
        for num in nums:
            if not(num in info):info[num]=1
            else:info[num] += 1
        for key in info:
            if(info[key]==1):result.append(key)
        return result
        #这样的时间复杂度为O(N),空间复杂度为O(N)
```

因为要保证空间复杂度为O(1),需要另辟蹊径，注意到一个定理，a⊕a = 0 0⊕a=a，并且满足交换律，因此如果只有一个数字x只出现一次，那么将所有的数字进行异或操作得到的结果就是x

单个数字：

```python
def singleNumber(self, nums: List[int]) -> List[int]:
    x = 0
    for num in nums:  # 1. 遍历 nums 执行异或运算
        x ^= num      
    return x;         # 2. 返回出现一次的数字 x
```

现在是两个数字，因此所有数字的异或是x⊕y，这两个数字怎么区分呢，可以找到这两个数字不同的一位（利用&）。然后再进行异或分类，找到两个值。

```python
class Solution:
    def singleNumbers(self, nums: List[int]) -> List[int]:
        #x1异或x2.... 结果可以得到最终的两个不同的数异或 x异或y
        a,x,y = 0,0,0
        for num in nums:
            a = a^num
        m = 1
        while m&a==0: m = m<<1 #找到不同位
        for num in nums:
            if(m&num):x^=num
            else:y^=num
        return [x,y]
```
还不清楚的话，可以参考解释代码哦~

```java
class Solution {
    public int[] singleNumbers(int[] nums) {
        //因为相同的数字异或为0，任何数字与0异或结果是其本身。
        //所以遍历异或整个数组最后得到的结果就是两个只出现一次的数字异或的结果：即 z = x ^ y
        int z = 0;  
        for(int i : nums) z ^= i;
        //我们根据异或的性质可以知道：z中至少有一位是1，否则x与y就是相等的。
        //我们通过一个辅助变量m来保存z中哪一位为1.（可能有多个位都为1，我们找到最低位的1即可）。
        //举个例子：z = 10 ^ 2 = 1010 ^ 0010 = 1000,第四位为1.
        //我们将m初始化为1，如果（z & m）的结果等于0说明z的最低为是0
        //我们每次将m左移一位然后跟z做与操作，直到结果不为0.
        //此时m应该等于1000，同z一样，第四位为1.
        int m = 1;
        while((z & m) == 0) m <<= 1;
        //我们遍历数组，将每个数跟m进行与操作，结果为0的作为一组，结果不为0的作为一组
        //例如对于数组：[1,2,10,4,1,4,3,3]，我们把每个数字跟1000做与操作，可以分为下面两组：
        //nums1存放结果为0的: [1, 2, 4, 1, 4, 3, 3]
        //nums2存放结果不为0的: [10] (碰巧nums2中只有一个10，如果原数组中的数字再大一些就不会这样了)
        //此时我们发现问题已经退化为数组中有一个数字只出现了一次
        //分别对nums1和nums2遍历异或就能得到我们预期的x和y
        int x = 0, y = 0;
        for(int i : nums) {
            //这里我们是通过if...else将nums分为了两组，一边遍历一遍异或。
            //跟我们创建俩数组nums1和nums2原理是一样的。
            if((i & m) == 0) x ^= i;
            else y ^= i;
        }
        return new int[]{x, y};
    }
}
```

