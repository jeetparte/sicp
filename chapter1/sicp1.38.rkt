#lang sicp

(define (e k)
  (+ 2 (e-minus-2 k)))

; see explanation of the lambda in the notebook
(define (e-minus-2 k)
  (cont-frac (lambda (i) 1.00)
             (lambda (i)
               (if (= (remainder i 3) 2)
                   (* 2 (/ (+ i 1) 3))
                   1))
             k))

(define (cont-frac n d k)
  (define (A i)
    (/ (n i)
       (+ (d i)
          (if (= i k)
              0
              (A (+ i 1))))))
  (A 1))