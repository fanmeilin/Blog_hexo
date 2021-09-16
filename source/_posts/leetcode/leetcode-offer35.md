---
title: 剑指offer35 复杂链表的复制
tags: 剑指
categories: 剑指
date: 2021-09-16 16:50:09
---

> 复杂链表的复制

## 题目

请实现 copyRandomList 函数，复制一个复杂链表。在复杂链表中，每个节点除了有一个 next 指针指向下一个节点，还有一个 random 指针指向链表中的任意节点或者 null。

### 示例 1：

```
输入：head = [[7,null],[13,0],[11,4],[10,2],[1,0]]
输出：[[7,null],[13,0],[11,4],[10,2],[1,0]]

```

### 示例 2：

```
输入：head = [[1,1],[2,1]]
输出：[[1,1],[2,1]]
```

### 示例 3：

```
输入：head = [[3,null],[3,0],[3,null]]
输出：[[3,null],[3,0],[3,null]]
```

### 示例 4：

```
输入：head = []
输出：[]
解释：给定的链表为空（空指针），因此返回 null。
```
### 提示：

- -10000 <= Node.val <= 10000
- Node.random 为空（null）或指向链表中的节点。
- 节点数目不超过 1000 。

## 题解

通常普通的链表复制只需要遍历链表，每轮新建立一个节点，在添加前驱节点到当前节点的引用指向即可，但是本题的节点新增了random指针，因此需要处理random指针。
- 第一种方法是使用`哈希表`
- 第二种方法是使用`拼接+拆分`

#### 哈希表

先构建原链表节点和新链表节点的键值对映射关系，再遍历构建新链表节点的next和random的引用指向。

这里可以直接使用字典，键值对就是（原节点，新节点），然后直接在字典中构建；

```python
class Solution:
    def copyRandomList(self,head:'Node')->'Node':
        if not head:return
        dic = {}
        cur = head
        while cur:
            dic[cur] = Node(cur.val)
            cur = cur.next
        cur = head
        while cur:
            dic[cur].next = dic.get(cur.next)
            dic[cur].random = dic.get(cur.random)
            cur = cur.next
        return dic[head]
```

> dict.get(key,default=None) key是字典中要查找的键，default是指定键值不存在时，返回默认值；

此时时间复杂度为O(N),空间复杂度为O(N)。

#### 拼接+拆分
构建拼接链表`原节点1->新节点1->原节点2->新节点2->......`,这时，在访问原节点的random时可以找到新对应新节点的random的指向节点。
当访问`cur.random`时，对应的新节点`cur.next`的随机指向节点为`cur.random.next`，就可以解决random的问题，再进行拆分链表。

```python
class Solution:
    def copyRandomList(self,head:'Node')->'Node':
		if not head:return
		cur = head
		#复制各个节点，并构建拼接链表
		while cur:
			tmp = Node(cur.val)
			tmp.next = cur.next
			cur.next = tmp
			cur = tmp.next
		#构建random指向
		cur = head
		while cur:
			if cur.random:
				cur.next.random = cur.random.next
            cur = cur.next.next
        #拆分链表
        cur = res = head.next
        while cur.next:
            cur.next = cur.next.next
            cur = cur.next
        return res
```

此时时间复杂度为O(N),空间复杂度为O(1)。
