---
title: Exercise 2.48 -- 2.49
layout: post
categories: chapter2
---

<a name="Ex2.48"> </a>
#### Exercise 2.48

A directed line segment in the plane can be represented as a pair of
vectors -- the vector running from the origin to the start-point of
the segment, and the vector running from the origin to the end-point
of the segment. Use your vector representation from
[Exercise 2.46]({{ site.baseurl }}/chapter2/Chapter2-01-exercise13.html)
to define a representation for segments with a constructor
`make-segment` and selectors `start-segment` and `end-segment`.

##### Solution

{% highlight scheme %}
(define (make-segment v1 v2)
  (cons v1 v2))

(define (start-segment seg)
  (car seg))

(define (end-segment seg)
  (cdr seg))
{% endhighlight %}

<a name="Ex2.49"> </a>
#### Exercise 2.49

Use `segments->painter` to define the following primitive painters:

1. The painter that draws the outline of the designated frame.
2. The painter that draws an “X” by connecting opposite corners of the
   frame.
3. The painter that draws a diamond shape by connected the midpoints
   of the sides of the frame.
4. The `wave` painter.

##### Solution

{% highlight scheme %}
; we define the corners of the frame (used for 1. and 2.)
(define c1 (make-vect 0 0))
(define c2 (make-vect 0 1))
(define c3 (make-vect 1 1))
(define c4 (make-vect 1 0))

; 1. outline of frame
(define outline
  (segments->painter (list (make-segment c1 c2)
                           (make-segment c2 c3)
                           (make-segment c3 c4)
                           (make-segment c4 c1))))

; 2. X in frame
(define X
  (segments->painter (list (make-segment c1 c4)
                           (make-segment c2 c3))))

; 3. diamond in frame
; we define the corners of the diamond
(define d1 (make-vect 0.5 0))
(define d2 (make-vect 0 0.5))
(define d3 (make-vect 0.5 1))
(define d4 (make-vect 1 0.5))

(define diamond
  (segments->painter (list (make-segment d1 d2)
                           (make-segment d2 d3)
                           (make-segment d3 d4)
                           (make-segment d4 d5))))
{% endhighlight %}
