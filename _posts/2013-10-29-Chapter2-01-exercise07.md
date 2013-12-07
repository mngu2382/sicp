---
title: Exercises 2.24 -- 2.29
layout: post
categories: chapter2
---

<a name="Ex2.24"> </a>
#### Exercise 2.24
Suppose we evaluate the expression

{% highlight scheme %}
(list 1 (list 2 (list 3 4)))
{% endhighlight %}

Give the result printed by the interpreter, the corresponding
box-and-pointer structure, and the interpretation of this as a tress.

##### Solution

{% highlight scheme %}
(list 1 (list 2 (list 3 4)))
; (1 (2 (3 4)))
{% endhighlight %}

![Exercise 2.24: Box-and-pointer representation]({{ site.baseurl }}/images/Ex2-24a.png "Exercise 2.24: Box-and-pointer representation")
![Exercise 2.24: Tree representation]({{ site.baseurl }}/images/Ex2-24b.png "Exercise 2.24: Tree representation")

<a name="Ex2.25"> </a>
#### Exercise 2.25
Give combinations of `car`s and `cdr`s that will pick 7 from each of
the following lists:

{% highlight scheme %}
(1 3 (5 7) 9)

((7))

(1 (2 (3 (4 (5 (6 7))))))
{% endhighlight %}

##### Solution
{% highlight scheme %}
(define x (list 1 3 (list 5 7) 9))
(car (cdr (car (cdr (cdr x)))))

(define x (list (list 7)))
(car (car x))

(define x (list 1 (list 2 (list 3 (list 4 (list 5 (list 6 7)))))))
(car (cdr (car (cdr (car (cdr (car (cdr (car (cdr (car (cdr x))))))))))))
{% endhighlight %}

<a name="Ex2.26"> </a>
#### Exercise 2.26
Suppose we define `x` and `y` to be  two lists:

{% highlight scheme %}
(define x (list 1 2 3))

(define y (list 4 5 6))
{% endhighlight %}

What results is printed by the interpreter in response to evaluating
each of the following expressions:

{% highlight scheme %}
(append x y)

(cons x y)

(list x y)
{% endhighlight %}

##### Solution
{% highlight scheme %}
(append x y)
; (1 2 3 4 5 6)

(cons x y)
; ((1 2 3) 4 5 6)

(list x y)
; ((1 2 3) (4 5 6))
{% endhighlight %}

<a name="Ex2.27"> </a>
#### Exercise 2.27
Modify your `reverse` procedure of
[Exercise 2.18]({{ site.baseurl }}/chapter2/Chapter2-01-exercise05.html#Ex2.18)
to produce a `deep-reverse` procedure that takes a list as argument
and returns as its value a list with its elements reverse and with all
sublists deep-reversed as well. For example,

{% highlight scheme %}
(define x (list (list 1 2) (list 3 4)))

x
; ((1 2) (3 4))

(reverse x)
; ((3 4) (1 2))

(deep-reverse x)
((4 3) (2 1))
{% endhighlight %}

##### Solution

{% highlight scheme %}
(define (deep-reverse items)
    (define (reverse-iter items rev-items)
        (cond ((null? items) rev-items)
              ((not (pair? items)) items)
              (else (reverse-iter (cdr items)
                                  (cons (deep-reverse (car items))
                                        rev-items)))))
    (reverse-iter items '()))
{% endhighlight %}

<a name="Ex2.28"> </a>
#### Exercise 2.28
Write a procedure `fringe` that takes as argument a tree (represented
as a list) and returns a list whose elements are all the leaves of the
tree arranged in left-to-right order. For example

{% highlight scheme %}
(define x (list (list 1 2) (list 3 4)))

(fringe x)
; (1 2 3 4)

(fringe (list x x))
; (1 2 3 4 1 2 3 4)
{% endhighlight %}

##### Solution

{% highlight scheme %}
(define (fringe items)
    (cond ((null? items) items)
          ((not (pair? items)) (list items))
          (else (append (fringe (car items))
                        (fringe (cdr items))))))
{% endhighlight %}

<a name="Ex2.29"> </a>
#### Exercise 2.29
A binary mobile consists of two branches, a left branch and a right
branch. Each branch is a rod of a certain length, from which hangs
either a weight or another binary mobile. We can represent a binary
mobile using compound data by constructing it from two branches (for
example, using `list`):

{% highlight scheme %}
(define (make-mobile left right)
    (list left right))
{% endhighlight %}

A branch is constructed from a `length` (which must be a number)
together with a `structure`, which may be wither a number
(representing a simple weight) or another mobile:

{% highlight scheme %}
(define (make-branch length structure)
    (list length structure))
{% endhighlight %}

<br>

1. Write the corresponding selectors `left-branch` and `right-branch`
   which return the branches of a mobile, and `branch-length` and
   `branch-structure`, which return the compoments of a branch.
2. Using your selectors, define a procedure `total-weight` that
   returns the total weight of a mobile.
3. A mobile is said to be _balanced_ if the torque applied by its top
   left branch is equal to that applied by its top right branch (that
   is, if the length of the left rod multiplied by the weight from
   that rod is equal to the corresponding  product for the right side)
   and if each of the submobiles hanging off its branches is balanced.
   Design a predicate that tests whether a binary mobile is balanced.
4. Suppose that we change the representation of mobiles so that the
   constructors are

        {% highlight scheme %}
(define (make-mobile left right)
    (cons left right))

(define (make-branch length structure)
    (cons length structure))
{% endhighlight %}
   How much do you need to change your program to convert to the new
   represenation?

##### Solution

The selectors for mobiles and branches:

{% highlight scheme %}
(define (left-branch mobile)
    (car mobile))
(define (right-branch mobile)
    (cadr mobile))

(define (branch-length branch)
    (car branch))
(define (branch-structure branch)
    (cadr branch))
{% endhighlight %}

To define the `total-weight` procedure we also define helper procedure,
`branch-weight`

{% highlight scheme %}
(define (branch-weight branch)
    (if (pair? (branch-structure branch))
        (total-weight (branch-structure branch))
        (branch-structure branch)))

(define (total-weight mobile)
    (+ (branch-weight (left-branch mobile))
       (branch-weight (right-branch mobile))))
{% endhighlight %}

We first define a procedure that calculates the torque of a branch,
then the `balanced?` predicate

{% highlight scheme %}
(define (torque branch)
    (* (branch-length branch)
       (branch-weight branch)))

(define (balanced? mobile)
    (and (= (torque (left-branch mobile))
            (torque (right-branch mobile)))
         (if (pair? (branch-structure (left-branch mobile)))
             (balanced? (branch-structure (left-branch mobile)))
             true)
         (if (pair? (branch-structure (right-branch mobile)))
             (balanced? (branch-structure (right-branch mobile)))
             true)))
{% endhighlight %}

If the representation of mobiles changes from using lists to cons
only a couple of the selectors need to be changed

{% highlight scheme %}
(define (right-branch mobile)
    (cdr mobile))

(define (branch-structure branch)
    (cdr branch))
{% endhighlight %}
