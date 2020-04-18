#lang sicp

(define (square-list items)
  (if (null? items)
      nil
      (cons (square (car items)) (square-list (cdr items)))))

(define (square-list-using-map items)
  (map square items))

; helpers
(define square (lambda (x) (* x x)))

; tests
(define a (list 1 2 3 4 5 6 7 8))
(square-list a)
(square-list-using-map a)