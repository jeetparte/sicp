#lang sicp

; Version A
(define (make-frame origin edge1 edge2) (list origin edge1 edge2))
(define (origin-frame frame) (car frame))
(define (edge1-frame frame) (cadr frame))
(define (edge2-frame frame) (caddr frame))

; Version B
(define (make-frame origin edge1 edge2) (cons origin (cons edge1 edge2)))
(define (origin-frame frame) (car frame))
(define (edge1-frame frame) (cadr frame))
(define (edge2-frame frame) (cddr frame))

; Tests
(define (test-frame-procedures origin edge1 edge2)
  (let ((frame (make-frame origin edge1 edge2)))
    (and (= origin (origin-frame frame))
         (= edge1 (edge1-frame frame))
         (= edge2 (edge2-frame frame)))))

(test-frame-procedures 3 6 1) ; convenient to use numbers in place of actual vectors