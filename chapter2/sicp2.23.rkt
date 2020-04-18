#lang sicp

(define (for-each action sequence)
  (cond ((null? sequence) true)
        (else (action (car sequence))
              (for-each action (cdr sequence)))))

; test
(for-each (lambda (x)
            (newline)
            (display x))
          (list 57 321 88))