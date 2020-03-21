#lang sicp

(define (cont-frac n d k)
  (define (A i)
    ; aggregate at level i,
    ; (A i) = Ni / Di for k-th level (i.e., i = k)
    ;       = Ni / (Di + (A i+1)) for higher levels
    (/ (n i)
       (+ (d i)
          (if (= i k)
              0
              (A (+ i 1))))))
  (A 1))

(define (golden-ratio k)
  (/ 1
     (cont-frac (lambda (i) 1.0)
                (lambda (i) 1.0)
                k)))

; shorter alias
(define (phi k) (golden-ratio k))

; answers

; a.
; k must be 12 to approximate phi accurate to 4 decimal places
; > (phi 12)
; 1.6180555555555558

; b.
;(define (cont-frac n d k)
;  ; for an iterative solution,
;  ; we must start from the k-th level and aggregate upwards
;  (define (iter i acc)
;    (if (= i 0)
;        acc
;        (iter (- i 1)
;              (/ (n i)
;                 (+ (d i) acc)))))
;  (iter k 0))