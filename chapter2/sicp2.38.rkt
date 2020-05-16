#lang sicp

(define (fold-left op initial sequence)
  (define (iter result rest)
    (if (null? rest)
        result
        (iter (op result (car rest))
              (cdr rest))))
  (iter initial sequence))

(define (fold-right op initial sequence)
  (accumulate op initial sequence))

; dependencies
(define (accumulate op init sequence)
  (if (null? sequence)
      init
      (op (car sequence) (accumulate op init (cdr sequence)))))

; answers
; a)
(fold-right / 1 (list 1 2 3))
(fold-left / 1 (list 1 2 3))
(fold-right list nil (list 1 2 3))
(fold-left list nil (list 1 2 3))

; b)
; (fold-l op i '(a)) -> (op i a)
; (fold-r op i '(a)) -> (op a i)
; For both these to be identical, `op` must be commutative.

; (fold-l op i '(a b)) -> (op (op i a) b) -> (op (op a i) b) - since `op` is commutative
; (fold-r op i '(a b)) -> (op a (op b i)) -> (op a (op i b)) - "
; For both these to be identical, `op` must also be associative.