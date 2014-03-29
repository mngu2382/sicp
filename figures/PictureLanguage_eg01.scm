(load "../fragments/PictureLanguage_SICP.scm")
(load "../fragments/PictureLanguage_ScriptFu.scm")

(define (addborder img)
  (script-fu-addborder
    img
    (car (gimp-image-get-active-drawable img))
    1 1 '(0 0 0) 0)
  (gimp-image-flatten img))


(define identity-frame (make-frame
                         (make-vect 0.0 0.0)
                         (make-vect 1.0 0.0)
                         (make-vect 0.0 1.0)))
(define eg01 (wave identity-frame))
(script-fu-addborder
  eg01 (car (gimp-image-get-active-drawable eg01))
  1 1 '(0 0 0) 0)
(gimp-image-flatten eg01)
(gimp-file-save RUN-INTERACTIVE
                eg01
                (car (gimp-image-get-active-layer eg01))
                "../images/PictureLanguage_eg01.png"
                "../images/PictureLanguage_eg01.png")

(load "./PictureLanguage_ScriptFu.scm")
(define eg02
  (wave (make-frame
          (make-vect 0.0 0.0)
          (make-vect 0.5 0.0)
          (make-vect 0.0 0.5))))
(script-fu-addborder
  eg02 (car (gimp-image-get-active-drawable eg02))
  1 1 '(0 0 0) 0)
(gimp-image-flatten eg02)
(gimp-file-save RUN-INTERACTIVE
                eg02
                (car (gimp-image-get-active-layer eg02))
                "../images/PictureLanguage_eg02.png"
                "../images/PictureLanguage_eg02.png")

(load "./PictureLanguage_ScriptFu.scm")
(define eg03
  (wave (make-frame
          (make-vect 1 1)
          (make-vect 0 -1)
          (make-vect -1 0))))
(script-fu-addborder
  eg03 (car (gimp-image-get-active-drawable eg03))
  1 1 '(0 0 0) 0)
(gimp-image-flatten eg03)
(gimp-file-save RUN-INTERACTIVE
                eg03
                (car (gimp-image-get-active-layer eg03))
                "../images/PictureLanguage_eg03.png"
                "../images/PictureLanguage_eg03.png")
