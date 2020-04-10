#lang sicp

; Rectangles

; (note: Representations A and B ignore rotation i.e.,
; the rectangle sides are assumed to align with the axes that define the 2D plane.
; `rect-width` is the length of the side parallel to the x-axis while
; `rect-height` the length of the side parallel to the y-axis)

; Representation A - describes a rectangle in terms of the length of its sides and its center.
(define (make-rect width height center)
  (cons (cons width height) center))

(define (width-rect rectangle)
  (car (car rectangle)))

(define (height-rect rectangle)
  (cdr (car rectangle)))

(define (center-rect rectangle)
  (cdr rectangle))

; Representation B - describes a rectangle as the line segment that defines either of its diagonals.
(define (make-rect start end)
  (make-segment start end))

(define (width-rect rectangle)
  (abs (- (x-point (start-segment rectangle))
          (x-point (end-segment rectangle)))))

(define (height-rect rectangle)
  (abs (- (y-point (start-segment rectangle))
          (y-point (end-segment rectangle)))))

(define (center-rect rectangle)
  (midpoint-segment rectangle)) 


; Programs that use rectangles (i.e., built on top of the constructors and selectors)
(define (area-rect rectangle)
  (* (width-rect rectangle)
     (height-rect rectangle)))

(define (perimeter-rect rectangle)
  (* 2
     (+ (width-rect rectangle)
        (height-rect rectangle))))

; Dependencies - (from the previous Exercise 2.2)
; Points
(define (make-point x y)
  (cons x y))
(define (x-point p)
  (car p))
(define (y-point p)
  (cdr p))

; Segments
(define (make-segment start-point end-point)
  (cons start-point end-point))
(define (start-segment s)
  (car s))
(define (end-segment s)
  (cdr s))

(define (midpoint-segment s)
  (define (average a b)
    (/ (+ a b) 2))
  (let ((start (start-segment s))
        (end (end-segment s)))
    (make-point (average (x-point start)
                         (x-point end))
                (average (y-point start)
                         (y-point end)))))

; Print helpers
(define (print-point p)
  (display "(")
  (display (x-point p))
  (display ",")
  (display (y-point p))
  (display ")"))

(define (print-rect rectangle)
  (newline)
  (display "A rectangle with ")
  (display "height: ")
  (display (height-rect rectangle))
  (display ", width: ")
  (display (width-rect rectangle))
  (display ", centered at point: ")
  (print-point (center-rect rectangle)))

(define (print-area-perimeter rectangle)
(newline)
(display "Area: ")
(display (area-rect rectangle))
(display ", Perimeter: ")
(display (perimeter-rect rectangle)))

; Testing
(define rect-a (make-rect 7 12 (make-point 5 17)))
(print-rect rect-a)
(print-area-perimeter rect-a)


; The same rectangle using representation B
;(define rect-b (make-rect (make-point 1.5 11) (make-point 8.5 23)))
;(print-rect rect-b)
;(print-area-perimeter rect-b)
