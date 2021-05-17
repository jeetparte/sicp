#lang sicp

; --------------
; Exercise 2.57:
; --------------

; A. (Optional) Check that sum and product expressions have at least 2 terms.
(define (sum? exp)
  (define (is-sum? exp)
    (and (pair? exp) (eq? (car exp) '+)))
  (if (and (is-sum? exp) (< (length (cdr exp)) 2))
      (error "Found sum expression with less than 2 sum terms. Invalid expression: "
             exp)
      (is-sum? exp)))

(define (product? exp)
  (define (is-product? exp)
    (and (pair? exp) (eq? (car exp) '*)))
  (if (and (is-product? exp) (< (length (cdr exp)) 2))
      (error "Found product expression with less than 2 product terms. Invalid expression: "
             exp)
      (is-product? exp)))

; B. Allow handling of products and sums with more than 2 terms.
(define (addend s) (cadr s))
(define (augend s)
  (let ((sum-terms (cdr s)))
    (cond ((= (length sum-terms) 2) (cadr sum-terms))
          ((> (length sum-terms)  2) (cons '+ (cdr sum-terms))))))

(define (multiplier p) (cadr p))
(define (multiplicand p)
  (let ((product-terms (cdr p)))
    (cond ((= (length product-terms) 2) (cadr product-terms))
          ((> (length product-terms)  2) (cons '* (cdr product-terms))))))

; C. (Bonus)
; I thought that `(make-product 'a '(* b c))` should simply return `(* a b c)` instead of `(* a (* b c))`.
; So here's the modification for handling arguments that are themselves products:
(define (make-product m1 m2)
  (define (terms arg) ; added this helper
    (if (product? arg)
        (list (multiplier arg) (multiplicand arg))
        (list arg)))
  (cond ((or (=number? m1 0) (=number? m2 0)) 0)
        ((=number? m1 1) m2)
        ((=number? m2 1) m1)
        ((and (number? m1) (number? m2)) (* m1 m2))
        (else (append '(*) (terms m1) (terms m2))))) ; changed here

; A similar modification can be made for `make-sum` but I left it unmodified for the sake of comparison.
(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        ((and (number? a1) (number? a2))
         (+ a1 a2))
        (else (list '+ a1 a2))))

; --------------------------------------------------
; Rest of the program (from previous exercise 2.56):
; --------------------------------------------------

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
        ((exponentiation? exp)
         (make-product (exponent exp)
                       (make-product (make-exponentiation (base exp)
                                                          ; to keep things simple, I'm assuming that `exponent` is a number
                                                          ; allowing direct use of the primitive subtraction operation
                                                          ; instead of a 'make-difference' operation that can handle 
                                                          ; symbols.
                                                          (- (exponent exp) 1))
                                     (deriv (base exp) var))))
        (else
         (error "unknown expression type: DERIV" exp))))

; Predicates
(define (variable? x) (symbol? x))
(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))

(define (exponentiation? exp) (and (pair? exp) (eq? (car exp) '**)))

(define (=number? exp num) (and (number? exp) (= exp num)))

; Selectors
(define (base e) (cadr e))
(define (exponent e) (caddr e))

; Constructors
(define (make-exponentiation base exponent)
  (cond ((=number? exponent 0) 1)
        ((=number? exponent 1) base)
        (else (list '** base exponent))))


