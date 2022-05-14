#lang sicp

(define (make-from-mag-ang x y)
  (define (dispatch op)
    (cond ((eq? op 'magnitude) x)
          ((eq? op 'angle) y)
          ((eq? op 'real-part) (* x (cos y)))
          ((eq? op 'imag-part) (* x (sin y)))
          (else (error "Unknown op: MAKE-FROM-MAG-ANG" op))))
  dispatch)


; Test run
;> (define z (make-from-mag-ang 3 4))
;> z
;#<procedure:...s-repo/sicp2.75.rkt:4:2>
;> (z 'magnitude)
;3
;> (z 'angle)
;4
;> (z 'real-part)
;-1.960930862590836
;> (cos 4)
;-0.6536436208636119
;> (z 'imag-part)
;-2.270407485923785
;> 