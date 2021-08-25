---
title: 在博客中显示pdf
tags: [配置,pdf]
categories: [配置]
date: 2021-08-25 16:29:58
---

> 参考师兄的方法配置
> https://www.zywvvd.com/2021/08/15/hexo-theme/fluid/fluid-pdf/fluid-pdf/

## 配置

pdf.js 是用于解析和呈现 PDF 的基于 Web 标准平台的通用解决方案，功能强大。

官方网站：https://mozilla.github.io/pdf.js/

由于我的浏览器的版本可能不高，考虑到兼容性下载旧版的文件。然后按师兄的步骤配置即可。

## 使用

```
<iframe src='/js/pdfjs_old/web/viewer.html?file=https://paper.mulindya.com/An%20Isotropic%203x3%20Image%20Gradient%20Operator.pdf' width=100% height=450></iframe>
```

file设置为文件的地址，宽高可以自己设置。

## 效果

<iframe src='/js/pdfjs_old/web/viewer.html?file=https://paper.mulindya.com/An%20Isotropic%203x3%20Image%20Gradient%20Operator.pdf' width=100% height=450></iframe>
