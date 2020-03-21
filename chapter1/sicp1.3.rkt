#lang sicp
(define (<= a b) (not (> a b)))

(define (smaller a b)
  (if (<= a b)
      a
      b))

(define (smallest a b c)
  (smaller (smaller a b) (smaller b c)))

(define (sum-of-squares x y)
  (+ (* x x) (* y y)))
  
(define (sum-of-squares-of-two-highest a b c)
  (cond ((= a (smallest a b c)) (sum-of-squares b c))
         ((= b (smallest a b c)) (sum-of-squares a c))
         (else (sum-of-squares a b))))