#lang sicp

(define (smallest-rat n d)
    (let ((g (gcd (abs n) (abs d)))) ; ignore signs
      (cons (/ n g) (/ d g))))

; version A
(define (make-rat n d)
    (if (or (and (> n 0) (> d 0))
            (and (< n 0) (< d 0)))
        (smallest-rat (abs n) (abs  d))
        (smallest-rat (- (abs n)) (abs d))))

; version B
; (inspired by jimwierich's solution here: https://github.com/jimweirich/sicp-study/blob/master/scheme/chapter2/ex2_01.scm)
(define (make-rat-2 n d)
  (if (< d 0)
      (smallest-rat (- n) (- d))
      (smallest-rat n d)))

; dependencies
(define (gcd a b) (if (= b 0)
                      a
                      (gcd b (remainder a b))))