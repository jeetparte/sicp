#lang sicp

; Let's start with the recursive variant -

; Our reverse procedure was defined as 
(define (reverse items)
  (if (null? items)
      nil
      (append (reverse (cdr items)) (list (car items)))))

; For deep reverse, we check if `(car items)` is itself a sequence and if so,
; apply deep reverse to it:

(define (deep-reverse items)
  (cond ((null? items) nil)
        ((pair? (car items))
         (append (deep-reverse (cdr items))
                 (list (deep-reverse (car items)))))
        (else
         (append (deep-reverse (cdr items))
                 (list (car items))))))


; Note: the iterative variant can be obtained similarly from our iterative reverse procedure of exercise 2.18

; tests
(define x (list (list 1 2) (list 3 4)))
x
(reverse x)
(deep-reverse x)
