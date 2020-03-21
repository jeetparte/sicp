#lang sicp

(define (cubic a b c)
  (lambda (x)
    (+ (cube x)
       (* a (square x))
       (* b x)
       c)))



; dependencies
(define (cube n) (* n n n))
(define (square n) (* n n))

(define dx 0.00001)
(define (deriv g)
  (lambda (x) (/ (- (g (+ x dx)) (g x)) dx)))

(define (newton-transform g)
  (lambda (x) (- x (/ (g x) ((deriv g) x)))))
(define (newtons-method g guess)
  (fixed-point (newton-transform g) guess))

(define tolerance 0.00001)
(define (fixed-point f first-guess)
  (define (close-enough? a b)
    (< (abs (- a b)) tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (if (close-enough? guess next)
          next
          (try next))))
  (try first-guess))
