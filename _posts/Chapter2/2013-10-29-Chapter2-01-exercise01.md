---
title: Exercise 2.1
layout: post
categories: chapter2
---

<a name="Ex2.1"> </a>

Define a better version of `make-rat` that handles both positive and
negative arguments. `make-rat` should normalize the sign so that if
the rational number is positive, both the numerator and denominator
are positive, and if the rational number is negative, only the
numerator is negative.

### Solution
The `make-rat` and `gcd` procedures as define in the text:

{% highlight scheme %}
(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (remainder a b))))

(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (remainder a b))))
{% endhighlight %}

A `make-rat` procedure that handles positive and negative integer
inputs"

{% highlight scheme %}
(define (make-rat n d)
    (let ((sign (if (or (and (< n 0) (< d 0))
                        (and (> n 0) (> d 0)))
                     +
                     -))
          (g (gcd n d)))
         (cons (sign (/ (abs n) g)) (/ (abs d) g))))
{% endhighlight %}
