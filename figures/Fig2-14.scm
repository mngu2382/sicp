(load "../fragments/PictureLanguage_SICP.scm")
(load "../fragments/PictureLanguage_ScriptFu.scm")

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

(define identity-frame (make-frame
                         (make-vect 0.0 0.0)
                         (make-vect 1.0 0.0)
                         (make-vect 0.0 1.0)))

(define right-split-wave-4-img (right-split-wave-4 identity-frame))
(define right-split-rogers-4-img (right-split-rogers-4 identity-frame))
(define corner-split-wave-4-img (corner-split-wave-4 identity-frame))
(define corner-split-rogers-4-img (corner-split-rogers-4 identity-frame))

(gimp-file-save RUN-INTERACTIVE
                right-split-wave-4-img
                (car (gimp-image-get-active-layer right-split-wave-4-img))
                "../images/right_split_wave_4.png"
                "../images/right_split_wave_4.png")
(gimp-file-save RUN-INTERACTIVE
                right-split-rogers-4-img
                (car (gimp-image-get-active-layer right-split-rogers-4-img))
                "../images/right_split_rogers_4.png"
                "../images/right_split_rogers_4.png")
(gimp-file-save RUN-INTERACTIVE
                corner-split-wave-4-img
                (car (gimp-image-get-active-layer corner-split-wave-4-img))
                "../images/corner_split_wave_4.png"
                "../images/corner_split_wave_4.png")
(gimp-file-save RUN-INTERACTIVE
                corner-split-rogers-4-img
                (car (gimp-image-get-active-layer corner-split-rogers-4-img))
                "../images/corner_split_rogers_4.png"
                "../images/corner_split_rogers_4.png")


