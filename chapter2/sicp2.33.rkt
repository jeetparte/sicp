#lang sicp

; accumulate
(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence) (accumulate op initial (cdr sequence)))))

; a. map
(define (map p sequence)
  (accumulate (lambda (x y) (cons (p x) y)) nil sequence))

; b. append
(define (append seq1 seq2)
  (accumulate cons seq2 seq1)) ; start with seq2 as the base, and cons up elements of seq1

; c. length
(define (length sequence)
  (accumulate (lambda (head elements-in-tail) (+ 1 elements-in-tail)) 0 sequence))
                           
; tests
(define one-through-four (list 1 2 3 4))
(define one-through-five (list 1 2 3 4 5))

(map (lambda (x) (* x x)) one-through-five)
(map (lambda (x) (* 2 x)) one-through-five)

(append one-through-four (list 5 6 7 8))
(append nil one-through-four)

(length one-through-five)
(length (list 1 2 (list 3 4) 5))