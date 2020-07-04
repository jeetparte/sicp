#lang sicp

; Exercise 2.53: What would the interpreter print in response to evaluating each of the following expressions?

; Note: Question should be solved 'by hand', i.e. without running the evaluator
; Answers can be checked against the evaluator.

(list 'a 'b 'c)
(list (list 'george))
(cdr '((x1 x2) (y1 y2)))
(cadr '((x1 x2) (y1 y2)))
(pair? (car '(a short list)))
(memq 'red '((red shoes) (blue socks)))
(memq 'red '(red shoes blue socks))
