#lang sicp

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence) (accumulate op initial (cdr sequence)))))

(define (accumulate-n op init seqs)
  (if (null? (car seqs))
      nil
      (cons (accumulate op init (map (lambda (seq) (car seq)) seqs))
            (accumulate-n op init (map (lambda (seq) (cdr seq)) seqs)))))

; test
(define seqs '((1 2 3) (4 5 6) (7 8 9) (10 11 12)))
(map (lambda (seq) (car seq)) seqs)
(map (lambda (seq) (cdr seq)) seqs)
(accumulate-n + 0 seqs)