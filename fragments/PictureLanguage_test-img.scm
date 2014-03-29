(load "./PictureLanguage_SICP.scm")
(load "./PictureLanguage_ScriptFu.scm")


(define identity-frame (make-frame
                         (make-vect 0.0 0.0)
                         (make-vect 1.0 0.0)
                         (make-vect 0.0 1.0)))

(define test (rogers identity-frame))
(define test-flip-vert ((flip-vert rogers) identity-frame))
(define test-flip-hori ((flip-horiz rogers) identity-frame))
(define test-rotate90 ((rotate90 rogers) identity-frame))
(define test-rotate180 ((rotate180 rogers) identity-frame))
(define test-rotate270 ((rotate270 rogers) identity-frame))
(define test-beside ((beside rogers wave) identity-frame))
(define test-below ((below rogers wave) identity-frame))
(define test-flipped-pairs ((flipped-pairs rogers) identity-frame))
(define test-right-split ((right-split rogers 1) identity-frame))
(define test-up-split ((up-split rogers 1) identity-frame))
(define test-corner-split ((corner-split rogers 1) identity-frame))
(define test-square-limit ((square-limit rogers 4) identity-frame))

; view image
(gimp-display-new test)
