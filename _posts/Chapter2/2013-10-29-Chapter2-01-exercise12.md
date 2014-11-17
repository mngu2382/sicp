---
title: Exercise 2.45
layout: post
categories: chapter2
---

`right-split` and `up-split` can be expressed as instances of a
general splitting operation. Define a procedure `split` with the
property that evaluating

{% highlight scheme %}
(define right-split (split beside below))
(define up-split (split below beside))
{% endhighlight %}

produces the procedures `right-split` and `up-split` with the same
behaviour as the one already defined.

### Solution

{% highlight scheme %}
(define (split proc1 proc2)
  (lambda (painter n)
    (if (= n 0)
        painter
        (let ((smaller ((split proc1 proc2) painter (- n 1))))
             (proc1 painter (proc2 smaller smaller))))))
{% endhighlight %}
