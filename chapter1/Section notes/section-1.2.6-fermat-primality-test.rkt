#lang sicp

; fermat primality test

(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder
          (square (expmod base (/ exp 2) m))
          m))
        (else
         (remainder
          (* base (expmod base (- exp 1) m))
          m))))

; test on random `a' between 1 and n - 1
(define (fermat-test n)
  (define (try-it a)
    (= (expmod a n n) a))
  (try-it (+ 1 (random (- n 1)))))    ; (random n) returns a number between 0 and n - 1

; repeat test given no. of times and report likely result
(define (fast-prime? n times)
  (cond ((= times 0) true)
        ((fermat-test n) (fast-prime? n (- times 1)))
        (else false)))

; helpers

(define (square x) (* x x))
(define (even? n) (= (remainder n 2) 0))

(define (f n) (fast-prime? n n))