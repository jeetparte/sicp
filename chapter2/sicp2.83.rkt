#lang sicp

; add this to the integer package
(define (raise-integer n)
  (make-rational n 1))
(put 'raise 'integer raise-integer)

; add this to the rational package
(define (raise-rational r)
  (make-real (/ (numer r) (denom r))))
(put 'raise 'rational raise-rational)

; add this to the real package
(define (raise-real r)
  (make-complex-from-real-imag r 0))
(put 'raise 'real raise-real)

(define (raise x)
  (let ((proc (get 'raise (type-tag x))))
    (if proc
        (proc x)
        false)))