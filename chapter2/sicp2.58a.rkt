#lang sicp

; -------------------------------------------------------------------------------------------------------------------------------------
; Exercise 2.58

; a. "Show how to do this in order to differentiate algebraic expressions presented in infix form, such as (x + (3 * (x + (y + 2)))).
; To simplify the task, assume that + and * always take two arguments and that expres- sions are fully parenthesized."
; -------------------------------------------------------------------------------------------------------------------------------------

; Changed Predicates
; The operator symbols are now at the second position in the expression list:
(define (sum? exp) (and (pair? exp) (eq? (cadr exp) '+)))
(define (product? exp) (and (pair? exp) (eq? (cadr exp) '*)))

; Changed Selectors
(define (addend s) (car s)) ; changed - now the 1st item in the list
(define (augend s) (caddr s)) ; no change - the augend is always the 3rd item in the list
(define (multiplier p) (car p)) ; "
(define (multiplicand p) (caddr p)) ; "

; Changed Constructors
(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        ((and (number? a1) (number? a2))
         (+ a1 a2))
        (else (list a1 '+ a2)))) ; change here
(define (make-product m1 m2)
  (cond ((or (=number? m1 0) (=number? m2 0)) 0)
        ((=number? m1 1) m2)
        ((=number? m2 1) m1)
        ((and (number? m1) (number? m2)) (* m1 m2))
        (else (list m1 '* m2)))) ; change here

; -------------------------------------------------------------------------------------------------------------------------------------
; Rest of the program:
; -------------------------------------------------------------------------------------------------------------------------------------

; The differentiation program
(define (deriv exp var)
  (cond ((number? exp) 0)
        ((variable? exp) (if (same-variable? exp var) 1 0))
        ((sum? exp)
         (make-sum (deriv (addend exp) var)
                   (deriv (augend exp) var)))
        ((product? exp)
         (make-sum
          (make-product (multiplier exp)
                        (deriv (multiplicand exp) var))
          (make-product (multiplicand exp)
                        (deriv (multiplier exp) var))))
         (else
          (error "unknown expression type: DERIV" exp))))

; Predicates
(define (variable? x) (symbol? x))
(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))
(define (=number? exp num) (and (number? exp) (= exp num)))