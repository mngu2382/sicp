---
title: Exercises 2.21 -- 2.23
layout: post
categories: chapter2
---

<a name="Ex2.21"> </a>
#### Exercise 2.21
The procedure `square-list` takes a list of numbers as arguments and
returns a list of the square of those numbers.

{% highlight scheme %}
(square-list (list 1 2 3 4))
; (1 4 9 16)
{% endhighlight %}

Here are two different definitions of `square-list`. Complete both of
them by filling in the missing expressions:

{% highlight scheme %}
(define (square-list items)
    (if (null? items)
        nil
        (cons <??> <??>)))

(define (square-list items)
    (map <??> <??>))
{% endhighlight %}

##### Solution
{% highlight scheme %}
(define (square-list items)
    (if (null? items)
        nil
        (cons (square (car items)) (square-list (cdr items)))))

(define (square-list items)
    (map square items))
{% endhighlight %}

<a name="Ex2.22"> </a>
#### Exercise 2.22
Louise Reasoner tries to rewrite the first `sqaure-list` procedure of
<a href="#Ex2.21">Exercise 2.21</a> so that it evolves an iterative
process:

{% highlight scheme %}
(define (square-list items)
    (define (iter things answer)
        (if (null? things)
            answer
            (iter (cdr things)
                  (cons (square (car things))
                        answer))))
    (iter items nil))
{% endhighlight %}
 Unfortunately, defining `square-list` this way produced the answer
 list in the reverse order of the one desired. Why?

Louis then tries to fix this bug by interchanging the arguments to
`cons`:

{% highlight scheme %}
(define (square-list items)
    (define (iter things answer)
        (if (null? things)
            answer
            (iter (cdr things)
                  (cons answer
                        (square (car things))))))
    (iter items nil))
{% endhighlight %}

This doesn't work either. Explain.

##### Solution
In the first procedure the `car` of items is squared and
_prepended_ to `answer`. This causes the list to be
reversed.

In the second procedure, although individual elements are appended to
`answer`, `(car answer)` now results in a list instead of a single
value and `(cdr answer)` results in square of `(car items)`, that is,
`answer` is nested the wrong way.

<a name="Ex2.23"> </a>
#### Exercise 2.23
The procedure `for-each` is similar to `map`. It takes as arguments a
procedure and a list of elements. However, rather than forming a list
of the results, `for-each` just applies the procedure to each of the
elements in turn, from left to right. The values returned by applying
the procedure to the elements are not used at all -- `for-each` is
used with procedures that perform an action, such as printed. For
example,

{% highlight scheme %}
(for-each (lambda (x) (newline) (display x))
          (list 57 321 88))
; 57
; 321
; 88
{% endhighlight %}

The value returned by the call to `for-each` (not illustrated above)
can be something arbitrary, such as true. Give an implementation of
`for-each`.

##### Solution
{% highlight scheme %}
(define (for-each p ls)
    (if (null? ls)
        true
        ((lambda (x) (p (car x)) (for-each p (cdr x))) ls)))
{% endhighlight %}