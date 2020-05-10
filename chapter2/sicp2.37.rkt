#lang sicp

(define (dot-product v w)
  (accumulate + 0 (map * v w)))

(define (matrix-*-vector m v)
  (map (lambda (vector) (dot-product vector v)) m))

(define (transpose mat)
  (accumulate-n cons nil mat))

(define (matrix-*-matrix m n)
  (let ((cols (transpose n)))
    (map (lambda (row)
           (map (lambda (col)
                  (dot-product row col))
                cols))
         m)))

; dependencies
(define (accumulate op init sequence)
  (if (null? sequence)
      init
      (op (car sequence) (accumulate op init (cdr sequence)))))

(define (accumulate-n op init seqs)
  (if (null? (car seqs))
      nil
      (cons (accumulate op init (map (lambda (seq) (car seq)) seqs))
            (accumulate-n op init (map (lambda (seq) (cdr seq)) seqs)))))

; tests
(define v '(1 2 3))
(define w  '(4 5 6))
(dot-product v w)

(define m (list v w))
(matrix-*-vector m v)
(transpose m)

(define n '((7 8) (9 10) (11 12)))
(matrix-*-matrix m n)