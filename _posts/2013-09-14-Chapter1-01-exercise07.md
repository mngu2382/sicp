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
