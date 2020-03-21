#lang sicp

(define (miller-rabin-test n)
  (define (try-it a)
    (= (expmod a (- n 1) n) 1))
  (try-it (+ 1 (random (- n 1)))))

(define (expmod base exp m)
  (define (conditional-square-mod value)
  (if (and (not (= value 1))
           (not (= value (- m 1)))
           (= (remainder (square value) m) 1))
      0 ; non-trivial square root discovered!
      (remainder (square value) m)))
  (cond ((= exp 0) 1)
        ((even? exp)
         (conditional-square-mod (expmod base (/ exp 2) m)))
        (else
         (remainder (* base
                       (expmod base (- exp 1) m))
                    m))))

; helpers
(define (square x) (* x x))
(define (even? x) (= (remainder x 2) 0))
(define (fast-prime? n times)
  (cond ((= times 0) true)
        ((miller-rabin-test n) (fast-prime? n (- times 1)))
        (else false)))

; for convenience
(define (test n) (fast-prime? n 10)) ; test the number artbirary times

