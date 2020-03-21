#lang sicp

(define (nth-root x n)
  (let ((repeat-count (floor (log n 2))))
    (fixed-point
     ((repeated average-damp repeat-count) (lambda (y) (/ x (^ y (- n 1)))))
     1.0)))

; dependencies
(define (compose f g)
  (lambda (x) (f (g x))))

(define (repeated f n)
  (if (= n 1)
      f
      (compose f (repeated f (- n 1)))))

(define tolerance 0.00001)
(define (fixed-point f first-guess)
  (define (close-enough? a b)
    (< (abs (- a b)) tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (if (close-enough? guess next)
          next
          (try next))))
  (try first-guess))

(define (average a b)
  (/ (+ a b) 2))
(define (average-damp f)
  (lambda (x) (average x (f x))))

(define (^ x y)
  (if (= y 0)
      1
      (* x (^ x (- y 1)))))