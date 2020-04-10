#lang sicp


; `x - y` will be lowest when x is at its minimum and y is at its maximum;
; at its highest when x is at its maximum and y at its minimum.
(define (sub-interval x y)
  (make-interval (- (lower-bound x)
                    (upper-bound y))
                 (- (upper-bound x)
                    (lower-bound y))))

; alternative - subtraction in terms of addition.
(define (sub-interval x y)
  (add-interval x
                (make-interval (- (upper-bound y)) ; notice that negation inverts the notion of magnitude.
                               (- (lower-bound y))))) ; (negated upperbound becomes the lowerbound and vice versa.)