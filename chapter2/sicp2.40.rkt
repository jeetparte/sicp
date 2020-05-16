#lang sicp

(define (unique-pairs n)
  (flatmap (lambda (i)
             (map (lambda (j) (list i j))
                  (enumerate-interval 1 (dec i))))
           (enumerate-interval 1 n)))

(define (prime-sum-pairs n)
  (map make-pair-sum
       (filter prime-sum? (unique-pairs n))))

(define (prime-sum? pair)
  (prime? (+ (car pair) (cadr pair))))

(define (make-pair-sum pair)
  (list (car pair) (cadr pair) (+ (car pair) (cadr pair))))

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

; prime helpers
(define (prime? n)
  (= n (smallest-divisor n)))

(define (smallest-divisor n) (find-divisor n 2))
(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (+ test-divisor 1)))))

(define (divides? a b) (= (remainder b a) 0))
(define (square n) (* n n))

; test
(unique-pairs 6)
(prime-sum-pairs 6)
