#lang sicp

; An exercise in using 'dotted-tail notation'

; Psuedocode:
; find the parity of the first argument (let's call it 'p')
; if 'p' is odd, filter other arguments for odd items
; if 'p' is even, filter other arguments for even items
; return the list containing 'p' + the filtered arguments

; Actual code:
(define (same-parity p . sub-list)
  (let ((parity-filter (if (odd? p) odd? even?)))
    (cons p (filter sub-list parity-filter))))

; helpers
(define (filter items predicate)
  (if (null? items)
      nil
      (let ((current-item (car items)))
        (if (predicate current-item)
            (cons current-item
                  (filter (cdr items) predicate))
            (filter (cdr items) predicate)))))

(define (even? x) (= (remainder x 2) 0))
(define (odd? x) (not (even? x)))

; tests
(define one-through-nine (list 1 2 3 4 5 6 7 8 9))
(filter one-through-nine odd?)
(filter one-through-nine even?)

(same-parity 1 2 3 4 5 6 7)
(same-parity 2 3 4 5 6 7)


