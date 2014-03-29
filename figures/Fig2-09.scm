(load "../fragments/PictureLanguage_SICP.scm")
(load "../fragments/PictureLanguage_ScriptFu.scm")

(define (square-limit painter n)
  (let ((quarter (corner-split painter n)))
    (let ((half (beside (flip-horiz quarter) quarter)))
      (below (flip-vert half) half))))

(define square-limit-wave (square-limit wave 4))
(define square-limit-rogers (square-limit rogers 4))

(define identity-frame (make-frame
                         (make-vect 0.0 0.0)
                         (make-vect 1.0 0.0)
                         (make-vect 0.0 1.0)))

(define square-limit-wave-img (square-limit-wave identity-frame))
(define square-limit-rogers-img (square-limit-rogers identity-frame))

(gimp-file-save RUN-INTERACTIVE
                square-limit-wave-img
                (car (gimp-image-get-active-layer square-limit-wave-img))
                "../images/square-limit-wave.png"
                "../images/square-limit-wave.png")
(gimp-file-save RUN-INTERACTIVE
                square-limit-rogers-img
                (car (gimp-image-get-active-layer square-limit-rogers-img))
                "../images/square-limit-rogers.png"
                "../images/square-limit-rogers.png")

