---
title: Exercise 1.34
layout: post
categories: chapter1
---

Suppose we define the procedure
{% highlight scheme %}
(define (f g)
    (g 2))
{% endhighlight %}
Then we have
{% highlight scheme %}
(f square)
; 4
 
(f (lambda (z) (* z (+ z 1))))
; 6
{% endhighlight %}
What happens if we (perversely) ask the interpreter to evaluate the
combination `(f f)`? Explain.

### Solution
The process of evaluating `(f f)` unfolds as follows:
{% highlight scheme %}
(f f)
(f 2)
(2 2)
;The object 2 is not applicable.
{% endhighlight %}
An error occurs as 2 is not a procedure (i.e. _"The object 2 is not
applicable"_) that can be evaluted with the argument 2.
