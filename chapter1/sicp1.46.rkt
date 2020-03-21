#lang sicp

(define (iterative-improve good-enough? improve)
  (lambda (guess) (if (good-enough? guess)
                      guess
                      ((iterative-improve good-enough? improve) (improve guess)))))

; usage
(define (sqrt x)
  ((iterative-improve (lambda (guess) (< (abs (- (square guess) x)) 0.001))
                      (lambda (guess) (average guess (/ x guess))))
   1.0))

(define (fixed-point f first-guess)
  (define tolerance 0.00001)
  (define (fixed-point? x)
    (< (abs (- x (f x)))
       tolerance))
  ((iterative-improve fixed-point? f) first-guess))

; helpers
(define (square x) (* x x))
(define (average a b) (/ (+ a b) 2))
