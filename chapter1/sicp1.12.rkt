#lang sicp

;(define (pascal row)
 ; (if (= row 1)
  ;    1
  ;    (* 11 (pascal (- row 1))))) ; breaks as soon as carry's are introduced...but the idea of shifting and adding might still work

; provide valid integer arguments:
; 1) for row N, element can be in the range 1...N.
; 2) row must be positive (>= 1)
(define (pascal row element)
  (if (or (= element 1) (= element row))
      1
      (+ (pascal (- row 1) (- element 1))
         (pascal (- row 1) element))))
