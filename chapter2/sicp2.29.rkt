#lang sicp

; given
(define (make-mobile left right)
  (list left right))
(define (make-branch length structure)
  (list length structure))

; a.
(define (left-branch mobile) (car mobile))
(define (right-branch mobile) (cadr mobile))
(define (branch-length branch) (car branch))
(define (branch-structure branch) (cadr branch))

; b.
(define (simple-weight? structure)
  (not (pair? structure)))

; Original version - I think this one is better because it is more clear
(define (total-weight mobile)
  (+ (weight (left-branch mobile))
     (weight (right-branch mobile))))

(define (weight branch)
  (let ((structure (branch-structure branch)))
    (if (simple-weight? structure)
        structure
        (total-weight structure))))

; Concise version - as a challenge, uses a single procedure for calculating the weight
(define (total-weight-2 mobile)
  (if (simple-weight? mobile) ; awkward check since we use this procedure on branch structures too
      mobile
      (+ (total-weight-2 (branch-structure (left-branch mobile)))
         (total-weight-2 (branch-structure (right-branch mobile))))))

; c.
(define (balanced? mobile)
  (let ((left (left-branch mobile))
        (right (right-branch mobile)))
    (and (= (torque-applied left)
            (torque-applied right))
         (structure-balanced? (branch-structure left))
         (structure-balanced? (branch-structure right)))))

(define (torque-applied branch)
  (* (branch-length branch) (weight branch)))

(define (structure-balanced? branch-structure)
  (if (simple-weight? branch-structure)
      true
      (balanced? branch-structure)))

; d.
; If we make the suggested change, we only have to change the implementation for some
; of the selectors in section a.
; i.e., we've suceeded in create a modular design which separates abstract data from
; its concrete implementation which I think was the authors' goal here.

; Test helpers
(define (display-n arg)
  (display arg)
  (newline))

(define (test-branch branch)
  (let ((length (branch-length branch))
        (structure (branch-structure branch)))
    (newline)
    (display "Representation: ")
    (display-n branch)
    (display "Length: ")
    (display-n  length)
    (display "Structure: ")
    (display-n structure)
    (display "Torque: ")
    (display-n (torque-applied branch))))

(define (test-mobile mobile)
  (let ((left (left-branch mobile))
        (right (right-branch mobile)))
    (newline)
    (display-n "+++ Mobile +++")
    (display "Representation: ")
    (display-n mobile)
    (display "Total weight: ")
    (display-n (total-weight mobile))
    (display "Balanced: ")
    (display-n (if (balanced? mobile) "true" "false"))
    (display "-- Left Branch --")
    (test-branch left)
    (display "-- Right Branch --")
    (test-branch right)
    (display-n "++++++++++++++")))
  
; Tests
(define component (make-mobile (make-branch 4 5)
                               (make-branch 10 2)))
(define mob (make-mobile (make-branch 7 2)
                         (make-branch 2 component)))
(test-mobile component)
(test-mobile mob)
