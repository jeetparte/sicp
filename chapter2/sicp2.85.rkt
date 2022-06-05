#lang sicp

; tower of types: integer, rational, real, complex

(define (project obj)
  (let ((proc (get 'project (type-tag obj))))
    (if proc
        (apply proc (contents obj))
        false)))

(define (drop obj)
  (let ((projected (project obj)))
    (if projected
        (if (equ? obj (raise projected))
            (drop projected)
            obj)
        obj)))

; projection operations

; add to complex package
(define (project-complex z)
  (make-real (real-part z)))
(put 'project '(complex) project-complex)
; add to real package
(define (project-real r)
  (make-integer (round r)))
(put 'project '(real) project-real)
; add to rational package
(define (project-rational r)
  (make-integer (numer r)))

; apply-generic w/ simplification
(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (drop (apply proc (map contents args))) ; *
          (if (= (length args) 2)
              (apply (apply-generic (cons op (raise-till-equal args))))
              (error "No method found for these types" (list op type-tags)))))))