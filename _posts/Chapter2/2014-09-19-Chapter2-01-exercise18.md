---
title: Exercises 2.56 -- 2.58
layout: post
categories: chapter2
mathjax: true
---

<a name="Ex2.56"> </a>

## Exercise 2.56

Show how to extend the basic differentiator to handle more kinds of
expressions. For instance, implement the differentiation rule

$$
\frac{d(u^n)}{dx} = nu^{n-1}\frac{du}{dx}
$$

by adding a new clause to the `deriv` program and defining appropriate
procedures `exponentiation?`, `base`, `exponent`, and
`make-exponentiation`. (You may use the symbol `**` to denote
exponentiation.) Build in the rules that anything raised to the power
0 is 1 and anything raised to the power 1 is the thing itself.

### Solution

{% highlight scheme %}
; exponentiation
(define (make-exponentiation base exponent)
  (cond ((=number? exponent 0) 1)
        ((=number? exponent 1) base)
        ((and (number? base) (number? exponent)) (expt base exponent))
        (else (list '** base exponent))))
(define (exponentiation? x)
  (and (pair? x) (eq? (car x) '**)))
(define (base x) (cadr x))
(define (exponent x) (caddr x))

; derivative
(define (deriv exp var)
  (cond ((number? exp) 0)
        ((variable? exp)
         (if (same-variable? exp var) 1 0))
        ((sum? exp)
         (make-sum (deriv (addend exp) var)
                   (deriv (augend exp) var)))
        ((product? exp)
         (make-sum
           (make-product (multiplier exp)
                         (deriv (multiplicand exp) var))
           (make-product (deriv (multiplier exp) var)
                         (multiplicand exp))))
        ((and (exponentiation? exp) (number? (exponent exp)))
         (make-product
          (exponent exp)
          (make-product
           (make-exponentiation (base exp) (- (exponent exp) 1))
           (deriv (base exp) var))))
        (else
         (error "unknown expression type - DERIV" exp))))
{% endhighlight %}

<a name="Ex2.57"> </a>

## Exercise 2.57

Extend differentiation program to handle sums and products of
arbitrary numbers of two or more terms. Then the two following
procedures would be equivalent:

{% highlight scheme %}
(deriv '(* (* x y) (+ x 3)) 'x)
(deriv '(* x y (+ x 3)) 'x)
{% endhighlight %}

Try to do this by changing only the representation for sums and
products, without changing the `deriv` procedure at all. For example,
the `addend` of a sum would be the first term, and the `augend` would
be the sum of the rest of the terms.

### Solution

{% highlight scheme %}
; sum
(define (make-sum  a1 a2 . an)
  (let ((a (cons a1 (cons a2 an))))
    (let ((symb (filter symbol? a))
          (numb (fold + 0 (filter number? a))))
      (if (pair? symb)
          (cons '+ (cons numb symb))
          numb))))
(define (sum? x)
  (and (pair? x) (eq? (car x) '+)))
(define (addend s) (cadr s))
(define (augend s) (cddr s))

; product
(define (make-product m1 m2 . mn)
  (let ((m (cons m1 (cons m2 mn))))
    (let ((symb (filter symbol? m))
          (numb (fold * 1 (filter number? m))))
      (if (pair? symb)
          (cons '* (cons numb symb))
          numb))))
(define (product? x)
  (and (pair? x) (eq? (car x) '*)))
(define (multiplier p) (cadr p))
(define (multiplicand p) (cddr p))

(deriv '(* (* x y) (+ x 3)) 'x)
(deriv '(* x y (+ x 3)) 'x)
{% endhighlight %}

<a name="Ex2.87"> </a>

## Exercise 2.58
Suppose we want to modify the differentiation program so that it works
with ordinary mathematical notation, which `+` and `*` are infix
rather than prefix operators. Since the differentiation program is
defined in terms of abstract data, we can modify it to work with
different representations of expressions solely by changing the
predicates, selectors, and constructors that define the representation
of the algebraic expressions on which the differentiator is to operate.

a. Show how to do this in order to differentiate algebraic expressions
   presented in infix form, such as `(x + (3 * (x + (y + 2))))`. To
   simplyfy the task, assume that `+` and `*` always take two
   arguments and that expressions are fully parenthesized.
b. The problem becomes substantially harder if we allow standard
   algebraic notation, such as `(x + 3 * (x + y + 2))`, which drops
   unnecessary parentheses and assumes that multiplication is done
   before addtion. Can you design appropriate predicates, selectors,
   and constructors for this notation such that our derivative program
   still works?

### Solution

