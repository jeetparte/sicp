#lang sicp

(define (queens board-size)
  (define (queen-cols k)
    (if (= k 0)
        (list empty-board)
        (filter
         (lambda (positions) (safe? k positions))
         (flatmap
          (lambda (rest-of-queens)
            (map (lambda (new-row)
                   (adjoin-position
                    new-row k rest-of-queens))
                 (enumerate-interval 1 board-size)))
          (queen-cols (- k 1))))))
  (queen-cols board-size))

; representation of a board (as a set of positions) 
(define empty-board nil)
(define (adjoin-position row column board-positions)
  (let ((new-position (make-position column row)))
    (append board-positions (list new-position))))
; Note - appending at the end means positions are arranged in ascending order of their columns.
; Makes it easy to visualize the boards denoted by our program's output.

; representation of individual positions
(define (make-position column row) (list column row))
(define (column position) (car position))
(define (row position) (cadr position))

; Is position safe w.r.t the others?
(define (safe? k positions)
  (let ((rest-of-positions (filter (lambda (position)
                                     (not (= k (column position))))
                                   positions))
        (kth-position (car (filter (lambda (position)
                                     (= k (column position)))
                                   positions))))
    (null?
     (filter (lambda (position)
               (check? position kth-position))
             rest-of-positions))))

; Two queens check if they are in the same row, column, or diagonal.
(define (check? position1 position2)
  (or (= (row position1) (row position2))
      (= (column position1) (column position2))
      (same-diagonal? position1 position2)))

(define (same-diagonal? position1 position2)
  (= (abs (- (row position1)
             (row position2)))
     (abs (- (column position1)
             (column position2)))))

; Dependencies
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

; Testing
(queens 0)
(queens 1)
(queens 2)
(queens 3)
(queens 4)
; The no. of solutions increases rapidly with 'n'.
; It is more convenient then, to tally the total number of solutions our program generates with some reference.
; See https://en.wikipedia.org/wiki/Eight_queens_puzzle#Counting_solutions
(length (queens 5))
(length (queens 6))
(length (queens 7))
(length (queens 8))
(length (queens 9))
(length (queens 10))
(length (queens 11)) ; Risk exceeding Racket's default memory limit!


