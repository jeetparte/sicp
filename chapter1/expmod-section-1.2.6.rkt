#lang sicp

(define (even? a)
  (= (remainder a 2) 0))

(define (square a)
  (* a a))

(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp) (remainder
                      (square (expmod base (/ exp 2) m))
                      m))
        (else (remainder
               (* base (expmod base (- exp 1) m))
               m))))