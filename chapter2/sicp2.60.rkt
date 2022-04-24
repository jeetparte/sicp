#lang sicp

; Theta(n) but n could be large due to duplicates. Previously Theta(n) with no duplicates.
(define (element-of-set? x set)
  (cond ((null? set) false)
        ((equal? x (car set)) true)
        (else (element-of-set? x (cdr set)))))

; Theta(1). Previously Theta(n).
(define (adjoin-set x set) (cons x set))

; Theta(n). Previously Theta(n^2).
(define (union-set set1 set2) (append set1 set2))

; Theta(n^2) but n could be large due to duplicates. Previously Theta(n^2).
(define (intersection-set set1 set2)
  (cond ((or (null? set1) (null? set2)) '())
        ((element-of-set? (car set1) set2)
         (cons (car set1) (intersection-set (cdr set1) set2)))
        (else (intersection-set (cdr set1) set2))))

; Observation: There is an efficiency improvement for operations that add to the set,
; while there's a drop in efficiency for the other operations (membership check and intersection).
; That drop is proportional to the no. of duplicates that are added to the set(s).
; e.g. For intersection of sets that are 2x their non-duplicate size, the performance cost is 4x.

; For applications where the sets are to be constructed from known non-duplicate elements,
; this representation is more efficient than the non-duplicate one.
