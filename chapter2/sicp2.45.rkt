#lang sicp
(#%require sicp-pict)

(define (split primary secondary)
  (define (rec-split painter n)
    (if (= n 0)
        painter
        (let ((next-level (rec-split painter (- n 1))))
          (primary painter (secondary next-level next-level)))))
  rec-split)

(define right-split (split beside below))
(define up-split (split below beside))

(define my-pattern
 (right-split mark-of-zorro 2))
(paint my-pattern)

         