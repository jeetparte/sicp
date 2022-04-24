#lang sicp

; Binary tree - constructors and selectors
(define (entry tree) (car tree))
(define (left-branch tree) (cadr tree))
(define (right-branch tree) (caddr tree))
(define (make-tree entry left right)
  (list entry left right))

(define (union-set set1 set2)
  ; union-set for sets as ordered lists from ex. 2.62
  (define (union-set-ordered-list set1 set2)
    (cond ((null? set1) set2)
          ((null? set2) set1)
          (else
           (let ((x1 (car set1)) (x2 (car set2)))
             (cond ((= (car set1) (car set2))
                    (cons x1 (union-set-ordered-list (cdr set1) (cdr set2))))                   
                   ((< x1 x2)
                    (cons x1 (union-set-ordered-list (cdr set1) set2)))
                   ((< x2 x1)
                    (cons x2 (union-set-ordered-list set1 (cdr set2)))))))))
  (list->tree
   (union-set-ordered-list (tree->list-2 set1)
                           (tree->list-2 set2))))


(define (intersection-set set1 set2)
  ; intersection-set for sets as ordered lists - from the book
  (define (intersection-set-ordered-list set1 set2)
    (if (or (null? set1) (null? set2))
        '()
        (let ((x1 (car set1)) (x2 (car set2)))
          (cond ((= x1 x2)
                 (cons x1 (intersection-set-ordered-list (cdr set1) (cdr set2))))
                ((< x1 x2)
                 (intersection-set-ordered-list (cdr set1) set2))
                ((< x2 x1)
                 (intersection-set-ordered-list set1 (cdr set2)))))))
  (list->tree
   (intersection-set-ordered-list (tree->list-2 set1)
                                  (tree->list-2 set2))))

; list->tree from ex. 2.64
(define (list->tree elements)
  (car (partial-tree elements (length elements))))
(define (partial-tree elts n)
  (if (= n 0)
      (cons '() elts)
      (let ((left-size (quotient (- n 1) 2)))
        (let ((left-result
               (partial-tree elts left-size)))
          (let ((left-tree (car left-result))
                (non-left-elts (cdr left-result))
                (right-size (- n (+ left-size 1))))
            (let ((this-entry (car non-left-elts))
                  (right-result
                   (partial-tree
                    (cdr non-left-elts)
                    right-size)))
              (let ((right-tree (car right-result))
                    (remaining-elts
                     (cdr right-result)))
                (cons (make-tree this-entry
                                 left-tree
                                 right-tree)
                      remaining-elts))))))))

; tree->list from ex. 2.63
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

; Tests
(define odds (list->tree '(1 3 5 7 9 11)))
(define evens (list->tree '(0 2 4 6 8 10)))
(define primes (list->tree '(2 3 5 7 11 13 17 19)))
(union-set odds evens)
(union-set odds primes)
(union-set evens primes)
(intersection-set odds evens)
(intersection-set odds primes)
(intersection-set evens primes)