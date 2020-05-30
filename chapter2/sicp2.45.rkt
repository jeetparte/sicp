#lang sicp
(#%require sicp-pict)

(define (split primary-split secondary-split)
  (define (rec-split painter n)
    (if (= n 0)
        painter
        (let ((next-level (rec-split painter (- n 1))))
          (primary-split painter (secondary-split next-level next-level)))))
  rec-split)

(define right-split (split beside below))
(define up-split (split below beside))

(define my-pattern
 (right-split mark-of-zorro 2))
(paint my-pattern)

         