#lang sicp

(define (tan-cf x k)
  (cont-frac (lambda (i)
               (if (= i 1)
                   x
                   (- (* x x))))
             (lambda (i)
               (- (* i 2) 1.0)) ; the i-th odd number
             k))

(define (cont-frac n d k)
  (define (A i)
    (/ (n i)
       (+ (d i)
          (if (= i k)
              0
              (A (+ i 1))))))
  (A 1))