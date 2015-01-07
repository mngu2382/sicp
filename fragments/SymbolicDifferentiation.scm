; number
(define (=number? exp num)
  (and (number? exp) (= exp num)))

; variable
(define (variable? x) (symbol? x))
(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))

;; for expressions using prefix notation
; sum
(define (make-sum . a)
  (if (< (length a) 2)
    (error "make-product requires at least 2 arguments")
    (let ((num (fold + 0 (filter number? a)))
          (var (filter symbol? a))
          (expr (filter pair? a)))
      (let ((sum
              (filter (lambda (x) (not (or (null? x) (=number? x 0))))
                        (cons num (append var expr)))))
        (cond ((= (length sum) 0) 0)
              ((= (length sum) 1) (car sum))
              (else (cons '+ sum)))))))
(define (sum? x)
  (and (pair? x) (eq? (car x) '+) (> (length x) 2)))
(define (addend s) (cadr s))
(define (augend s)
  (if (> (length s) 3) (cons '+ (cddr s)) (caddr s)))

; product
(define (make-product . m)
  (if (< (length m) 2)
    (error "make-product requires at least 2 arguments")
    (let ((num (fold * 1 (filter number? m)))
          (var (filter variable? m))
          (expr (filter pair? m)))
      (let ((prod
              (filter (lambda (x) (not (or (null? x) (=number? x 1))))
                      (cons num (append var expr)))))
            (if (< (length prod) 2)
              (car prod)
              (cond ((=number? (car prod) 0) 0)
                    ((=number? (car prod) 1) (cons '* (cdr prod)))
                    (else (cons '* prod))))))))
(define (product? x)
  (and (pair? x) (eq? (car x) '*) (> (length x) 2)))
(define (multiplier p) (cadr p))
(define (multiplicand p)
  (if (> (length p) 3) (cons '* (cddr p)) (caddr p)))

; exponentiation
(define (make-exponentiation base exponent)
  (cond ((=number? exponent 0) 1)
        ((=number? exponent 1) base)
        ((and (number? base) (number? exponent)) (expt base exponent))
        (else (list '** base exponent))))
(define (exponentiation? x)
  (and (pair? x) (eq? (car x) '**)))
(define (base x) (cadr x))
(define (exponent x) (caddr x))

; derivative
(define (deriv exp var)
  (cond ((number? exp) 0)
        ((variable? exp)
         (if (same-variable? exp var) 1 0))
        ((sum? exp)
         (make-sum (deriv (addend exp) var)
                   (deriv (augend exp) var)))
        ((product? exp)
         (make-sum
           (make-product (multiplier exp)
                         (deriv (multiplicand exp) var))
           (make-product (deriv (multiplier exp) var)
                         (multiplicand exp))))
        ((and (exponentiation? exp) (number? (exponent exp)))
         (make-product
          (exponent exp)
          (make-product
           (make-exponentiation (base exp) (- (exponent exp) 1))
           (deriv (base exp) var))))
        (else
         (error "unknown expression type - DERIV" exp))))

;; for expression using infix representaion
; when operations have only two arguments and are fully parenthesized
(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        ((and (number? a1) (number? a2)) (+ a1 a2))
        (else (list a1 '+ a2))))
(define (sum? x)
  (and (pair? x) (= (length x) 3) (eq? (cadr x) '+)))
(define (addend s) (car s))
(define (augend s) (caddr s))

(define (make-product m1 m2)
  (cond ((or (=number? m1 0) (=number? m2 0)) 0)
        ((=number? m1 1) m2)
        ((=number? m2 1) m1)
        ((and (number? m1) (number? m2)) (* m1 m2))
        (else (list m1 '* m2))))
(define (product? x)
  (and (pair? x) (= (length x) 3) (eq? (cadr x) '*)))
(define (multiplier p) (car p))
(define (multiplicand p) (caddr p))
