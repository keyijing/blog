---
layout: post
post: true
title: "Interactive Proofs with Public Coins"
date: 2025-07-02
description: "Arthur-Merlin proof"
tags:
  - TCS
---

## Arthur-Merlin proof

在交互式证明 $\textbf{IP}$ 类中，verifier 与 prover 交互时，verifier 可以使用 prover 不可见的 private coins 来产生随机性。如果要求 verifier 的随机串完全对 prover 公开，就得到了新的复杂度类 public-coin proof。Public-coin proof 也叫做 Arthur-Merlin proof，其中 Arthur 是 verifier，Merlin 是 prover。Arthur 只能向 Merlin 发送随机串，而 Merlin 需要根据接收到的随机串返回字符串。

> [!blue] 定义（$\textbf{AM}[k]$）
>
> $\textbf{AM}[k]$ 是 $\textbf{IP}[k]$ 的子集，要求 verifier 发送的信息只能是随机串，并且不能使用其他的随机性。

例如，$\textbf{AM}[2]$ 交互 $2$ 轮，首先 Arthur 向 Merlin 发送一个随机串，接着 Merlin 返回一个字符串，最后 Arthur 根据以上信息进行判定。形式化地，对于语言 $L\subseteq\{0,1\}^*$，$L\in\textbf{AM}[2]$ 当且仅当存在多项式时间图灵机 $V$ 与多项式 $p$ 使得

- Completeness：$x\in L\Longrightarrow\mathbb{P}_{r\sim U_{p(|x|)}}\left[\exists u\in\{0,1\}^{p(|x|)}\text{ s.t. }V(x,u,r)=1\right]\ge\frac{2}{3}$

- Soundness：$x\notin L\Longrightarrow\mathbb{P}_{r\sim U_{p(|x|)}}\left[\forall u\in\{0,1\}^{p(|x|)},V(x,u,r)=0\right]\ge\frac{2}{3}$

> [!blue] 定义（$\textbf{MA}$）
>
> $\textbf{MA}$ 也是一种 Arthur-Merlin proof。Merlin 先发送一个字符串，然后 Arthur 生成一个随机串，接着根据以上信息进行判定。形式化地，对于语言 $L\subseteq\{0,1\}^*$，$L\in\textbf{MA}$ 当且仅当存在多项式时间图灵机 $V$ 与多项式 $p$ 使得
>
> - Completeness：$x\in L\Longrightarrow\exists u\in\{0,1\}^{p(|x|)}\text{ s.t. }\mathbb{P}_{r\sim U_{p(|x|)}}\left[V(x,u,r)=1\right]\ge\frac{2}{3}$
> - Soundness：$x\notin L\Longrightarrow\forall u\in\{0,1\}^{p(|x|)},\mathbb{P}_{r\sim U_{p(|x|)}}\left[V(x,u,r)=0\right]\ge\frac{2}{3}$
>

> [!green] 定理
>
> $\textbf{MA}\subseteq\textbf{AM}[2]$
>
> > [!yellow]- 证明
> >
> > 对任意语言 $L\in\textbf{MA}$，首先可以通过 error reduction 使得
> >
> > - Completeness：$x\in L\Longrightarrow\exists u\in\{0,1\}^{p(|x|)}\text{ s.t. }\mathbb{P}_{r\sim U_{p(|x|)}}\left[V(x,u,r)=1\right]\ge\frac{2}{3}$
> > - Soundness：$x\notin L\Longrightarrow\forall u\in\{0,1\}^{p(|x|)},\mathbb{P}_{r\sim U_{p(|x|)}}\left[V(x,u,r)=1\right]\le\frac{1}{3\cdot 2^{p(|x|)}}$
> >
> > 显然
> >
> > $$x\in L\Longrightarrow\mathbb{P}_{r\sim U_{p(|x|)}}\left[\exists u\in\{0,1\}^{p(|x|)}\text{ s.t. }V(x,u,r)=1\right]\ge\frac{2}{3}$$
> > 同时由 Union Bound 知
> > 
> > $$x\notin L\Longrightarrow\mathbb{P}_{r\sim U_{p(|x|)}}\left[\exists u\in\{0,1\}^{p(|x|)}\text{ s.t. }V(x,u,r)=1\right]\le\frac{1}{3}$$
> > 因此 $L\in\textbf{AM}[2]$。

可以证明，对任意常数 $k$ 均有 $\textbf{AM}[k]=\textbf{AM}[2]$。

## AM[poly]=IP[poly]

事实上，增加 public coins 的限制并不会改变 $\textbf{IP}$ 的定义。

> [!green] 定理
>
> $\textbf{AM}[\text{poly}]=\textbf{IP}[\text{poly}]$
> > [!yellow]- 证明
> >
> > 对任意语言 $L\in\textbf{IP}[\text{poly}]$，不妨设每轮 verifier 只发送 $1$ 个 bit，否则可以将多个 bit 分多轮发送。同时假设 verifier 所需的随机串在交互开始前就已经确定，设其长度为 $p(n)$。
> >
> > 给定输入 $x$，对于每个随机串 $r\in\{0,1\}^{p(|x|)}$，记 $u_r$ 为交互过程中 verifier 发送的所有字符串拼接成的串。不妨设所有 $u_r$ 均长为 $q(|x|)$ 且互不相同，可以通过在交互结束时 verifier 额外发送 $r$ 来满足这一条件。
> >
> > 将所有 $u_r$ 建成一棵 Trie 树 $T$，则 $T$ 恰好有 $2^{p(|x|)}$ 个叶节点，每个叶节点代表一种随机性。对每个点 $v$，记 $N_v$ 表示点 $v$ 的子树中有多少叶节点接受 $x$。记 $T$ 的根节点为 $v_\text{start}$。考虑构造一个 Arthur-Merlin proof 协议，Merlin 需要说服 Arthur $N_{v_\text{start}}\ge\frac{2}{3}\cdot 2^{p(|x|)}$。
> >
> > 该协议由 $q(|x|)$ 步构成，初始时 Arthur 位于 $T$ 的根节点，每步结束时 Arthur 会进入当前节点的某个子节点。设当前 Arthur 位于点 $v$。首先 Merlin 发送 $M_v$，声称 $N_v=M_v$，当 $v$ 是叶节点时 Arthur 容易验证其正确性。否则设 $v$ 的子节点为 $v_0,v_1$，Merlin 需再发送 $M_{v_0},M_{v_1}$，声称 $N_{v_0}=M_{v_0},N_{v_1}=M_{v_1}$。然后 Arthur 需要对其进行验证，先验证 $M_{v_0}+M_{v_1}=M_v$，接下来 Arthur 发送一个随机串，根据该随机串以 $\frac{M_{v_0}}{M_v}$ 的概率走到 $v_0$，以 $\frac{M_{v_1}}{M_v}$ 的概率走到 $v_1$，递归验证某个子节点。
> >
> > 显然该协议的 completeness 为 $1$。对于 soundness，有如下引理
> >
> > > [!teal]- $p_v:=\mathbb{P}[\text{接受 $x$ | 当前位于点 $v$}]\le\frac{N_v}{M_v}$。
> > >
> > > 对 $v$ 归纳，当 $v$ 是叶节点时，由 $N_v\in\{0,1\}$ 知结论显然成立。否则设 $v$ 的子节点为 $v_0,v_1$，则 $p_v=\frac{M_{v_0}}{M_v}p_{v_0}+\frac{M_{v_1}}{M_v}p_{v_1}$，由归纳假设知 $p_v\le\frac{M_{v_0}}{M_v}\cdot\frac{N_{v_0}}{M_{v_0}}+\frac{M_{v_1}}{M_v}\cdot\frac{N_{v_1}}{M_{v_1}}=\frac{N_v}{M_v}$。
> >
> > 若 $x\notin L$，则 $N_{v_\text{start}}\le\frac{1}{3}\cdot 2^{p(|x|)}$，当 $M_{v_\text{start}}\ge\frac{2}{3}\cdot 2^{p(|x|)}$ 时 $\mathbb{P}[\text{接受 $x$}]\le\frac{1}{2}$。再通过 error reduction 即可使 soundness 升至 $\frac{2}{3}$ 以上。

事实上，进一步可以证明，对任意 $k:\mathbb{N}\to\mathbb{N}$ 均有 $\textbf{IP}[k]\subseteq\textbf{AM}[k+2]$。

## Perfect completeness for AM

Perfect completeness 限制就是要求交互协议的 completeness 为 $1$。由 $\textbf{IP}[\text{poly}]=\textbf{PSPACE}$ 的证明不难发现 perfect completeness 限制不改变 $\textbf{IP}[\text{poly}]$ 的定义。

> [!green] 定理
>
> Perfect completeness 限制不改变 $\textbf{MA}$ 的定义。
>
> > [!yellow]- 证明
> >
> > 对任意语言 $L\in\textbf{MA}$，首先可以通过 error reduction 使得
> >
> > - Completeness：$x\in L\Longrightarrow\exists u\in\{0,1\}^{p(|x|)}\text{ s.t. }\mathbb{P}_{r\sim U_{p(|x|)}}\left[V(x,u,r)=1\right]\ge 1-\frac{1}{2^{|x|}}$
> > - Soundness：$x\notin L\Longrightarrow\forall u\in\{0,1\}^{p(|x|)},\mathbb{P}_{r\sim U_{p(|x|)}}\left[V(x,u,r)=1\right]\le\frac{1}{2^{|x|}}$
> >
> > 给定 $x,u$，记 $S_{x,u}=\left\{r\in\{0,1\}^{p(|x|)}:V(x,u,r)=1\right\}$。考虑如下引理
> >
> > > [!teal] 引理
> > >
> > > 设 $m=\text{poly}(n)$，$S\subseteq\{0,1\}^m$，令 $k=\left\lfloor\frac{m}{n}\right\rfloor+1$。
> > >
> > > 1. 当 $|S|\ge(1-2^{-n})\cdot 2^m$ 时 $\exists z_1,\cdots,z_k\in\{0,1\}^m\text{ s.t. }\left|\bigcup_{i=1}^k(S\oplus z_i)\right|=2^m$；
> > >
> > > 2. 当 $|S|\le 2^{-n}\cdot 2^m$ 时 $\forall z_1,\cdots,z_k\in\{0,1\}^m,\left|\bigcup_{i=1}^k(S\oplus z_i)\right|\le\frac{m+1}{2^n}\cdot 2^m$。
> > >
> > > > [!yellow]- 证明
> > > >
> > > > 首先由 Union Bound 知 (2) 显然成立。对于 (1) 考虑概率方法，令 $z_1,\cdots,z_k$ 从 $\{0,1\}^m$ 中均匀独立采样。对每个 $x\in\{0,1\}^m$
> > > > 
> > > > $$\mathbb{P}_{z_1,\cdots,z_k\overset{\text{i.i.d}}{\sim}U_m}\left[x\notin\bigcup_{i=1}^k(S\oplus z_i)\right]\le (\mathbb{P}_{z\sim U_m}[x\oplus z\notin S])^k\le 2^{-nk}<2^{-m}$$
> > > > 由 Union Bound 知
> > > > 
> > > > $$\mathbb{P}_{z_1,\cdots,z_k\overset{\text{i.i.d}}{\sim}U_m}\left[\exists x\in\{0,1\}^m\text{ s.t. }x\notin\bigcup_{i=1}^k(S\oplus z_i)\right]<1$$
> > > > 因此 (1) 成立。
> >
> > 当 $x\in L$ 时存在 $u$ 使得 $|S_{x,u}|\ge\left(1-2^{-|x|}\right)\cdot 2^{p(|x|)}$，故
> > 
> > $$\exists u,z_1,\cdots,z_k\in\{0,1\}^{p(|x|)}\text{ s.t. }\mathbb{P}_{r\in U_{p(x)}}\left[\bigcup_{i=1}^k V(x,u,r\oplus z_i)=1\right]=1$$
> > 当 $x\notin L$ 时对任意 $u$ 皆有 $|S_{x,u}|\le 2^{-n}\cdot 2^{p(|x|)}$，故
> > 
> > $$\forall u,z_1,\cdots,z_k\in\{0,1\}^{p(|x|)},\mathbb{P}\left[\bigcup_{i=1}^k V(x,u,r\oplus z_i)=1\right]\le\frac{p(|x|)+1}{2^{|x|}}$$
> > 因此新的协议满足 perfect completeness，且 $|x|$ 充分大时满足 soundness 条件。

类似地可以证明

> [!green] 定理
>
> Perfect completeness 限制不改变 $\textbf{AM}[2]$ 的定义。
