---
title: Exercises 2.40 -- 2.43
layout: post
categories: chapter2
mathjax: true
---

<a name="Ex2.40"> </a>

## Exercise 2.40

Define a procedure `unique-pairs` that, given an integer $n$,
generates the sequence of pairs $(i, j)$ with $1\le j\lt i\le n$.
Use `unique-pairs` to simplify the definition of `prime-sum-pairs`
given above.

### Solution

The following are defined in the text:

{% highlight scheme %}
(define (enumerate-interval low high)
    (if (> low high)
        '()
        (cons low (enumerate-interval (+ low 1) high))))
        
(define (prime-sum? pair)
    (prime? (+ (car pair) (cadr pair))))

(define (make-pair-sum pair)
    (list (car pair) (cadr pair) (+ (car pair) (cadr pair))))

(define (flatmap proc seq)
    (fold-right append `() (map proc seq)))
{% endhighlight %}

We define `unique-pairs` and redefine `prime-sum-pairs`

{% highlight scheme %}
(define (unique-pairs n)
    (flatmap (lambda (i)
                     (map (lambda (j) (list i j))
                          (enumerate-interval 1 (- i 1))))
             (enumerate-interval 1 n)))

(define (prime-sum-pairs n)
  (map make-pair-sum (filter prime-sum? (unique-pairs n))))
{% endhighlight %}

<a name="Ex2.41"> </a>

## Exercise 2.41

Write a procedure to find all ordered triples of positive integers
$i$, $j$ and $k$ less that or equal to a given integer $n$ that sum to
a given integer s.

### Solution

Using `unique-pairs` from [Exercise 2.40](#Ex2.40) above, we define
`unique-triple` as:
{% highlight scheme %}
(define (unique-triples n)
    (flatmap (lambda (i) (map (lambda (j) (cons j i))
                              (enumerate-interval (+ (car i) 1) n)))
             (unique-pairs n)))
{% endhighlight %}

<a name="Ex2.42"> </a>

## Exercise 2.42

The "eight queens puzzle" asks how to place eight queens on a
chessboard so that no queeds is in check from any other (i.e., no two
queems are in the same row, column, or diagonal). One possible
solution is shown below.

![A solution to the eight-queens puzzle]({{ site.baseurl }}/images/Fig2-08.png "A solution to the eight-queens puzzle")

_LaTex code for image on [Github](https://github.com/mngu2382/sicp/blob/master/figures/Fig2-08.tex)_

One way to sole the puzzle is to work across the board, placing a
queen in each column. Once we have placed $k-1$ queens, we must place
the $k$-th queens in a position where it does not check any of the
queens already on the board. We ca formulate this approach recursively:
assume that we have already generated he sequence os all possible ways
to place $k-1$ queens in the first $k-1$ columns of the board. For
each of these ways, generate an extended set of positions by placing a
queen in each row of the $k$-th column. Now filter these, keeping only
the positions for which the queen in the $k$-th column is safe with
respect to the other queens. This produces the sequence of all ways to
place $k$ queens in the first $k$ columns. By continuing this process,
we will produce not only one solution but all solutions to the puzzle.

We implement this solution as a procedure `queens`, which returns a
sequence of all solutions to the problem of placing $n$ queens on an
$n\times n$ chessboard. `queens` has an internal procedure
`queen-cols` that returns the sequence of all ways to place queens in
the first $k$ columns of the board.

{% highlight scheme %}
(define (queens board-size)
    (define (queen-cols k)
        (if (= k 0)
            (list empty-board)
            (filter
             (lambda (positions) (safe? k positions))
             (flatmap
              (lambda (rest-of-queens)
                  (map (lambda (new-row)
                           (adjoin-position new-row
                                            k
                                            rest-of-queens))
                       (enumerate-interval 1 board-size)))
              (queen-cols (- k 1))))))
    (queen-cols board-size))
{% endhighlight %}

In this procedure `rest-of-queens` is a way to place $k-1$ queens in
the first $k-1$ columns, and `new-row` is a proposed row in which to
place the queen for the $k$-th column. Complete the program by
implementing the representation for sets of board positions, including
the procedure `adjoin-position`, which adjoins a new row-column
position to a set os positions, and `empty-board`, which represents an
empty set of positions. You must also write the procedure `safe?`,
which determines for a set of positions, whether the queen in the
$k$-th column is safe with respect to the others. (Note that we need
only check whether the new queen is safe -- the other queens are
already guaranteed safe with respect to each other.)

### Solution

{% highlight scheme %}
(define empty-board '())

(define (adjoin-position row col board)
    (cons (list row col) board))

(define (row board)
    (map car board))
    
(define (col board)
    (map cadr board))
    
(define (safe? k board)
    (define (member-test val seq)
        (cond ((null? seq) true)
              ((= val (car seq)) false)
              (else (member-test val (cdr seq)))))
    (define (comparison-test seq1 seq2)
        (cond ((null? seq1) true)
              ((= (car seq1) (car seq2)) false)
              (else (comparison-test (cdr seq1) (cdr seq2)))))
    (let ((rows (row board))
          (cols (col board)))
         (and (member-test (car rows) (cdr rows))
              (member-test (car cols) (cdr cols))
              (comparison-test (map (lambda (i) (abs (- i (car rows))))
                                    (cdr rows))
                               (map (lambda (i) (abs (- i (car cols))))
                                    (cdr cols))))))
{% endhighlight %}

<a name="Ex2.43"> </a>

## Exercise 2.43

Louis Reasoner is having a terrible time doing
[Exercise 2.42](#Ex2.42). His `queens` procedure seems to work, but it
runs extremely slowly. (Louis never does manage to wait long enough
for it to solve even the 6 x 6 case.) When Louis asks Eva Lu Ator for
help, she points out that he has interchanged the order of the nested
mappings in the `flatmap` writting it as

{% highlight scheme %}
(flatmap
    (lambda (new-row)
        (map (lambda (rest-of-queens)
                 (adjoin-position new-row k rest-of-queens))
             (queen-cols (- k 1))))
    (enumerate-interval 1 board-size))
{% endhighlight %}

Explain why this interchange makes the program run slowly. Estimate
how long it will take Louis's program to solve the eight-queens puzzle,
assuming that the program in [Exercise 2.42](#Ex2.42) solves the
puzzle in time $T$.

### Solution

In Louis's `flatmap` chunk above, to place the 8th queen, the
expression `(queen-cols 7)`, which returns the collection of all
boards with 7 queens safely placed, is evaluated 8 times while the
corresponding steps in [Exercise 2.42](#Ex2.42) only have the
expression `(queen-cols 7)` evaluated once.

So in the evaluation of `(queens 8)`, `(queen-col 8)` is called once
in both versions, `(queen-col 7)` is called once in the first
procedure and 7 times in Louis's procedure, `(queen-col 6)` called
once in the first procedure and 7 x 6 = 42 times in Louis's, and so on.

Therefore, if the first procedure solves the n queens puzzle in time
$T$, we would expect  Louis's procedure to solve it in $O((n-1)!)T$.
We run some timings:

{% highlight scheme %}
(define (queens1 board-size)
    (define (queen-cols k)
        (if (= k 0)
            (list empty-board)
            (filter
             (lambda (positions) (safe? k positions))
             (flatmap
              (lambda (new-row)
                  (map (lambda (rest-of-queens)
                           (adjoin-position new-row
                                            k
                                            rest-of-queens))
                       (queen-cols (- k 1))))
              (enumerate-interval 1 board-size)))))
    (queen-cols board-size))
    
(define (time-queens proc n)
    (let ((start (runtime)))
         (proc n)
         (proc n)
         (proc n)
         (display (/ (- (runtime) start) 3))))
{% endhighlight %}

<table>
<thead>
  <tr>
    <th>Board</th>
    <th style="text-align:center" colspan="2">Time (sec)</th>
    <th></th>
    <th>Ratio/</th>
  </tr>
  <tr>
    <th>Size</th>
    <th>queens</th>
    <th>queens1</th>
    <th>Ratio</th>
    <th>(n-1)!</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td>4</td>
    <td>0.00333</td>
    <td>0.01000</td>
    <td>3</td>
    <td>0.44</td>
  </tr>
  <tr>
    <td>5</td>
    <td>0.00333</td>
    <td>0.07000</td>
    <td>21</td>
    <td>0.64</td>
  </tr>
  <tr>
    <td>6</td>
    <td>0.01667</td>
    <td>1.03667</td>
    <td>62</td>
    <td>0.52</td>
  </tr>
  <tr>
    <td>7</td>
    <td>0.04333</td>
    <td>20.03333</td>
    <td>462</td>
    <td>0.88</td>
  </tr>
  <tr>
    <td>8</td>
    <td>0.20000</td>
    <td>444.19000</td>
    <td>2221</td>
    <td>0.50</td>
  </tr>
</tbody>
</table>

In the last column of the table we calculate:

$$
\frac{\mathrm{time}(\mathtt{queens})}{(n-1)!\ \mathrm{time}(\mathtt{queens1})}
$$

That these values are similar for the difference boards sizes supports
somewhat our guess.
