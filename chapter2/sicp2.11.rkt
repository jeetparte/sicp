#lang sicp

(define (mul-interval x y)
  (let ((lx (lower-bound x)) (ly (lower-bound y)) (ux (upper-bound x)) (uy (upper-bound y)))
    ; checking signs of endpoints
    (cond ; all positive
           ((and (+ve lx) (+ve ux) (+ve ly) (+ve uy)) (make-interval (* lx ly) (* ux uy)))
           ; one negative
           ((and (-ve lx) (+ve ux) (+ve ly) (+ve uy)) (make-interval (* lx uy) (* ux uy)))
           ((and (+ve lx) (+ve ux) (-ve ly) (+ve uy)) (make-interval (* ly ux) (* uy ux)))
           ; two negative (same interval)
           ((and (-ve lx) (-ve ux) (+ve ly) (+ve uy)) (make-interval (* lx uy) (* ux ly)))
           ((and (+ve lx) (+ve ux) (-ve ly) (-ve uy)) (make-interval (* ly ux) (* uy lx)))
           ; two negative (different intervals)
           ((and (-ve lx) (+ve ux) (-ve ly) (+ve uy))
            (make-interval (min (* lx uy) (* ly ux))
                           (max (* ux uy) (* lx ly))))
           ; three negative
           ((and (-ve lx) (-ve ux) (-ve ly) (+ve uy)) (make-interval (* lx uy) (* lx ly)))
           ((and (-ve lx) (+ve ux) (-ve ly) (-ve uy)) (make-interval (* ly ux) (* ly lx)))
           ; all negative
           ((and (-ve lx) (-ve ux) (-ve ly) (-ve uy)) (make-interval (* ux uy) (* lx ly))))))

; helpers
(define (+ve x) (> x 0))
(define (-ve x) (not (+ve x))) ; strictly speaking, this is "non-positive"
(define (print-interval i)
  (newline)
  (display "[")
  (display (lower-bound i))
  (display ", ")
  (display (upper-bound i))
  (display "]"))

; dependencies
(define (make-interval a b) (cons a b))
(define (upper-bound i) (max (car i) (cdr i)))
(define (lower-bound i) (min (car i) (cdr i)))

; testing
(define x (make-interval -5 17))
(define y (make-interval -85 20))
(print-interval (mul-interval x y))
         

