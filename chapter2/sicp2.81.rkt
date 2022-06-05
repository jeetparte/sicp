#lang sicp

(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (apply proc (map contents args))
          (if (= (length args) 2)
              (let ((type1 (car type-tags))
                    (type2 (cadr type-tags))
                    (a1 (car args))
                    (a2 (cadr args)))
                (let ((t1->t2 (get-coercion type1 type2))
                      (t2->t1 (get-coercion type2 type1)))
                  (cond (t1->t2
                         (apply-generic op (t1->t2 a1) a2))
                        (t2->t1
                         (apply-generic op a1 (t2->t1 a2)))
                        (else (error "No method for these types" (list op type-tags))))))
              (error "No method for these types"
                     (list op type-tags)))))))

; Louis' coercion procedures
(define (scheme-number->scheme-number n) n)
(define (complex->complex z) z)
(put-coercion 'scheme-number
              'scheme-number
                    scheme-number->scheme-number)
(put-coercion 'complex 'complex complex->complex)

; Answers
; a.
; With Louis' procedures installed, if apply-generic is
; called with two arguments of the same type for an operation
; not defined for those types in the table, apply-generic 
; coerces one of the arguments to itself and calls apply-generic again.
; Since the arguments are no different than the original call,
; we end up recursively calling apply-generic indefinitely.

; For the exponentiation procedure, (exp z1 z2) evaluates
; (apply-generic 'exp z1 z2)
; Inside apply-generic, (get 'exp '(complex complex)) does not find a procedure,
; and we enter into the coercion check. There we find a valid coercion (from the first type to itself)
; and apply it to the first argument to evaluate
; (apply-generic 'exp (complex->complex z1) z2) which is nothing but
; (apply-generic 'exp z1 z2) which brings us back full-circle.

; b.
; Louis is wrong (I think). apply-generic works correctly as is -
; if it cannot find a generic procedure defined for a pair of arguments of the same type,
; it enters the coercion code, but finding no coercion for a type to itself,
; evaluates the else expression which correctly signals a "No method for these types" error.


; c.
; I think this is the main point of the exercise - that apply-generic
; should not attempt coercion when the arguments are of the same type.
; Louis tried to prevent this but made the problem worse.

; apply-generic modified:
(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (apply proc (map contents args))
          (if (= (length args) 2)
              (let ((type1 (car type-tags))
                    (type2 (cadr type-tags))
                    (a1 (car args))
                    (a2 (cadr args)))
                (if (eq? type1 type2)
                    (error "No method for these types" (list op type-tags))
                    (let ((t1->t2 (get-coercion type1 type2))
                      (t2->t1 (get-coercion type2 type1)))
                  (cond (t1->t2
                         (apply-generic op (t1->t2 a1) a2))
                        (t2->t1
                         (apply-generic op a1 (t2->t1 a2)))
                        (else (error "No method for these types" (list op type-tags)))))))
              (error "No method for these types"
                     (list op type-tags)))))))