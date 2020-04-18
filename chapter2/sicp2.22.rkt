#lang sicp


; Why does Louis' code return the desired output with items in reversed order?

(define (square-list items)
  (define (iter things answer)
    (if (null? things) answer
        (iter (cdr things)
              (cons (square (car things))
                    answer))))
  (iter items nil))

; Answer - As the process generated iterates over the sequence,
; each iterated item is added at the beginning (,i.e. top) of the answer list.
; The effect is that the answer list has the items in the reverse order.

; Interchanging the arguments to cons doesn't work either:

(define (square-list-2 items)
  (define (iter things answer)
    (if (null? things) answer
        (iter (cdr things)
              (cons answer
                    (square (car things))))))
  (iter items nil))

; This is because the resulting structure is no longer a list:
; ( ... (cons (cons (cons nil item-1-square) item-2-square) item-3-square) ... ) 
                 
; This structure has reverse semantics i.e., `cdr` returns the first item in the structure,
; while `car` returns the sub-list.
; More importantly, even if we accept the new semantics, the list still has the items in reverse order.
; Poor Louis!

; test
(define (square x) (* x x))
(define a (list 1 2 3 4 5 6 7 8 9))
(square-list a)
(square-list-2 a)
