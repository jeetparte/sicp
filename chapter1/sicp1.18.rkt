#lang sicp

; a * b = 1 * (a * b) + 0
;       = (2 ^ n) * (a * b) + c —> invariant quantity for iterative process

(define (* a b)
  (define (mul-iter n a b c)
    (cond ((= b 0) c)
          ((even? b) (mul-iter (+ n 1) a (halve b) c))
          (else (mul-iter n a (- b 1) (+ c (repeat-double n a))))))
  (mul-iter 0 a b 0))
 
(define (double x) (+ x x))
(define (even? x) (= (remainder x 2) 0))
(define (halve x) (/ x 2))
(define (repeat-double n x) ; double x, n times and return the result i.e. computes `x * (2 ^ n)'
  (if (= n 0)
      x
      (repeat-double (- n 1) (double x))))


; a * b = a * b + c
; simpler implementation - uses only 3 state variables
(define (si-mul a b c)
  (cond ((= b 0) c)
        ((even? b) (si-mul (double a) (halve b) c))
        (else (si-mul a (- b 1) (+ c a)))))