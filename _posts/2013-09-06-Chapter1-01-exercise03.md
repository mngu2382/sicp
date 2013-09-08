---
layout: post
title: Exerices 1.11 -- 1.13
categories: chapter1
mathjax: true
---

#### Exercise 1.11
A function $f$ is defined by the rule that

$$
f(n) = \begin{cases}
  n & \text{if $n\lt 3$}\\\\
  f(n-1)+2f(n-2)+3f(n-3) & \text{if $n\ge3$}
  \end{cases}
$$

Write a procedure that computes $f$ by means of a recursive process.
Write a procedure that computee $f$ by means of an iterative process.

##### Solution
The recursive process:

{% highlight scheme %}
(define (fn n)
    (if (< n 3)
        n
        (+ (fn (- n 1))
           (* 2 (fn (- n 2)))
           (* 3 (fn (- n 3))))))
{% endhighlight %}

The itertive process:

{% highlight scheme %}
(define (fn1 n)
    (define (fn-iter a b c i)
        (if (= n i)
            (+ (* 3 a) (* 2 b) c)
            (fn-iter b c (+ (* 3 a) (* 2 b) c) (+ i 1))))
    (if (< n 3)
        n
        (fn-iter 0 1 2 3)))
{% endhighlight %}

#### Exercise 1.12
The following pattern of numbers is called _Pascal's triangle_.

            1
          1   1
        1   2   1
      1   3   3   1
    1   4   6   4   1
Write a procedure that computes elements of Pascal's triangle by
means of a recursive process.

##### Solution
Using the properties of binomial coefficients, which can be expressed
as

$$
\binom{n}{m} = \binom{n-1}{m-1} + \binom{n-1}{m}
$$

{% highlight scheme %}
(define (choose n m)
    (cond ((or (= n m) (= m 0)) 1)
          ((or (= m (- n 1)) (= m 1)) n)
          (else (+ (choose (- n 1) m)
                   (choose (- n 1) (- m 1))))))
{% endhighlight %}

#### Exercise 1.3
Prove that $\text{Fib}(n)$ is the closest integer to
$\varphi^n/\sqrt{5}$, where $\varphi = (1 + \sqrt{5})/2$.

Hint: Let $\psi = (1-\sqrt{5})/2$. Use induction and the definition of
the Fibonacci numbers to prove that
$\text{Fib}(n)= (\varphi^n-\psi^n)/\sqrt{5}$.

##### Solution
To prove

$$
\text{Fib}(n)= (\varphi^n-\psi^n)/\sqrt{5}\tag{$\star$}
$$

by induction, we firstly note that the identity is true for $n=0$ and
$n=1$.

Next, assuming that the following two equalities hold true

$$
\begin{align}
\text{Fib}(n-1) &= (\varphi^{n-1}-\psi^{n-1})/\sqrt{5}\\\\
\text{Fib}(n-2) &= (\varphi^{n-2}-\psi^{n-2})/\sqrt{5}
\end{align}
$$

we have

$$
\begin{align}
\text{Fib}(n) &= \text{Fib}(n-1) + \text{Fib}(n-2)\\\\
  &=(\varphi^{n-1}+\varphi^{n-2}-\psi^{n-1}-\psi^{n-2})/\sqrt{5}\\\\
  &=\bigr(\varphi^{n-2}(\varphi+1)-\psi^{n-2}(\psi+1)\bigl)/\sqrt{5}\\\\
  &=(\varphi^2-\psi^2)/\sqrt{5}
\end{align}
$$

as $\varphi^2=\varphi + 1$ and $\psi^2 = \psi + 1$. Thus we have proved
$(\star)$.

Now, noting that $\psi^{n}/\sqrt{5} < 0.5$ for all $n\ge0$ and that
$\text{Fib}(n)=(\varphi^n-\psi^n)/\sqrt{5}$ is an integer, we see
that $\text{Fib}(n)$ must be the closest integer to
$\varphi^n/\sqrt{5}$.
