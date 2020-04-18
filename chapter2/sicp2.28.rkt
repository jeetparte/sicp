#lang sicp

; We can store the result from each branch and use append to combine them:

; As a first step, let's try to return just the top-level elements of a tree.
; We can add in recursion later.
(define (top-level-elements tree)
  (if (null? tree)
      nil
      (append (list (car tree))
              (top-level-elements (cdr tree)))))

; Adding recursion:
(define (fringe tree)
 (cond ((null? tree) nil)
       ((pair? (car tree))
        (append (fringe (car tree)) (fringe (cdr tree))))
       (else
        (append (list (car tree)) (fringe (cdr tree))))))

; Tests
(define a (list (list 1 (list 2 3)) 4 5))
(top-level-elements a) ; note that this returns the list itself
(fringe a)


; TODO - an iterative solution.