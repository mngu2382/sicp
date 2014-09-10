---
layout: post
title: Exerices 1.16 -- 1.19
categories: chapter1
mathjax: True
---

## Exercise 1.16
Design a procedure that evolves an iterative exponentiation process
that uses successive squaring and uses a logarithmic number of steps,
as does `fast-expt`. (Hint: Using the observation that
$(b^{n/2})^2 = (b^2)^{n/2}$, keep, along with the exponent $n$ and
the base $b$, an additional state variable $a$, and define that
state transformation in such a way that the product $ab^n$ is
unchanged from state to state. At the beginning of the process $a$
is taken to be 1, and the answer is given by the value of $a$ at the
end of the process. In general, the technique of defining an _invariant
quantity_ that remains unchanged from state to state is a powerful
way to think about the design of iterative algorithms.)

### Solution

{% highlight scheme %}
(define (fast-expt b n)
    (define (expt-iter a b n)
        (cond ((= n 0) a)
              ((even? n) (expt-iter a (square b) (/ n 2)))
              (else (expt-iter (* a b) b (- n 1)))))
    (expt-iter 1 b n))
{% endhighlight %}

## Exercise 1.17
The exponentiation algorithms in this section are base on performing
exponentiation by means of repeated multiplication. In a similar way,
one can perform integer multiplication by means of repeated addition.
The following multiplication procedure (in which it is assumed that
our language can only add, not multiply) is analogous to the `expt`
procedure:

{% highlight scheme %}
(define (* a b)
    (if (= b 0)
        0
        (+ a (* a (- b 1)))))
{% endhighlight %}

This algorithm take a number of steps that is linear in `b`. Now
suppose we include, together with addition, operations `double`, which
doubles an integer, and `halve`, which divides an (even) integer by 2.
Using these, design a multiplication procedure analogous to
`fast-expt` that uses a logarithmic number of steps.

### Solution

{% highlight scheme %}
(define (fast-multiply a b)
    (if (< (abs a) (abs b))
        (fast-multiply b a)
        (cond ((= 0 b) 0)
              ((even? b) (double (fast-multiply a (halve b))))
              (else (+ a (fast-multiply a (- b 1)))))))
{% endhighlight %}

## Exercise 1.18
Using the results of Exercise 1.16 and Exercise 1.17, devise a
procedure that generates an iterative process for multiplying two
integers in terms of adding, doubling, and halving and uses a
logarithmic number of steps.

### Solution

{% highlight scheme %}
(define (fast-multiply a b)
    (define (multiply-iter x y acc)
        (cond ((= y 0) acc)
              ((even? y) (multiply-iter (double x) (halve y) acc))
              (else (multiply-iter x (- y 1) (+ acc x)))))
    (if (< (abs a) (abs b))
        (multiply-iter b a 0)
        (multiply-iter a b 0)))
{% endhighlight %}

## Exercise 1.19

There is a clever algorithm for computing the Fibonacci numbers in a
logarithmic number of steps. Recall the transformation of the state
$a$ and $b$ in the `fib-iter` process of of Section 1.2.2:

$$
\begin{align}
a&\leftarrow a+b\\\\
b&\leftarrow a.
\end{align}
$$

Call the transformation $T$, and observe that applying $T$ over
and over again $n$ times, starting with 1 and 0, produces the pair

$$
\begin{align}
&\mathrm{Fib}(n+1)\\\\
&\mathrm{Fib}(n).
\end{align}
$$

In other words, the Fibonacci numbers are produced by applying $T^n$,
the $n^{th}$ power of the transformation $T$, starting with the
pair $(1,0)$.

Now consider $T$ to be the special case of $p=0$ and $q=1$ in a
family of transformation $T_{pq}$, where
$T_{pq}$ transforms the
pair $(a,b)$ according to

$$
\begin{align}
a&\leftarrow bq+aq+ap\\\\
b&\leftarrow bq+aq.
\end{align}
$$

Show that if we apply such a transformation $T_{pq}$ twice, the effect
is the same as using a single transformation $T_{p'q'}$ of the same
form, and compute $p'$ and $q'$ in terms of $p$ and $q$.

This gives us an explicit way to square these transformations, and
this we can compute $T^n$ using successive squaring, as in the
`fast-expt` procedure. Put this all together to complete the following,
which runs a logarithmic number of steps:

{% highlight scheme %}
(define (fib n)
  (fib-iter 1 0 0 1 n))

(define (fib-iter a b p q count)
  (cond ((= count 0) b)
        ((even? count)
         (fib-iter a
                   b
                   <??>       ; compute p'
                   <??>       ; compute q'
                   (/ count 2)))
        (else (fib-iter (+ (* b q) (* a q) (* a p))
                        (+ (* b p) (* a q))
                        p
                        q
                        (- count 1)))))
{% endhighlight %}

### Solution
Applying $T_{pq}$ to $a_0,b_0$

$$
\begin{align}
a_1 &= b_0q+a_0q+a_0p\\\\
b_1 &= b_0p+a_0q
\end{align}
$$

Applying the transformation a second time to $a_0,b_0$

$$
\begin{align}
a_2 &= b_1q+a_1q+a_1p\\\\
  &= (b_0p+a_0q)q + ( b_0q+a_0q+a_0p)q + (b_0q+a_0q+a_0p)p\\\\
  &= b_0(2pq+q^2) + a_0(2pq+q^2) + a_0(q^2+p^2)\\\\
b_2 &= b_1p+a_1q\\\\
  &= ( b_0p+a_0q)p + (b_0q+a_0q+a_0p)q\\\\
  &= b_0(p^2+q^2) + a_0(2pq+q^2)
\end{align}
$$

Thus

$$
T_{pq}^2(a,b) = T_{p'q'}(a,b)
$$

where $p'=p^2+q^2$ and $q'=2pq+q^2$.

So completing the above code:

{% highlight scheme %}
(define (fib1 n)
  (fib-iter1 1 0 0 1 n))

(define (fib-iter1 a b p q count)
  (cond ((= count 0) b)
        ((even? count)
         (fib-iter1 a
                   b
                   (+ (square p) (square q))
                   (+ (* 2 p q) (square q))
                   (/ count 2)))
        (else (fib-iter1 (+ (* b q) (* a q) (* a p))
                        (+ (* b p) (* a q))
                        p
                        q
                        (- count 1)))))
{% endhighlight %}

