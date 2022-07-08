---
title: bytedance2018算法方向题解
tags: [CodeTop,bytedance]
categories: [CodeTop,bytedance]
date: 2022-07-07 17:17:50
---

>  字节跳动2018校招算法方向题目记录

### 题目1：

P为给定的二维平面整数点集。定义 P 中某点x，如果x满足 P 中任意点都不在 x 的右上方区域内（横纵坐标都大于x），则称其为“最大的”。求出所有“最大的”点的集合。（所有点的横坐标和纵坐标都不重复, 坐标轴范围在[0, 1e9) 内）

如下图：实心点为满足条件的点的集合。请实现代码找到集合 P 中的所有 ”最大“ 点的集合并输出。

![](https://picture.mulindya.com/Aleetcode%2Fbytedance_leetcode1.png)

##### 输入描述：

第一行输入点集的个数 N， 接下来 N 行，每行两个数字代表点的 X 轴和 Y 轴。
对于 50%的数据,  1 <= N <= 10000;
对于 100%的数据, 1 <= N <= 500000;

##### 输出描述：

输出“最大的” 点集合， 按照 X 轴从小到大的方式输出，每行两个数字分别代表点的 X 轴和 Y轴。

##### 示例1

```
输入：
5
1 2
5 3
4 6
7 5
9 0

输出：
4 6
7 5
9 0
```
方法一：
``` python
from sys import stdin
n =int(stdin.readline().strip())
data= [int(x) for x in stdin.readline().strip().split()] #可以对每一行进行操作，会统一放进同一个列表中；注意int操作对字符串数据变换
#使用stdin.readline().strip().split()  strip去掉首尾空字符串 split进行切割数据
partsum=[0]
for x in data:
    partsum.append( partsum[-1]+x )
 
def left_bound(data):
    left=[ 0 for i in range(n) ]
    for i,v in enumerate( data[1:],1):
        if v > data[i-1]:
            left[i]=i
        else:
            k = i-1
            while k >= 0:
                if v < data[k]:
                    k = left[k]-1
                else :
                    left[i] = left[k] if v == data[k] else k+1
                    break
    return left
 
left = left_bound(data)
right= left_bound(data[::-1])[::-1]
right= [n-x for x in right ]
 
res = max([ data[i]*(partsum[right[i]]-partsum[left[i]]) for i in range(n) ])
print(res)
```

> 思路是：把每个数当做区间里的最小值，找区间左右边界，即第一个小于它的数（区间里加入小于它的数，它就不是最小值了）
> 优化的点有两个：
> 1.求和涉及大量的重复运算——可以用从0到n的部分和减法代替
> 2.找边界的过程涉及大量的重复比较——
>  以找左边界为例， 从第二个数起，
>  如果大于前一个数，则左边界为自身；否则：
>      如果等于前一个数，则左边界跟前一个数的左边界一样；
>      如果小于，则它的左边界小于前一个数的左边界；
>      这样可以跳过重复的比较。
> 把找左边界写成函数，求右边界把数组逆置调用下再转换就行了，不用重写

方法二：
``` python
p = []
n = int(input())
for i in range(n):
    tmp = input()
    a = [int(x) for x in tmp.split(' ')]
    p.append(a)
sorted(p, key=lambda x: (-x[0], -x[1]))
tmp = -1
for t in p:
    if t[1] > tmp:
        print('%d %d' % (t[0], t[1]))
        tmp = t[1]
```

### 题目2

给定一个数组序列, 需要求选出一个区间, 使得该区间是所有区间中经过如下计算的值最大的一个：

区间中的最小数 * 区间所有数的和最后程序输出经过计算后的最大值即可，不需要输出具体的区间。如给定序列  [6 2 1]则根据上述公式, 可得到所有可以选定各个区间的计算值:

[6] = 6 * 6 = 36;

[2] = 2 * 2 = 4;

[1] = 1 * 1 = 1;

[6,2] = 2 * 8 = 16;

[2,1] = 1 * 3 = 3;

[6, 2, 1] = 1 * 9 = 9;

从上述计算可见选定区间 [6] ，计算值为 36， 则程序输出为 36。

区间内的所有数字都在[0, 100]的范围内;

```python
n=int(input())
arr=[int(x) for x in input().split()]
stack = []
arr.append(0)
result = 0
i = 0
presum = []
tempsum = 0
while i<len(arr):
    if not stack or arr[i]>=stack[-1]:
        presum.append(tempsum)
        tempsum = 0
        stack.append(arr[i])
        i+=1
    else:
        temp = stack.pop(-1)
        tempsum+=(temp+presum.pop())
        result = max(tempsum*temp,result)
print(result)
```

### 题目3

产品经理(PM)有很多好的idea，而这些idea需要程序员实现。现在有N个PM，在某个时间会想出一个 idea，每个 idea 有提出时间、所需时间和优先等级。对于一个PM来说，最想实现的idea首先考虑优先等级高的，相同的情况下优先所需时间最小的，还相同的情况下选择最早想出的，没有 PM 会在同一时刻提出两个 idea。

同时有M个程序员，每个程序员空闲的时候就会查看每个PM尚未执行并且最想完成的一个idea,然后从中挑选出所需时间最小的一个idea独立实现，如果所需时间相同则选择PM序号最小的。直到完成了idea才会重复上述操作。如果有多个同时处于空闲状态的程序员，那么他们会依次进行查看idea的操作。

求每个idea实现的时间。

输入第一行三个数N、M、P，分别表示有N个PM，M个程序员，P个idea。随后有P行，每行有4个数字，分别是PM序号、提出时间、优先等级和所需时间。输出P行，分别表示每个idea实现的时间点。

```c++
#include<bits/stdc++.h>
using namespace std;
struct idea{
    // idea的标号, 想出idea的pm, 想出idea的时间, idea的优先级, idea所需时间
    int id, pm, time, priority, cost;
    idea(int id_, int pm_, int time_, int priority_, int cost_):
        id(id_),pm(pm_),time(time_),priority(priority_),cost(cost_){
    }
};
// pm对idea的优先级比较
struct cmp_by_pm{
    bool operator()(const idea& a, const idea& b) {
        if (a.priority != b.priority) {
            return a.priority < b.priority;
        }
        if (a.cost != b.cost) {
            return a.cost > b.cost;
        }
        if (a.time != b.time) {
            return a.time > b.time;
        }
        return a.pm < b.pm;
    }
};
// 想出idea的时间比较
bool cmp_time(const idea& a, const idea& b){
    return a.time < b.time;
}
// 程序员对idea的优先级比较
struct cmp_by_worker{
    bool operator()(const idea& a, const idea& b) {
        if (a.cost != b.cost) {
            return a.cost > b.cost;
        }
        return a.pm > b.pm;
    }
};
int main(){
    int i;
    int N, M, P;
    cin >> N >> M >> P;
    vector<idea> ideas;  // 记录ideas
    int pm, time, priority, cost;
    for (int i = 0; i < P; i++) {
        cin >> pm >> time >> priority >> cost;
        ideas.emplace_back(idea(i, pm - 1, time, priority, cost));
    }
    vector<int> workers(M, 0);  // 程序员剩余的工作时间
    vector<int> finished(P);  // 记录ideas的完成时间
    // 优先队列, 分别记录每个PM当前尚未执行的idea, 可获得其最想执行的idea
    priority_queue<idea, vector<idea>, cmp_by_pm> cur_ideas[N];
    // 对ideas排序, 按时间逐个加入每个PM的优先队列中
    sort(ideas.begin(), ideas.end(), cmp_time);
    int count = 0, p = 0;
    time = 1;
    while (count < P) {
        while (p < P && ideas[p].time <= time) {
            int pm_ = ideas[p].pm;
            cur_ideas[pm_].push(ideas[p]);
            p++;
        }
        // 优先队列, 记录每个PM最想执行的idea, 可获得程序员将要做的idea
        priority_queue<idea, vector<idea>, cmp_by_worker> q;
        for (i = 0; i < N; i++) {
            if (!cur_ideas[i].empty()) {
                q.push(cur_ideas[i].top());
            }
        }
        // 更新程序员的剩余工作时间, 为空闲程序员分配工作
        for (i = 0; i < M; i++) {
            if (workers[i] > 0) {
                workers[i]--;
            }
            if (workers[i] == 0 && !q.empty()) {
                idea t = q.top();
                q.pop();
                cur_ideas[t.pm].pop();
                // 一个PM的idea被执行后, 他的次优先idea需要加入队列中
                if (!cur_ideas[t.pm].empty()) {
                    q.push(cur_ideas[t.pm].top());
                }
                // 分配工作后更新剩余工作时间, 同时可确定完成时间
                workers[i] = t.cost;
                finished[t.id] = time + t.cost;
                count++;
            }
        }
        time++;
    }
    for (i = 0; i < P; i++) {
        cout << finished[i] << endl;
    }
}
```

```c++
#include <bits/stdc++.h>
 
using namespace std;
 
struct Task
{
    int id;
    int pm;
    int time;
    int pri;
    int dur;
};
 
vector<vector<Task>> pmtasks;
map<int, int> result;
int proid = 1;
struct Programer
{
    Programer()
    {
        t = 0;
        this->id = proid++;
    }
    int t;//当前的时间
    int id;
    int doTask()
    {
        vector<Task>::iterator findT;
        int index = -1;
        for (size_t i = 0; i < pmtasks.size(); i++)
        {
            auto& tasks = pmtasks.at(i);
            if (tasks.size() == 0) continue;
            auto it = tasks.begin();
            while (it!= tasks.end() && it->time > t)
                it++;
            if (it == tasks.end()) continue;
            if (index == -1)
            {
                findT = it;
                index = i;
            }
            else
            {
                if (it->dur < findT->dur)
                {
                    findT = it;
                    index = i;
                }
            }
        }
        if (index != -1)
        {
            t += findT->dur;
            result[findT->id] = t;
            pmtasks.at(index).erase(findT);
            return 1;
        }
        else
            t++;
        return 0;
    }
};
 
int main()
{
    int n, m, p;
    cin >> n >> m >> p;
    pmtasks.resize(n);
    for (size_t i = 0; i < p; i++)
    {
        Task task;
        cin >> task.pm >> task.time >> task.pri >> task.dur;
        task.id = i;
        pmtasks.at(task.pm - 1).push_back(task);
    }
    for (size_t i = 0; i < pmtasks.size(); i++)
    {
        auto& tasks = pmtasks.at(i);
        if (tasks.size() == 0) continue;
        sort(tasks.begin(), tasks.end(), [](Task & t1, Task & t2)
        {
            if (t1.pri == t2.pri)
            {
                if (t1.dur == t2.dur)
                {
                    return t1.time < t2.time;
                }
                else return t1.dur < t2.dur;
            }
            else return t1.pri > t2.pri;
        });
    }
    vector<Programer> pros(m);
    while (p > 0)
    {
        sort(pros.begin(), pros.end(), [&](Programer & t1, Programer & t2)
        {
            return t1.t < t2.t;
        });
        p -= pros.begin()->doTask();
    }
    for (auto &it : result)
        cout << it.second << endl;
    return 0;
}
```

### 题目4

给定一棵树的根节点, 在已知该树最大深度的情况下, 求节点数最多的那一层并返回具体的层数。

如果最后答案有多层, 输出最浅的那一层，树的深度不会超过100000。实现代码如下，请指出代码中的多处错误：

```
struct Node {

  vector<Node*> sons;

};

void dfsFind(Node *node, int dep, int counter[]) {

  counter[dep]++;

  for(int i = 0; i < node.sons.size(); i++) {

     dfsFind(node.sons[i], dep, counter);

  }

}

int find(Node *root, int maxDep) {

  int depCounter[100000];

  dfsFind(root, 0, depCounter);

 

  int max, maxDep;

  for (int i = 1; i <= maxDep; i++) {

    if (depCounter[i] > max) {

      max = depCounter[i];

      maxDep = i;

    }

  }

  return maxDep;

}
```

1. 树的深度有可能为100000，数组应该初始化为长度为100001.

2. 在dfsFind中，递归访问子节点应该将树的深度+1：

```
for(int i = 0; i < node.sons.size(); i++) { 

  dfsFind(node.sons[i], dep+1, counter); 

}
```

3. dfsFind函数中，node是指针，所以访问其成员函数sons时应该用 '->'而不是 '.'

```
dfsFind(node->sons[i], dep+1, counter);
```

4. 在最后求最大值的循环前，变量int max没有初始化。maxDep是函数传入的值，不应该再次定义，改定义为depth_res。

```
int max = 0;

int depth_res = 0;
```

在循环求最大值中，以及最终的返回结果都应该是depth_res.

### 题目5

早期短链接广泛应用于图片上传网站，通过缩短网址URL链接字数，达到减少代码字符串的目的。常见于网店图片分类的使用，因有字符个数限制，采用短链接可以达到外链图片的目的。自微博盛行以来，在微博字数有限的特色下，短链接也盛行于微博网站，以节省字数给博主发布更多文字的空间。

问题描述：设计一个短链生成和查询系统，需要提供以下两个功能：

  1、提供长链转换短链的接口

  2、点击短链能跳转到对应的长链

题目要求：

  1、同一个长链生成同一个短链接，不要有多个短链指向同一个长链。

  2、同一个短链只能指向某一个长链，短链生成后要固定不变，不能再指向其它长链。

  3、给出系统架构，需要考虑高并发解决方案。

  4、考虑存储和缓存方案

数据量预估：

  1、预计长链接总量500亿

  2、长链换短链请求量：10W qps

  3、短链跳转请求量：100W qps

映射方法：
1、设计记号器，服务端每进入一个长联接，记号器就加一计数，计数器计数值转为62进制格式，在6位数之内可以满足存储500亿长连接的存储和映射关系

2、系统基本架构由服务器、客户端组成 使用nginx进行并发处理操作

3、存储数据结构为链表，链表顺序为记号器从大到小的顺序
