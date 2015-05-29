---
title: Exercise 2.50 -- 2.51
layout: post
categories: chapter2
---

<a name="Ex2.50"> </a>

## Exercise 2.50

Define the transformation `flip-horiz`, which flips painters
horizontally, and transformations that rotate painters
counterclockwise by 180 and 270 degrees.

### Solution

Analogus to `flip-vert` define in the text we define `flip-horiz`:

{% highlight scheme%}
(define (flip-horiz painter)
  (transform-painter painter
                     (make-vect 1.0 0.0)
                     (make-vect 0.0 0.0)
                     (make-vect 1.0 1.0)))
{% endhighlight %}

And 180 and 270 counterclockwise rotations (we repeatedly apply
`rotate90` defined in the text):

{% highlight scheme %}
(define (rotate90 painter)
  (transform-painter painter
                     (make-vect 1.0 0.0)
                     (make-vect 1.0 1.0)
                     (make-vect 0.0 0.0)))

(define (rotate180 painter)
  (rotate90 (rotate90 painter)))

(define (rotate270 painter)
  (rotate90 (rotate180 painter))
{% endhighlight %}

<a name="Ex2.51"> </a>

## Exercise 2.51

Define the `below` operation for painters. `below` takes two painters
as arguments. The resulting painter, given a frame, draws with the
first painter in the bottom of the frame and with the second painter
in the top. Define `below` in two different ways -- first by writing
a procedure that is analogous to the `beside` procedure given above,
and again in terms of `beside` and suitable rotation operations (from
[Exercise 2.50](#Ex2.51)).

### Solution

Analogous to `beside`:

{% highlight scheme %}
(define (below painter1 painter2)
  (let ((split-point (make-vect 0.0 0.5)))
    (let ((paint-below
           (transform-painter painter1
                              (make-vect 0.0 0.0)
                              (make-vect 1.0 0.0)
                              split-point))
          (paint-above
           (transform-painter painter2
                              split-point
                              (make-vect 0.5 1.0)
                              (make-vect 0.0 1.0))))
         (lambda (frame)
           (paint-above frame)
           (paint-below frame)))))
{% endhighlight %}

Using `beside` and rotations:

{% highlight scheme %}
(define (below painter1 painter2)
  (rotate90 (beside (rotate270 painter1)
                    (rotate270 painter2))))
{% endhighlight %}
