#lang sicp

(define (cons a b)
  (* (^ 2 a)
     (^ 3 b)))

(define (count-of-factor f number)
  (if (divides f number)
      (+ 1 (count-of-factor f (/ number f)))
      0))

(define (car z)  
  (count-of-factor 2 z))

(define (cdr z)
  (count-of-factor 3 z))

; helpers
(define (^ b n)
  (if (= n 0)
      1
      (* b
         (^ b (- n 1)))))

(define (divides a b)
  (= (remainder b a) 0))

; testing
(define (test-pair a b)
  (let ((pair (cons a b)))
    (newline)
    (if (and (= (car pair) a)
             (= (cdr pair) b)
             (= (cons (car pair) (cdr pair)) pair))
        (display "Test passed.")
        (display "Test failed."))))

(test-pair 5 2)
(test-pair 0 0)
(test-pair 91 93)
