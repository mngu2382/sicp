---
title: Exercises 2.33 -- 2.39
layout: post
categories: chapter2
mathjax: true
---

<a name="Ex2.33"> </a>
#### Exercise 2.33
Fill in the missing expressions to complete the following definitions
of some basic list-manipulation operations as accumulations:

{% highlight scheme %}
(define (map p sequence)
  (accumulate (lambda (x y) <??>) '() sequence))
  
(define (append seq1 seq2)
  (accumulate cons <??> <??>))
  
(define (length sequence)
  (accumulate <??> 0 sequence))
{% endhighlight %}

##### Solution
The `accumulate` procedure as defined in the text

{% highlight scheme %}
(define (accumulate op initial sequence)
     (if (null? sequence)
         initial
         (op (car sequence)
             (accumulate op initial (cdr sequence)))))
{% endhighlight %}

{% highlight scheme %}
(define (map p sequence)
  (accumulate (lambda (x y) (cons (p x) y))
              '()
              sequence))

(define (append seq1 seq2)
  (accumulate cons seq2 seq1))

(define (length sequence)
  (accumulate (lambda (x y) (+ 1 y)) 0 sequence))
{% endhighlight %}

<a name="Ex2.34"> </a>
#### Exercise 2.34
Evaluating a polynomial in $x$ at a given value of x can be formulated
as an accumulation. We evaluate the polynomial

$$
a_nx^n + a_{n-1}x^{n-1} + \ldots + a_1x + a_0
$$

using a well-known algorithm called _Horner's rule_, which structures
the computation as

$$
(\ldots (a_nx + a_{n-1})x + \ldots + a_1)x + a_0
$$

In other words, we start with $a_n$, multiply by $x$, add $a_{n-1}$,
mulitply by $x$, and so on, until we reach $a_0$.

Fill in the following template to produce a procedure that evaluates
a polynomial using Horner's rule. Assume that the coefficients of the
polynomial are arranged in a sequence from $a_0$ throught $a_n$.

{% highlight scheme %}
(define (horner-eval x coefficient-sequence)
    (accumulate (lambda (this-coeff higher-terms) <??>)
                0
                coefficient-sequence))
{% endhighlight %}

For example, to compute $1+3x+5x^3+x^5$ at $x=2$ you would evaluate

{% highlight scheme %}
(horner-eval 2 (list 1 3 0 5 0 1))
{% endhighlight %}

##### Solution
{% highlight scheme %}
(define (horner-eval x coefficient-sequence)
    (accumulate (lambda (this-coeff higher-terms)
                        (+ this-coeff
                           (* higher-terms x)))
                0
                coefficient-sequence))

(horner-eval 2 (list 1 3 0 5 0 1))
; 79
{% endhighlight %}

<a name="Ex2.35"> </a>
#### Exercise 2.35
Redefine `count-leaves` as an accumulation:

{% highlight scheme %}
(define (count-leaves t)
    (accumulate <??> <??> (map <??> <??>)))
{% endhighlight %}

##### Solution
Using a procedure analogous to `enumerate-tree` from the text

{% highlight scheme %}
(define (enumerate-tree tree)
    (cond ((null? tree) '())
          ((not (pair? tree)) (list tree))
          (else (append (enumerate-tree (car tree))
                        (enumerate-tree (cdr tree))))))

(define (count-leaves tree)
    (accumulate +
                0
                (map (lambda (x) 1) (enumerate-tree tree))))
{% endhighlight %}

<a name="Ex2.36"> </a>
#### Exercise 2.36

The procedure `accumulate-n` is similar to `accumulate` except that it
takes as its third arguments a sequence of sequences, which are all
assumed to have the same number of elements. It applies the designed
accumulation procedure to combine all the first elements of the
sequences, all the second elements of the sequences, and so on, and
returns a sequence of results. For instance, if `s` is a sequence
containing four sequences, `((1 2 3) (4 5 6) (7 8 9) (10 11 12))`,
then the value of `(accumulate-n + 0 s)` should be the sequence
`(22 26 30)`. Fill in the missing expressions in the following
definition of `accumulate-n`:

{% highlight scheme %}
(define (accumulate-n op init seqs)
    (if (null? (car seqs))
        '()
        (cons (accumulate op init <??>)
              (accumulate-n op init <??>))))
{% endhighlight %}

##### Solution

{% highlight scheme %}
(define (accumulate-n op init seqs)
    (if (null? (car seqs))
        '()
        (cons (accumulate op init (map car seqs))
              (accumulate-n op init (map cdr seqs)))))
{% endhighlight %}

<a name="Ex2.37"> </a>
#### Exercise 2.37

Suppose we represent vector $\boldsymbol v=(v_i)$ as sequences of
numbers, and matricies $\boldsymbol m=(m_{ij})$ as sequences of
vectors (the rows of the matrix). For example, the matrix

$$
\begin{pmatrix}
1 & 2 & 3 & 4\\\\
4 & 5 & 6 & 6\\\\
6 & 7 & 8 & 9
\end{pmatrix}
$$

is represented as the sequence `((1 2 3 4) (4 5 6 6) (6 7 8 9))`. With
this representation, we can use sequence operations to concisely
express the basic matrix and vector operations. These operations are
the following:

- `(dot-product v w)` returns the sum $\sum_iv_iw_i$
- `(matrix-*-vector m v)` returns the vector $\boldsymbol t$, where
  $t_i=\sum_jm_{ij}v_j$
- `(matrix-*-matrix m n)` returns the matrix $\boldsymbol p$, where
  $p_{ij}=\sum_km_{ik}n_{kj}$
- `(transpose m)` returns the matrix $\boldsymbol n$, where
  $n_{ij}=m_{ji}$

We can define the dot product as

{% highlight scheme %}
(define (dot-product v w)
    (accumulate + 0 (map * v w)))
{% endhighlight %}

Fill in the missing expressions in the following procedures for
computing the other matrix operations.

{% highlight scheme %}
(define (matrix-*-vector m v)
    (map <??> m))
    
(define (transpose mat)
    (accumulate-n <??> <??> mat))
    
(define (matrix-*-matrix m n)
    (let ((cols (transpose n)))
      (map <??> m)))
{% endhighlight %}

##### Solution

{% highlight scheme %}
(define (matrix-*-vector m v)
    (map (lambda (x) (dot-product x v)) m))

(define (transpose mat)
    (accumulate-n cons '() mat))

(define (matrix-*-matrix m n)
    (let ((cols (transpose n)))
      (map (lambda (x) (matrix-*-vector cols x)) m)))
{% endhighlight %}

<a name="Ex2.38"> </a>
#### Exercise 2.38

The `accumulate` procedure is also known as `fold-right`, because it
combines the first element of the sequence with the result of
combining all the elements to the right. There is also a `fold-left`,
which is similar to `fold-right`, except that it combines elements
working on the opposite direction:

{% highlight scheme %}
(define (fold-left op initial sequence)
    (define (iter result rest)
        (if (null? rest)
            result
            (iter (op result (car rest))
                  (cdr rest))))
    (iter initial sequence))
{% endhighlight %}

What are the values of

{% highlight scheme %}
(fold-right / 1 (list 1 2 3))

(fold-left / 1 (list 1 2 3))

(fold-right list '() (list 1 2 3))

(fold-left list '() (list 1 2 3))
{% endhighlight %}

Give a property that `op` should satisfy to guarantee that `fold-right`
and `fold-left` will produce the same values for any sequence.

##### Solution

{% highlight scheme %}
(fold-right / 1 (list 1 2 3))
; 3/2

(fold-left / 1 (list 1 2 3))
; 1/6

(fold-right list '() (list 1 2 3))
; (1 (2 (3 ())))

(fold-left list '() (list 1 2 3))
; (((() 1) 2) 3)
{% endhighlight %}

The results of `fold-right` and `fold-left` will be the same if `op`
is communitative.

<a name="Ex2.39"> </a>
#### Exercise 2.39
Complete the following definitions of `reverse` in terms of
`fold-right` and `fold-left`:

{% highlight scheme %}
(define (reverse sequence)
    (fold-right (lambda (x y) <??>) '() sequence))
  
(define (reverse sequence)
    (fold-left (lambda (x y) <??>) '() sequence))
{% endhighlight %}

##### Solution

{% highlight scheme %}
(define (reverse sequence)
    (fold-right (lambda (x y) (append y (list x))) '() sequence))
  
(define (reverse sequence)
    (fold-left (lambda (x y) (cons y x)) '() sequence))
{% endhighlight %}