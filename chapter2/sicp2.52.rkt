#lang sicp

; b.
(define (corner-split painter n)
  (if (= n 0)
      painter
      (let ((up (up-split painter (- n 1)))
            (right (right-split painter (- n 1))))
        (let ((top-left up)
              (bottom-right right)
              (corner (corner-split painter (- n 1))))
          (below (beside painter bottom-right)
                 (beside top-left corner))))))
; c.
(define (square-limit painter n)
  (define (identity painter) painter)
  (let ((combine4 (square-of-four flip-vert rotate180 identity flip-horiz)))
    (combine4 (corner-split painter n))))