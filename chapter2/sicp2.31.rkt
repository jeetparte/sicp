#lang sicp

; tree-map:
; apply tree-map to every element that is it itself a tree.
; apply `proc` to every element which is a leaf.
(define (tree-map proc tree)
  (map (lambda (subtree)
         (if (pair? subtree)
             (tree-map proc subtree)
             (proc subtree)))
       tree))

; test
(define (square x) (* x x))
(define (square-tree tree) (tree-map square tree))

(define test-tree (list 1
             (list 2 (list 3 4) 5)
(list 6 7)))
(square-tree test-tree)

; we can also define `scale-tree` using tree-map:
(define (scale-tree tree factor)
  (tree-map (lambda (leaf)
              (* leaf factor))
            tree))
(scale-tree test-tree 2)