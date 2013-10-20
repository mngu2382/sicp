;;; Provided scheme code for Twenty-One Simulator

; Simulates a game given two strategies, returns
; 1 if player wins, 0 if house wins
(define (twenty-one player-strategy house-strategy)
  (let ((house-initial-hand (make-new-hand (deal))))
    (let ((player-hand
           (play-hand player-strategy
                      (make-new-hand (deal))
                      (hand-up-card house-initial-hand))))
      (if (> (hand-total player-hand) 21)
          0                                ; ``bust'': player loses
          (let ((house-hand 
                 (play-hand house-strategy
                            house-initial-hand
                            (hand-up-card player-hand))))
            (cond ((> (hand-total house-hand) 21)
                   1)                      ; ``bust'': house loses
                  ((> (hand-total player-hand)
                      (hand-total house-hand))
                   1)                      ; house loses
                  (else 0)))))))           ; player loses

; Given arguments, continues to accept cards for as
; long as the strategy requests, ot until the total
; of the cards in the hand exceed 21
(define (play-hand strategy my-hand opponent-up-card)
  (cond ((> (hand-total my-hand) 21) my-hand) ; I lose... give up
        ((strategy my-hand opponent-up-card) ; hit?
         (play-hand strategy
                    (hand-add-card my-hand (deal))
                    opponent-up-card))
        (else my-hand)))                ; stay

; infinite deck with values 1,...,10 all equally likely
(define (deal) (+ 1 (random 10)))

; Constructors
(define (make-new-hand first-card)
  (make-hand first-card first-card))

(define (make-hand up-card total)
  (cons up-card total))

(define (hand-add-card hand new-card)
  (make-hand (hand-up-card hand)
             (+ new-card (hand-total hand))))

; Selectors
(define (hand-up-card hand)
  (car hand))

(define (hand-total hand)
  (cdr hand))

; Interactive strategy procedure which can be used with twenty-one
(define (hit? your-hand opponent-up-card)
  (newline)
  (display "Opponent up card ")
  (display opponent-up-card)
  (newline)
  (display "Your Total: ")
  (display (hand-total your-hand))
  (newline)
  (display "Hit? ")
  (user-says-y?))

; Compares expression read from the terminal to the symbol y
(define (user-says-y?) (eq? (read) 'y))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Problem 2
; Define a stop-at procedure that takes an argument x and returns a
; strategy which will continue drawing while hand-total is less than x
(define (stop-at x)
  (lambda (my-hand opponent-up-card)
    (< (hand-total my-hand) x))) 

; Problem 3
