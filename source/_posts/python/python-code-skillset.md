---
title: python刷题常用知识点
tags: [python]
categories: [python]
date: 2022-07-05 16:31:51
---

> 记录python刷题常用的知识点，主要针对的是leetcode，编程题的一些小技巧，常用的函数，balabala...

## 输入输出方法

### 输入

最常见的输入方法是`input()`，默认输入的类型为字符串，可以直接进行类型转换。

- 单一的输入，将输入的内容转化为自己需要的类型。

```python
n = int(input())
m = float(input())
```

多值输入转化为需要的类型 包括一维数组的输入，两个值，三个值的输入

```python
# input().split() 默认是空白字符（若干个空格）来分割字符串  返回的是字符串的列表
'''
string.split(separator, max)
separator: 可选。规定分割字符串时要使用的分隔符。默认值为空白字符。
max: 可选。规定要执行的拆分数。默认值为 -1，即“所有出现次数”。
'''
list1 = list(map(int, input().split())  #map处理结束后转化为列表类型
m1, m2 = map(int, input().split()) #使用map对字符串列表中的元素int操作 后直接赋值到两个变量中
a, b, c = map(float, input().split())
```

``` python
'''
str.strip([chars]) 
chars -- 移除字符串头尾指定的字符序列。
返回移除字符串头尾指定的字符生成的新字符串。
'''
import sys
n = int(sys.stdin.readline().strip()) #使用sys
#一维数组
data= [int(x) for x in stdin.readline().strip().split()]

# 二维数组
import sys
n = int(sys.stdin.readline().strip())
point = []
for i in range(n):
    point.append(list(map(int, sys.stdin.readline().strip().split())))
```

### 输出

常见的输出是print(),默认每次打印之后换行符结尾，如果想要修改，可以对参数end来修改，还可以使用%填充字符串的输出方式，也可以使用str.format()方法。

```python
# 单值打印
print('Hello')
# 多值打印
print('Hello','world',end="")
print()
# 格式化字符串
aName = 'ali'
age = 18
print('%s is %d years old.' % (aName, age))
t = 232.109223
# 使用{}和: 来代替 % 都可以用于保留有效数字
string1 = '{:.2f}'.format(t)
print(string1)
print('{0}, {1:.2f}'.format('Hehe', 20.278))
print('%s, %.2f' % ('Hehe', 20.278))

结果：
Hello
Hello world
ali is 18 years old.
232.11
Hehe, 20.28
Hehe, 20.28
```

## 常用函数

### 创建数组

```python
# 创建一维列表
sqlist = [ x*x for x in range(1, 11)]
print(sqlist)
str2 = [ch.upper() for ch in 'Hello world!' if ch not in 'orld'] #循环和判断语句同时使用
print(str2)
```

```python
创建二维数组 ：
a = [[0 for col in range(m)] for row in range(n)] 
或者[[0]*m for i in range(n)]
但是千万不要用[[0]*m]*n！！是错误的。对象被复制
# 创建一个二维列表5*5
list1 = [[0]*5 for i in range(5)]
print(list1)
# 创建一个3*3的二维数组
arr=[list(map(int,input().split())) for i in range(3)]
```

### 判断变量

`isalpha()` 判断**字符串**是否全是字母；检查一个字符串中所有的字符是否都是由字母构成的，并且至少有1个字符。

`isalnum()`函数判断的**字符**范围不仅包括字母，还包括0-9的数字。

`isdigit()` 判断**字符串**是否全是数字0-9

`is_integer()` 判断浮点数是否为整数

### 字符串操作

#### 基本操作

`join()`: 用法 '分隔符'.join(字符串序列) 比如' '.join(["hello","world","thank","you"]) 输出 “hello world thank you”

`str.count(substr,start,end)`:计数子序列出现的次数

`str.upper()`：字符串转成大写

`str.lower()`：字符串转成小写

##### 补充

- ord()： 将ASCLL码转换为数字。ord('a')返回91

- chr()： 将数字转换为ASCLL码。chr(97) 返回字符串 'a'

- str1.swapcase() : 翻转 str1 中的大小写

- list(str1): 将字符串转化为列表

- ''.join(str1): 将字符串列表，拼成字符串

- srt1.split()：将字符串按一定符号分割，分割后成列表

- srt1.isdigit() : 检测字符串是否由十进制数 0--9组成

- str1.isnumeric(): 检测字符串是否只由数字组成

- srt1.isxdigit() : 检测字符串是否由十六进制数 0--9，a—f，或A--F组成

- srt1.isalnum() : 检测字符串是否由字母数字符号 0--9，a--Z，或A--Z组成

- srt1.isalpha() : 检测字符串是否由字母a--Z或A--Z组成

- srt1.islower(): 检测字符串是否否由小写字母 a--Z组成

- srt1.isupper(): 检测字符串是由 大写字母 A--Z组成

- **strip() / lstrip() / rstrip(): 用于移除字符串头尾 / 开头 / 结尾指定的字符（默认为空格）**

#### 反转

字符串反转 使用切片反转：str[::-1]

##### reverse()

reverse()是python中**列表的一个内置方法**（也就是说，在字典，[字符串](https://so.csdn.net/so/search?q=字符串&spm=1001.2101.3001.7020)或者元组中，是没有这个内置方法的），用于列表中数据的反转；

```python
lista = [1, 2, 3, 4]
lista.reverse() #原地操作 无返回值
print(lista)
[4,3,2,1]
```

##### reversed()

有返回值，是python的自带方法，经过reversed()的作用之后，返回的是一个把序列值经过反转之后的**迭代器**，所以，需要通过遍历，或者List,或者next()等方法，获取作用后的值；

### 列表操作

列表有自带的sort函数，直接对原列表进行更改。

- list1.append（x） ： 将x添加到列表末尾

- list1.sort()： 对列表元素排序 默认**升序** 如果设置为降序：list1.sort(reverse=True)

- list1.reverse() ： 将列表元素逆序

- list1.index(x) ： 返回第一次出现元素x的索引值

- list1.insert(x) ： 在位置i处插入新元素x

- list1.count(x) ： 返回元素x在列表中的数量
- list.remove(value)：删除第一个匹配的值
- list.pop(index)：删除对应位置的元素 

### 字典操作

判断是否含有该元素 ：key in dict 即可

### 列表和字典相关技巧

#### 字典排序

```python
# python 根据 key，value 排序字典
d = {'d': 4, 'a': 1, 'b': 2, 'c':3}
# dict sort by key and reverse
#按照key
print(dict(sorted(d.items())))               # {'a': 1, 'b': 2, 'c': 3, 'd': 4}
print(dict(sorted(d.items(),reverse=True))) # {'d': 4, 'c': 3, 'b': 2, 'a': 1}
#按照value
print(dict(sorted(d.items(),key=lambda d:d[1])))               
print(dict(sorted(d.items(),key=lambda d:d[1],reverse=True)))
```

```python
# 排序嵌套 list
l = [('a', 1), ('c', 2), ('b',3)]
print(sorted(l, key=lambda p:p[0])) # 根据第1个值排序，[('a', 1), ('b', 3), ('c', 2)]
print(sorted(l, key=lambda p:p[1])) # 根据第2个值排序，[('a', 1), ('c', 2), ('b', 3)]
[('a', 1), ('b', 3), ('c', 2)]
[('a', 1), ('c', 2), ('b', 3)]
```
#### 获取最大值和下标

```python
# 同时获取最大值的下标和值
lis = [1,2,5,4,3]
max_index,max_value = max(enumerate(lis),key=lambda iv:iv[1])
print('最大值的下标：',max_index,'、','最大值为：',max_value)
```

```python
# 获取字典对应的最大值对应的 key,value
mydict = {'A':4,'B':10,'C':0,'D':87}
max_key, max_value = max(mydict.items(), key=lambda k: k[1])
print('最大值的key：',max_key,'、','最大值为：',max_value)
```

### 内置函数

`zip()`： 创建一个聚合了来自每个可迭代对象中的元素的迭代器。

```
x = [1, 2, 3]
y = [4, 5, 6]
zipped = zip(x, y)
print(list(zipped)) 
[(1, 4), (2, 5), (3, 6)]
```

zip() 与 \* 运算符相结合可以用来拆解*

```
x2, y2 = zip(*zipped)
```



### 排序

对于字典，字符串等数据结构，必须用sorted函数。
sorted(iterable[, cmp[, key[, reverse]]])

- cmp和key都是函数
- key的输出是cmp的输入
- cmp函数默认是升序

比如

```python
dic = {‘a’:2,’b’:1} 
# 按照key排序
dict1 = sorted(dic.items(),key=lambda d:d[0])
返回[(‘a’,2),(‘b’,1)]
# 按照value排序 
dict2 = sorted(dic.items(),key= lambda d:d[1])
返回元组列表[(‘b’,1),(‘a’,2)]
```

> dic.items() 函数以列表返回可遍历的(键, 值) 元组数组。把字典中每对 key 和 value 组成一个元组，并把这些元组放在列表中返回。

### 数据结构

#### list

普通的栈和队列，使用list即可实现

- append(value) 加入元素
- pop() 出栈
- pop(0) 出队列

#### deque

collections模块的deque（双端队列）

deque是栈和队列的一种广义实现，deque是"double-end queue"的简称；deque支持线程安全、有效内存地以近似O(1)的性能在deque的两端插入和删除元素，尽管list也支持相似的操作，但是它主要在固定长度操作上的优化，从而在pop(0)和insert(0,v)（会改变数据的位置和大小）上有O(n)的时间复杂度。

deque 是一个双端队列, 如果要经常从两端append 的数据, 选择这个数据结构就比较好了, 如果要实现随机访问,不建议用这个,请用列表. deque 优势就是可以从两边append ,appendleft 数据. 这一点list 是没有的.

```python
import collections
d = collections.deque([])
d.append('a') # 在最右边添加一个元素，此时 d=deque('a')
d.appendleft('b') # 在最左边添加一个元素，此时 d=deque(['b', 'a'])
d.extend(['c','d']) # 在最右边添加所有元素，此时 d=deque(['b', 'a', 'c', 'd'])
d.extendleft(['e','f']) # 在最左边添加所有元素，此时 d=deque(['f', 'e', 'b', 'a', 'c', 'd'])
d.pop() # 将最右边的元素取出，返回 'd'，此时 d=deque(['f', 'e', 'b', 'a', 'c'])
d.popleft() # 将最左边的元素取出，返回 'f'，此时 d=deque(['e', 'b', 'a', 'c'])
d.rotate(-2) # 向左旋转两个位置（正数则向右旋转），此时 d=deque(['a', 'c', 'e', 'b'])
d.count('a') # 队列中'a'的个数，返回 1
d.remove('c') # 从队列中将'c'删除，此时 d=deque(['a', 'e', 'b'])
d.reverse() # 将队列倒序，此时 d=deque(['b', 'e', 'a'])
f=d.copy()
print(f)#deque(['b', 'e', 'a'])
f.clear()
print(f)#deque([])
 
#可以指定队列的长度，如果添加的元素超过指定长度，则原元素会被挤出。
e=collections.deque(maxlen=5)
e.extend([1,2,3,4,5])
e.append("a")
print(e)
#deque([2, 3, 4, 5, 'a'], maxlen=5)
e.appendleft("b")
print(e)
#deque(['b', 2, 3, 4, 5], maxlen=5)
e.extendleft(["c","d"])
print(e)
#deque(['d', 'c', 'b', 2, 3], maxlen=5)
```



#### 例题：

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
>     以找左边界为例， 从第二个数起，
>     如果大于前一个数，则左边界为自身；否则：
>         如果等于前一个数，则左边界跟前一个数的左边界一样；
>         如果小于，则它的左边界小于前一个数的左边界；
>         这样可以跳过重复的比较。
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