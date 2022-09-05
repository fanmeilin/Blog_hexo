---
title: CodeTop200 岛屿数量
tags: [CodeTop,算法,优先遍历]
categories: [CodeTop,算法,优先遍历]
date: 2022-05-25 16:43:21
---

> 岛屿数量

## 题目

给你一个由 '1'（陆地）和 '0'（水）组成的的二维网格，请你计算网格中岛屿的数量。

岛屿总是被水包围，并且每座岛屿只能由水平方向和/或竖直方向上相邻的陆地连接形成。

此外，你可以假设该网格的四条边均被水包围。


### 示例 1：

```
输入：grid = [
  ["1","1","1","1","0"],
  ["1","1","0","1","0"],
  ["1","1","0","0","0"],
  ["0","0","0","0","0"]
]
输出：1

```

### 示例 2：

```
输入：grid = [
  ["1","1","0","0","0"],
  ["1","1","0","0","0"],
  ["0","0","1","0","0"],
  ["0","0","0","1","1"]
]
输出：3

```

### 提示：

- m == `grid.length`
- n == `grid[i].length`
- 1 <= m, n <= 300
- `grid[i][j]` 的值为 '0' 或 '1'

## 题解

#### 解法一 DFS

目标是找到矩阵中的岛屿数量，上下左右相连为1的数字是合并的岛屿

dfs方法：设当前指针指向的岛屿中的某点(i,j)，寻找包括此点的岛屿边界

- 从当前出发对上下左右的点进行深度搜索，即(i,j+1),(i,j-1),(i-1,j),(i+1,j);
- 终止条件：
  - 越过矩阵边界
  - 矩阵对应的点为0，代表此点已经越过了岛屿边界
- 在搜索岛屿的同时，还需要将`grid[i][j]`都设置为0，也就是将记录过的岛屿点删除，避免之后重复搜索。
- 主循环
  - 遍历整个矩阵，当遇到点为1时，进行dfs递归，岛屿数count+1且在深度优先搜索中删除此岛屿。
- 最终返回count即可。

```python
class Solution:
    def numIslands(self, grid: List[List[str]]) -> int:
        h,w = len(grid),len(grid[0])
        def dfs(i,j):
            if not (0<=i<h and 0<=j<w) or grid[i][j]=='0': return
            grid[i][j] = '0'
            dfs(i-1,j)
            dfs(i+1,j)
            dfs(i,j-1)
            dfs(i,j+1)
        count = 0
        for i in range(h):
            for j in range(w):
                if grid[i][j] == '1':
                    dfs(i,j)
                    count += 1
        return count
```

时间复杂度为 O(MN)

空间复杂度为 O(MN) 最坏情况下，整个网格均为陆地，dfs的深度达到MN

#### 解法二 BFS

- 主循环的方法一致，但是搜索岛屿边界的方法不同。
- 使用队列queue，判断队列的首部节点(i,j)是否未越界并且为'1'  (摸索岛屿边缘)
  - 首先将其点置为0，并且将其上下左右的节点加入队列中 （消除整座岛屿）
  - 否则，跳过该节点
- 循环pop该队列，直到队列为空，则消除完整片岛屿。

```python
class Solution:
    def numIslands(self, grid: List[List[str]]) -> int:
        h, w = len(grid),len(grid[0])
        def bfs(i,j):
            grid[i][j] = "0"
            neighbors = collections.deque([(i, j)]) #双端队列
            while neighbors:
                row, col = neighbors.popleft() #左边出队列
                for x, y in [(row - 1, col), (row + 1, col), (row, col - 1), (row, col + 1)]: #判断上下左右
                    if 0 <= x < h and 0 <= y < w and grid[x][y] == "1": #满足条件则入队列
                        neighbors.append((x, y))
                        grid[x][y] = "0" #在入队列时置为0，避免后续重复循环插入该元素
        count = 0
        for i in range(h):
            for j in range(w):
                if grid[i][j] == "1":
                    count += 1
                    bfs(i,j)
        return count
```

时间复杂度为 O(MN)

空间复杂度为 O(min(M,N)) 最坏情况下，整个网格均为陆地，bfs的深度达到min(M,N)，BFS按照每一层进行遍历，最长的队列长度为对角线。

#### 解法三 并查集

使用并查集代替搜索，

可以扫描整个二位网格，如果有一个位置上为1，则将其与邻居节点的1在并查集中进行合并，最终的岛屿数就是连通分类的数目。

```python
class UnionFind:
    def __init__(self, grid):
        m, n = len(grid), len(grid[0])
        self.count = 0
        self.parent = [-1] * (m * n)
        self.rank = [0] * (m * n)
        for i in range(m):
            for j in range(n):
                if grid[i][j] == "1":
                    self.parent[i * n + j] = i * n + j
                    self.count += 1  #所有1的数目，原本可以自成一方
    
    def find(self, i):
        if self.parent[i] != i:
            self.parent[i] = self.find(self.parent[i])
        return self.parent[i]
    
    def union(self, x, y):
        rootx = self.find(x)
        rooty = self.find(y)
        if rootx != rooty: #连通该节点
            if self.rank[rootx] < self.rank[rooty]: #向更大的父节点上添加
                rootx, rooty = rooty, rootx
            self.parent[rooty] = rootx
            if self.rank[rootx] == self.rank[rooty]:
                self.rank[rootx] += 1  #单个节点进行的连通
            self.count -= 1 #用统一的父节点代替该岛屿
    
    def getCount(self):
        return self.count

class Solution:
    def numIslands(self, grid: List[List[str]]) -> int:
        nr,nc = len(grid),len(grid[0])
        if nr == 0:
            return 0
        uf = UnionFind(grid)
        num_islands = 0
        for r in range(nr):
            for c in range(nc):
                if grid[r][c] == "1":
                    grid[r][c] = "0"
                    for x, y in [(r - 1, c), (r + 1, c), (r, c - 1), (r, c + 1)]:
                        if 0 <= x < nr and 0 <= y < nc and grid[x][y] == "1": #位置满足要求且为岛屿
                            uf.union(r * nc + c, x * nc + y)
        
        return uf.getCount()

```

