#lang sicp

; 1.42
(define (compose f g)
  (lambda (x) (f (g x))))

; 1.43
(define (repeated f n)
  (if (= n 1)
      f
      (compose f (repeated f (- n 1)))))

; 1.44
(define dx 0.0001)
(define (average a b c) (/ (+ a b c) 3))
(define (smooth f)
  (lambda (x)
    (average (f (- x dx))
             (f x)
             (f (+ x dx)))))

(define (n-fold-smoothed f n)
  ((repeated smooth n) f))

    