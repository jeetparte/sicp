#lang sicp
;; modified to count the no. of steps and return that
(define (count-change-steps amount kinds-of-coins)
  (+ 1  ;; root node
     (cc amount kinds-of-coins)))
(define (cc amount kinds-of-coins)
  (cond ((= amount 0) 0)
        ((or (< amount 0) (= kinds-of-coins 0)) 0)
        (else (+ (cc amount
                     (- kinds-of-coins 1))
                 (cc (- amount
                        (first-denomination kinds-of-coins))
                     kinds-of-coins)
                 2))))
(define (first-denomination kinds-of-coins)
  (cond ((= kinds-of-coins 1) 1)
        ((= kinds-of-coins 2) 5)
        ((= kinds-of-coins 3) 10)
        ((= kinds-of-coins 4) 25)
        ((= kinds-of-coins 5) 50)))

;; save typing
(define (count amount coins) (count-change-steps amount coins))
