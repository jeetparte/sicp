#lang sicp

(define (square x) (* x x))
(define (inc x) (+ x 1))

(define (compose f g)
  (lambda (x) (f (g x))))

(define (repeated f n)
  (if (= n 1)
      f
      (compose f (repeated f (- n 1)))))

(define dx 0.0001)
(define (average a b c) (/ (+ a b c) 3))
(define (smooth f)
  (lambda (x)
    (average (f (- x dx))
             (f x)
             (f (+ x dx)))))

(define (n-fold-smoothed f n)
  (repeated smooth n))

    