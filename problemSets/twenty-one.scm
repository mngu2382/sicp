;;; Provided scheme code for Twenty-One Simulator

; NB: a strategy is a procedure which take a hand and
; oppenents up card as arguments and returns a true is
; it wants another card and false otherwise

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
; Define a "stop-at" procedure that takes an argument x and returns a
; strategy which will continue drawing while hand-total is less than x
(define (stop-at x)
  (lambda (my-hand opponent-up-card)
    (< (hand-total my-hand) x))) 

; Problem 3
; Define a procedure "test-strategy" that tests two strategies by
; playing a specified number of simulated twenty-one games using the
; two strategies, it should return the number of games won by the
; player
(define (test-strategy player-strategy house-strategy games)
  (if (= games 0)
      0
      (+ (twenty-one player-strategy house-strategy)
         (test-strategy player-strategy house-strategy (- games 1)))))

(test-strategy (stop-at 16) (stop-at 15) 10000)
; 4806

; Problem 4
; Define a procedure "watch-player" that takes a strategy as an argument
; and returns a strategy as a result. The strategy returned is the
; same as the original strategy, but also should print the information
; suppiled to the strategy and the decision made.
(define (watch-player strategy)
  (lambda (hand opponent-up-card)
    (newline)
    (display "Your hand total:  ")
    (display (hand-total hand))
    (newline)
    (display "Opponent up card: ")
    (display opponent-up-card)
    (newline)
    (display "Hit?              ")
    (display (if (strategy hand opponent-up-card)
                 "You bet"
                 "Nah"))
    (strategy hand opponent-up-card)))

(test-strategy (watch-player (stop-at 16))
               (watch-player (stop-at 15))
               2)

; Your hand total:  4
; Opponent up card: 4
; Hit?              You bet
; Your hand total:  6
; Opponent up card: 4
; Hit?              You bet
; Your hand total:  14
; Opponent up card: 4
; Hit?              You bet
; Your hand total:  20
; Opponent up card: 4
; Hit?              Nah
; Your hand total:  4
; Opponent up card: 4
; Hit?              You bet
; Your hand total:  7
; Opponent up card: 4
; Hit?              You bet
; Your hand total:  12
; Opponent up card: 4
; Hit?              You bet
; Your hand total:  15
; Opponent up card: 4
; Hit?              Nah
; Your hand total:  9
; Opponent up card: 6
; Hit?              You bet
; Your hand total:  11
; Opponent up card: 6
; Hit?              You bet
; Your hand total:  14
; Opponent up card: 6
; Hit?              You bet
; Your hand total:  15
; Opponent up card: 6
; Hit?              You bet
; 1

; Problem 5
; Louis's strategy
(define (louis hand opponent-up-card)
  (let ((a1 (< (hand-total hand) 12))
        (a2 (= (hand-total hand) 12))
        (a3 (= (hand-total hand) 16))
        (a4 (and (> (hand-total hand) 12) (< (hand-total hand) 16)))
        (b1 (< opponent-up-card 4))
        (b2 (= opponent-up-card 10))
        (b3 (> opponent-up-card 6)))
    (or a1
        (and a2 b1)
        (and a3 (not b2))
        (and a4 b3))))

(test-strategy louis (stop-at 15) 10000)
; 3619
(test-strategy louis (stop-at 16) 10000)
; 3571
(test-strategy louis (stop-at 17) 10000)
; 3526

; Problem 6
; Define a procedure "both" which takes two strategies as arguments
; and returns a new strategy that will ask for a new card if and only
; if both strategies ark for a new card
(define (both strategy1 strategy2)
  (lambda (hand opponent-up-card)
    (and (strategy1 hand opponent-up-card)
         (strategy2 hand opponent-up-card))))

(twenty-one (both (stop-at 19) hit?) (stop-at 16))
; Opponent up card 10
; Your Total: 4
; Hit? y
; 
; Opponent up card 10
; Your Total: 12
; Hit? y

; Tutorial Exercise 1
; Data abstraction "card" which will record both the card's value and
; suit. "card-set" will be a set of cards. Therefore a hand will be
; represented as the hand's up card together with a set of cards

; card constructor and selectors
(define (make-card value suit)
  (cons value suit))

(define (card-value card)
  (car card))

(define (card-suit card)
  (cdr card))

; card-set constructors and selectors
(define (new-card-set up-card)
  (cons up-card `()))

(define (card-set-add card-set card)
  (cons (car card-set) (cons card (cdr card-set))))

(define (card-set-up-card card-set)
  (car card-set))

(define (card-set-total card-set)
  (if (null? card-set)
      0
      (+ (card-value (car card-set))
         (card-set-total (cdr card-set)))))




