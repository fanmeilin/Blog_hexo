---
title: 研究新意度和论文思路方法
tags: [文献]
categories: [文献]
date: 2022-02-11 11:50:23
math: true
---

> 参考李沐的相关视频
>
> [研究新意度的五大误解](https://www.bilibili.com/video/BV1ea41127Bq?spm_id_from=333.999.0.0)
>
> [如何找论文思路1--打补丁法](https://www.bilibili.com/video/BV1qq4y1z7F2?spm_id_from=333.999.0.0)



## 文章的新意度​ :mag_right:

可能在发表文章的时候，经常会被吐槽文章的新意度不够。

$研究价值=新意度 \times 有效性 \times 问题大小$

有效性可以用实验结果的好坏衡量，问题大小可以在研究领域中有多少研究者，发表了多少篇论文来大致衡量。

查阅一位学术大佬Michael Black的一篇博客 科学中的新意度 （[Novelty in Science](https://perceiving-systems.blog/en/news/novelty-in-science)）他的副标题是A guide for reviewers 给审稿人的指南。

![](https://picture.mulindya.com/read_paper-1.png)

I see reviewers regularly mistake **complexity**, **difficulty**, and **technicality** for **novelty**. In science reviewing, novelty seems to imply these things. We might be better served by removing the word "novelty" from the review instructions and replacing it with ***beauty***. 

审稿人经常会把复杂度，困难度和技术度与新意度搞混，他建议在评审时把新意度拿掉，换成*优美*。

对于理论研究者而言，之前所说的判断价值的方法就失效了哦~，对理论研究的判断一般会使用两个词，深刻和优美，深刻就是说是否揭示了本质的东西，优美是指定理的本身和其相关的证明是否有美感，优美的好处是把技术性和复杂性剥除

来看看审稿人对于novelty的误区

### **Novelty as complexity**

The simplicity of an idea is often confused with a lack of novelty when exactly the opposite is often true.  A common review critique is

*The idea is very simple. It just changes one term in the loss and everything else is the same as prior work.*

**If nobody thought to change that one term, then it is *ipso facto* novel.** The inventive insight is to realize that a small change could have a big effect and to formulate the new loss.  

Such reviews lead my students to say that we should make an idea appear more complex so that reviewers will find it of higher value.  **I value simplicity over unnecessary complexity; the simpler the better.** Taking an existing network and replacing one thing is better science than concocting a whole new network just to make it look more complex.

误区一：用复杂度衡量新意度；应该是大道至简！

### **Novelty as difficulty**

It's hard to get a paper into a top conference, therefore reviewers often feel that the ideas and technical details must be difficult.  The authors have to shed blood, sweat, and tears to deserve a paper. Inexperienced reviewers, in particular, like to see that the authors have really worked hard. 

Formulating a simple idea means stripping away the unnecessary to reveal the core of something. This is one of the most useful things that a scientist can do. 

**A simple idea can be important. But it can also be trivial**（显然的）. This is where reviewers struggle. A trivial idea is an unimportant idea. If a paper has a simple idea that works better than the state of the art, then it is most likely not trivial.  The authors are onto something and the field will be interested.

误区二：用困难度衡量新意度；简单有效证明最核心的东西。方法简单但非常有效

### **Novelty as surprise**

Novelty and surprise are closely related. A novel idea is a surprising one by definition -- it's one that nobody in the field thought of.  But there is a flip side to this as surprise is a fleeting emotion. If you hear a good idea, there is a moment of surprise and then, the better it is, the more obvious it may seem. A common review:

*The idea is obvious because the authors just combined two well known ideas.*

Obvious is the opposite of novelty. So, if an idea is obvious *after* you've heard it, reviewers quickly assume it isn't novel.  The novelty, however, must be evaluated *before* the idea existed. The inventive novelty was to have the idea in the first place.  If it is easy to explain and obvious in hindsight, this in no way diminishes the creativity (and novelty) of the idea.

误区三：用惊讶程度衡量新意度；A，B被提出，不能说A+B有效果就不够创新了。

### **Novelty as technical novelty**

The most common misconception of reviewers is that novelty pertains to technical details. Novelty (and value) come in many forms in papers. A new dataset can be novel if it does something no other dataset has done, even if all the methods used to generate the dataset are well known. A new use of an old method can be novel if nobody ever thought to use it this way. Replacing a complex algorithm with a simple one provides insight. 

Novelty reveals itself in as many ways as beauty. Before critiquing a paper for a lack to technical novelty ask yourself if the true novelty lies elsewhere.

误区四：技术新意代表新意度；老方法用在新领域就是有创新;

### **Novelty as usefulness or value**

Not all novel ideas are useful. Just the property of being new does not connote value.  We want new ideas that lead us somewhere.  Here, reviewers need to be very careful.  It's very hard to know where a new idea wi

ll take the field because any predictions that we make are based on the field as it is today.

A common review I get is

*The authors describe a new method but I don't know why anyone needs this.*

Lack of utility is indeed an issue but it is very hard to assess with a new idea. Reviewers should be careful here and aware that we all have limited imagination. 

误区五：用有效性或价值来衡量新意度；

#### 作者见解

新意度不等于  复杂度，困难度，惊讶度，技术新意，有效性

新意度 约等于 优美

要懂得欣赏

## 如何寻找研究想法 :bulb:

### 打补丁法

在读论文的时候，读的是一个完整的故事，在自己探索idea的时候，就需要把原文章的东西提炼，改进它的不足之处，再讲好一个故事，勇于尝试。可能会产生很多想法，关键在于验证，做实验去看哪一个效果最好，很多时候思考理论得出的直觉在做实验的时候发现并不是那么回事，但是通过观察实验结果，可以得到一些新的想法，然后再开始做实验，可以再实验中发现一些想法。很多时候，其实每个idea对自己最后都有一定的贡献，把这些东西糅合起来，也可以形成一篇文章。

好处是比较好上手，门槛不太高。

比如说何恺明21年11月份MAE这篇文章，就是糅合了两个东西，缺少一个效果都会大打折扣；这些补丁的作用就是让最后的效果有提升。

MAE

- 基于VIT+BERT
  - 遮住更多的图片块
    - 编码时只处理没有遮住的
- 用Transfomer来输出（解码）

但是也要注意不要在一个问题上打上太多补丁，如果杂乱的填充会显得idea不够优雅。最好在打补丁的时候，可以有一个故事将自己的想法串起来。也就是要有逻辑，讲好故事，不要有太强的违和感。

难点是：这种方法对写作是一个考验，有时可以把不太重要的补丁拿掉，在最后选择哪些论文打补丁也是很有讲究的，选择的论文要新，空间要大。如果一篇论文本身就是打了补丁，再去改进就很难有很好的成就，因为作者在进行自己的改进就可能试过很多方法了。最好是选一些脑洞比较打的论文，比如说VIT刚出来，马上就有很多人去跟进做实验，因为VIT的思想比较新，里面没有做过的想法很多，这种方法对硬件要求也比较高，对财力要求较高。

反过来来讲，也可以去做一些比较新的模型，进行一些改进使得训练更快，转换思路让训练更快更便宜，而不是执着于精度。
