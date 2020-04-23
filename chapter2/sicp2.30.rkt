#lang sicp

; a. define directly (without using any higher-order procedures)
(define (square-tree tree)
  (cond ((null? tree) nil)
        ((not (pair? tree)) (square tree))
        (else (cons (square-tree (car tree))
                    (square-tree (cdr tree))))))

; note how we use the above procedure on single elements (leaves) as well.
; we could separate that logic and distinguish the base cases better.
; Trade-off with conciseness here.

; b. using map
(define (square-tree tree)
  (map (lambda (sub-tree)
         (if (pair? sub-tree)
             (square-tree sub-tree)
             (square sub-tree)))
       tree))

; dependencies
(define (square x) (* x x))

; tests
(square-tree (list 1
                   (list 2 (list 3 4) 5)
                   (list 6 7)))