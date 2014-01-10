---
title: Exercises 1.35 -- 1.39
layout: post
categories: chapter1
mathjax: true
---

#### Exercise 1.35
Show that the golden ratio $\varphi$ (Section 1.2.2) is a fixed point
of the transformation $x\mapsto 1+1/x$, and use this fact to compute
$\varphi$ by means of the `fixed-point` procedure.

##### Solution
The golden ratio is the value that satisfies the equation

$$
\varphi^2 = \varphi + 1.
$$

Dividing both sides of the equation by $\varphi$ we get the required
identity.

The `fixed-point` procedure given in the text
{% highlight scheme %}
(define tolerance 0.00001)
 
(define (fixed-point f first-guess)
    (define (close-enough? v1 v2)
        (< (abs (- v1 v2)) tolerance))
    (define (try guess)
        (let ((next (f guess)))
             (if (close-enough? guess next)
                 next
                 (try next))))
    (try first-guess))
{% endhighlight %}

So $\varphi$ can be estimated with the following procedure
{% highlight scheme %}
(fixed-point (lambda (x) (+ 1 (/ 1 x))) 1.0)
; 1.6180327868852458
{% endhighlight %}

#### Exercise 1.36
Modify `fixed-point` so that it prints the sequence of approximations
it generates, using the `newline` and `display` primitives shown in
[Exercise 1.22]({{ site.baseurl }}/chapter1/Chapter1-01-exercise07.html#Ex1.22).
Then find a solution to $x^x = 1000$ by finding a fixed point of
$x \mapsto \log(1000)/\log(x)$. (Use Scheme's primitive `log` procedure
which computes natural logarimths.) Compare the number of steps this
takes with and without average damping. (Note that you cannot start
`fixed-point` with a guess of 1 as this would cause division by
$\log(1) = 0$.)

##### Solution
{% highlight scheme %}
(define tolerance 0.00001)

; fixed-point with printing 
(define (fixed-point f first-guess)
    (define (close-enough? v1 v2)
        (< (abs (- v1 v2)) tolerance))
    (define (try guess)
        (newline)
        (display guess)
        (let ((next (f guess)))
             (if (close-enough? guess next)
                 next
                 (try next))))
    (newline)
    (try first-guess))

; without damping
(fixed-point (lambda (x) (/ (log 1000) (log x))) 2.0)
2.
9.965784284662087
3.004472209841214
6.279195757507157
3.759850702401539
5.215843784925895
4.182207192401397
4.8277650983445906
4.387593384662677
4.671250085763899
4.481403616895052
4.6053657460929
4.5230849678718865
4.577114682047341
4.541382480151454
4.564903245230833
4.549372679303342
4.559606491913287
4.552853875788271
4.557305529748263
4.554369064436181
4.556305311532999
4.555028263573554
4.555870396702851
4.555315001192079
4.5556812635433275
4.555439715736846
4.555599009998291
4.555493957531389
4.555563237292884
4.555517548417651
4.555547679306398
4.555527808516254
4.555540912917957
4.555532270803653

; with damping
(define (average x y) (/ (+ x y) 2))
(fixed-point (lambda (x) (average (/ (log 1000) (log x)) x)) 2.0)
2.
5.9828921423310435
4.922168721308343
4.628224318195455
4.568346513136242
4.5577305909237005
4.555909809045131
4.555599411610624
4.5555465521473675
4.555537551999825
{% endhighlight %}

<a name="Ex1.37"> </a>
#### Exercise 1.37
1. An infinite _continued fraction_ is an expression of the form

   $$
   f=\frac{N_1}{D_1 + \frac{N_2}{D_2 + \frac{N_3}{D_3 + \dotsb}}}.
   $$
   
   As an example, one can show that the infinite continued fraction
   expansion with the $N_i$ and $D_i$ all equal to 1 produces
   $1/\varphi$, where $\varphi$ is the golden ratio (described in
   Section 1.2.2). One way to approximate an infinite continued
   fraction is to truncate the expansion after a given number of terms.
   Such a truncation -- a so-called _$k$-term finite continued
   fraction_ -- has the form

   $$
   \frac{N_1}{D_1 + \frac{N_2}{\ddots + \frac{N_K}{D_K}}}.
   $$

   Suppose that `n` and `d` are procedures of one argument (the term
   index $i$) that return the $N_i$ and $D_i$ of the terms of the
   continued fraction. Define a procedure `cont-frac` such that
   evaulating `(cont-frac n d k)` computes the value of the $k$-term
   finite continued fraction. Check your procedure by approximating
   $1/\varphi$ using
   
        (cont-frac (lambda (i) 1.0)
                   (lambda (i) 1.0)
                   k)
                   
   for successive values of `k`. How large must you make
   `k` in order to get and approximation that is accurate to 4
   decimal places?
   
2. If you `cont-frac` procedure generates a recursive process, write
   one that generates an iterative one. If it generates an iterative
   process, write one that generates a recursive process.

##### Solution
1. A recursive procedure for continued fractions
        {% highlight scheme %}
(define (cont-frac n d k)
       (define (cont-frac-rec i)
           (if (= i > k)
               0
               (/ (n i) (+ (d i) (cont-frac-rec (+ i 1))))))
       (cont-frac-rec 1))
       
(/ 1 (cont-frac (lambda (i) 1.0) (lambda (i) 1.0) 12))
; 1.6180555555555558
     
(/ 1 (cont-frac (lambda (i) 1.0) (lambda (i) 1.0) 13))
; 1.6180257510729614
{% endhighlight %}

2. An iterative procedure for continued fractions
        {% highlight scheme %}
(define (cont-frac n d k)
       (define (cont-frac-iter i acc)
           (if (= i 0)
               acc 
               (cont-frac-iter (- i 1)
                               (/ (n i) (+ (d i) acc)))))
       (cont-frac-iter k 0))
{% endhighlight %}

#### Exercise 1.38
In 1737, the Swiss mathematician Leonhard Euler published a memoir
_De Fractionibus Continuis_, which included a continued fraction
expansion for $e - 2$, where $e$ is the base of the natural logarithms.
In this fraction, the $N_i$ are all 1, and the $D_i$ are successively
1, 2, 1, 1, 4, 1, 1, 6, 1, 1, 8, .... Write a program that uses
your `cont-frac` procedure from [Exercise 1.37](#Ex1.37) to approximate
$e$ based on Euler's expansion.

##### Solution
{% highlight scheme %}
(+ 2 (cont-frac (lambda (i) 1.0)
                (lambda (i) (if (= 0 (remainder (+ i 1) 3))
                                (* 2 (/ (+ i 1) 3))
                                1))
               10))
; 2.7182817182817183
{% endhighlight %}

#### Exercise 1.39
A continued fraction representation of the tangent function was
published in 1770 by the German mathematician J.H. Lambert:

$$
\tan x = \frac{x}{1-\frac{x^2}{3 - \frac{x^2}{5 - \dotsb}}}
$$

where $x$ is in radians. Define a procedure `(tan-cf x k)` that
computes an prroximation to the tangent function based on Lambert's
formula. As in [Exercise 1.37](#Ex1.37), `k` specifies the number of
terms to compute.

##### Solution
{% highlight scheme %}
(define (tan-cf x k)
    (define x2 (* x x))
    (define (ni k) (if (= k 1) x (- x2)))
    (define (di k) (- (* 2 k) 1))
    (cont-frac ni di k))
{% endhighlight %}
