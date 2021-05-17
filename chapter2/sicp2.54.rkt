#lang sicp

(define (equal? a b)
  (or
   (eq? a b) ; note - eq? handles empty lists correctly, i.e. (eq? '() '()) --> #t.
             ; This is important when we recursively cdr down the argument lists and might call (equal? '() '()).
   (and (pair? a)
        (pair? b)
        (equal? (car a) (car b))
        (equal? (cdr a) (cdr b)))))
