#lang sicp

(define (equal? a b)
  (or
   (eq? a b)
   (and (equal? (car a) (car b))
        (equal? (cdr a) (cdr b)))))
