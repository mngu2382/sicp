---
title: Exercises 2.30 -- 2.32
layout: post
categories: chapter2
---

<a name="Ex2.30"> </a>
#### Exercise 2.30
Define a procedure `square-tree` analogous to the `square-list`
procedure of
[Exercise 2.21]({{ site.baseurl }}/chapter2/Chapter2-01-exercise06.html#Ex2.21).
That is, `square-tree` should behave as follows:

{% highlight scheme %}
(square-tree
 (list 1
       (list 2 (list 3 4) 5)
       (list 6 7)))
; (1 (4 (9 16) 25) (36 49))
{% endhighlight %}

##### Solution

{% highlight scheme %}
(define (square-tree tree)
    (map (lambda (subtree)
             (if (pair? subtree)
                 (square-tree subtree)
                 (square subtree)))
         tree))
{% endhighlight %}

<a name="Ex2.31"> </a>
#### Exercise 2.31
Abstract your answer to [Exercise 2.30](#Ex2.30) to produce a
procedure `tree-map` with the property that `square-tree` could be
define as

{% highlight scheme %}
(define (square-tree tree) (tree-map square tree)
{% endhighlight %}

##### Solution

{% highlight scheme %}
(define (tree-map proc tree)
    (map (lambda (subtree)
             (if (pair? subtree)
                 (tree-map proc subtree)
                 (proc subtree)))
         tree))
{% endhighlight %}

<a name="Ex2.32"> </a>
#### Exercise 2.32
We can represent a set as a list of distinct elements, and we can
represent the set of all subsets of the set as a list of lists. For
example, if the set is `(1 2 3)`, then the set of all subsets is

{% highlight scheme %}
(() (3) (2) (2 3) (1) (1 3) (1 2) (1 2 3))
{% endhighlight %}

Complete the following definition of a procedure that generates the
set of subsets of a set and give a clear explanation of why it works:

{% highlight scheme %}
(define (subsets s)
    (if (null? s)
        (list nil)
        (let ((rest (subset (cdr s))))
             (append rest (map ?? rest)))))
{% endhighlight %}

##### Solution

{% highlight scheme %}
(define (subset s)
    (if (null? s)
        (list '())
        (let ((rest (subset (cdr s))))
             (append rest (map (lambda (ls) (cons (car s) ls))
                               rest)))))
{% endhighlight %}

Start with a collection containing only the empty set (`'()`) we
extend the collection by firstly including all set perviously in the
collection and then adding the sets created by adding an additional
unique element to each of the sets already in the collection. To
illustrate:

{% highlight scheme %}
; starting with the empty set
(())

; collection extended by including the new set (3),
; created by adding 3 to the empty
(() (3))

; extend the old collection by including the sets created
; by adding the new element, 2, to existing sets
(() (3) (2) (3 2))

...
{% endhighlight %}