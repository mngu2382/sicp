; sum
(make-sum 1)                    ;error
(make-sum 0 1)                  ;1
(make-sum 0 'a)                 ;a
(make-sum 'a 'b)                ;(+ a b)
(make-sum 'a  2 '(+ 1 b))       ;(+ 2 a (+ 1 b))
(make-sum 'a  2 '(+ 1 b) 0)     ;(+ 2 a (+ 1 b))

(define s1 (make-sum 'a 'b))
(define s2 (make-sum 'a  2 '(+ 1 b) 0))
(sum? s1)                       ;#t
(sum? (make-product 1 'a))      ;#f
(addend s1)                     ;a
(augend s1)                     ;b
(augend s2)                     ;(+ a (+ 1 b))

; product
(make-product 1)                ;error
(make-product 0 1)              ;0
(make-product 1 'a)             ;a
(make-product 'a 'b)            ;(* a b)
(make-product 'a  2 '(+ 1 b))   ;(* 2 a (+ 1 b))
(make-product 'a  2 '(+ 1 b) 0) ;0

(define p1 (make-product 'a  2 '(+ 1 b)))
(define p2 (make-product 'a 'b))
(product? p1)                   ;#t
(product? (make-sum 1 'a))      ;#f
(multiplier p1)                 ;a
(multiplicand p1)               ;b
(multiplicand p2)               ;(* a (+ 1 b))

; exponentiation
(make-exponentiation 0 0)       ;1
(make-exponentiation 0 1)       ;0
(make-exponentiation 'a 0)      ;1
(make-exponentiation 'a 1)      ;a
(make-exponentiation 'a 2)      ;(** a 2)
(make-exponentiation 2 'a)      ;(** 2 a)

(define e (make-exponentiation 2 'a))
(exponentiation? e)             ;#t
(base e)                        ;2
(exponent e)                    ;a


(deriv 0)                       ;0
(deriv 1)                       ;0
(deriv (list 1))                ;error unknown expression type - DERIV (1)
(deriv '(+ 1 x) 'x)             ;1
(deriv '(+ 1 x 2 y) 'x)         ;1
(deriv '(+ 1 x (+ 1 x)) 'x)     ;2
(deriv '(* 1 x (+ 1 x)) 'x)     ;(+ x (+ 1 x))
(deriv '(* (* x y) (+ x 3)) 'x) ;(+ (* x y) (* y (+ x 3)))
(deriv '(* x y (+ x 3)) 'x)     ;(+ (* x y) (* y (+ x 3)))
(deriv '(** x 2) 'x)            ;(* 2 x)
(deriv '(+ (** x 2) x 1) 'x)    ;(+ 1 (* 2 x))
(deriv '(+ (** x 2) (** x 2)) 'x);(+ (* 2 x) (* 2 x))

