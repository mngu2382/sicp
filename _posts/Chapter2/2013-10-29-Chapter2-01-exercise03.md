---
title: Exercises 2.4 -- 2.6
layout: post
categories: chapter2
mathjax: true
---

<a name="Ex2.4"> </a>

## Exercise 2.4

Here is an alternative procedural representation of pairs. For this
representation, verify that `(car (cons x y))` yields `x` for any
objects `x` and `y`.

{% highlight scheme %}
(define (cons x y)
    (lambda (m) (m x y)))

(define (car z)
    (z (lambda (p q) p)))
{% endhighlight %}

What is the corresponding definition of `cdr`? (Hint: To verify that
this works, make use of the substitution model of Section 1.1.5)

### Solution

Using the substitution method:

{% highlight scheme %}
(car (cons x y))
(car (lambda (m) (m x y)))
((lambda (m) (m x y)) (lambda (p q) p))
((lambda (p q) p) x y)
x
{% endhighlight %}

And the corresponding definition of `cdr`:

{% highlight scheme %}
(define (cdr z)
    (z (lambda (p q) q)))
{% endhighlight %}

<a name="Ex2.5"> </a>

## Exercise 2.5

Show that we can represent pairs of nonnegative integers using only
numbers and arithmetic operations if we represent the pair $a$ and $b$
as the integer that is the product $2^a3^b$. Give the corresponding
definitions of the procedures `cons`, `car`, and `cdr`.

### Solution

Since $2^a3^b$ is a composite of only two prime numbers, 2 and 3,
given an integer $x=2^a3^b$, $a$ and $b$ are, respectively, the
number of times that 2 and 3 divide $x$. Hence we can define

{% highlight scheme %}
(define (cons a b)
   (cond ((> a 0) (* 2 (cons (- a 1) b)))
         ((> b 0) (* 3 (cons a (- b 1))))
         (else 1)))

(define (car c)
    (if (even? c)
        (+ 1 (car (/ c 2)))
        0))

(define (cdr c)
    (if (= (remainder c 3) 0)
        (+ 1 (cdr (/ c 3)))
        0))
{% endhighlight %}

<a name="Ex2.6"> </a>

## Exercise 2.6

In case representing pairs as procedures wasn't mind-boggling enough,
consider that, in a language that can manipulate procedures, we can
get by without numbers (at least insofar as nonnegative integers are
concerned) by implementing 0 and the operations of adding 1 as

{% highlight scheme %}
(define zero (lambda (f) (lambda (x) x)))

(define (add-1 n)
    (lambda (f) (lambda (x) (f ((n f) x)))))
{% endhighlight %}

This representation is known as _Church numerals_, after its inventor,
Alonzo Church, the logician who invernted the $\lambda$-calculus.

Define `one` and `two` directly (not in terms of `zero` and `add-1`).
(Hint: Use substitution to evaluate `(add-1 zero)`). Give a direct
definition of the addition procedure `+` (not in terms of repeated
applications of `add-1`).

### Solution

Using the substitution model to evaluate `(add-1 zero)`:

{% highlight scheme %}
(add-1 zero)
(add-1 (lambda (f) (lambda (x) x)))
(lambda (f) (lambda (x) (f (((lambda (f) (lambda (x) x)) f) x))))
(lambda (f) (lambda (x) (f ((lambda (x) x) x))))
(lambda (f) (lambda (x) (f x)))
{% endhighlight %}

That is, we can define `one` as:

{% highlight scheme %}
(define one (lambda (f) (lambda (x) (f x))))
{% endhighlight %}

Similarly, evaluating `(add-1 one)`:

{% highlight scheme %}
(add-1 one)
(add-1 (lambda (f) (lambda (x) (f x))))
(lambda (f) (lambda (x) (f (((lambda (f) (lambda (x) (f x))) f) x))))
(lambda (f) (lambda (x) (f ((lambda (x) (f x)) x))))
(lambda (f) (lambda (x) (f (f x))))
{% endhighlight %}

So we can define `two`:

{% highlight scheme %}
(define two (lambda (f) (lambda (x) (f (f x)))))
{% endhighlight %}

Finally, we can define `add`

{% highlight scheme %}
(define (add num1 num2)
    (labmda (f) (lambda (x) ((num1 f) ((num2 f) x)))))
{% endhighlight %}

So, for example:

{% highlight scheme %}
(add one two)
(add (lambda (f) (lambda (x) (f x)))
     (lambda (f) (lambda (x) (f (f x)))))
(lambda (f) (lambda (x)
             (((lambda (f) (lambda (x) (f x))) f)
              (((lambda (f) (lambda (x) (f (f x)))) f) x))))
(lambda (f) (lambda (x)
             (((lambda (f) (lambda (x) (f x))) f)
              ((lambda (x) (f (f x))) x))))
(lambda (f) (lambda (x)
             (((lambda (f) (lambda (x) (f x))) f)
              (f (f x))))
(lambda (f) (lambda (x)
             ((lambda (x) (f x)) (f (f x)))))
(lambda (f) (lambda (x) (f (f (f x)))))
{% endhighlight %}
