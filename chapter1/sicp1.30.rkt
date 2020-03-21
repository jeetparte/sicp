#lang sicp

; iterative variant of the `sum` procedure
(define (sum term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a) (+ result (term a)))))
  (iter a 0))

; run-time helpers
(define (cube x) (* x x x)) ; term
(define (identity x) x) ; term
(define (inc n) (+ n 1)) ; next
