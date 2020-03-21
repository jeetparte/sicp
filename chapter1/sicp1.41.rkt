#lang sicp

(define (double f)
  (lambda (x) (f (f x))))

(define (inc n) (+ n 1))

; (((double (double double)) inc) 5) will return what value?
; (see notebook - evaluating the combination using the substitution model provides a clearer proof)
; First, let us see the amount of doubling involved - 
; (double double) returns a procedure that applies `double` to its argument twice.
; (double (double double)) returns a procedure that applies (double double) to its argument twice i.e., applies `double` to its argument 4 times.
; So the operator of the outermost combination will add 2 ^ 4 = 16 to the operand which is 5. Result will be 21.