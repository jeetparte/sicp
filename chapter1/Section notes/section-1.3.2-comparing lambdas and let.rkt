#lang sicp

; SICP - 1.3.2 - Using `let` to create local variables

; comparing the special forms - lambdas and let

; goal - to express the function `f`:
; f(x, y) = x(1 + xy)^2 + y(1 - y) (1 + xy)(1 - y),
; which can be expressed as
; a = 1 + xy,
; b = 1 - y,
; f(x, y) = x * (a^2) + yb + ab

; Option 1
; using an auxiliary procedure
(define (f x y)
  (define (f-helper a b)
    (+ (* x (square a))
       (* y b)
       (* a b)))
  (f-helper (+ 1 (* x y))
            (- 1 y)))

; Option 2
; using a lambda expression to specify an anonymous procedure
; for binding our local variables
(define (f x y)
  ((lambda (a b)
     (+ (* x (square a))
        (* y b)
        (* a b)))
   (+ 1 (* x y))
   (- 1 y)))

; Option 3
; using the special form `let`
(define (f x y)
  (let ((a (+ 1 (* x y)))
        (b (- 1 y)))
    (+ (* x (square a))
       (* y b)
       (* a b))))
