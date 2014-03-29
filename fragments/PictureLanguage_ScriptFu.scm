; The Picture Language: integrating Script Fu and SICP

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

;; Image files
(define rogers-img (car (gimp-file-load RUN-INTERACTIVE
                                        "../images/rogers.png"
                                        "../images/rogers.png")))
(define wave-img (car (gimp-file-load RUN-INTERACTIVE
                                      "../images/wave.png"
                                      "../images/wave.png")))

;; New image to draw on
(define img-out (car (gimp-image-new
                          (* 1.5 (car (gimp-image-width rogers-img)))
                          (* 1.5 (car (gimp-image-height rogers-img)))
                          GRAY)))

;; Create painter from image files
(define (gimp-image->painter img-in img-out)
  (lambda (frame)
    (let
      ((width (car (gimp-image-width img-out)))
       (height (car (gimp-image-height img-out)))
       (o (origin-frame frame))
       (e1 (edge1-frame frame))
       (e2 (edge2-frame frame))
       (sum-e1e2 (add-vect (edge1-frame frame)
                           (edge2-frame frame)))
       (img-copy (car (gimp-image-duplicate img-in))))

      ; debugging info
      ;(display "Image width: ") (display width) (newline)
      ;(display "Image height: ") (display height) (newline)
      ;(display "Frame: ") (display frame) (newline)
      ;(display "Edge1 + Edge2: ") (display sum-e1e2) (newline)
      ;(display "Frame edges orthogonal: ")
      ;  (display (= 0 (dot-product e1 e2))) (newline)
      ;(display "Frame edges square with canvas: ")
      ;  (display (= (len-vect e1)
      ;              (+ (abs (xcor-vect e1))
      ;                 (abs (ycor-vect e1))))) (newline)
      (display "Adjusted x offest: ")
        (display (+ (xcor-vect o)
                    (min 0 (xcor-vect sum-e1e2)))) (newline)
      (display "Adjusted y offest: ")
        (display (- (+ (- (ycor-vect o) 1)
                       (max 0 (ycor-vect sum-e1e2))))) (newline)

      (define (flip? frame)
        (let
          ((v1 (edge1-frame frame))
           (v2 (edge2-frame frame)))
          (> 0 
             (- (* (xcor-vect v1) (ycor-vect v2))
                (* (ycor-vect v1) (xcor-vect v2))))))

      (define (inv-flip-frame frame)
        (let
          ((e1 (edge1-frame frame))
           (e2 (edge2-frame frame)))
          (make-frame
            (origin-frame frame)
            (make-vect
              (- (xcor-vect e1))
              (ycor-vect e1))
            (make-vect
              (- (xcor-vect e2))
              (ycor-vect e2)))))

      (define (inv-rotate-frame frame)
        (let
          ((e1 (edge1-frame frame))
           (e2 (edge2-frame frame)))
          (make-frame
            (origin-frame frame)
            (make-vect
              (ycor-vect e1)
              (- (xcor-vect e1)))
            (make-vect
              (ycor-vect e2)
              (- (xcor-vect e2))))))

      (define (iter-img frame)
        (cond
          ((or (>= 0 (xcor-vect (edge1-frame frame)))
               (>= 0 (ycor-vect (edge2-frame frame))))
           (cond
             ((flip? frame)
              ; horizontal flip
              (gimp-image-flip img-copy ORIENTATION-HORIZONTAL)
              (iter-img (inv-flip-frame frame)))
             (else
               ; rotating
               (gimp-image-rotate img-copy 2)
               (iter-img (inv-rotate-frame frame)))))))
      
      (cond
        ; frame edges orthogonal and square with canvas
        ((and (= 0 (dot-product e1 e2))
              (= (len-vect e1)
                 (+ (abs (xcor-vect e1))
                    (abs (ycor-vect e1)))))

         (iter-img frame)

         ; scaling
         (gimp-image-scale
           img-copy
           (* width (abs (xcor-vect sum-e1e2)))
           (* height (abs (ycor-vect sum-e1e2))))

         (define layer-img
           (car (gimp-layer-new-from-visible
                  img-copy
                  img-out
                  (number->string
                    (+ (car (gimp-image-get-layers img-out))
                       1)))))

         ; offsets
         (gimp-layer-set-offsets
           layer-img
           (* width (+ (xcor-vect o)
                       (min 0 (xcor-vect sum-e1e2))))
           (* height (- (+ (- (ycor-vect o) 1)
                           (max 0 (ycor-vect sum-e1e2))))))

         (gimp-image-insert-layer img-out layer-img 0 -1)
         (gimp-image-flatten img-out)
         (car (gimp-image-duplicate img-out)))

        (else
          (display "Cannot handle frame") (newline)
          (car (gimp-image-duplicate img-out)))))))

;; painters
(define rogers (gimp-image->painter rogers-img img-out))
(define wave (gimp-image->painter wave-img img-out))

