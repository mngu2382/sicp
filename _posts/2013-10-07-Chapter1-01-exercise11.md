---
title: Exercises 1.40 -- 1.46
layout: post
categories: chapter1
mathjax: true
---

<a name="Ex1.40"> </a>
#### Exercise 1.40
Define a procedure `cubic` that can be used together with the
`newtons-method` procedure in expressions of the form
{% highlight scheme %}
(newtons-method (cubic a b c) 1)
{% endhighlight %}
to approximate zeros of the cubic $x^3+ax^2+bx+c$.

##### Solution
{% highlight scheme %}
(define (cubic a b c)
    (lambda (x) (+ (* x x x) (* a x x) (* b x) c)))
{% endhighlight %}

<a name="Ex1.41"> </a>
#### Exercise 1.41
Define a procedure, `double`, that takes a procedure of one argument
as argument and returns a procedure that applies the original
procedure twice. For example, if `inc` is a procedure that adds 1 to
its argument, then `(double inc)` should be a procedure that adds 2.
What value is returned by
{% highlight scheme %}
(((double (double double)) inc) 5)
{% endhighlight %}

##### Solution
{% highlight scheme %}
(define (double f)
    (lambda (x) (f (f x))))

(define (inc x) (+ x 1))

(((double (double double)) inc) 5)
; 21
{% endhighlight %}
We find that `inc` has been evaluated 16 times. This can be shown using
the substitution model -- the full parenthetical nightmare can be found
on [Github](https://github.com/mngu2382/sicp/blob/master/fragments/Ex1-41.scm).
 
<a name="Ex1.42"> </a>
#### Exercise 1.42
Let $f$ and $g$ be two one-argument functions. The _composition_ $f$
after $g$ is defined to be the function $x\mapsto f(g(x))$. Define a
procedure `compose` that implements composition. For example,
if `inc` is a procedure that adds 1 to its argument,
{% highlight scheme %}
((compose square inc) 6)
; 49
{% endhighlight %}

##### Solution
{% highlight scheme %}
(define (compose f g)
    (lambda (x) (f (g x))))
{% endhighlight %}

<a name="Ex1.43"> </a>
#### Exercise 1.43
If $f$ is a numerical function and $n$ is a positive integer, then we
can form the $n$-th repeated application of $f$, which is defined to be
the function whose value at $x$ is $f(f(\ldots(f(x))\ldots))$. For
example, if $f$ is the function $x\mapsto x+1$ then the $n$-th repeated
application of $f$ is the function $x\mapsto x+n$. If $f$ is the
operation of squaring a number, then the $n$-th repeated application of
$f$ is the function that raises its arguments to the $2^n$-th power.
Write a procedure that takes as inputs a procedure that computes $f$
and a positive integer $n$ and returns the procedure that computes the
$n$-th repeated application if $f$. Your procedure should be able to be
used as follows:
{% highlight scheme %}
((repeated square 2) 5)
; 625
{% endhighlight %}
Hint: You may find it convenient to use `compose` from
[Exercise 1.42](#Ex1.42).

##### Solution
{% highlight scheme %}
(define (compose f g)
    (lambda (x) (f (g x))))

(define (double f)
    (compose f f))

(define (repeated f n)
    (cond ((= n 1) f)
          ((even? n) (double (repeated f (/ n 2))))
          (else (compose f (repeated f (- n 1))))))

((repeated square 2) 5)
; 625
{% endhighlight %}

<a name="Ex1.44"> </a>
#### Exercise 1.44
The idea of _smoothing_ a function is an important concept in signal
processing. If $f$ is a function and $dx$ us some small number, then
the smoothed version of $f$ is the function whose value at a point
$x$ is the average of $f(x-dx)$, $f(x)$, and $f(x+dx)$. Write a
procedure that that takes as input a procedure that computes $f$ and
returns a procedure that computes the smoothed $f$. It is sometimes
valuable to repeatedly smooth a function (that is, smooth the smoothed
function, and so on) to obtain the _$n$-fold smoothed function_.
Show how to generate the $n$-fold smoothed function of any given
function using `smooth` and `repeated` from [Exercise 1.43](#Ex1.43).

##### Solution
{% highlight scheme %}
(define dx 0.00001)

(define (smooth f) 
    (lambda (x) (/ (+ (f x) (f (+ x dx)) (f (- x dx))) 3)))

(define (n-fold-smooth f n)
    ((repeated smooth n) f)) 
{% endhighlight %}

<a name="Ex1.45"> </a>
#### Exercise 1.45
We saw in Section 1.3.3 that attempting to compute square roots by
naively finding a fixed point of $x\mapsto x/y$ does not converge, and
that this can be fixed by average damping. The same method works for
finding cube roots as fixed points of the average-damped
$y\mapsto x/y^2$. Unfortunately, the process does not work for fourth
roots -- a single average damp is not enough to make a fixed-point
search for $y\mapsto x/y^3$ converge. Do some experiments to determine
how many average damps are required to compute $n$-th roots as a
fixed-point search based upon repeated average damping of
$y\mapsto x/y^{n-1}$. Use this to implement a simple procedure for
computing $n$-th roots using `fixed-point`, `average-damp`, and the
`repeated` procedure of [Exercise 1.43](#Ex1.43). Assume that any
arithmetic operations you need are available as primitives.

##### Solution
Some previously defined procedures:
{% highlight scheme %}
; finds fixed point of a function, print successive guesses (Ex1.36)
(define (fixed-point f first-guess)
    (define (close-enough? v1 v2)
        (< (abs (- v1 v2)) tolerance))
    (define (try guess)
        (display guess)
        (newline)
        (let ((next (f guess)))
             (if (close-enough? guess next)
                 next
                 (try next))))
    (try first-guess))

; (Sec1.3.4)
(define (average-damp f)
    (lambda (x) (/ (+ x (f x)) 2)))

; (Sec1.3.4)
(define (fixed-point-of-transform g transform guess)
    (fixed-point (transform g) guess))
{% endhighlight %}
We will also use `compose`, `double` and `repeated` defined in
[Exercise 1.43](Ex1.43).

{% highlight scheme %}
(define tolerance 0.00001)

(define (cuberoot x)
    (fixed-point-of-transform (lambda (y) (/ x (expt y 2)))
                              average-damp
                              1.0))

(define (fourth-root x)
    (fixed-point-of-transform (lambda (y) (/ x (expt y 3)))
                              (repeated average-damp 2)
                              1.0))

(define (fifth-root x)
    (fixed-point-of-transform (lambda (y) (/ x (expt y 4)))
                              (repeated average-damp 2)
                              1.0))

(define (sixth-root x)
    (fixed-point-of-transform (lambda (y) (/ x (expt y 5)))
                              (repeated average-damp 2)
                              1.0))

(define (seventh-root x)
    (fixed-point-of-transform (lambda (y) (/ x (expt y 6)))
                              (repeated average-damp 2)
                              1.0))
(define (eighth-root x)
    (fixed-point-of-transform (lambda (y) (/ x (expt y 7)))
                              (repeated average-damp 3)
                              1.0))
{% endhighlight %}
It appears that the number of repeated applications of `average-damp`
needed to calculate the $n$-th root of a number using the fixed-point
method is the largest integer less than $\log_2 n$. We therefore
define the `nth-root` procedure as

{% highlight scheme %}
(define (nth-root x n)
    (fixed-point-of-transform (lambda (y) (/ x (expt y (- n 1))))
                              (repeated average-damp
                                        (floor (/ (log n) (log 2))))
                              1.0))
{% endhighlight %}

<a name="Ex1.46"> </a>
#### Exercise 1.46
Several of the numerical methods described in this section are
instances of an extremely general computational strategy known as
_iterative improvement_. Iterative improvement says that, to compute
something, we start with an initial guess for the answer, test if the
guess is good enough, and otherwise improve the guess and continue the
process using the improved guess as the new guess. Write a procedure
`iterative-imporve` that takes two procedures as arguments: a method
for telling whether a guess is good enough and a method for improving
a guess. `iterative-improve` should return as its value a procedure
that takes a guess as argument and keeps improving the guess until it
is good enough. Rewrite the `sqrt` procedure of Section 1.1.7 and the
`fixed-point` procedure of Section 1.3.3 in terms of
`iterative-improve`.

##### Solution
{% highlight scheme %}
(define (iterative-improve good-enough? improve-guess)
    (lambda (x)
        (if (good-enough? x)
            x
            ((iterative-improve good-enough? improve-guess)
             (improve-guess x)))))

(define (sqrt x)
    ((iterative-improve (lambda (y) (< (abs (- (square y) x)) 0.0001))
                        (lambda (y) (/  (+ y (/ x y)) 2.0)))
     1.0))

(define (fixed-point f)
    (let ((improve-guess (lambda (x) (f x))))
         (define good-enough?
             (lambda (x) (< (abs (- x (improve-guess x))) 0.0001)))
         ((iterative-improve good-enough? improve-guess) 1.0)))

(define (sqrt1 x)
    (fixed-point (lambda (y) (/ (+ y (/ x y)) 2.0))))
{% endhighlight %}
