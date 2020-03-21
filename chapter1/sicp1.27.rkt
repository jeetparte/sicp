#lang sicp

(define (fermat-test n a)
  (= (expmod a n n) a))

(define (fermat-test-exhaustive n)
  (define (run step)
    (cond ((= step n) ; steps 1 to n - 1 tested successfully
           true)
          ((fermat-test n step)
           (run (+ step 1)))
          (else
           false)))
  (run 1))

; returns base ^ exp (mod m)
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

; helpers
(define (square x) (* x x))
(define (even? x) (= (remainder x 2) 0))

; for convenience
(define (test n) (fermat-test-exhaustive n))

; Test results - 
; > (test 3)
; #t
; > (test 5)
; #t
; > (test 87)
; #f
; > (test 983)
; #t
; > (test 982)
; #f
; > (test 999983)
; #t
; 
; Carmichael numbers - 
; > (test 561)
; #t
; > (test 1105)
; #t
; > (test 1729)
; #t
; > (test 2465)
; #t
; > (test 2821)
; #t
; > (test 6601)
; #t