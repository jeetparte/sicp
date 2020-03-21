#lang sicp

; helpers
(define (average a b)
  (/ (+ a b) 2))
(define (display-step value step)
  (newline)
  (display value)
  (display " - step ")
  (display step))

(define tolerance 0.00001)
(define (fixed-point f first-guess)
  (define (close-enough? a b)
    (< (abs (- a b)) tolerance))
  (define (try guess step)
    (display-step guess step)
    (let ((next (f guess)))
      (cond ((close-enough? guess next)
             (display-step next (+ 1 step))
             next)
            (else (try next (+ step 1))))))
  (try first-guess 1))

; Solution to x ^ x = 1000
; i.e., the fixed point of x --> log(1000)/log(x)
;(define x (fixed-point (lambda (x) (/ (log 1000) (log x))) 2.0))

; with average damping
(define x (fixed-point (lambda (x) (average x (/ (log 1000) (log x)))) 2.0))