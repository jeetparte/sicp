#lang sicp

; -------------------------------------------------------------------------------------------------------------------------------------
; Exercise 2.58

; b. "The problem becomes substantially harder if we allow standard algebraic notation, such as (x + 3 * (x + y + 2)), which drops
; unnecessary parentheses and assumes that multiplication is done before addition.
; Can you design appropriate predicates, selectors, and constructors for this notation such that our derivative program still works?"
; -------------------------------------------------------------------------------------------------------------------------------------


; Helpers
(define (equals? a b)
  (or (and (symbol? a) (symbol? b) (eq? a b))
      (and (number? a) (number? b) (= a b))))
(define (contains? list item)
  (any? (lambda (element) (equals? element item))
        list))
(define (any? predicate collection)
  (if (null? collection)
      false
      (or (predicate (car collection))
          (any? predicate (cdr collection)))))
(define (filter items predicate)
  (if (null? items)
      nil
      (let ((current-item (car items)))
        (if (predicate current-item)
            (cons current-item
                  (filter (cdr items) predicate))
            (filter (cdr items) predicate)))))
(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence) (accumulate op initial (cdr sequence)))))

; Operator definitions    
(define sum-operator '+)
(define product-operator '*)
(define operators (list sum-operator product-operator))
(define (is-operator? symbol) (contains? operators symbol))

; Operator precedence
(define (precedence operator)
  (cond ((eq? operator sum-operator) 1)
        ((eq? operator product-operator) 2)))

(define (lower-precedence-operator op1 op2)
  (define (lower-precedence? a b)
    (<= (precedence a) (precedence b)))
  (if (lower-precedence? op1 op2)
      op1
      op2))

(define (lowest-precedence-operator operators)
  (accumulate lower-precedence-operator (car operators) operators))

; Expressions
(define (expression? candidate)
  (and (pair? candidate) (any? is-operator? candidate)))

; The 'operator' of an expression is the one with lowest precedence.
(define (operator exp)
  (lowest-precedence-operator (filter exp is-operator?)))

;(define (right-most-operator exp)())

; Predicates
(define (sum? exp) (and (expression? exp) (eq? (operator exp) sum-operator)))
(define (product? exp) (and (expression? exp) (eq? (operator exp) product-operator)))

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
        (else (list a1 '+ a2))))
(define (make-product m1 m2)
  (cond ((or (=number? m1 0) (=number? m2 0)) 0)
        ((=number? m1 1) m2)
        ((=number? m2 1) m1)
        ((and (number? m1) (number? m2)) (* m1 m2))
        (else (list m1 '* m2))))

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