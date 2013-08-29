Title: Chapter 1.1: The Elements of Programming
Date: 2013-06-16
Slug: sicp/chapter1/notes1
Category: SICP
Modified:
MathJax:

This section introduces the basic language features of __Scheme__.

#### Expressions and Combinations

An __expression__ is a unit of the language: a combination of
syntactically correct characters and something that can be evaluated
by an interpreter.

A __combination__ is a list of expressions, surround by parentheses,
denoting a procedure application. The first element in the list is the
__operator__. Subsequent expression are the __operands__. This method
of expressing operations, with the operator first followed by the
operands, is called __prefix notation__.

    :::scheme
    (<operator> <operand1> <operand2> ...)

The value of a combination is the obtained by the application of
`operator` (a _procedure_) to the __arguments__ (which are _values_)
given by the evaluation of the `operand`s (which are _expressions_).

#### Defining Variables and Procedures

We can define variables using `define`, 

    :::scheme
    (define <varName> <varValue>)
Note that the `define` procedure does not follow the steps for
evaluating combinations described in the paragraph above:
> evaluating `(define x 3)` does not apply define to two arguments,
> one of which is the value of the symbol `x` and the other of which
> is 3, since the purpose of the define is precisely to associate `x`
> with a value. (That is, `(define x 3)` is not a combination.)

Procedures that do not follow the general evaluation rule are called
__special forms__. Each special form has its own evaluation rule.

The `define` procedure can be used to define procedures as well, these
are called __compound procedures__:

    :::scheme
    (define (<name> <formal params>) <body>)

For example:

    :::scheme
    (define (square x) (* x x))
    (define (sum-of-squares x y) (+ (square x) (square y)))

#### The Substitution Model

The __substitution model__ is used to help us think about how compound
procedures are evaluated:
> To apply a compound procedure to arguments, evaluate the body of the
> procedure with each formal parameter replaced by the corresponding
> argument.

Using the substitution model there are two different way in which to
evaluate a compound procedure: 

* __applicative order__ evaluates the operands before substitutes them
to the definition of the compound procedure;
* __normal order__ substitutes the unevaluated operands to the
definition of the compound procedure and only evaluated operands as
their values are needed.

An example using the `square` compound procedure:

###### Applicative Order

    :::scheme
    (square (+ 1 5))
    (square 6)
    (* 6 6)

###### Normal Order

    :::scheme
    (square (+ 1 5))
    (* (+ 1 5) (+ 1 5))
    (* 6 6)

Applicative order and normal order evaluation will produce that same
value for procedures that can be interpreted using the substitution
model.

Scheme uses applicative order evaluation. This is mainly due to its
advantage over normal order for procedures that can't be interpreted
using the substitution model. Normal order evaluation, of course, has
its advantages which will be explored in later sections.

#### Conditional Expressions

A __case analysis__ can be performed using the `cond` special form

    :::scheme
    (cond (<pred1> <exp1>)
          (<pred2> <exp2>)
          ...
          (<predN> <expN>))
where `pred` are predicates that evaluate to `#t`/`#f` and the
expressions `exp` are the possible values of `cond`. Predicates are
successively evaluated, the expression associated with the first true
predicate is the value returned by `cond`, subsequent predicates and
expressions are not evaluated. If none of the predicates are true an
__unspecified value__ is returned.

Note that in cases where `#t`/`#f` is expected any value not `#f` is
considered as `#t` (that is, `0` and `""` are also "true").

The `cond` expression also supports a catch-all case: the keyword
`else` can be used in place of the last predicate, its associated
value is returned in the case where all predicates are false. 

    :::scheme
    (cond (<pred1> <exp1>)
          ...
          (else <expN>))

The `if` special form can be used when there are only two cases:

    :::scheme
    (if <pred> <consequent> <alternative>)

#### Logical Expressions

There are __primitive predicates__ such as `<`, `=` and `>`.

There are __logical composition operations__:

    :::scheme
    (and <pred1> ... <predN>)
the predicates `pred` are evalutated from left to right, if a
predicate is false subsequent predicates are not evalutated and the
`and` expression is false. If all predicates are true then the `and`
expression is true

    :::scheme
    (or <pred1> ... <predN>)
similar to `and` -- the predicates `pred` are evaluated until the
first true in which case the `or` expression is true. If all
predicates are false then the `or` expression is false

    :::scheme
    (not <pred>)
the negation of `pred`

#### Example: Square Roots by Newton's Method

> whenever we have a guess y for the value of a square root of a
> number x, we can alway produce a better guess by averaging y
> with x/y

    :::scheme
    (define (sqrt-iter guess x)
        (if (good-enough? guess x)
            guess
            (sqrt-iter (improve guess x)
                       x)))

    (define (improve guess x)
        (average guess (/ x guess)))

    (define (average x y)
        (/ (+ x y) 2))

    (define (good-enough? guess x)
        (< (abs (- (square guess) x)) 0.001))

    (define (sqrt x)
        (sqrt-iter 1.0 x))

#### Procedures as Black Box Abstractions

In the example above, the process of finding the square root of a
number has been broken down into sub-tasks performed by separate
procedures. Each procedure is completely self-contained in performing
its specified task.

When a procedure is self-contained it can be readily used as a module
in the definitions of other procedures, that is, it can be used as a
box block or __procedural abstraction__, 


That is, the details of its
implementation is 

A self-contained procedure can be readily used as a module in the
definition of other procedures. That is, this procedure can be used
without concern that is it can be treated as black box or
__procedural abstractions__. That is, these procedures can be used
without having to know how they have been implemented. For example, in
the `good-enough?` procedure, whether `square` is defined in terms of
mulitplcation or exponentials and logarithms ought not be of concern.

    :::scheme
    (define (square x) (* x x))

    (define (square x)
        (exp (double (log x))))
    (define (double x) (+ x x))

It should also not matter, in the second version of `square`, that `x`
is used as the formal parameter for both `square` and `double`: the
`x`s in the two procedures are not mixed up by making the values
associated with these formal paramenter local to their respective
procedures.

##### Local Variables
The names of the formal parameters used in the definition of a
procedure should be irrelavent to its user. That is,
the following pair should be indistinguishable:

    :::scheme
    (define (square (x) (* x x))

    (define (square (y) (* y y))


