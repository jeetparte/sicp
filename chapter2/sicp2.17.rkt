#lang sicp

(define (last-pair list)
  (if (null? (cdr list))
      list
      (last-pair (cdr list))))

; testing
(last-pair (list 1 2 9 63))
(last-pair (list 68 888 2 -133))