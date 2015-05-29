; leaf constructor and selectors
(define (make-leaf symbol weight)
  (list 'leaf symbol weight))

(define (leaf? object)
  (eq? (car object) 'leaf))

(define (symbol-leaf x) (cadr x))

(define (weight-leaf x) (caddr x))

; tree constructor and selectors
(define (make-code-tree left right)
  (list left
        right
        (append (symbols left) (symbols right))
        (+ (weight left) (weight right))))

(define (left-branch tree) (car tree))

(define (right-branch tree) (cadr tree))

(define (symbols tree)
  (if (leaf? tree)
      (list (symbol-leaf tree))
      (caddr tree)))

(define (weight tree)
  (if (leaf? tree)
      (weight-leaf tree)
      (cadddr tree)))

; decoding
(define (decode bits tree)
  (define (decode-1 bits current-branch)
    (if (null? bits)
        '()
        (let ((next-branch
               (choose-branch (car bits) current-branch)))
             (if (leaf? next-branch)
                 (cons (symbol-leaf next-branch)
                       (decode-1 (cdr bits) tree))
                 (decode-1 (cdr bits) next-branch)))))
  (decode-1 bits tree))

(define (choose-branch bit branch)
  (cond ((= bit 0) (left-branch branch))
        ((= bit 1) (right-branch branch))
        (else (error "bad bit - CHOOSE-BRANCH" bit))))

; encoding
(define (encode message tree)
  (if (null? message)
      '()
      (append (encode-symbol (car message) tree)
              (encode (cdr message) tree))))

(define (encode-symbol symbol tree)
  (cond ((leaf? tree) '())
        ((element-of-set? symbol (symbols (left-branch tree)))
         (cons 0 (encode-symbol symbol (left-branch tree))))
        ((element-of-set? symbol (symbols (right-branch tree)))
         (cons 1 (encode-symbol symbol (right-branch tree))))
        (else (error "symbol not in tree - ENCODE-SYMBOL" ))))

; generate huffman tree
(define (generate-huffman-tree pairs)
  (successive-merge (make-leaf-set pairs)))

(define (successive-merge leaf-set)
  (if (null? (cdr leaf-set))
      (car leaf-set)
      (successive-merge
        (adjoin-set
          (make-code-tree (cadr leaf-set)
                          (car leaf-set))
          (cddr leaf-set)))))

; utility procedures
(define (adjoin-set x set)
  (cond ((null? set) (list x))
        ((< (weight x) (weight (car set))) (cons x set))
        (else (cons (car set)
                    (adjoin-set x (cdr set))))))

(define (make-leaf-set pairs)
  (if (null? pairs)
      '()
      (let ((pair (car pairs)))
        (adjoin-set (make-leaf (car pair)      ;symbol
                               (cadr pair))    ;frequency
                    (make-leaf-set (cdr pairs))))))

(define (element-of-set? x set)
  (cond ((null? set) false)
        ((equal? x (car set)) true)
        (else (element-of-set? x (cdr set)))))

; Exercise 2.72
; We test two different huffman trees: firstly, were all symbols
; have the same relative frequencies; and secondly, where the
; the symbol/frequencies are as described in Ex2.71
;
; We will encode 100 random symbols while increasing the number of
; symbols in our alphabet 

(define (make-my-tree-1 n)
  ; all symbols have same frequency
  (define (make-my-list n)
    (if (< n 0)
        '()
        (cons (list n 1) (make-my-list (- n 1)))))
  (generate-huffman-tree (make-my-list n)))

(define (make-my-tree-2 n)
  ; symbol/frequency as described in Ex2.71
  (define (make-my-list n)
    (if (< n 0)
        '()
        (cons (list n (expt 2 n)) (make-my-list (- n 1)))))
  (generate-huffman-tree (make-my-list n)))

(define (time-encoding symbols tree start-time)
  (map (lambda (s) (encode-symbol s tree)) symbols)
  (display (- (runtime) start-time)))

(define (random-symbols-1 n)
  ; a list of 1000 random numbers, between 0 and n (inclusive)
  (map (lambda (i) (random n)) (iota 1000)))

(define t (make-my-tree-1 1000))
(define s (random-symbols-1 1000))
(time-encoding s t (runtime))
; .8300000000000001

(define t (make-my-tree-1 2000))
(define s (random-symbols-1 2000))
(time-encoding s t (runtime))
; 1.5899999999999999

(define t (make-my-tree-1 3000))
(define s (random-symbols-1 3000))
(time-encoding s t (runtime))
; 2.510000000000005

(define t (make-my-tree-1 4000))
(define s (random-symbols-1 4000))
(time-encoding s t (runtime))
; 3.200000000000003

(define t (make-my-tree-1 5000))
(define s (random-symbols-1 5000))
(time-encoding s t (runtime))
; 4.150000000000006

(define (random-symbols-2 n)
  (let ((d (- (expt 2 (+ n 1)) 1)))
    (define (f x m)
      (if (<= x (/ (expt 2 m) d))
          m
          (f (- x (/ (expt 2 m) d)) (- m 1))))
    (map (lambda (i) (f (random 1.0) n))
         (iota 10000))))

(define t (make-my-tree-2 1000))
(define s (random-symbols-2 1000))
(time-encoding s t (runtime))
; .10000000000000142

(define t (make-my-tree-2 2000))
(define s (random-symbols-2 2000))
(time-encoding s t (runtime))
; .120000000000001

(define t (make-my-tree-2 3000))
(define s (random-symbols-2 3000))
(time-encoding s t (runtime))
; .09999999999999432

(define t (make-my-tree-2 4000))
(define s (random-symbols-2 4000))
(time-encoding s t (runtime))
; .10000000000000142

(define t (make-my-tree-2 5000))
(define s (random-symbols-2 5000))
(time-encoding s t (runtime))
; .09000000000000341
