#lang sicp

(define (f n)
  (if (< n 3)
      n
      (+ (f (- n 1))
         (* 2 (f (- n 2)))
         (* 3 (f (- n 3))))))
      
; iterative process
(define (f-iter n)
  (define (iter a b c state)    ; for any state, a is f(state), b is f(state - 1), c is f(state -2)
    (if (= state n)
        a
        (iter (+ a (* 2 b) (* 3 c))
              a
              b
              (+ state 1))))
  (cond ((< n 3) n)
        (else (iter 2 1 0 2))))
  