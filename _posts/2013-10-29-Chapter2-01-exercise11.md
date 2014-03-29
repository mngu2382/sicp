---
title: Exercise 2.44
layout: post
categories: chapter2
---

Define the procedure `up-split` used by `corner-split`. It is similar
to `right-split`, except that is switches the roles of `below` and
`beside`.

##### Solution

{% highlight scheme %}
(define (up-split painter n)
  (if (= n 0)
      painter
      (let ((smaller (up-split painter (- n 1))))
        (below painter (beside smaller smaller)))))
{% endhighlight %}
