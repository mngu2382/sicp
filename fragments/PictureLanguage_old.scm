; From SICP
;; Vectors
(define (make-vect x y)
  (cons x y))

(define (xcor-vect vect)
  (car vect))

(define (ycor-vect vect)
  (cdr vect))

(define (add-vect v1 v2)
  (make-vect (+ (xcor-vect v1) (xcor-vect v2))
             (+ (ycor-vect v1) (ycor-vect v2))))

(define (sub-vect v1 v2)
  (make-vect (- (xcor-vect v1) (xcor-vect v2))
             (- (ycor-vect v1) (ycor-vect v2))))

(define (scale-vect s v)
   (make-vect (* s (xcor-vect v))
              (* s (ycor-vect v))))

;; Segments
(define (make-segment v1 v2)
  (cons v1 v2))

(define (start-segment seg)
  (car seg))

(define (end-segment seg)
  (cdr seg))

;; Frames
(define (make-frame origin edge1 edge2)
  (list origin edge1 edge2))

(define (origin-frame frame)
  (car frame))

(define (edge1-frame frame)
  (car (cdr frame)))

(define (edge2-frame frame)
  (car (cdr (cdr frame))))

(define (frame-coord-map frame)
  (lambda (v)
    (add-vect
      (origin-frame frame)
      (add-vect (scale-vect (xcor-vect v)
                            (edge1-frame frame))
                (scale-vect (ycor-vect v)
                            (edge2-frame frame))))))

;; Painters
(define (segments->painter segment-list)
  (lambda (frame)
    (for-each
      (lambda (seqment)
        (draw-line
         ((frame-coord-map frame) (start-segment segment))
         ((frame-coord-map frame) (end-seqment segment))))
      segment-list)))

;; Transforms
(define (transform-painter painter origin corner1 corner2)
  (lambda (frame)
    (let ((m (frame-coord-map frame)))
      (let ((new-origin (m origin)))
        (painter
          (make-frame new-origin
                      (sub-vect (m corner1) new-origin)
                      (sub-vect (m corner2) new-origin)))))))

;; Operations
(define (flip-vert painter)
  (transform-painter painter
                     (make-vect 0.0 1.0)
                     (make-vect 1.0 1.0)
                     (make-vect 0.0 0.0)))

(define (flip-horiz painter)
  (transform-painter painter
                     (make-vect 1.0 0.0)
                     (make-vect 0.0 0.0)
                     (make-vect 1.0 1.0)))

(define (rotate90 painter)
  (transform-painter painter
                     (make-vect 1.0 0.0)
                     (make-vect 1.0 1.0)
                     (make-vect 0.0 0.0)))

(define (rotate180 painter)
  (rotate90 (rotate90 painter)))

(define (rotate270 painter)
  (rotate90 (rotate180 painter))

(define (beside painter1 painter2)
  (let ((split-point (make-vect 0.5 0.0)))
    (let ((paint-left
           (transform-painter painter1
                              (make-vect 0.0 0.0)
                              split-point
                              (make-vect 0.0 1.0)))
          (paint-right
           (transform-painter painter2
                              split-point
                              (make-vect 1.0 0.0)
                              (make-vect 0.5 1.0))))
       (lambda (frame)
         (paint-left frame)
         (paint-right frame)))))

(define (below painter1 painter2)
  (rotate90 (beside (rotate270 painter1)
                    (rotate270 painter2))))

(define (square-of-four tl tr bl br)
  (lambda (painter)
    (let ((top (beside (tl painter) (tr painter)))
          (bottom (beside (bl painter) (br painter))))
      (below bottom top))))

(define flipped-pairs
  (square-of-four identity flip-vert identity flip-vert))

(define (split proc1 proc2)
  (lambda (painter n)
    (if (= n 0)
        painter
        (let ((smaller ((split proc1 proc2) painter (- n 1))))
             (proc1 painter (proc2 smaller smaller))))))

(define right-split (split beside below))
(define up-split (split below beside))

(define (corner-split painter n)
  (if (= n 0)
      painter
      (let ((up (up-split painter (- n 1)))
            (right (right-split painter (- n 1))))
        (let ((top-left (beside up up))
              (bottom-right (below right right))
              (corner (corner-split painter (- n 1))))
             (beside (below painter top-left)
                     (below bottom-right corner))))))

(define (square-limit painter n)
  (let ((combine4 (square-of-four flip-horiz identity
                                  rotate180 flip-vert)))
    (combine4 (corner-split painter n))))

; Intergrating Script Fu and SICP

;; More vector operations
(define (square x) (* x x))
(define (len-vect v)
  (sqrt (+ (square (xcor-vect v))
           (square (ycor-vect v)))))
(define (dot-product u v)
  (+ (* (xcor-vect u) (xcor-vect v))
     (* (ycor-vect u) (ycor-vect v))))
(define (det u v)
  (- (* (xcor-vect u) (ycor-vect v))
     (* (ycor-vect u) (xcor-vect v))))

(define rogers-img (car (gimp-file-load RUN-INTERACTIVE
                                        "../images/rogers.png"
                                        "../images/rogers.png")))

(define rogers
  (lambda (frame)
    (lambda (gimp-image)
      (let ((width (car (gimp-image-width gimp-image)))
            (height (car (gimp-image-height gimp-image)))
            (o (origin-frame frame))
            (e1 (edge1-frame frame))
            (e2 (edge2-frame frame))
            (e1-len (len-vect (edge1-frame frame)))
            (e2-len (len-vect (edge2-frame frame)))
            (frame-diag (add-vect (edge1-frame frame)
                                  (edge2-frame frame)))
            (frame-width (+ (xcor-vect (edge1-frame frame))
                            (xcor-vect (edge2-frame frame))))
            (frame-height (+ (ycor-vect (edge1-frame frame))
                             (ycor-vect (edge2-frame frame))))
            (rogers-copy (car (gimp-image-duplicate rogers-img))))

        ; debugging info
        (display "Image width: ") (display width) (newline)
        (display "Image height: ") (display height) (newline)
        (display "Frame origin: ") (display o) (newline)
        (display "Frame edge 1: ") (display e1) (newline)
        (display "Frame edge 2: ") (display e2) (newline)
        (display "Frame width: ") (display frame-width) (newline)
        (display "Frame height: ") (display frame-height) (newline)
        (display "Frame edges orthogonal: ") (display (= 0 (dot-product e1 e2))) (newline)
        (display "Frame edges square with canvas: ") (display (= (len-vect e1)
                                                                 (+ (xcor-vect e1)
                                                                    (ycor-vect e1)))) (newline)

        (define (flip? frame)
          (let ((v1 (edge1-frame frame))
                (v2 (edge2-frame frame)))
            (> 0 
               (- (* (xcor-vect v1) (ycor-vect v2))
                  (* (ycor-vect v1) (xcor-vect v2))))))

        (define (rotate? frame)
          (or (> 0 (xcor-vect (edge1-frame frame)))
              (> 0 (ycor-vect (edge2-frame frame)))))

        (define (rotate-frame frame)
          (let ((o (origin-frame frame))
                (e1 (edge1-frame frame))
                (e2 (edge2-frame frame)))
            (make-frame o
                        (make-vect (- (ycor-vect e1)) (xcor-vect e1))
                        (make-vect (- (ycor-vect e2)) (xcor-vect e2)))))

        (define (rotate-img frame)
          (cond ((rotate? frame)
                 (gimp-image-rotate rogers-copy 2)
                 (rotate-img (rotate-frame frame)))))

        (cond
          ; frame edges orthogonal and square with canvas
          ((and (= 0 (dot-product e1 e2))
                (= (len-vect e1)
                   (+ (xcor-vect e1)
                      (ycor-vect e1))))
           
           (gimp-image-scale
             rogers-copy
             (* width e1-len)
             (* height e2-len))

           (cond
             ((rotate? frame)
              (let (l (max (* width frame-width)
                           (* height frame-height)))
                (gimp-image-resize rogers-copy l l 0 0))

              (rotate-img frame)

              (gimp-image-resize
                rogers-copy
                (* width frame-width)
                (* height frame-height)
                0
                0)))

           (cond
             ((> 0 (det e1 e2))
              (gimp-image-flip rogers-copy ORIENTATION-HORIZONTAL)))

           (define layer-img
             (car (gimp-layer-new-from-visible
                    rogers-copy
                    gimp-image
                    "rogers-copy")))

           (gimp-layer-set-offsets
             layer-img
             (* width (+ (xcor-vect o)
                         (min 0 (xcor-vect frame-diag))))
             (* height (+ (ycor-vect o)
                          (min 0 (ycor-vect frame-diag)))))

           (gimp-image-insert-layer gimp-image layer-img 0 -1)
           (gimp-image-flatten gimp-image)
           (car (gimp-image-duplicate gimp-image)))

          (else
            (display "Cannot handle frame") (newline)
            (car (gimp-image-duplicate gimp-image))))))))

(define rogers
  (lambda (frame)
    (lambda (gimp-image)
      (let ((width (car (gimp-image-width gimp-image)))
            (height (car (gimp-image-height gimp-image)))
            (x-edge1 (xcor-vect (edge1-frame frame)))
            (y-edge2 (ycor-vect (edge2-frame frame)))
            (rogers-copy (car (gimp-image-duplicate rogers-img))))

        ; debugging
        (display "Image width: ") (display width) (newline)
        (display "Image height: ") (display height) (newline)
        (display "Frame origin: ") (display (origin-frame frame)) (newline)
        (display "Frame edge 1: ") (display (edge1-frame frame)) (newline)
        (display "Frame edge 2: ") (display (edge2-frame frame)) (newline)
        (display "Rogers width: ") (display (* width x-edge1)) (newline)
        (display "Rogers height: ") (display (* height y-edge2)) (newline)
        (display "Rogers offset x: ") (display (* width (xcor-vect (origin-frame frame)))) (newline)
        (display "Rogers offset y: ") (display (* height (ycor-vect (origin-frame frame)))) (newline)

        (gimp-image-scale
          rogers-copy
          (* width (abs x-edge1))
          (* height (abs y-edge2)))

        (cond
          ((< x-edge1 0)
           (gimp-image-flip rogers-copy ORIENTATION-HORIZONTAL)
           (define origin-x-adj x-edge1))
          (else (define origin-x-adj 0)))

        (cond
          ((< y-edge2 0)
           (gimp-image-flip rogers-copy ORIENTATION-VERTICAL)
           (define origin-y-adj y-edge2))
          (else (define origin-y-adj 0)))

        (display "Rogers offset x with adjustment: ")
          (display (* width (+ (xcor-vect (origin-frame frame)) origin-x-adj))) (newline)
        (display "Rogers offset y with adjustment: ")
          (display (* height (+ (ycor-vect (origin-frame frame)) origin-y-adj))) (newline)

        (define layer-img (car (gimp-layer-new-from-visible
                                 rogers-copy
                                 gimp-image
                                 "rogers-copy")))

        (gimp-layer-set-offsets
          layer-img
          (* width (+ (xcor-vect (origin-frame frame))
                origin-x-adj))
          (* height (+ (ycor-vect (origin-frame frame))
                origin-y-adj)))

        (gimp-image-insert-layer gimp-image layer-img 0 -1)
        (gimp-image-flatten gimp-image)
        (car (gimp-image-duplicate gimp-image))))))

(define test-image (car (gimp-image-new
                          (car (gimp-image-width rogers-img))
                          (car (gimp-image-height rogers-img))
                          GRAY)))
(define identity-frame (make-frame
                         (make-vect 0.0 0.0)
                         (make-vect 1.0 0.0)
                         (make-vect 0.0 1.0)))

(define test ((rogers identity-frame) test-image))
(define test-flip-vert (((flip-vert rogers) identity-frame) test-image))
(define test-flip-hori (((flip-hori rogers) identity-frame) test-image))
(define test-rotate90 (((rotate90 rogers) identity-frame) test-image))

(gimp-display-new test-flip-vert)
