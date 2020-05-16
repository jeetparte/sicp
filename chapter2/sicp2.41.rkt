#lang sicp

; Exercise 2.41:
; Write a procedure to find all ordered triples of distinct positive integers i, j, and k less than or equal to
; a given integer n that sum to a given integer s.

(define (sum-triplets n s)
  (filter (lambda (t)
            (= (triplet-sum t) s))
          (unique-triplets n)))

(define (triplet-sum t)
  (accumulate + 0 t)) ; sum over the list that is a triplet

(define (unique-triplets n)
  (flatmap (lambda (i)
         (map (lambda (pair) (cons i pair))
              (flatmap (lambda (j)
                         (map (lambda (k) (list j k))
                              (enumerate-interval 1 (dec j))))
                       (enumerate-interval 1 (dec i)))))
  (enumerate-interval 1 n)))

; Notice the inner flatmap that returns set of possible pairs j, k for a given i
; is actually `unique-pairs` from the previous exercise.

; ex 2.40
(define (unique-pairs n)
  (flatmap (lambda (i)
             (map (lambda (j) (list i j))
                  (enumerate-interval 1 (dec i))))
           (enumerate-interval 1 n)))

; Using `unique-pairs` 
;(define (unique-triplets n)
;  (flatmap (lambda (i)
;         (map (lambda (pair) (cons i pair))
;              (unique-pairs (dec i))))
;  (enumerate-interval 1 n)))

; another approach
;(define (unique-triplets n)
;  (flatmap (lambda (i)
;         (flatmap (lambda (j)
;                    (map (lambda (k) (list i j k))
;                         (enumerate-interval 1 (dec j))))
;                    (enumerate-interval 1 (dec i))))
;                  (enumerate-interval 1 n)))

; dependencies
(define (enumerate-interval a n)
  (if (> a n)
      nil
      (cons a (enumerate-interval (inc a) n))))

(define (flatmap proc sequence)
  (accumulate append nil (map proc sequence)))

(define (accumulate op init sequence)
  (if (null? sequence)
      init
      (op (car sequence) (accumulate op init (cdr sequence)))))

(define (filter predicate sequence)
  (cond ((null? sequence) nil)
        ((predicate (car sequence))
         (cons (car sequence)
               (filter predicate (cdr sequence))))
        (else (filter predicate (cdr sequence)))))
