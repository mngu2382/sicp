---
title: Exercise 2.53 -- 2.55
layout: post
categories: chapter2
---

<a name="Ex2.53"> </a>
#### Exercise 2.53

What woud the interpreter print in response to evaluating each of the
following expressions?

{% highlight scheme %}
(list 'a 'b 'c)
(list (list 'george))
(cdr '((x1 x2) (y1 y2)))
(cadr '((x1 x2) (y1 y2)))
(pair? (car '(a short list)))
(memq 'red '((red shoes) (blue socks)))
(memq 'red '(red shoes blue socks))
{% endhighlight %}

##### Solution

{% highlight scheme %}
(list 'a 'b 'c)
; (a b c)

(list (list 'george))
; ((george))

(cdr '((x1 x2) (y1 y2)))
; ((y1 y2))

(cadr '((x1 x2) (y1 y2)))
; (y1 y2)

(pair? (car '(a short list)))
; false

(memq 'red '((red shoes) (blue socks)))
; false

(memq 'red '(red shoes blue socks))
; (red shoes blue socks)
{% endhighlight %}

<a name="Ex2.54"> </a>
#### Exercise 2.54
Two lists are said to be `equal?` if they contain equal elements
arranged in the same order. For example,

{% highlight scheme %}
(equal? '(this is a list) '(this is a list))
{% endhighlight %}

is true, but

{% highlight scheme %}
(equal? '(this is a list) '(this (is a) list))
{% endhighlight %}

is false. To be more precise, we can define `equal?` recursively in
terms of the basic `eq?` equality of symbols by saving that `a` and `b`
are `equal?` if they are both symbols and the symbols are `eq?`, or if
they are both list such that `(car a)` is `equal?` to `(car b)` and
`(cdr a)` is `equal?` `(cdr b)`. Using this idea, implement `equal?`
as a procedure.

##### Solution

{% highlight scheme %}
(define (equal? x y)
  (cond ((null? x) (null? y))
        ((null? y) (null? x))
        ((eq? (car x) (car y)) (equal? (cdr x) (cdr y)))
        (else false)))
{% endhighlight %}

<a name="Ex2.55"> </a>
#### Exercise 2.55

Eva Lu Ator types to the interpreter the expression

{% highlight scheme %}
(car ''abracadabra)
{% endhighlight %}

To her supprise, the interpreter prints back `quote`. Explain.

##### Solution

If we translate the expression `''abracadabra` to use the `quote`
special form instead of `'`, we get

{% highlight scheme %}
(car (quote (quote abracadabra)))
{% endhighlight %}

The second inner `quote` is not evaluated but treated as a symbol, so
that the expression is getting the `car` of the list
`(quote abracadabra)` which is quote.
