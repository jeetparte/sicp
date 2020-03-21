#lang sicp

; Programs that use points and segments
(define (midpoint-segment s)
  (let ((start (start-segment s))
        (end (end-segment s)))
    (make-point (average (x-point start)
                         (x-point end))
                (average (y-point start)
                         (y-point end)))))

; trying out nested `let` statements
;(define (midpoint-segment s)
;  (define (average a b)
;    (/ (+ a b) 2))
;  (let ((start (start-segment s))
;        (end (end-segment s)))
;    (let ((start-x (x-point start))
;          (start-y (y-point start))
;          (end-x (x-point end))
;          (end-y (y-point end)))
;      (make-point (average start-x end-x)
;                  (average start-y end-y)))))

; Segments
(define (make-segment start-point end-point)
  (cons start-point end-point))
(define (start-segment s)
  (car s))
(define (end-segment s)
  (cdr s))

; Points
(define (make-point x y)
  (cons x y))
(define (x-point p)
  (car p))
(define (y-point p)
  (cdr p))

; Printing points
(define (print-point p)
  (newline)
  (display "(")
  (display (x-point p))
  (display ",")
  (display (y-point p))
  (display ")"))

; Helpers
(define (average a b)
  (/ (+ a b) 2))

; Testing
(define point-a (make-point 0 0))
(define point-b (make-point 4 10))
(define line-segment (make-segment point-a point-b))
(print-point (midpoint-segment line-segment))