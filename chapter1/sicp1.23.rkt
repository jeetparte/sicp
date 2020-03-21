#lang sicp

; helpers
(define (square x) (* x x))

; dependencies
(define (prime? n)
  (= n (smallest-divisor n)))

; given procedure
(define (timed-prime-test n)
  (newline)
  (display n)
  (start-prime-test n (runtime)))
(define (start-prime-test n start-time)
  (if (prime? n)
      (report-prime (- (runtime) start-time))))
(define (report-prime elapsed-time)
  (display " *** ")
  (display elapsed-time))

; modified smallest-divisor procedure - ex. 1.23
; only tests 2 and odd divisors
(define (next n)
  (if (= n 2)
      3
      (+ n 2)))

(define (smallest-divisor n)
  (find-divisor n 2))
(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((= (remainder n test-divisor) 0) test-divisor)
        (else (find-divisor n (next test-divisor)))))

; for convenience
(define (test n) (timed-prime-test n))
