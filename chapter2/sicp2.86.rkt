#lang sicp

; This exercise introduces the possibility that the various parts of a complex number (real, imaginary, magnitude, angle)
; might be data objects of various number types (ordinary scheme numbers, rational numbers, etc.).

; This means that the various procedures of the complex number package that manipulate these parts will need to be generic
; over the supported number types. For example, in the procedure that gets the magnitude of a complex number in rectangular form,
; the procedures square, + and sqrt need to be generic:

;(define (magnitude z)
;    (sqrt (+ (square (real-part z))
;             (square (imag-part z)))))


; Below are the changes required in the system:

; 1. change the helper procedure definitions
(define (square x) (mul x x)) ; redirect to the generic procedure mul
(define (sqroot x) (apply-geneirc 'sqroot x))
(define (sine x) (apply-generic 'sine x))
(define (cosine x) (apply-generic 'cosine x))
(define (arctan y x) (apply-generic 'arctan y x))

; 2. implement the generic procedures for the various types
; add to scheme-number package
(put 'sqroot 'scheme-number (lambda (x)
                              (tag (sqrt x))))
(put 'sine 'scheme-number (lambda (x)
                            (tag (sin x))))
(put 'cosine 'scheme-number (lambda (x)
                              (tag (cosine x))))
(put 'arctan '(scheme-number scheme-number) (lambda (y x)
                                              (tag (atan y x))))
; add to rational package
(put 'sqroot 'rational (lambda (x)
                         (make-rational (sqroot (numer x))
                                        (sqroot (denom x)))))
; convert to ordinary numbers for the other procedures
(define (rational->scheme-number x)
  (make-scheme-number (/ (numer x) (denom x))))
(put 'sine 'rational (lambda (x)
                       (sine (rational->scheme-number x))))
(put 'cosine 'rational (lambda (x)
                       (cosine (rational->scheme-number x))))
(put 'arctan '(rational rational) (lambda (y x)
                       (arctan (rational->scheme-number y)
                               (rational->scheme-number x))))

; 3. replace the primitive procedures +, -, *, / by the generic procedures add, sub, mul, div
; in the rectangular, polar and the complex-number packages.
; e.g. in the polar package,
(define (real-part z) (mul (magnitude z) (cos (angle z))))
(define (imag-part z) (mul (magnitude z) (sin (angle z))))
(define (make-from-real-imag x y)
    (cons (sqroot (add (square x) (square y)))
          (arctan y x)))
