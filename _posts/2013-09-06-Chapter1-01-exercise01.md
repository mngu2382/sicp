---
layout: post
title: Exerices 1.6 -- 1.8
categories: chapter1
mathjax: true
---

#### Exercise 1.6
Alyssa P. Hacker doesn't see why `if` needs to be provided as a
special form. "Why can't I just define it a an ordinary procedure in
terms of cond?" she asks. Alyssa's friend Eva Lu Ator claims this can
indeed be done, and she defines a new version of `if`:

{% highlight scheme %}
(define (new-if predicate then-clause else-clause)
    (cond (predicate then-clause)
          (else else-clause)))
{% endhighlight %}

Eva demonstrates the program for Alyssa:

{% highlight scheme %}
(new-if (= 2 3) 0 5)
; 5
(new-if (= 1 1) 0 5)
; 0
{% endhighlight %}

Delighted, Alyssa uses `new-if` to rewrite the square-root program:

{% highlight scheme %}
(define (sqrt-iter guess x)
    (new-if (good-enough? guess x)
             guess
             (sqrt-iter (improve guess x)
                        x)))
{% endhighlight %}

What happens when Alyssa attempts to use this to compute square roots?
Explain.

##### Solution
As `new-if` is evaluated in an applicative interpreter, all its
operands are evaluated first.

So that

{% highlight scheme %}
(sqrt-iter (improve guess x) x)
{% endhighlight %}
will be executed regardless of whether the guess is "good enough".
This leads to the indefinite recursion of the `sqrt-iter` procedure.

#### Exercise 1.7
The `good-enough?` test used in computing square roots will not be
very effective for finding the square root of very small numbers.
Also, in real computers, arithmetic operations are almost always
performed with limited precision. This makes our test inadequate for
very large numbers. Explain these statements, with examples showing
how the test fails for small and large numbers. An alternative
strategy for implementing `good-enough?` is to watch how `guess`
changes from one iteration to the next and to stop when the change is
a very small fraction of the guess. Design a square-root procedure
that uses this kind of end test. Does this work better for small and
large numbers?

##### Solution
Based upon Newton's method the following procedures are used to find
the square root of `x`:

{% highlight scheme %}
(define (average x y)
    (/ (+ x y) 2))

(define (improve guess x)
    (average guess (/ x guess)))

(define (good-enough? guess x)
    (< (abs (- (square guess) x)) tol))

(define (sqrt-iter guess x)
    (if (good-enough? guess x)
        guess
        (sqrt-iter (improve guess x)
                   x)))

(define (sqrt x)
    (sqrt-iter 1.0 x))
{% endhighlight %}
where, in `good-enough?`, `tol` is some predetermined tolerance level.

For a small enough `x`, the tolerance may be relative large in
comparion `x`, and since the final `guess` need only be within `tol`
of `x`, it may be realtively far away from `x`. For example, for a
tolerance of `0.001`:

{% highlight scheme %}
(sqrt (square 0.01))
; .03230844833048122
{% endhighlight %}

On the other end of the scale: for large enough `x`, due to the nature
of floating point arithmetic, `guess` may not be significant to the
same level of the tolerance. This would lead to the comparison in
`good-enough?` to always evalute to true causing an indefinite loop
in `square-iter`. For example, again with a tolerance of 0.001, the
following expression does not finish evaluating:

{% highlight scheme %}
(sqrt (square 11111111111111111))
{% endhighlight %}

Redefining a new `good-enough?`

{% highlight scheme %}
(define (good-enough? guess x)
    (< (/ (abs (- guess (improve guess x))) guess) tol))
{% endhighlight %}
the previous failing examples now produce more sensible outputs:

{% highlight scheme %}
(sqrt (square 0.01))
; 1.0000714038711746e-2
(sqrt (square 11111111111111111))
; 11111162851502884.
{% endhighlight %}

#### Exercise 1.8
Newton's method for cubed roots is based on the fact that if $y$ is
an approximation to the cube root of $x$, then a better
approximation is given by the value

$$
\frac{x/y^2 + 2y}{3}
$$

Use this formula to implement a cube-root procedure analogous to the
square-root procedure.

##### Solution
We use `good-enough?` from Exercise 1.7 and redefine `improve` to
write our `cuberoot` procedure:

{% highlight scheme %}
(define (improve guess x)
    (/ (+ (/ x (* guess guess))
          (* 2 guess))
       3))

(define (cuberoot-iter guess x)
    (if (good-enough? guess x)
        guess
        (cuberoot-iter (improve guess x) x)))

(define (cuberoot x)
    (cuberoot-iter 1.0 x))
{% endhighlight %}

Illustrating the use of the procedure

{% highlight scheme %}
(cuberoot (* 2 2 2))
; 2.000004911675504
{% endhighlight %}
