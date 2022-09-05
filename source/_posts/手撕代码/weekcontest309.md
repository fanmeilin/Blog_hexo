---
title: 周赛309
tags: [CodeTop,周赛]
categories: [CodeTop,周赛]
date: 2022-09-05 19:19:28
math: true
---

>easy        2399 检查相同字母间的距离 
>
>medium 6168 恰好移动k步到达某一位置的方法数目
>
>medium 2401 最长优雅子数组
>
>hard       2402 会议室Ⅲ

## 2399  检查相同字母间的距离 

给你一个下标从 0 开始的字符串 s ，该字符串仅由小写英文字母组成，s 中的每个字母都 恰好 出现 两次 。另给你一个下标从 0 开始、长度为 26 的的整数数组 distance 。

字母表中的每个字母按从 0 到 25 依次编号（即，'a' -> 0, 'b' -> 1, 'c' -> 2, ... , 'z' -> 25）。

在一个 匀整 字符串中，第 i 个字母的两次出现之间的字母数量是 distance[i] 。如果第 i 个字母没有在 s 中出现，那么 distance[i] 可以 忽略 。

如果 s 是一个 匀整 字符串，返回 true ；否则，返回 false 。

### 示例 1：

```
输入：s = "abaccb", distance = [1,3,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
输出：true
解释：
- 'a' 在下标 0 和下标 2 处出现，所以满足 distance[0] = 1 。
- 'b' 在下标 1 和下标 5 处出现，所以满足 distance[1] = 3 。
- 'c' 在下标 3 和下标 4 处出现，所以满足 distance[2] = 0 。
注意 distance[3] = 5 ，但是由于 'd' 没有在 s 中出现，可以忽略。
因为 s 是一个匀整字符串，返回 true 。
```

### 示例 2：

```
输入：s = "aa", distance = [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
输出：false
解释：
- 'a' 在下标 0 和 1 处出现，所以两次出现之间的字母数量为 0 。
但是 distance[0] = 1 ，s 不是一个匀整字符串。
```

### 提示：

- 2 <= s.length <= 52
- s 仅由小写英文字母组成
- s 中的每个字母恰好出现两次
- distance.length == 26
- 0 <= distance[i] <= 50


### 题解

使用哈希表记录字母出现的位置即可。这里的ord是序数函数，返回字符在ASCLL码的序号；因为在python中不能像C中对str进行相减，需要转化为序号后再计算。

```python
class Solution:
    def checkDistances(self, s: str, distance: List[int]) -> bool:
        flag = [-1]*26 
        for i,ch in enumerate(s):
            index = ord(ch)-ord('a')
            if flag[index] == -1:
                flag[index] = i
            else:
                if(distance[index]!=i-flag[index]-1):return False
        return True
```

## 6168 恰好移动k步到达某一位置的方法数目

给你两个 正 整数 startPos 和 endPos 。最初，你站在 无限 数轴上位置 startPos 处。在一步移动中，你可以向左或者向右移动一个位置。

给你一个正整数 k ，返回从 startPos 出发、恰好 移动 k 步并到达 endPos 的 不同 方法数目。由于答案可能会很大，返回对 10^9 + 7 取余 的结果。

如果所执行移动的顺序不完全相同，则认为两种方法不同。

注意：数轴包含负整数。

### 示例1：

```
输入：startPos = 1, endPos = 2, k = 3
输出：3
解释：存在 3 种从 1 到 2 且恰好移动 3 步的方法：
- 1 -> 2 -> 3 -> 2.
- 1 -> 2 -> 1 -> 2.
- 1 -> 0 -> 1 -> 2.
可以证明不存在其他方法，所以返回 3 。
```

### 示例2：

```
输入：startPos = 2, endPos = 5, k = 10
输出：0
解释：不存在从 2 到 5 且恰好移动 10 步的方法。
```

### 提示：

- `1 <= startPos, endPos, k <= 1000`

### 题解

#### 记忆化搜索

一种方法是记忆化搜索，使用@cache可以对已经计算过的dfs(x,k)记录到缓存直接读取，dfs函数需要有返回值。设两点之间的距离为d，如果d大于最大步数k直接剪枝，另外还有一个小的剪枝，d和k的奇偶必须相同否则也无法到达终点。如果走到终点则返回1，返回向左向右移动一部后的路径相加。

dfs(x,k)可以理解为在x的位置，还剩k步可以走。

```python
class Solution:
    def numberOfWays(self, startPos: int, endPos: int, k: int) -> int:
        MOD = 10**9 + 7
        @cache #使用cache装饰器则后续对于重复运算的dfs函数可以直接读取缓存 因此需要有return
        def dfs(x, k):
            d = abs(x-endPos)
            if d > k: return 0     # 剪枝：x与endPos之间的距离超过剩余步数     
            if x == endPos and k == 0: return 1 # 找到了一条可行路径
            return  (dfs(x-1, k-1)+dfs(x+1, k-1)) % MOD
        d = abs(startPos-endPos)
        if d>k or d%2!=k%2:return 0 #小小剪枝
        return dfs(startPos, k)
```

#### 数学公式

第二种方法是数学方法，假设startpos位置小于endpos，总共需要右移x次，那么有x-（k-x）= d，因此x = （d+k）/ 2，则数学求解$C_k^{right}$，在python中有函数comb。这里可以先剪枝，相加为偶数才能有选择指定左走/右走

```python
class Solution:
    def numberOfWays(self, startPos: int, endPos: int, k: int) -> int:
        d = abs(startPos-endPos)
        if d>k or d%2!=k%2:return 0 #剪枝
        #必须相加为偶数才能有选择指定左走/右走
        return comb(k,int((d+k)/2)) % (10**9 + 7) #C k_right 
```

## 2401 最长优雅子数组

给你一个由 正 整数组成的数组 nums 。

如果 nums 的子数组中位于 不同 位置的每对元素按位 与（AND）运算的结果等于 0 ，则称该子数组为 优雅 子数组。

返回 最长 的优雅子数组的长度。

子数组 是数组中的一个 连续 部分。

注意：长度为 1 的子数组始终视作优雅子数组。

### 示例1：

```
输入：nums = [1,3,8,48,10]
输出：3
解释：最长的优雅子数组是 [3,8,48] 。子数组满足题目条件：
- 3 AND 8 = 0
- 3 AND 48 = 0
- 8 AND 48 = 0
可以证明不存在更长的优雅子数组，所以返回 3 。
```

### 示例2：

```
输入：nums = [3,1,5,11,13]
输出：1
解释：最长的优雅子数组长度为 1 ，任何长度为 1 的子数组都满足题目条件。
```

### 提示：
- `1 <= nums.length <= 105`
- `1 <= nums[i] <= 109`

### 题解

方法为滑动窗口，这里对x进行按位与操作时需要与之前的保留数字（长度为length）逐一比较，可以先记录前期保留的数字位为1的位置，因此需要对前期的数字记录位信息于maxflag中，也就是使用按位或运算达成目的，并且更新length和result。如果x不满足条件，则需要收缩length，在前期保留的数字中从后向前配对x，并且更新length和当前的maxflag。

```python
class Solution:
    def longestNiceSubarray(self, nums: List[int]) -> int:
        maxflag,length,result = 0,0,0
        for i,x in enumerate(nums):
            if maxflag&x==0:
                maxflag = maxflag|x
                length +=1
                result = max(length,result)
            else:
                maxflag,tmp = x,1
                while tmp<=length and nums[i-tmp]&x==0:
                    maxflag |= nums[i-tmp]
                    tmp+=1
                length = tmp
        return result
```

## 2402 会议室Ⅲ

给你一个整数 n ，共有编号从 0 到 n - 1 的 n 个会议室。

给你一个二维整数数组 meetings ，其中 meetings[i] = [starti, endi] 表示一场会议将会在 半闭 时间区间 [starti, endi) 举办。所有 starti 的值 互不相同 。

会议将会按以下方式分配给会议室：

每场会议都会在未占用且编号 最小 的会议室举办。
如果没有可用的会议室，会议将会延期，直到存在空闲的会议室。延期会议的持续时间和原会议持续时间 相同 。
当会议室处于未占用状态时，将会优先提供给原 开始 时间更早的会议。
返回举办最多次会议的房间 编号 。如果存在多个房间满足此条件，则返回编号 最小 的房间。

半闭区间 [a, b) 是 a 和 b 之间的区间，包括 a 但 不包括 b 。

### 示例1：

```
输入：n = 2, meetings = [[0,10],[1,5],[2,7],[3,4]]
输出：0
解释：
- 在时间 0 ，两个会议室都未占用，第一场会议在会议室 0 举办。
- 在时间 1 ，只有会议室 1 未占用，第二场会议在会议室 1 举办。
- 在时间 2 ，两个会议室都被占用，第三场会议延期举办。
- 在时间 3 ，两个会议室都被占用，第四场会议延期举办。
- 在时间 5 ，会议室 1 的会议结束。第三场会议在会议室 1 举办，时间周期为 [5,10) 。
- 在时间 10 ，两个会议室的会议都结束。第四场会议在会议室 0 举办，时间周期为 [10,11) 。
会议室 0 和会议室 1 都举办了 2 场会议，所以返回 0 。
```

### 示例2：

```
输入：n = 3, meetings = [[1,20],[2,10],[3,5],[4,9],[6,8]]
输出：1
解释：
- 在时间 1 ，所有三个会议室都未占用，第一场会议在会议室 0 举办。
- 在时间 2 ，会议室 1 和 2 未占用，第二场会议在会议室 1 举办。
- 在时间 3 ，只有会议室 2 未占用，第三场会议在会议室 2 举办。
- 在时间 4 ，所有三个会议室都被占用，第四场会议延期举办。 
- 在时间 5 ，会议室 2 的会议结束。第四场会议在会议室 2 举办，时间周期为 [5,10) 。
- 在时间 6 ，所有三个会议室都被占用，第五场会议延期举办。 
- 在时间 10 ，会议室 1 和 2 的会议结束。第五场会议在会议室 1 举办，时间周期为 [10,12) 。 
会议室 1 和会议室 2 都举办了 2 场会议，所以返回 1 。 
```

### 提示：

- 1 <= n <= 100
- 1 <= meetings.length <= 105
- meetings[i].length == 2
- 0 <= starti < endi <= 5 * 105
- starti 的所有值 互不相同

### 题解

 times.index(max(times))可以找到times的最大值对应的索引，默认返回最小索引；

注意这里的meating是起始时间和终止时间，当开始还以为是开始时间和持续时间。

首先定义两个数组，保存房间的使用次数和占用情况，room[i]表示第i个房间会被占用至room[i]时刻；对会议列表排序，对meeting，找到可用的合适的房间（最快出现或者对于空闲选最小）两种情况：

- 在start时刻有空闲的即可选用，退出循环

- 如果不存在空闲，找最快出现空闲的房间。

更新该房间的room和对应的times数组，在times中找到对应的最多使用次数的房间。

```python
class Solution:
    def mostBooked(self, n: int, meetings: List[List[int]]) -> int:
        times,room = [0]*n,[0]*n
        # meetings = sorted(meetings,key = lambda x:x[0]) 等价于sorted(meetings)
        for meeting in sorted(meetings):
            earlyroom,index,minindex = room[0],-1,0
            while index+1<n:
                index += 1
                if meeting[0]>=room[index]:
                    minindex = index
                    break
                if earlyroom>room[index]: earlyroom,minindex = room[index],index
            room[minindex] = max(room[minindex]+meeting[1]-meeting[0], meeting[1])
            times[minindex] += 1
        return times.index(max(times))
```