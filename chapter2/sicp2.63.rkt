#lang sicp

; Answers -
; a. Yes, both procedures produce the same result for every tree.
; The result is the list of tree elements arranged in increasing order.

; b. No, both procedures do not have the same order of growth w.r.t number of steps required.
; tree->list-2 grows more slowly than the 1st.
; tree->list-1 is theta(n.logn) from  T(n) = 2 T(n/2) + theta(n/2) (putting together is more work with append)
; tree->list-2 is theta(n) from T(n) = 2 T(n/2) + 1.

; I don't know how the growth for 1st is calculated, just that it's derived from Master theorem.

; Tree - constructor and selectors
(define (entry tree) (car tree))
(define (left-branch tree) (cadr tree))
(define (right-branch tree) (caddr tree))
(define (make-tree entry left right)
  (list entry left right))

; Ex. 2.63 - Tree-to-list procedures
(define (tree->list-1 tree)
  (if (null? tree)
      '()
      (append (tree->list-1 (left-branch tree))
              (cons (entry tree)
                    (tree->list-1 (right-branch tree))))))

(define (tree->list-2 tree)
  (define (copy-to-list tree result-list)
    (if (null? tree)
        result-list
        (copy-to-list (left-branch tree)
                      (cons (entry tree)
                            (copy-to-list
                             (right-branch tree)
                             result-list)))))
  (copy-to-list tree '()))


; Trees of Fig 2.16
(define tree1
  (make-tree 7
             (make-tree 3
                        (make-tree 1 '() '())
                        (make-tree 5 '() '()))
             (make-tree 9
                        '()
                        (make-tree 11 '() '()))))
(define tree2
  (make-tree 3
             (make-tree 1 '() '())
             (make-tree 7
                        (make-tree 5 '() '())
                        (make-tree 9 '()
                                   (make-tree 11 '() '())))))

(define tree3
  (make-tree 5
             (make-tree 3
                        (make-tree 1 '() '())
                        '())
             (make-tree 9
                        (make-tree 7 '() '())
                        (make-tree 11 '() '()))))