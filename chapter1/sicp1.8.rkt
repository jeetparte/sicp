#lang sicp

; is 'a' a good approximate for 'b'?
(define (approximates a b)
  (< (/ (abs (- a b)) b) 1.0e-20))

; improve guess 'y' to get it closer to cube root of 'x'
(define (improve y x)
  (/ (+ (/ x
           (* y y))
        (* 2 y))
     3))

; find cube root of 'x' by improving 'guess'
(define (cubert-find x guess)
  (if (approximates (improve guess x) guess)
      guess
      (cubert-find x (improve guess x))))

; public API
(define (cubert x)
  (cubert-find x 1.0))