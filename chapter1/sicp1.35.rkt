#lang sicp

;the golden ratio is the number* that satisfies the equation
;x^2 = x + 1
;* (one of them?)
;Dividing both sides by x, this becomes
;x = 1 + 1 / x
;i.e., the golden ratio is a fixed point of  x --> 1 + 1 / x

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

(define golden-ratio
  (fixed-point (lambda (x) (+ 1 (/ 1 x))) 1.0))