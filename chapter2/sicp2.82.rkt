#lang sicp

; Our coercion strategy does not support any mixed type operation other than
; the one defined for the types as arranged in the initial call
; (which doesn't require coercion and can be looked up as-is).

; e.g. if some generic operation mixed-op is only defined for types '(b a) and
; there are valid type conversions b->a and a->b available,
; then the generic call (mixed-op some-a some-b) will fail with the error "No method for these types"
; even though a valid conversion existed as (mixed-op (a->b some-a) (b->a some-b)).

; In general, if we call a generic operation with argument types '(a b c ...),
; our coercion strategy will only attempt to look up the operation table for the types:
; '(a b c ...) - i.e. argument types in their original order i.e. no coercion, and
; '(a a a ...),
; '(b b b ...),
; '(c c c ...),
; and so on...
; It will fail to find any mixed type operations such as '(a b b ...) or '(a a c ...) which may exist in the table.

; P.S. the apply-generic procedure below has been made a bit more flexible - 
; if it cannot convert all arguments to a given type, it tries to find a procedure with possible arguments converted and the others unmodified.
; That way it may find some mixed-type operations which the above approach won't.


; apply-generic w/ with coercion handling for multiple arguments
(define (apply-generic op . args)
  (let ((original-args args)
        (original-types (map type-tag args)))
  (define (apply-generic-coerce args pos)
    (let ((type-tags (map type-tag args)))
      (let ((proc (get op type-tags)))
        (cond (proc
               (apply proc (map contents args)))
              ((< pos (length args))
               (apply-generic-coerce (coerce original-args (inc pos)) (inc pos)))
              (else
               (error "No method for these types" (list op original-types)))))))
  (apply-generic-coerce args 0)))

; Helpers
(define (find-at items index) ; first index is 1
  (if (or (< index 1) (> index (length items)))
      (error "Index out of bounds: FIND-AT" index)
      (if (= index 1)
          (car items)
          (find-at (cdr items) (- index 1)))))

(define (coerce args n) ; coerce all other arguments to the type of the nth argument, arguments that cannot be coerced are left unmodified
  (let ((nth-arg (find-at args n)))
    (let ((type-n (type-tag nth-arg)))
      (map (lambda (arg)
             (let ((c (get-coercion (type-tag arg) type-n)))
               (if c (c arg) arg)))
           args))))

; Stub definitions - to prevent compile errors
(define type-tag 1)
(define contents 0)
(define get-coercion 0)
(define get 1)