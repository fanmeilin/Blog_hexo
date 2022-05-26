---
title: 博客bug排查
tags: [报错解决]
categories: [报错解决]
date: 2022-05-24 16:04:30
---

>很久没有更新博客，突然发现博客的界面渲染崩掉了。

执行命令`hexo g` 和`hexo s`

都会出现警告：

```
INFO  Files loaded in 23 s
(node:11164) Warning: Accessing non-existent property 'lineno' of module exports inside circular dependency
(Use `node --trace-warnings ...` to show where the warning was created)
(node:11164) Warning: Accessing non-existent property 'column' of module exports inside circular dependency
(node:11164) Warning: Accessing non-existent property 'filename' of module exports inside circular dependency
(node:11164) Warning: Accessing non-existent property 'lineno' of module exports inside circular dependency
(node:11164) Warning: Accessing non-existent property 'column' of module exports inside circular dependency
(node:11164) Warning: Accessing non-existent property 'filename' of module exports inside circular dependency
```

虽然是警告，但是以前没有遇到过，因此怀疑是版本的问题导致hexo和node不兼容。

**解决方案1**：

出现警告，是因为`node`版本太高，切换成低版本的`node`来安装`Hexo`就可以了.但是不太建议，容易引起其他的依赖问题。

**解决方案2：**

找到下面的文件：
`node_modules\stylus\lib\nodes\index.js`
在`index.js`文件中加上以下代码

```
exports.lineno = null;
exports.column = null;
exports.filename = null;
```

> 但是在我的index.js文件中已经设置了该代码。所以还是不太行~~

**解决办法3：**

Hexo 这里的 warning是由于[stylus](https://link.zhihu.com/?target=https%3A//github.com/stylus/stylus)导致的，幸运的是stylus 在 0.54.8 版本修复了这个问题，所以对于 Hexo 用户来说，重新装一下`hexo-renderer-stylus`，就可正常使用。

```python
npm install hexo-renderer-stylus --save
```

成功解决！

> 参考博客：
>
> https://zhuanlan.zhihu.com/p/397813964
>
> https://blog.csdn.net/m0_46374969/article/details/121727107
