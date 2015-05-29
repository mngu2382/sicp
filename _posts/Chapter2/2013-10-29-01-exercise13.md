---
title: Exercise 2.46 -- 2.47
layout: post
categories: chapter2
mathjax: true
---

<a name="Ex2.46"> </a>

## Exercise 2.46

A two-dimensional vector $\boldsymbol{v}$ running from the origin to a
point to can be represented as a pair consisting of an $x$-coordinate
and a $y$-coordinate. Implement a data abstraction for vectors by
giving a constructor `make-vect` and corresponding selectors
`xcor-vect` and `ycor-vect`. In terms of your selector and
constructors, implement procedures `add-vect`, `sub-vect`, and
`scale-vect` that perform the operations vector addition, vector
subtraction, and multiplying a vector by a scalar:

$$
\begin{align}
(x_1,y_1) + (x_2,y_2) &= (x_1 + x_2,y_1 +y_2)\\\\
(x_1,y_1) - (x_2,y_2) &= (x_1 - x_2,y_1 -y_2)\\\\
s\cdot(x,y) &= (sx,sy)
\end{align}
$$

### Solution

{% highlight scheme %}
(define (make-vect x y)
  (cons x y))

(define (xcor-vect vect)
  (car vect))

(define (ycor-vect vect)
  (cdr vect))

(define (add-vect v1 v2)
  (make-vect (+ (xcor-vect v1) (xcor-vect v2))
             (+ (ycor-vect v1) (ycor-vect v2))))

(define (sub-vect v1 v2)
  (make-vect (- (xcor-vect v1) (xcor-vect v2))
             (- (ycor-vect v1) (ycor-vect v2))))

(define (scale-vect v s)
   (make-vect (* s (xcor-vect v1))
              (* s (ycor-vect v2))))
{% endhighlight %}

<a name="Ex2.47"> </a>

## Exercise 2.47

Here are two possible constructors for frames:

{% highlight scheme %}
(define (make-frame origin edge1 edge2)
  (list origin edge1 edge2))

(define (make-frame origin edge1 edge2)
  (cons origin (cons edge1 edge2)))
{% endhighlight %}

For each constructor supply the appropriate selectors to produce an
implementation for frames.

### Solution

{% highlight scheme %}
; the origin and edge1 selectors are common for both constructors
(define (origin-frame frame)
  (car frame))

(define (edge1-frame frame)
  (car (cdr frame)))

; edge2 selector for list make-frame
(define (edge2-frame frame)
  (car (cdr (cdr frame))))

; edge2 selector for cons make-frame
(define (edge2-frame frame)
  (cdr (cdr frame)))
{% endhighlight %}
