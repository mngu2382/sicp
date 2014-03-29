(define (combine-in-halves img1 img2 type)
  (let* ((width (car (gimp-image-width img1)))
         (height (car (gimp-image-height img1)))
         (new-img (car (gimp-image-new width height GRAY)))
         (img1-copy (car (gimp-image-duplicate img1)))
         (img2-copy (car (gimp-image-duplicate img2))))
        (cond ((string=? type "beside")
               (map gimp-image-scale
                    (list img1-copy img2-copy)
                    (list (/ width 2) (/ width 2))
                    (list height height)))
              ((string=? type "below")
               (map gimp-image-scale
                    (list img1-copy img2-copy)
                    (list width width)
                    (list (/ height 2) (/ height 2))))
              (else (error "incorrect TYPE string")))
        (define layer-img1 (car (gimp-layer-new-from-visible
                                  img1-copy
                                  new-img
                                  "img1")))
        (define layer-img2 (car (gimp-layer-new-from-visible
                                  img2-copy
                                  new-img
                                  "img2")))
        (if (string=? type "beside")
            (gimp-layer-set-offsets layer-img2 (/ width 2) 0)
            (gimp-layer-set-offsets layer-img1 0 (/ height 2))) 
        (gimp-image-insert-layer new-img layer-img1 0 -1)
        (gimp-image-insert-layer new-img layer-img2 0 -1)
        (gimp-image-flatten new-img)
        (car (gimp-image-duplicate new-img))))

(define (beside img1 img2)
  (combine-in-halves img1 img2 "beside"))

(define (below img1 img2)
  (combine-in-halves img1 img2 "below"))

(define (flip-horiz img)
    (let ((new-img (car (gimp-image-duplicate img))))
         (gimp-image-flip new-img ORIENTATION-HORIZONTAL)
         (car (gimp-image-duplicate new-img))))

(define (flip-vert img)
    (let ((new-img (car (gimp-image-duplicate img))))
         (gimp-image-flip new-img ORIENTATION-VERTICAL)
         (car (gimp-image-duplicate new-img))))

(define rogers (car (gimp-file-load RUN-INTERACTIVE
                                    "../images/rogers.png"
                                    "../images/rogers.png")))
(define wave (car (gimp-file-load RUN-INTERACTIVE
                                  "../images/wave.png"
                                  "../images/wave.png")))

;; figure 2.12
(define wave2 (beside wave (flip-vert wave)))
(define wave4 (below wave2 wave2))
(gimp-file-save RUN-INTERACTIVE
                wave2
                (car (gimp-image-get-active-layer wave2))
                "../images/wave2.png"
                "../images/wave2.png")
(gimp-file-save RUN-INTERACTIVE
                wave4
                (car (gimp-image-get-active-layer wave4))
                "../images/wave4.png"
                "../images/wave4.png")

;; figure 2.14
(define (right-split painter n)
  (if (= n 0)
      painter
      (let ((smaller (right-split painter (- n 1))))
        (beside painter (below smaller smaller)))))

(define (up-split painter n)
  (if (= n 0)
      painter
      (let ((smaller (up-split painter (- n 1))))
        (below painter (beside smaller smaller)))))

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

(define right-split-wave-4 (right-split wave 4))
(define right-split-rogers-4 (right-split rogers 4))
(define corner-split-wave-4 (corner-split wave 4))
(define corner-split-rogers-4 (corner-split rogers 4))
(gimp-file-save RUN-INTERACTIVE
                right-split-wave-4
                (car (gimp-image-get-active-layer right-split-wave-4))
                "../images/right_split_wave_4.png"
                "../images/right_split_wave_4.png")
(gimp-file-save RUN-INTERACTIVE
                right-split-rogers-4
                (car (gimp-image-get-active-layer right-split-rogers-4))
                "../images/right_split_rogers_4.png"
                "../images/right_split_rogers_4.png")
(gimp-file-save RUN-INTERACTIVE
                corner-split-wave-4
                (car (gimp-image-get-active-layer corner-split-wave-4))
                "../images/corner_split_wave_4.png"
                "../images/corner_split_wave_4.png")
(gimp-file-save RUN-INTERACTIVE
                corner-split-rogers-4
                (car (gimp-image-get-active-layer corner-split-rogers-4))
                "../images/corner_split_rogers_4.png"
                "../images/corner_split_rogers_4.png")

; figure 2.9
(define (square-limit painter n)
  (let ((quarter (corner-split painter n)))
    (let ((half (beside (flip-horiz quarter) quarter)))
      (below (flip-vert half) half))))

(define square-limit-wave (square-limit wave 4))
(define square-limit-rogers (square-limit rogers 4))
(gimp-file-save RUN-INTERACTIVE
                square-limit-wave
                (car (gimp-image-get-active-layer square-limit-wave))
                "../images/square-limit-wave.png"
                "../images/square-limit-wave.png")
(gimp-file-save RUN-INTERACTIVE
                square-limit-rogers
                (car (gimp-image-get-active-layer square-limit-rogers))
                "../images/square-limit-rogers.png"
                "../images/square-limit-rogers.png")


;; test images
; (define test-beside (beside rogers wave))
; (gimp-file-save RUN-INTERACTIVE
;                 test-beside
;                 (car (gimp-image-get-active-layer test-beside))
;                 "../images/test_beside1.png"
;                 "../images/test_beside1.png")
; 
; (define test-beside (beside wave rogers))
; (gimp-file-save RUN-INTERACTIVE
;                 test-beside
;                 (car (gimp-image-get-active-layer test-beside))
;                 "../images/test_beside2.png"
;                 "../images/test_beside2.png")
; 
; (define test-below (below rogers wave))
; (gimp-file-save RUN-INTERACTIVE
;                 test-below
;                 (car (gimp-image-get-active-layer test-below))
;                 "../images/test_below1.png"
;                 "../images/test_below1.png")
; 
; (define test-below (below wave rogers))
; (gimp-file-save RUN-INTERACTIVE
;                 test-below
;                 (car (gimp-image-get-active-layer test-below))
;                 "../images/test_below2.png"
;                 "../images/test_below2.png")
; 
; (define test-flip-horiz (flip-horiz rogers))
; (gimp-file-save RUN-INTERACTIVE
;                 test-flip-horiz
;                 (car (gimp-image-get-active-layer test-flip-horiz))
;                 "../images/test_flip_horiz.png"
;                 "../images/test_flip_horiz.png")
; 
; (define test-flip-vert (flip-vert rogers))
; (gimp-file-save RUN-INTERACTIVE
;                 test-flip-vert
;                 (car (gimp-image-get-active-layer test-flip-vert))
;                 "../images/test_flip_vert.png"
;                 "../images/test_flip_vert.png")


