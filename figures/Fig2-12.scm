(load "../fragments/PictureLanguage_SICP.scm")
(load "../fragments/PictureLanguage_ScriptFu.scm")

(define wave2 (beside wave (flip-vert wave)))
(define wave4 (below wave2 wave2))

(define identity-frame (make-frame
                         (make-vect 0.0 0.0)
                         (make-vect 1.0 0.0)
                         (make-vect 0.0 1.0)))

(define wave2-img (wave2 identity-frame))
(define wave4-img (wave4 identity-frame))

(gimp-file-save RUN-INTERACTIVE
                wave2-img
                (car (gimp-image-get-active-layer wave2-img))
                "../images/wave2.png"
                "../images/wave2.png")
(gimp-file-save RUN-INTERACTIVE
                wave4-img
                (car (gimp-image-get-active-layer wave4-img))
                "../images/wave4.png"
                "../images/wave4.png")

