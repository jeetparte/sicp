#lang sicp

(define (square x) (* x x))
(define (average x y)
  (/ (+ x y) 2))

(define (good-enough? guess x)
  (< (abs (- (square guess) x)) 0.0001))

(define (improve guess x)
  (average guess (/ x guess)))

(define (sqrt-iter guess x)
  (if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess x) x)))

(define (sqrt x)
  (sqrt-iter 1.0 x))

;; ex 1.6

(define (new-if predicate-clause then-clause else-clause)
  (cond (predicate-clause then-clause)
        (else else-clause)))

(define (new-sqr-iter guess x)
  (new-if (good-enough? guess x)
          guess
          (new-sqr-iter (improve guess x) x)))