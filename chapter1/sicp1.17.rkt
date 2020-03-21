#lang sicp

; integer multiplication through repeated addition

; no. of steps: linear in b (given)
(define (l* a b)
  (if (= b 0)
      0
      (+ a (l* a (- b 1)))))

; no. of steps: O(b * log b)
(define (* a b)
  (cond ((= b 0) 0)
        ((even? b) (double (* a (halve b))))
        (else (+ a (* a (- b 1))))))
  


(define (even? a) (= (remainder a 2) 0))
(define (double a) (+ a a))
(define (halve a)
  (if (= a 0)
      0
      (+ 1 (halve (- a 2))))) ; add 1 for every 2 you remove

