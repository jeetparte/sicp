#lang sicp

; raise
(define (raise x)
  (let ((proc (get 'raise (type-tag x))))
    (if proc
        (proc x)
        false)))

; counts how many times a type can be raised before we hit the top
; in other words, how far is the type from the top
(define (count-max-raises x)
  (let ((raised (raise x)))
    (if raised
        (+ 1 (count-max-raises raised))
        0)))

; this was my first attempt
; only issue is it doesn't remember which argument type was the highest and computes it repeatedly at every step
(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (apply proc (map contents args))
          (if (= (length args) 2)
              (let ((a1 (car args))
                    (a2 (cdr args)))
                (let ((distance-from-top1 (count-max-raises a1))
                      (distance-from-top2 (count-max-raises a2)))
                  (cond ((< distance-from-top1 distance-from-top2) ; a1 is higher
                         (apply-generic op a1 (raise a2)))
                        ((> distance-from-top1 distance-from-top2) ; a2 is higher
                         (apply-generic op (raise a1) a2))
                        (else
                         (error "No method found for these types" (list op type-tags))))))
              (error "No method found for these types" (list op type-tags)))))))

; an improved implementation
(define (apply-generic-v2 op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (apply proc (map contents args))
          (if (= (length args) 2)
              (apply (apply-generic-v2 (cons op (raise-till-equal args))))
              (error "No method found for these types" (list op type-tags)))))))

(define (raise-till-equal args)
  (let ((distances-from-top (map count-max-raises args)))
    (let ((distance-for-highest (min distances-from-top)))
      (let ((raise-counts (map (lambda (d)
                                (- d distance-for-highest))
                              distances-from-top)))
        (map (lambda (arg raise-count)
               ((repeated raise raise-count) arg))
             (zip args raise-counts))))))

(define (zip seq1 seq2)
  (cond ((or (null? seq1) (null? seq2))
         '())
        ((and (pair? seq1) (pair? seq2))
         (cons (list (car seq1) (car seq2))
               (zip (cdr seq1) (cdr seq2))))
        (else
         (error "Arguments must be lists: ZIP" seq1 seq2))))

; stubs - prevent evaluation errors
(define type-tag 1)
(define get 0)
(define contents 0)
(define repeated 0) ; this was implemented in a chapter 1 exercise