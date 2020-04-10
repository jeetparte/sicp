#lang sicp

; Given
(define zero (lambda (f) (lambda (x) x)))
(define (add-1 n)
  (lambda (f) (lambda (x) (f ((n f) x)))))

; Part 1

; Deriving 'one' from (add-1 zero):
(add-1 zero) ; comments will go here
(add-1 (lambda (f) (lambda (x) x))) ; evaluated zero
(lambda (f) (lambda (x) (f (((lambda (f) (lambda (x) x)) f) x)))) ; substituted parameter 'n' inside the body of add-1 with the procedural argument
(lambda (f) (lambda (x) (f ((lambda (x) x) x)))) ; applied lambda procedure to 'f'
(lambda (f) (lambda (x) (f x))) ; applied lambda procedure to 'x'

(define one (lambda (f) (lambda (x) (f x))))

; Similiarly deriving 'two' from (add-1 one), we find:
(define two (lambda (f) (lambda (x) (f (f x)))))

; Part 2
; (I solved this in my notebook. Would be difficult to explain it here.)

(define (+ a b)
  (lambda (f) (lambda (x) ((b f) ((a f) x)))))