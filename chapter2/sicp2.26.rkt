#lang sicp

(define x (list 1 2 3))
(define y (list 4 5 6))

(append x y) ; ---> list containing elements of x followed by elements of y
(cons x y) ; ---> list with the list x appended as an element at the beginning of y
(list x y) ; ---> list with both lists, x and y, as elements