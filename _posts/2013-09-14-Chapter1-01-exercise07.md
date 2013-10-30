---
layout: post
title: Exercises 1.21 -- 1.28
category: chapter1
mathjax: true
---

<a name="Ex1.21"> </a>
#### Exercise 1.21

Use the `smallest-divisor` procedure to find the smallest divisor of
each of the following numbers: 199, 1999, 19999.

##### Solution
The `smallest-divisor` is defined as
{% highlight scheme %}
(define (smallest-divisor n)
    (find-divisor n 2))

(define (find-divisor n test-divisor)
    (cond ((> (square test-divisor) n) n)
          ((divides? test-divisor n) test-divisor)
          (else (find-divisor n (+ test-divisor 1)))))

(define (divides? a b)
    (= (remainder b a) 0))
{% endhighlight %}

{% highlight scheme %}
(smallest-divisor 199)
;199

(smallest-divisor 1999)
; 1999

(smallest-divisor 19999)
; 7
{% endhighlight %}

<a name="Ex1.22"> </a>
#### Exercise 1.22
Most Lisp implementations include a primitive called `runtime`
that returns an integer that specifies the amount of time the system
has been running (measured, for example, in mircoseconds). The
following `timed-prime-test` procedure, when called with an
integer $n$, prints $n$ and checks to see if $n$ is prime. If $n$ is
prime, the procedure prints three asterisks followed by the amount of
time used in performing the test.
{% highlight scheme %}
(define (timed-prime-test n)
    (newline)
    (display n)
    (start-prime-test n (runtime)))
    
(define (start-prime-test n start-time)
    (if (prime? n)
        (report-prime (- (runtime) start-time))))
        
(define (report-prime elapsed-time)
    (display " *** ")
    (display elapsed-time))
{% endhighlight %}
Using this procedure, write a procedure `search-for-primes` that
checks the primality of consecutive odd integers in a specified range.
Use your procedure to find the three smallest primes larger than 1000;
larger than 10,000; larger than 100,000; larger than 1,000,000. Note
the time needed to test each prime. Since the testing algorithm has
order of growth of $\Theta(\sqrt{n})$, you should expect that testing
for primes arround 10,000 should take about $\sqrt{10}$ times as long
as testing for primes around 10000. Do you timings bear this out? How
well do the data for 100,000 and 1,000,000 support the
$\Theta(\sqrt{n})$ predictions? Is your result compatible with the
notation that programs on your machine run in time proportional to the
number of steps required for the computation?

##### Solution
The procedure `primes` was previously defined in the text as
{% highlight scheme %}
(define (prime? n)
    (= n (smallest-divisor n)))
{% endhighlight %}
where `smallest-divisor` is as define in [Exercise 1.21](#Ex1.21).

Firstly, we modify `start-prime-test` to return `false` if `n` is not
prime:
{% highlight scheme %}
(define (start-prime-test n start-time)
    (if (prime? n)
        (report-prime (- (runtime) start-time))
        false))
{% endhighlight %}
and define `search-for-primes` as
{% highlight scheme %}
(define (search-for-primes greater-than how-many)
    (if (even? greater-than)
        (search-for-primes (- greater-than 1) how-many)
        (if (> how-many 0)
            (if (timed-prime-test (+ 2 greater-than))
                (search-for-primes (+ 2 greater-than) (- how-many 1))
                (search-for-primes (+ 2 greater-than) how-many)))))
{% endhighlight %}

We will evaluate the procedures at starting values larger than
suggested so that inceases in `runtime` are more illustrative. For
example,
{% highlight scheme %}
(search-for-primes 1000000000 3)
1000000001
1000000003
1000000005
1000000007 *** .04999999999999999
1000000009 *** .04000000000000001
1000000011
1000000013
1000000015
1000000017
1000000019
1000000021 *** .03999999999999998
{% endhighlight %}

<table>
<thead>
  <tr>
    <th></th>
    <th></th>
    <th style="text-align:center">Avg.</th>
    <th></th>
  </tr>
  <tr>
    <th>Prime</th>
    <th>Time (ms)</th>
    <th>Time (ms)</th>
    <th>Ratio</th>
  </tr>
</thead>
<tbody style="text-align:right">
  <tr style="border-top-color:#000">
    <td>1000000007</td>
    <td>50</td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>1000000009</td>
    <td>40</td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>1000000021</td>
    <td>40</td>
    <td>43</td>
    <td></td>
  </tr>
</tbody>
<tbody style="text-align:right">
  <tr>
    <td>10000000019</td>
    <td>130</td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>10000000033</td>
    <td>130</td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>10000000061</td>
    <td>130</td>
    <td>130</td>
    <td>3.0</td>
  </tr>
</tbody>
<tbody style="text-align:right">
<tr>
    <td>100000000003</td>
    <td>420</td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>100000000019</td>
    <td>400</td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>100000000057</td>
    <td>400</td>
    <td>407</td>
    <td>3.1</td>
  </tr>
</tbody>
<tbody style="text-align:right">
<tr>
    <td>1000000000039</td>
    <td>1290</td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>1000000000061</td>
    <td>1260</td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>1000000000063</td>
    <td>1280</td>
    <td>1277</td>
    <td>3.1</td>
  </tr>
</tbody>
</table>
Here "ratio" refers to the average time for `timed-prime-test` of the
set compared with the previous set. We see the the ratios are close to
$\sqrt{10}\approx 3.2$.

#### Exercise 1.23
The `smallest-divisor` procedure shown at the start of this section
does lots of needless testing: After it checks to see if the number is
divisible by 2 there is no point in checking to see if it is divisible
by any larger even numbers. This suggests that the values used for
`test-divisor` should not be 2, 3, 4, 5, 6, ..., but rather 2, 3, 5,
7, 9, .... To implement this change, define a procedure `next` that
returns 3 if its input is equal to 2 and otherwise returns its input
plus 2. Modify the `smallest-divisor` procedure to use
`(next test-divisor)` instead of `(+ test-divisor 1)`. With
`timed-prime-test` incorporating this modified version of
`smallest-divisor`, run the test for each of the 12 primes found in
[Exercise 1.22](#Ex1.22). Since this modification halves the
number of test steps, you should expect it to run about twice as fast.
Is this expectation confirmed? If not, what is the observed ratio of
the speeds of the two algorithms, and how do you explain the fact that
it is different from 2?

##### Solution
We define the `next` procedure
{% highlight scheme %}
(define (next n)
    (if (= n 2) 3 (+ n 2)))
{% endhighlight %}
and modify the `find-divisor` procedure to use `next`
{% highlight scheme %}
(define (find-divisor n test-divisor)
    (cond ((> (square test-divisor) n) n)
          ((divides? test-divisor n) test-divisor)
          (else (find-divisor n (next test-divisor)))))
{% endhighlight %}
<table>
<thead>
  <tr>
    <th></th>
    <th></th>
    <th style="text-align:center">Avg.</th>
    <th style="text-align:center">Cmp.</th>
  </tr>
  <tr>
    <th>Prime</th>
    <th>Time (ms)</th>
    <th>Time (ms)</th>
    <th>Ex2.22</th>
  </tr>
</thead>
<tbody style="text-align:right">
  <tr style="border-top-color:#000">
    <td>1000000007</td>
    <td>30</td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>1000000009</td>
    <td>30</td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>1000000021</td>
    <td>30</td>
    <td>30</td>
    <td>0.70</td>
  </tr>
</tbody>
<tbody style="text-align:right">
  <tr>
    <td>10000000019</td>
    <td>80</td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>10000000033</td>
    <td>80</td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>10000000061</td>
    <td>70</td>
    <td>77</td>
    <td>0.59</td>
  </tr>
</tbody>
<tbody style="text-align:right">
  <tr>
    <td>100000000003</td>
    <td>250</td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>100000000019</td>
    <td>250</td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>100000000057</td>
    <td>240</td>
    <td>247</td>
    <td>0.61</td>
  </tr>
</tbody>
<tbody style="text-align:right">
  <tr>
    <td>1000000000039</td>
    <td>770</td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>1000000000061</td>
    <td>790</td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>1000000000063</td>
    <td>770</td>
    <td>777</td>
    <td>0.61</td>
  </tr>
</tbody>
</table>
We see that the time is reduced by about 40%, not quite half.

I'm was not sure why it is not closer to a half. Others (e.g.
[Bill the Lizard](http://www.billthelizard.com/2010/02/sicp-exercise-123-improved-prime-test.html))
have suggested that it is due to the extra checking that is done in the
`next` procedure -- we can check this out: since we are only
prime-testing odd number for this excercise, we don't need to test if
the number is divisible by 2, therefore we can modify the
`smallest-divisor` procedure to start testing divisors from 3 and rid
ourselves of the `if` check in `next`, that is
{% highlight scheme %}
(define (smallest-divisor n)
    (find-divisor n 3))

(define (next n) (+ n 2))
{% endhighlight %}
This brings the reduction (in the three larger sets) to about 45%.

A further suggestion is the extra overhead of the calling `next`, we
can raplace that call with its definition:
{% highlight scheme %}
(define (find-divisor n test-divisor)
    (cond ((> (square test-divisor) n) n)
          ((divides? test-divisor n) test-divisor)
          (else (find-divisor n (+ 2 test-divisor)))))
{% endhighlight %}
This brings the reduction (in the three larger sets) to about 48%.
I'll stop here.

<a name="Ex1.24"> </a>
#### Exercise 1.24
Modify the `timed-prime-test` procedure of [Exercise 1.22](#Ex1.22)
to use `fast-prime?` (the Fermat method), and test each of the 12
primes you found in that exercise. Since the Fermat test has
$\Theta(\log n)$ growth, how would you expect the time to test primes
near 1,000,000 to compare with the time needed to test primes near
1000? Do your data bear this out? Can you explain any discrepancy you
find?

##### Solution
The `fast-prime?` and associated procedures:
{% highlight scheme %}
(define (expmod base exp m)
    (cond ((= exp 0) 1)
          ((even? exp)
           (remainder (square (expmod base (/ exp 2) m))
                      m))
          (else
           (remainder (* base (expmod base (- exp 1) m))
                      m))))
                      
(define (fermat-test n)
    (define (try-it a)
        (= (expmod a n n) a))
    (try-it (+ 1 (random (- n 1)))))
    
(define (fast-prime? n times)
    (cond ((= times 0) true)
          ((fermat-test n) (fast-prime? n (- times 1)))
          (else false)))
{% endhighlight %}
and modifying the `start-prime-test` to use `fast-prime?`:
{% highlight scheme %}
(define (start-prime-test n start-time)
    (if (fast-prime? n 1000)
        (report-prime (- (runtime) start-time))
        false))
{% endhighlight %}

<table>
<thead>
  <tr>
    <th></th>
    <th></th>
    <th style="text-align:center">Avg.</th>
    <th></th>
  </tr>
  <tr>
    <th>Prime</th>
    <th>Time (ms)</th>
    <th>Time (ms)</th>
    <th>Ratio</th>
  </tr>
</thead>
<tbody style="text-align:right">
  <tr style="border-top-color:#000">
    <td>1000000007</td>
    <td>70</td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>1000000009</td>
    <td>70</td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>1000000021</td>
    <td>60</td>
    <td>67</td>
    <td></td>
  </tr>
</tbody>
<tbody style="text-align:right">
  <tr>
    <td>10000000019</td>
    <td>90</td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>10000000033</td>
    <td>70</td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>10000000061</td>
    <td>70</td>
    <td>77</td>
    <td>1.15</td>
  </tr>
</tbody>
<tbody style="text-align:right">
  <tr>
    <td>100000000003</td>
    <td>90</td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>100000000019</td>
    <td>90</td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>100000000057</td>
    <td>100</td>
    <td>93</td>
    <td>1.21</td>
  </tr>
</tbody>
<tbody style="text-align:right">
  <tr>
    <td>1000000000039</td>
    <td>100</td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>1000000000061</td>
    <td>90</td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>1000000000063</td>
    <td>100</td>
    <td>97</td>
    <td>1.04</td>
  </tr>
</tbody>
</table>

Testing primes near 1,000,000 should take about twice as long as primes
near 1,000:

$$
\frac{\log{10^6}}{\log{10^3}} = 2
$$

This is roughly the case when we compare times for tests of primes near
$10^{12}$ with primes near $10^6$.

#### Exercise 1.25
Alyssa P. Hacker complaind that we went to a lot of extra work in
writting `expmod`. After all, she says, since we already know
how to compute exponentials, we could have simply written
{% highlight scheme %}
(define (expmod base exp m)
    (remainder (fast-expt base exp) m)
{% endhighlight %}
Is she correct? Would this procedure serve as well as for our fast
prime tester? Explain.

##### Solution
For large `exp` the `expmod` defined in [Exercise 1.24](#Ex1.24) helps
us avoid numerical overflow as the returned value of `expmod` is never
greater that `m`. In Alyssa's `expmod`, `fast-expt` can grow very
quickly and cause numerical overflow.

#### Exercise 1.26
Louis Reasoner is having great difficulty doing
[Exercise 1.24](#Ex1.24). His `fast-prime?` test seems to run more
slowly than his `prime?` test. Louis calles his friend Eva Lu Ator over
to help. When they examine Louis's code, they find that he has
rewritten the `expmod` procedure to use an explicit multiplication,
rather than calling square:
{% highlight scheme %}
(define (expmod base exp m)
    (cond ((=exp 0) 1)
          ((even? exp)
           (remainder (* (expmod base (/ exp 2) m)
                         (expmod base (/ exp 2) m))
                      m))
          (else (remainder (* base (expmod base (- exp 1) m))
                           m))))
{% endhighlight %}
"I don't see what difference that could make", says Louis. "I do."
says Eva. "By writing the procedure like that, you have transformed
the $\Theta(\log n)$ process into a $\Theta(n)$ process." Explain.

##### Solution
The difference between
{% highlight scheme %}
(* (expmod base (/ exp 2) m)
   (expmod base (/ exp 2) m))
{% endhighlight %}
and
{% highlight scheme %}
(square (expmod base (/ exp 2) m))
{% endhighlight %}
is caused by applicative-order evaluation which means that
`(expmod base (/ exp 2) m)` is evaluated twice in the first fragment,
while only once in the second.

#### Exercise 1.27
Demonstrate that Carmichael numbers listed really do fool the Fermat
test. That is, write a procedure that take s an integer $n$ and test
whether $a^n$ is congruent to $a$ modulo $n$ for every $a\lt n$, and
try your procedure on the Carmichael numbers.

##### Solution
{% highlight scheme %}
(define (congruent? n)
    (define (congruent-test n a)
        (cond ((= n a) true)
              ((= (expmod a n n) a) (congruent-test n (+ a 1)))
              (else false)))
    (congruent-test n 2))
{% endhighlight %}

Evaluating this procedure with a Carmichael number:
{% highlight scheme %}
(congruent? 561)
; #t

(prime? 561)
; #f
{% endhighlight %}

#### Exercise 1.28
One variant of the Fermat test that cannot be fooled is called the
_Miller-Rabin test_
([Miller 1976](http://www.cs.cmu.edu/~glmiller/Publications/sort_date.html#1976);
[Rabin 1980](http://dx.doi.org/10.1016%2F0022-314X%2880%2990084-0)).
This starts from an alternative form of Fermat's Little Theorem, which
states that if $n$ is a prime number and $a$ is any positive integer
less that $n$, than $a$ raised to the $(n-1)$-th power is congruent to
1 modulo $n$. To test the primality of a number $n$ by the Miller-Rabin
test, we pick a random number $a\lt n$ and raise $a$ to the $(n-1)$-th
power modulo $n$ using the `expmod` procedure. However, whenever we
perform that squaring step in `expmod`, we check to see if we have
discovered a "nontrivial square root of 1 modulo $n$", that is a number
not equal to 1 or $n-1$ whose square is equal to 1 modulo $n$. It is
possible to prove that if such a nontrivial square root of 1 exits,
then $n$ is not prime. It is also possible to prove that if $n$ is an
odd number that is not prime, then, for at least half the numbers
$a\lt n$, computing $a^{n-1}$ in this way will reveal a nontrivial
square root of 1 modulo $n$. (This is why the Miller-Rabin test cannot
be fooled.) Modify the `expmod` procedure to signal if it discovers a
nontrivial square root of 1, and use this to implement the Miller-Rabin
test with a procedure analogous to `fermat-test`. Check your procedure
by testing various known prime and non-primes. Hint: One convenient way
to make `expmod` signal is to have it return 0.

##### Solution
The following `expmod` will now return 0 in the case that a nontrivial
square root of 1 mod $m$ is found.
{% highlight scheme %}
(define (expmod1 base exp m)
    (define (test x)
        (cond ((or (= x 1) (= x (- m 1))) 1)
              ((= 1 (remainder (square x) m)) 0)
              (else (remainder (square x) m))))
    (cond ((= exp 0) 1)
          ((even? exp) (test (expmod1 base (/ exp 2) m)))
          (else
           (remainder (* base (expmod1 base (- exp 1) m))
                      m))))

(define (miller-rabin-test n)
    (define (try-it a)
        (= (expmod1 a (- n 1) n) 1))
    (try-it (+ 1 (random (- n 2)))))

(define (fast-miller-rabin-prime? n times)
    (cond ((= times 0) true)
          ((miller-rabin-test n) (fast-miller-rabin-prime? n (- times 1)))
          (else false)))
{% endhighlight %}