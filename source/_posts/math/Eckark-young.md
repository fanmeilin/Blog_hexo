---
title: Eckark_young定理
date: 2021-08-09 10:57:16
tags: [math,线性代数]
categories: [math,线性代数]
math: true
---

最佳低秩逼近和奇异值的关系(*Eckart*-*Young定理*)
### 定理
Suppose a matrix $A\in \mathbb{R}^{m\times n}$has an SVD-decomposition$A=U\Sigma V^T$. Let $k < r= \mathsf{rank}(A)$and truncated matrix
$$
A_k = \sum_{i=1}^k \sigma_i \mathbf u_i \mathbf v_i^T,
$$
then, for any matrix B of rank k , the minimal error is achieved with $A_k$:

{% raw %}
$$
\min_{\mathsf{rank}(B)=k}||A-B||_2 = || A - A_k||_2 = \sigma_{k+1}.
$$
{% endraw %}

The same holds for Frobenius norm as well

{% raw %}
$$
\min_{\mathsf{rank}(B)=k}||A-B||_F = || A - A_k||_F = \sqrt{\sigma_{k+1}^2 + \cdots + \sigma_p^2}.
$$

{% endraw %}

### 证明 (2-norm case)

Since $U^\ A_k V = \mathrm{diag}(\sigma_1,\ldots, \sigma_k,0,\ldots,0)$ it means that $A_k$ is rank K. Moreover, $U^T (A-A_k) V =  \mathrm{diag}(0,\ldots, 0,\sigma_{k+1},\ldots, \sigma_p)$with the largest singular value is $\sigma_{k+1}$ and thus {% raw %}$||A-A_k||_2 = \sigma_{k+1}$.{% endraw %}

### 证明 (Frobenius norm case)

> Lemma: If $A,B \in \mathbb{R}^{m\times n}$ , with B having rank K , then $\sigma_{k+i}(A) \le \sigma_i(A-B) \text{ for all }\; i.$

To prove the lemma, first consider the case i=1, we have proved that $\sigma_{k+1}(A) \le \sigma_1(A-B) = ||A-B||_2$in the 2-norm case. Then we do the general case:

{% raw %}
$$
\begin{aligned} 	\sigma_i(A-B) = & \sigma_i(A-B) + \sigma_1(B-B_k)\qquad\text{since } B=B_k\\ 	=& \sigma_1(A-B - (A-B)_{i-1}) + \sigma_1(B-B_k)\qquad\\ 	\ge & \sigma_1(A-B - (A-B)_{i-1}+B-B_k)   \\ 	=& \sigma_1(A  - (A-B)_{i-1} -B_k)\\ 	\ge & \sigma_1(A - A_{k+i-1})\\ 	=& \sigma_{k+i}(A)   \end{aligned} 
$$
{% endraw %}



> https://zhuanlan.zhihu.com/p/361938622
>
> https://zhuanlan.zhihu.com/p/75283604
