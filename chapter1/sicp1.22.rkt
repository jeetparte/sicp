#lang sicp

; helpers
(define (square x) (* x x))
(define (odd? n) (not (= (remainder n 2) 0)))

; dependencies
(define (prime? n)
  (= n (smallest-divisor n)))

(define (smallest-divisor n)
  (find-divisor n 2))
(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((= (remainder n test-divisor) 0) test-divisor)
        (else (find-divisor n (+ 1 test-divisor)))))

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

; our procedure - ex. 1.22
(define (search-for-primes from to)
  (define (still-in-range? n) (not (> n to)))
  (define (test n)
    (cond ((still-in-range? n) (timed-prime-test n) (test (+ n 2)))))
  (if (odd? from)
      (test from)
      (test (+ 1 from))))

; alias
(define (search from to) (search-for-primes from to))