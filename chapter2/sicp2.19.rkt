#lang sicp

(define (first-denomination coins)
  (car coins))

(define (except-first-denomination coins)
  (cdr coins))

(define (no-more? coins)
  (null? coins))

; Regarding whether the order of the coins in the input list affects the output of `cc`,
; my guess is it would'nt.
; The tree formed by the recursive process would have a different shape (i.e. structuring) but
; essentially have the same components.

; modified `cc` procedure
(define (cc amount coin-values)
  (cond ((= amount 0) 1)
        ((or (< amount 0) (no-more? coin-values)) 0)
        (else
         (+ (cc amount
                (except-first-denomination
                 coin-values))
            (cc (- amount
                   (first-denomination
                    coin-values))
                coin-values)))))
; Tests
(define us-coins (list 50 25 10 5 1))
(define us-coins-shuffled (list 1 50 5 25 10))
(define uk-coins (list 100 50 20 10 5 2 1 0.5))

(cc 100 us-coins)
(cc 100 us-coins-shuffled)
(cc 100 uk-coins)