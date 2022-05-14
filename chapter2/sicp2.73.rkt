#lang sicp

(define (deriv exp var)
  (cond ((number? exp) 0)
        ((variable? exp)
         (if (same-variable? exp var) 1 0))
        (else ((get 'deriv (operator exp))
               (operands exp) var))))
(define (operator exp) (car exp))
(define (operands exp) (cdr exp))

; Answer - a.
; Here, the derivatives of compound expressions are computed by dispatching on their type.
; This assumes that the deriv procedures for each type have already been inserted into the dispatch table.
; Just to be clear, (operator exp) gives us the type,
; (get 'deriv (operator exp)) gives us the derivative procedure corresponding to this type
; finally, we apply this procedure to the arguments -
; (operands exp) i.e. the operands of the expression ('contents')
; and var, the variable with respect to which the derivative is to be computed.

; We cannot assimilate the number? and variable? predicates into the data-directed dispatch because
; values of these types do not (explicitly) carry the type information with them.
; (whereas a sum expression like (+ 2 3) contains the type '+ along with the sum terms).
; The dispatch helper procedures - operator and operands - which give us the type and contents of expressions respectively,
; assume the data is tagged and has the form (list tag contents).
; Number and variable values do not obey this format.

; Answer - b.

(define (install-deriv-sum)
  ;; internal procedures
  (define (addend sum) (car sum))
  (define (augend sum) (cadr sum))
  (define (deriv-sum sum var)
    (make-sum (deriv (addend sum) var)
              (deriv (augend sum) var)))
  ;; install into dispatch table
  (put 'deriv '+ deriv-sum)
  'done)

(define (install-deriv-product)
  ;; internal procedures
  (define (multiplier p) (car p))
  (define (multiplicand p) (cadr p))
  (define (deriv-product exp var)
    (make-sum
     (make-product (multiplier exp)
                   (deriv (multiplicand exp) var))
     (make-product (multiplicand exp)
                   (deriv (multiplier exp) var))))
  ;; install into dispatch table
  (put 'deriv '* deriv-product)
  'done)

; Answer - c.
(define (install-deriv-exponentiation)
  ;; internal procedures
  (define (base e) (car e))
  (define (exponent e) (cadr e))
  (define (deriv-exponentiation exp var) ; exp = expression (!= exponent)
    (let ((u (base exp)) (n (exponent exp)))
      (make-product n
                    (make-product (make-exponentiation u (- n 1))
                                  (deriv u var)))))
  ;; install into dispatch table
  (put 'deriv '** deriv-exponentiation)
  'done)

; Answer - d.
; If we change the order of the indexes in the call to the get procedure,
; we must update the order of the indexes in the call to the put procedures to match.
; e.g. the put line for install-deriv-sum would have to become
; (put '+ 'deriv deriv-sum)

; Selectors
(define (make-sum x y) (list '+ x y))
(define (make-product x y) (list '* x y))
(define (make-exponentiation x y) (list '** x y))

; Predicates
(define (variable? x) (symbol? x))
(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))

; get and put definitions - from Chapter 3
(define (make-table)
  (let ((local-table (list '*table*)))
    (define (lookup key-1 key-2)
      (let ((subtable
             (assoc key-1 (cdr local-table))))
        (if subtable
            (let ((record
                   (assoc key-2 (cdr subtable))))
              (if record (cdr record) false)) false)))
    (define (insert! key-1 key-2 value)
      (let ((subtable
             (assoc key-1 (cdr local-table))))
        (if subtable
            (let ((record
                   (assoc key-2 (cdr subtable))))
              (if record
                  (set-cdr! record value)
                  (set-cdr! subtable
                            (cons (cons key-2 value)
                                  (cdr subtable)))))
            (set-cdr! local-table
                      (cons (list key-1 (cons key-2 value))
                            (cdr local-table)))))
      'ok)
    (define (dispatch m)
      (cond ((eq? m 'lookup-proc) lookup)
            ((eq? m 'insert-proc!) insert!)
            (else (error "Unknown operation: TABLE" m))))
    dispatch))

(define operation-table (make-table))
(define get (operation-table 'lookup-proc))
(define put (operation-table 'insert-proc!))

; Install packages
(install-deriv-sum)
(install-deriv-product)
(install-deriv-exponentiation)