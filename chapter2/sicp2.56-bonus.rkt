#lang sicp

; Bonus:
; A difference operation appears in the differentiation rule for exponentiations -
; d(u^n) = n*(u^n-1)*d(u).

; Instead of the direct subtraction used in sicp2.56.rkt,
; which assumes the exponent is always a number, we can use an appropriate
; abstraction in which both difference arguments can be arbitrary symbols.

; And while we're adding subtraction to the mix, might as well add support for differentiation.
; The below symbolic-differentiation program supports difference expressions as well.
(define (deriv exp var)
  (cond ((number? exp) 0)
        ((variable? exp) (if (same-variable? exp var) 1 0))
        ((sum? exp)
         (make-sum (deriv (addend exp) var)
                   (deriv (augend exp) var)))
        ((difference? exp)
         (make-difference (deriv (minuend exp) var)
                          (deriv (subtrahend exp) var)))
        ((product? exp)
         (make-sum
          (make-product (multiplier exp)
                        (deriv (multiplicand exp) var))
          (make-product (multiplicand exp)
                        (deriv (multiplier exp) var))))
        ((exponentiation? exp)
         (make-product (exponent exp)
                       (make-product (make-exponentiation (base exp)
                                                          (make-difference (exponent exp) 1))
                                     (deriv (base exp) var))))
        (else
         (error "unknown expression type: DERIV" exp))))

; Predicates
(define (variable? x) (symbol? x))
(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))
(define (sum? exp) (and (pair? exp) (eq? (car exp) '+)))
(define (product? exp) (and (pair? exp) (eq? (car exp) '*)))
(define (exponentiation? exp) (and (pair? exp) (eq? (car exp) '**)))
(define (difference? exp) (and (pair? exp) (eq? (car exp) '-))) ; new definition

(define (=number? exp num) (and (number? exp) (= exp num)))

; Selectors
(define (addend s) (cadr s))
(define (augend s) (caddr s))
(define (multiplier p) (cadr p))
(define (multiplicand p) (caddr p))
(define (base e) (cadr e))
(define (exponent e) (caddr e))
(define (minuend d) (cadr d)) ; new definition
(define (subtrahend d) (caddr d)) ; new definition

; Constructors
(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        ((and (number? a1) (number? a2))
         (+ a1 a2))
        (else (list '+ a1 a2))))
(define (make-product m1 m2)
  (cond ((or (=number? m1 0) (=number? m2 0)) 0)
        ((=number? m1 1) m2)
        ((=number? m2 1) m1)
        ((and (number? m1) (number? m2)) (* m1 m2))
        (else (list '* m1 m2))))
(define (make-exponentiation base exponent)
  (cond ((=number? exponent 0) 1)
        ((=number? exponent 1) base)
        (else (list '** base exponent))))
(define (make-difference d1 d2) ; new definition
  (cond ((=number? d2 0) d1) ; anything minus 0 is the thing itself
        ((and (number? d1) (number? d2)) (- d1 d2))
        (else (list '- d1 d2))))

; Tests
; > (deriv '(** x y) 'x)
; (* y (** x (- y 1))) <----- the output

; > (deriv '(- a b) 'b)
; -1

; > (deriv '(- a (** b 2)) 'b)
; (- 0 (* 2 b)) <----- we haven't simplified "(- 0 x)" to "-x" as that will introduce additional complexities for handling +/-ve signs