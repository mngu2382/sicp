---
title: Exercises 2.17 -- 2.20
layout: post
categories: chapter2
---

<a name="Ex2.17"> </a>

## Exercise 2.17

Define a procedure `last-pair` that returns the list that contains
only the last element of a given (non-empty) list:

{% highlight scheme %}
(last-pair (list 23 72 149 34))
; (34)
{% endhighlight %}

### Solution

{% highlight scheme %}
(define (list-pair items)
    (if (null (cdr items))
        items
        (last-pair (cdr items))))
{% endhighlight %}

<a name="Ex2.18"> </a>

## Exercise 2.18

Define a procedure `reverse` that takes a list as argument and returns
a list of the same elements in reverse order:

{% highlight scheme %}
(reverse (list 1 4 9 16 25))
; (25 16 9 4 1)
{% endhighlight %}

### Solution

{% highlight scheme %}
(define (reverse items)
    (define (reverse-iter items rev-items)
        (if (null? items)
            rev-items
            (reverse-iter (cdr items) (cons (car items) rev-items))))
    (reverse-iter items '()))
{% endhighlight %}

TODO: is there a recursive process solution?

<a name="Ex2.19"> </a>

## Exercise 2.19

Consider the counting-change program of Section 1.2.2. It would be
nice to be able to easily change the currency used by the program, so
that we could compute the number of ways to change a British pound,
for example. As the program is written, the knowledge of the currency
is distributed partly into the procedure `first-denomination` and
partly into the procedure `count-change` (which knows that there are
five kind of U.S. coins). It would be nicer to be able to supply a
list of coins to be used for making change.

We want to rewrite the procedure `cc` so that its second argument is a
list of the values of the coins to use rather than an integer
specifying which coins to use. We could then have a list that defined
each kind of currency:

{% highlight scheme %}
(define us-coins (list 50 25 10 5 1))

(define uk-coins (list 100 50 20 10 5 2 1 0.5))
{% endhighlight %}

We could then call `cc` as follows:

{% highlight scheme %}
(cc 100 us-coins)
; 292
{% endhighlight %}

To do this will require changing the program `cc` somewhat. It will
still have the same form, but will access its second argument
differently, as follows:

{% highlight scheme %}
(define (cc amount coin-values)
    (cond ((= amount 0) 1)
          ((or (< amount 0) (no-more? coin-values)) 0)
          (else
           (+ (cc amount
                  (except-first-denomination coin-values))
              (cc (- amount (first-denomination coin-values))
                  coin-values)))))
{% endhighlight %}

Define the procedure `first-denomination`, `except-first-denomination`
and `no-more?` in terms of primitive operations on list structures.
Dose the order of the list `coin-values` affect the answer produced by
`cc`? Why or why not?

### Solution

{% highlight scheme %}
(define (first-denomination coins)
    (car coins))

(define (except-frist-denomination coins)
    (cdr coins))

(define (no-more? coins)
    (null? coins))
{% endhighlight %}

The order of the coins used in `cc` does not affect the results.

<a name="Ex2.20"> </a>

## Exercise 2.20

The procedures `+`, `*`, and `list` takes arbitrary numbers of
arguments. One way to define such proceures is to use `define` with
__dotted-tail notation__. In a procedure definition, a parameter list
that has a dot before the last parameter name indicates that , when
the procedure is called, the initial parameters (if any) will have as
values the initial arguments, as usual, but the finial parameter's
value will be a list of any remaining arguments. For instance, given
the definition

{% highlight scheme %}
(define (f x y . z) <body>)
{% endhighlight %}

the procedure `f` can be called with two or more arguments. If we
evaluate

{% highlight scheme %}
(f 1 2 3 4 5 6)
{% endhighlight %}

then in the body of `f`, `x` will be 1, `y` will be 2, and `z` will be
the list `(3 4 5 6)`. Given the definition

{% highlight scheme %}
(define (g . w) <body>)
{% endhighlight %}

the procedure `g` can be called with zero or more arguments. If we
evaluate

{% highlight scheme %}
(g 1 2 3 4 5 6)
{% endhighlight %}

then in the body of `g`, `w` will be the list `(1 2 3 4 5 6)`.

To define `f` and `g` using `lambda` we would write

{% highlight scheme %}
(define f (lambda (x y . w) <body>))

(define g (lambda w <body>))
{% endhighlight %}

Use this notation to write a procedure `same-parity` that takes one or
more integers and returns a list of all the arguments that have the
same even-odd parity as the first argument. For example,

{% highlight scheme %}
(same-parity 1 2 3 4 5 6 7)
; (1 3 5 7)

(same-parity 2 3 4 5 6 7)
; (2 4 6)
{% endhighlight %}

### Solution

{% highlight scheme %}
(define (same-parity x . y)
    (let ((parity (if (odd? x) odd? even?)))
        (define (same-parity-with-list x ls)
            (if (null? ls)
                '()
                (if (parity (car ls))
                    (cons (car ls) (same-parity-with-list x (cdr ls)))
                    (same-parity-with-list x (cdr ls)))))
        (if (null? y)
            (list x)
            (cons x (same-parity-with-list x y)))))
{% endhighlight %}

TODO: is there a recursive process solution?
