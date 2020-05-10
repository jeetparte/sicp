#lang sicp

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence) (accumulate op initial (cdr sequence)))))

(define (count-leaves t)
  (accumulate + 0 (map (lambda (element)
                         (if (pair? element)
                             (count-leaves element)
                             1))
                       t)))

; tests
(define tree (list (list 4 4 4 4) (list 2 2) (list 3 3 3) 1))
(count-leaves tree)