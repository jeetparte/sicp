#lang sicp

; Records
(define (make-record key value) (cons key value))
(define (key record) (car record))
; Trees
(define (entry tree) (car tree))
(define (left-branch tree) (cadr tree))
(define (right-branch tree) (caddr tree))
(define (make-tree entry left right)
  (list entry left right))
; Database operations
(define (lookup given-key set-of-records)
  (cond ((null? set-of-records) false)
        (else
         (let ((entry-key (key (entry set-of-records))))
           (cond ((= given-key entry-key) (entry set-of-records))
                 ((< given-key entry-key) (lookup given-key (left-branch set-of-records)))
                 ((> given-key entry-key) (lookup given-key (right-branch set-of-records))))))))

; list->tree
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

; Test
(define records
  '((0 John)
    (1 Marie)
    (2 Elvis)
    (3 Peter)
    (4 Srinivas)
    (5 Kim)
    (7 Melissa)))

(define database
  (list->tree records))
;(lookup 3 database)
;(lookup 7 database)
;(lookup 9 database)
