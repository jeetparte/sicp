#lang sicp

; The strategy here is similar to that in the change-counting program from Section 1.2.2:
; set of all subsets of s = (set of all subsets of s containing the first element)
;                         ∪ (set of all subsets of s not containing that element)
; We use append for uniting the sets.
; The map adds the first element to every subset without it, returning the first set in R.H.S. above.
(define (subsets s)
  (if (null? s)
      (list nil)
      (let ((rest (subsets (cdr s))))
        (append rest (map (lambda (subset)
                            (cons (car s) subset))
                          rest)))))

; Test
(subsets (list 1 2 3))
