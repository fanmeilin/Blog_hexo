---
title: CodeTop_Microsoft207 课程表
tags: [CodeTop,微软,拓扑排序]
categories: [CodeTop,微软,拓扑排序]
date: 2022-03-16 10:32:29
---

> 课程表

## 题目
你这个学期必须选修 numCourses 门课程，记为 0 到 numCourses - 1 。

在选修某些课程之前需要一些先修课程。 先修课程按数组 prerequisites 给出，其中 prerequisites[i] = [ai, bi] ，表示如果要学习课程 ai 则 必须 先学习课程  bi 。

- 例如，先修课程对 [0, 1] 表示：想要学习课程 0 ，你需要先完成课程 1 。
请你判断是否可能完成所有课程的学习？如果可以，返回 true ；否则，返回 false 。



### 示例 1：

```
输入：numCourses = 2, prerequisites = [[1,0]]
输出：true
解释：总共有 2 门课程。学习课程 1 之前，你需要完成课程 0 。这是可能的。
```

### 示例 2：

```
输入：numCourses = 2, prerequisites = [[1,0],[0,1]]
输出：false
解释：总共有 2 门课程。学习课程 1 之前，你需要先完成​课程 0 ；并且学习课程 0 之前，你还应先完成课程 1 。这是不可能的。
```

### 提示：

- 1 <= numCourses <= 105
- 0 <= prerequisites.length <= 5000
- prerequisites[i].length == 2
- 0 <= ai, bi < numCourses
- prerequisites[i] 中的所有课程对 互不相同

## 题解

目标是判断课程安排图是否为有向无环图（DAG）
思路是通过拓扑排序判断，原理是对DAG的顶点进行排序，使得每一条有向边（u，v），均有u（在排序记录中比v先出现），也就是就说对于某点v而言，必须其源点都出现了，v才能出现。

#### 方法一: 入度表（广度优先遍历）

```python
class Solution:
    def canFinish(self, numCourses: int, prerequisites: List[List[int]]) -> bool:
        from collections import deque
        indegrees = [0 for _ in range(numCourses)] #每个节点的入度个数记录
        adjacency = [[] for _ in range(numCourses)] #邻接表
        for cur,pre in prerequisites: #初始化
            adjacency[pre].append(cur)
            indegrees[cur] += 1
         #寻找开始节点
        queue = deque()
        for i in range(numCourses):
            if not indegrees[i]: queue.append(i)
        # BFS
        while queue:
            pre = queue.popleft() #弹出一个入度为0的节点
            numCourses -= 1 #弹出一个就可以消减一个
            for cur in adjacency[pre]: #判断此节点是否入度为0
                indegrees[cur] -= 1
                if not indegrees[cur]: queue.append(cur)
        return not numCourses
```

> 在python中队列可以用list实现
>
> ```python
> queue = list() 
> queue.append(num) #压入
> queue.pop(0) #弹出，指定下标是0
> ```
>
> 栈也可以使用list实现
>
> ```python
> stack = list() 
> stack.append(num) #压入
> stack.pop() #弹出，默认弹出末尾的节点
> ```
>
> Python中的collentions中有一个[deque](https://so.csdn.net/so/search?q=deque&spm=1001.2101.3001.7020)，这个对象类似于list列表，但是使用list存储数据是，按索引访问元素很快，但是插入和删除就很慢了，因为list是线性存储，数据量大的时候，插入和删除效率很低。deque是一个链表结构所以在使用栈或者队列更推荐使用deque来实现。
>
> deque可以理解为双向队列
>
> - append，pop，extend默认从右端操作数据
>
> -  appendleft 在列表左侧插入
> -  popleft 弹出列表左侧的值
> -  extendleft 在左侧扩展**一组**

#### 方法二：深度优先遍历

原理是通过DFS判断图中是否有环

借助一个标志列表flags，用于判断每个节点i的状态：

1. 未被DFS访问时标志为0
2. 已经被其他节点访问过就无需访问了标志位-1
3. 被当前的DFS访问标志位1，如果当前路径又访问该节点则说明有环

```python
class Solution:
    def canFinish(self, numCourses: int, prerequisites: List[List[int]]) -> bool:
        def dfs(i,adjacency,flags):
            if flags[i] == -1: return True
            if flags[i] == 1: return False
            flags[i] = 1
            for j in adjacency[i]:
                if not dfs(j,adjacency,flags): return False #剪枝
            flags[i] = -1
            return True
        flags = [0 for _ in range(numCourses)] #每个节点状态
        adjacency = [[] for _ in range(numCourses)] #邻接表
        for cur,pre in prerequisites: #初始化
            adjacency[pre].append(cur)
        for i in range(numCourses):
            if not dfs(i, adjacency, flags): return False
        return True
```

这两种方法的时间和空间复杂度均为O(M+N)N 和 M 分别为节点数量和临边数量；
