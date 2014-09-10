---
title: Exercises 1.29 -- 1.33
layout: post
categories: chapter1
mathjax: true
---

#### Exercise 1.29

Simpson's rule is a more accurate method of numerical integration than
the method illustrated above (i.e. the sum the areas of a series of
rectangular boxes of width $dx$. Using Simpson's Rule, the integral of
a function $f$ between $a$ and $b$ is approximated as

$$
\frac{h}{3}(y_0+4y_1+2y_2+4y_3+2y_4+\ldots+2y_{n-2}+4y_{n-1}+y_n)
$$

where $h=(b-a)/n$, for some even integer $n$, and $y_k=f(a+kh)$. Define
a procedure that takes as arguments $f$, $a$, $b$, and $n$ and returns
the value of the integral, computed using Simpson's rule. Use your
procedure to integrate `cube` between 0 and 1 with $n=100$ and
$n=1000$, and compare the results to those of the integral procedure
shown above.

##### Solution

The `sum` procedure (which calculates the sum of a subsequence of terms
in a series) and `integral` procedure provided in the text
{% highlight scheme %}
(define (sum term a next b)
    (if (> a b)
        0
        (+ (term a)
           (sum term (next a) next b))))

(define (integral f a b dx)
    (define (add-dx x) (+ x dx))
    (* (sum f (+ a (/ dx 2.0)) add-dx b) dx))
{% endhighlight %}

Implementing Simpson's rule and evaluating the integral of $x^3$
{% highlight scheme %}
(define (simpsons-rule f a b n)
    (define h (/ (- b a) n))
    (define (inc x) (+ x (* 2 h)))
    (* (/ h 3.0)
       (+ (f a)
          (f b)
          (* 4 (sum f (+ a h) inc b))
          (* 2 (sum f (+ a (* 2 h)) inc (- b h))))))

(define (cube x) (* x x x))

(simpsons-rule cube 0 1 100)
; .25
(simpsons-rule cube 0 1 1000)
; .25
{% endhighlight %}

#### Exercise 1.30

The `sum` procedure above generates a linear recursion. The procedure
can be rewritten so that the sum is performed iteratively. Show how to
do this by filling in the missing expressions in the following
definition:
{% highlight scheme %}
(define (sum term a next b)
    (define (iter a result)
        (if <??>
            <??>
            (iter <??> <??>)))
    (iter <??> <??>))
{% endhighlight %}

##### Solution

{% highlight scheme %}
(define (sum term a next b)
    (define (iter a result)
        (if (> a b)
            result
            (iter (next a) (+ result (term a)))))
    (iter a 0))
{% endhighlight %}

#### Exercise 1.31

1. The `sum` procedure is only the simplest of a vast number of similar
   abstractions that can be captured as higher-order procedures. Write
   an analogous procedure called `product` that returns the
   product of the values of a function at points over a given range.
   Show how to define `factorial` in terms of `product`. Also use
   `product` to compute approximations to $\pi$ using the formula

   $$
   \frac{\pi}{4}=\frac{2\cdot 4\cdot 4\cdot 6\cdot 6\cdot 8\ldots}{3\cdot 3\cdot 5\cdot 5\cdot 7\cdot 7\ldots}
   $$

2. If your `product` procedure generates a recursive process, write one
   that generates an iterative process. If it generates an iterative
   process, write one that generates a recursive process.

##### Solution

1. Defining `product` and `factorial` and calculating an approximation
   of $\pi$:

       (define (product term a next b)
              (if (> a b)
                  1
                  (* (term a)
                     (product term (next a) next b))))
              
       (define (factorial n)
              (define (identity x) x)
              (define (inc x) (+ x 1))
              (product identity 1 inc n))
              
       (define (pi-prod n)
              (define (pi-term1 x) (/ (- x 1) x))
              (define (pi-term2 x) (/ (+ x 1) x))
              (define (inc x) (+ x 2))
              (* 4.0
                 (product pi-term1 3 inc n)
                 (product pi-term2 3 inc n)))

2. An iterative version of `product`:

       (define (product term a next b)
              (define (prod-iter a result)
                  (if (> a b)
                      result
                      (prod-iter (next a) (* result (term a)))))
              (prod-iter a 1))

#### Exercise 1.32

1. Show that `sum` and `product` are both special cases of a still more
   general notion called `accumulate` that combines a collection of
   terms, using some general accumulation function:

       (accumulate combiner null-value term a next b)

   This procedure takes as arguments the same term and range
   specifications as `sum` and `product`, together with a `combiner`
   procedure (of two arguments) that specifies how the current term
   is to be combined with the accumulation of the preceding terms and
   a `null-value` that specifies what base value to use when the terms
   run out. Write `accumulate` and show how `sum` and `product` can
   both be defined as simple calls to `accumulate`.

2. If your `accumulate` procedure generates a recursive process, write
   one that generates an iterative process. If it generates an
   iterative process, write one that generates a recursive process.

##### Solution

1. Defining `accumulate`

       (define (accumulate combiner null-value term a next b)
              (if (> a b)
                  null-value
                  (combiner (term a)
                            (accumulate combiner null-value term (next a) next b))))

2. An iterative version of `accumulate`:

       (define (accumulate combiner null-value term a next b)
              (define (accumulate-iter a result)
                  (if (> a b)
                      result
                     (accumulate-iter (inc a) (combiner result (term a)))))
              (accumulate-iter a null-value))

#### Exercise 1.33:

You can obtain an even more general version of `accumulate` by
introducing the notion of a `filter` on the terms to be combined.
That is, combine only those terms derived from values in the range that
satisfy a specified condition. The resulting `filtered-accumulate`
abstraction takes the same arguments as `accumulate`, together with an
additional predicate of one argument that specifies the filter. Write
`filtered-accumulate` as a procedure. Show how to express the
following using `filtered-accumulate`:

1. the sum of the squares of the prime numbers in the interval $a$ to
   $b$ (assuming that you have a `prime?` predicate already written)

2. the product of all the positive integers less than $n$ that are
   relatively prime to $n$ (i.e., all positive integers $i\lt n$ such
   that $\mathrm{\small GCD}(i,n)=1)$.

##### Solution

Defining the `filtered-accumulate`, which takes the same arguments as
`accumulate`, and an addtional one, `pred`, with which to filter `term`

{% highlight scheme %}
(define (filtered-accumulate combiner null-value term a next b pred)
    (if (> a b)
        null-value
        (combiner (if (pred a)
                      (term a)
                      null-value)
                  (filtered-accumulate combiner null-value term (next a) next b pred))))
{% endhighlight %}


1. the sum of squares of primes

       (filtered-accumulate + 0 square a inc b prime?)
           
       (define (inc x) (+ x 1))


2. the product of all positive integers less than $n$ that are
   relatively prime to $n$

       (filtered-accumulate * 1 identity 1 inc (- n 1) rel-prime-n)
           
       (define (identity x) x)
        
       (define (inc x) (+ x 1))
        
       (define (rel-prime-n i)
           (= (gcd i n) 1))
        
       (define (gcd a b)
           (if (= b 0)
               a
               (gcd b (remainder a b))))
