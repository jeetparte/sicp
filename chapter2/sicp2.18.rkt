#lang sicp

; Recursive:
; a) initial solution
(define (reverse items)
  (if (= (length items) 1)
      items ; the reverse of a one-element list is itself
      (append-last (reverse (cdr items))
                   (car items))))

; b) refined solution
(define (reverse-b items)
  (if (null? items)
      nil
      (append-last (reverse-b (cdr items))
                   (car items))))

; Iterative:
; (Straightforward and more performant. Uses an auxiliary list.)
(define (reverse-iter items)
  (define (reverse-helper items new-list)
    (if (null? items)
        new-list
        (reverse-helper (cdr items)
                        (cons (car items)
                              new-list))))
  (reverse-helper items nil))

; Helpers
(define (length list)
  (if (null? list)
      0
      (+ 1 (length (cdr list)))))


; we could also have used `append` in place of this 
(define (append-last list element)
  (if (null? list)
      (cons element nil)
      (cons (car list) (append-last (cdr list) element))))


; Tests
(define test-list (list 1 3 5 7 9))
(reverse test-list)
(reverse-b test-list)
(reverse-iter test-list)