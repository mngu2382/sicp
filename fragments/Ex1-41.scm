;; Given the following two procedures, the substitution methods is used
;; to evaluate (((double (double double)) inc) 5)

;; TODO: find a better way to format code

(define (double f)
    (lambda (x) (f (f x))))

(define (inc x) (+ x 1))

(((double (double double)) inc) 5)

(((lambda (x) ((double double) ((double double) x))) inc) 5)

(((lambda (x) ((lambda (x) (double (double x)))
               ((lambda (x) (double (double x))) x))) inc) 5)

(((lambda (x) ((lambda (x) (double (double x)))
               (double (double x)))) inc) 5)

(((lambda (x) (double (double (double (double x))))) inc) 5)

((double (double (double (double inc)))) 5)

((double (double (double (lambda (x) (inc (inc x)))))) 5)

((double (double (lambda (x) ((lambda (x) (inc (inc x)))
                              ((lambda (x) (inc (inc x))) x))))) 5)

((double (double (lambda (x) ((lambda (x) (inc (inc x)))
                              (inc (inc x)))))) 5)

((double (double (lambda (x) (inc (inc (inc (inc x))))))) 5)

((double (lambda (x) ((lambda (x) (inc (inc (inc (inc x)))))
                      ((lambda (x) (inc (inc (inc (inc x))))) x)))) 5)

((double (lambda (x) ((lambda (x) (inc (inc (inc (inc x)))))
                      (inc (inc (inc (inc x))))))) 5)

((double (lambda (x) (inc (inc (inc (inc (inc (inc (inc (inc x)))))))))) 5)

((lambda (x) ((lambda (x) (inc (inc (inc (inc (inc (inc (inc (inc x)))))))))
              ((lambda (x) (inc (inc (inc (inc (inc (inc (inc (inc x)))))))))
               x))) 5)

((lambda (x) ((lambda (x) (inc (inc (inc (inc (inc (inc (inc (inc x)))))))))
              (inc (inc (inc (inc (inc (inc (inc (inc x)))))))))) 5)

((lambda (x) (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc x))))))))))))))))) 5)

(inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc 5))))))))))))))))

