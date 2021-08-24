---
title: 博客中的emoji
tags: emoji
categories: [配置,hexo]
date: 2021-08-24 15:00:26
---

> 在博客中使用emoji，可可爱爱小表情:heart_eyes:

> 相关配置参见这个博客哟 [Hexo -19- 添加emoji表情](https://www.zywvvd.com/2021/08/23/hexo/19%20hexo-emoji/hexo-emoji/)
> 可以在这两个网站看看有哪些小表情
> https://www.webfx.com/tools/emoji-cheat-sheet/
> https://www.zywvvd.com/2021/08/13/git/git-emoji/git-emoji/

## 安装渲染器

```
npm un hexo-renderer-marked --save
npm i hexo-renderer-markdown-it --save
```

## 修改配置文件

在_config.yml文件尾部添加下段代码

```
# Markdown-it config
## Docs: https://github.com/celsomiranda/hexo-renderer-markdown-it/wiki
markdown:
  render:
    html: true
    xhtmlOut: false
    breaks: true
    linkify: true
    typographer: true
    quotes: '“”‘’'
  plugins:
    - markdown-it-abbr
    - markdown-it-footnote
    - markdown-it-ins
    - markdown-it-sub
    - markdown-it-sup
    - markdown-it-emoji  # add emoji
```

使用的时候就直接在md文件中用两个引号中间填写emoji的名称即可啦 :happy:

