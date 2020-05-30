#lang sicp

; define `queen-cols` as a stand-alone so we can run timed tests for each k level
(define (queen-cols k board-size)
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
        (queen-cols (- k 1) board-size)))))

; representation of a board (as a set of positions) 
(define empty-board nil)
(define (adjoin-position row column board-positions)
  (let ((new-position (make-position column row)))
    (cons new-position board-positions))) ; append at beginning - a Θ(1) operation

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

(define (reverse items)
  (define (reverse-helper items new-list)
    (if (null? items)
        new-list
        (reverse-helper (cdr items)
                        (cons (car items)
                              new-list))))
  (reverse-helper items nil))

(define (for-each action sequence)
  (cond ((null? sequence) true)
        (else (action (car sequence))
              (for-each action (cdr sequence)))))

; Timed tests
(define (print-value value)
  (newline)
  (display value))

(define (timed-queen-cols k board-size)
  (define (start-queen-cols start-time)
    (queen-cols k board-size)
    (print-value (- (runtime) start-time)))
  (start-queen-cols (runtime)))

(for-each (lambda (k) (timed-queen-cols k 8)) (reverse (list 0 1 2 3 4 5 6 7 8)))