#lang sicp

(define (simpsons f a b n)
  ; given
  (define h (/ (- b a) n))
  (define (y k)
    (f (+ a
          (* k h))))
  ; determine coefficient for the k-th term
  (define (coeff k)
    (cond ((or (= k 0) (= k n))
           1.0)
          ((odd? k) 4.0)
          (else 2.0)))
  ; compute k-th term
  (define (term k) (* (coeff k) (y k)))
  (* (/ h 3.0)
     (sum term 0 inc n)))

; procedure to compare with
(define (integral f a b dx)
  (define (add-dx x)
    (+ x dx))
  (* (sum f (+ a (/ dx 2.0)) add-dx b)
     dx))

; higher-order procedure
(define (sum term a next b)
  (if (> a b)
      0
      (+ (term a)
         (sum term (next a) next b))))

; helpers
(define (inc n) (+ n 1))
(define (even? n) (= (remainder n 2) 0))
(define (odd? n) (not (even? n)))
(define (cube x) (* x x x))
(define (error expected actual) (- actual expected)) ; used to compare results at runtime

; **********************************************************************************
; Results - simpson's method is more accurate by a huge factor
; **********************************************************************************

;> (error 0.25 (integral cube 0 1 0.01))
;-1.249999999958229e-05
;> (error 0.25 (integral cube 0 1 0.001))
;-1.2499999899051595e-07
;> (error 0.25 (simpsons cube 0 1 100))
;-8.326672684688674e-17
;> (error 0.25 (simpsons cube 0 1 1000))
;2.220446049250313e-16