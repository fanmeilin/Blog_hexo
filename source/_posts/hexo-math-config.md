---
title: hexo中公式显示
date: 2021-08-05 20:38:51
tags: [hexo,fluid,配置]
math: true
---

> 公式的显示问题。Hexo中Mathjax是用于显示公式的插件，但是多行显示会出现问题，有时还会出现乱码的情况。

### 配置

在根目录下的config\_fluid.yml​文件中打开math的相关配置。

```yaml
  # 数学公式，开启之前需要更换 Markdown 渲染器，否则复杂公式会有兼容问题，具体请见：https://hexo.fluid-dev.com/docs/guide/##latex-数学公式
  # Mathematical formula. If enable, you need to change the Markdown renderer, see: https://hexo.fluid-dev.com/docs/en/guide/#math
  math:
    # 开启后文章默认可用，自定义页面如需使用，需在 Front-matter 中指定 `math: true`
    # If you want to use math on the custom page, you need to set `math: true` in Front-matter
    enable: true

    # 开启后，只有在文章 Front-matter 里指定 `math: true` 才会在文章页启动公式转换，以便在页面不包含公式时提高加载速度
    # If true, only set `math: true` in Front-matter will enable math, to load faster when the page does not contain math
    specific: true

    # Options: mathjax | katex
    engine: mathjax

```

### 出现的问题

#### 问题1

- 由于hexo解码时关注{{，}}，%% 等连续字符，会将这部分代码解读为其他带有特殊含义的内容
- 如果公式中恰巧出现了此类字符，会报出上述错误

#### 问题2

- 由于hexo在公式中的`\\`错会成了转义符，也就是说他只看见了一个反斜杠，不会执行换行命令，导致公式堆成一行

### 解决方案

#### 临时方案

##### 针对问题1

- 可以在连续的 `{` `}` `%`中间插入空格，分开就没事了

##### 针对问题2

- 可以将`\\`换成`\\\\`，可以实现公式的多行正确显示

#### 终极方案

- 在官方文档中提到了可以为hexo提供标记，阻止其按照自己的规则解释我们的字符串，显示其原本的含义

- 标记为

  ```
  {% raw %}
  $$
  ...
  $$
  {% endraw %}
  ```

### 多行显示和对齐
- 默认是显示为一行要实现公式多行和对齐可以使用{aligned}模式，使用"&"来标记对齐位置。"\\\\"表示换行

    ```
    $$
    \begin{aligned}
    \boldsymbol{x}^{\mathrm{T}}C\boldsymbol{x}	&=\boldsymbol{x}^{\mathrm{T}}\mathrm{E}\left[\left(X-\mu\right)\left(X-\mu\right)^{\mathrm{T}}\right]\boldsymbol{x} 	
    \\&=\mathrm{E}\left[\boldsymbol{x}^{\mathrm{T}}\left(X-\mu\right)\left(X-\mu\right)^{\mathrm{T}}\boldsymbol{x}\right] 	\\&=\mathrm{E}\left[\left(\left(X-\mu\right)^{\mathrm{T}}\boldsymbol{x}\right)^{\mathrm{T}}\left(\left(X-\mu\right)^{\mathrm{T}}\boldsymbol{x}\right)\right] 	
    \\&=\mathrm{E}\left(\left\Vert \left(X-\mu\right)^{\mathrm{T}}\boldsymbol{x}\right\Vert ^{2}\right) 	
    \\&=\sigma_{X}^{2}
    \end{aligned}
    $$
    ```

- 显示为

{% raw %}
$$
\begin{aligned}
\boldsymbol{x}^{\mathrm{T}}C\boldsymbol{x}	&=\boldsymbol{x}^{\mathrm{T}}\mathrm{E}\left[\left(X-\mu\right)\left(X-\mu\right)^{\mathrm{T}}\right]\boldsymbol{x} 	
\\&=\mathrm{E}\left[\boldsymbol{x}^{\mathrm{T}}\left(X-\mu\right)\left(X-\mu\right)^{\mathrm{T}}\boldsymbol{x}\right] 	\\&=\mathrm{E}\left[\left(\left(X-\mu\right)^{\mathrm{T}}\boldsymbol{x}\right)^{\mathrm{T}}\left(\left(X-\mu\right)^{\mathrm{T}}\boldsymbol{x}\right)\right] 	
\\&=\mathrm{E}\left(\left\Vert \left(X-\mu\right)^{\mathrm{T}}\boldsymbol{x}\right\Vert ^{2}\right) 	
\\&=\sigma_{X}^{2}
\end{aligned}
$$
{% endraw %}

