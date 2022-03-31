---
title: CodeTop_Microsoft146 LRU缓存
tags: [CodeTop,微软,数据结构组合]
categories: [CodeTop,微软,数据结构组合]
date: 2022-03-31 12:08:42
---

>LRU缓存 https://leetcode-cn.com/problems/lru-cache/

## 题目

请你设计并实现一个满足  LRU (最近最少使用) 缓存 约束的数据结构。
实现 LRUCache 类：
LRUCache(int capacity) 以 正整数 作为容量 capacity 初始化 LRU 缓存
int get(int key) 如果关键字 key 存在于缓存中，则返回关键字的值，否则返回 -1 。
void put(int key, int value) 如果关键字 key 已经存在，则变更其数据值 value ；如果不存在，则向缓存中插入该组 key-value 。如果插入操作导致关键字数量超过 capacity ，则应该 逐出 最久未使用的关键字。
函数 get 和 put 必须以 O(1) 的平均时间复杂度运行。

### 示例 1：

```
输入
["LRUCache", "put", "put", "get", "put", "get", "put", "get", "get", "get"]
[[2], [1, 1], [2, 2], [1], [3, 3], [2], [4, 4], [1], [3], [4]]
输出
[null, null, null, 1, null, -1, null, -1, 3, 4]

解释
LRUCache lRUCache = new LRUCache(2);
lRUCache.put(1, 1); // 缓存是 {1=1}
lRUCache.put(2, 2); // 缓存是 {1=1, 2=2}
lRUCache.get(1);    // 返回 1
lRUCache.put(3, 3); // 该操作会使得关键字 2 作废，缓存是 {1=1, 3=3}
lRUCache.get(2);    // 返回 -1 (未找到)
lRUCache.put(4, 4); // 该操作会使得关键字 1 作废，缓存是 {4=4, 3=3}
lRUCache.get(1);    // 返回 -1 (未找到)
lRUCache.get(3);    // 返回 3
lRUCache.get(4);    // 返回 4
```

### 提示：

- 1 <= capacity <= 3000
- 0 <= key <= 10000
- 0 <= value <= 105
- 最多调用 2 * 105 次 get 和 put

## 题解

使用哈希表+双向链表

https://leetcode-cn.com/problems/lru-cache/solution/lruhuan-cun-ji-zhi-by-leetcode-solution/

```python
class ListNode:
    def __init__(self,value=None,key=None): #还要记录key
        self.value = value
        self.key = key
        self.leftnode = None
        self.rightnode = None
class LRUCache:
## 使用双链表和哈希表 这样可以保证O(1)的时间复杂度 新建head tail头尾节点便于对节点操作是一致的，哈希表是key是键 value尾双链表中的node
    def __init__(self, capacity: int):
        self.capacity = capacity
        self.hashmap = {}
        self.head = ListNode()
        self.tail = ListNode()
        self.head.rightnode = self.tail
        self.tail.leftnode = self.head

    def move2tail(self,key):
        node = self.hashmap[key] #查找目标节点
        #更新目标节点的左右节点的连接
        node.leftnode.rightnode = node.rightnode
        node.rightnode.leftnode = node.leftnode

        #移动到尾部
        self.tail.leftnode.rightnode = node
        node.leftnode = self.tail.leftnode
        node.rightnode = self.tail
        self.tail.leftnode = node


    def get(self, key: int) -> int:
        res = self.hashmap.get(key,-1)
        if res==-1:return -1 #不存在时
        self.move2tail(key) #查找到就移动到尾部
        return res.value

    def put(self, key: int, value: int) -> None:
        res = self.hashmap.get(key,-1)
        if res==-1: #不存在
            if len(self.hashmap) == self.capacity:
                #去除第一个节点
                self.hashmap.pop(self.head.rightnode.key) #剔除key  
                #先处理hashmap再修改链表
                self.head.rightnode = self.head.rightnode.rightnode 
                self.head.rightnode.leftnode = self.head  
            node = ListNode(value,key)
            self.hashmap[key] = node

            self.tail.leftnode.rightnode = node
            node.leftnode = self.tail.leftnode
            self.tail.leftnode = node
            node.rightnode = self.tail
        else: #存在 移到末尾
            self.hashmap[key].value = value #注意更新他的value而不是node
            self.move2tail(key)


# Your LRUCache object will be instantiated and called as such:
# obj = LRUCache(capacity)
# param_1 = obj.get(key)
# obj.put(key,value)
```

时间复杂度：对于 put 和 get 都是 O(1)。

空间复杂度：O(capacity)，因为哈希表和双向链表最多存储 capacity+1 个元素。

