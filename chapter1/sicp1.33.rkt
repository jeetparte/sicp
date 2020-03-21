#lang sicp

;(define (filtered-accumulate predicate combiner null-value term a next b)
;  (if (> a b)
;      null-value
;      (if (predicate a)
;          (combiner (term a)
;                    (filtered-accumulate predicate combiner null-value term (next a) next b))
;          (filtered-accumulate predicate combiner null-value term (next a) next b))))

; iterative
;(define (filtered-accumulate predicate combiner null-value term a next b)
;  (define (iter a result)
;    (if (> a b)
;        result
;        (iter (next a)
;              (if (predicate a)
;                  (combiner (term a) result)
;                  result))))
;  (iter a null-value))

; recursive - made concise
(define (filtered-accumulate predicate combiner null-value term a next b)
  (define (filtered-accumulate k)
    (if (> k b)
        null-value
        (if (predicate k)
            (combiner (term k)
                      (filtered-accumulate (next k)))
            (filtered-accumulate (next k)))))
  (filtered-accumulate a))
      

; using `filtered-accumulate` to express
; a. the sum of squares of the prime numbers in the interval `a` to `b`
(define (sum-squares-of-primes a b)
  (filtered-accumulate prime? + 0 square a inc b))
; b. the product of all the positive integers < `n` that are relatively prime to n
; (i.e., all positive integers i < n such that GCD(i, n) = 1)
(define (product-of-relative-primes-smaller-than n)
  (define (relative-prime? i)
    (= (gcd n i) 1))
  (filtered-accumulate relative-prime? * 1 identity 1 inc (- n 1)))

; dependencies
(define (prime? n)
  (= n (smallest-divisor n)))

(define (smallest-divisor n)
  (find-divisor n 2))
(define (find-divisor n test-divisor)
  (define (next-test-divisor)
  (if (= test-divisor 2)
      3
      (+ test-divisor 2)))
  (cond ((> (square test-divisor) n) n)
        ((= (remainder n test-divisor) 0) test-divisor)
        (else (find-divisor n (next-test-divisor)))))

(define (gcd a b) ; note: `a` > `b`
  (if (= b 0)
      a
      (gcd b (remainder a b))))

; helpers
(define (square x) (* x x))
(define (inc n) (+ n 1))
(define (identity x) x)


