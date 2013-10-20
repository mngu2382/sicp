; For each of the procedures defined below, give a Curried
; application of the procedure which evaluates to 3

(define foo1
  (lambda (x)
    (* x x)))
(foo1 (sqrt 3))
; 2.9999999999999996

(define foo2
  (lambda (x y)
    (/ x y)))
(foo2 3 1)
; 3

(define foo3
  (lambda (x)
    (lambda (y)
      (/ x y))))
((foo3 3) 1)
; 3

(define foo4
  (lambda (x)
    (x 3)))
(foo4 +)
; 3

(define foo5
  (lambda (x)
    (cond ((= x 2)
           (lambda () x))
          (else
            (lambda () (* x 3))))))
((foo5 1))
; 3

(define foo6
  (lambda (x)
    (x (lambda (y) (y y)))))
(foo6 (lambda (x) 3))
