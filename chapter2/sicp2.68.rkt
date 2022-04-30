#lang sicp

; Encode.
(define (encode message tree)
  (if (null? message)
      '()
      (append (encode-symbol (car message) tree)
              (encode (cdr message) tree))))

(define (encode-symbol symbol tree)
  (define (encode-symbol-1 symbol branch)
    (let ((next-bit
           (choose-bit symbol tree)))
      (let ((next-branch
             (if (= next-bit 0) (left-branch tree) (right-branch tree))))
        (if (leaf? next-branch)
            (if (eq? symbol (symbol-leaf next-branch))
                (list next-bit)
                (error "Tree is malformed: ENCODE-SYMBOL" symbol tree))
            (cons next-bit (encode-symbol symbol next-branch))))))
  (if (not (is-in-tree symbol tree))
      (error "Symbol not in tree: ENCODE-SYMBOL" symbol tree)
      (encode-symbol-1 symbol tree)))

(define (choose-bit symbol tree)
  (if (is-in-tree symbol (left-branch tree)) 0 1))

(define (is-in-tree symbol tree)
  (define (contains element list)
    (if (null? list)
        false
        (or (eq? element (car list))
            (contains element (cdr list)))))
  (contains symbol (symbols tree)))

; Tree leaves.
(define (make-leaf symbol weight) (list 'leaf symbol weight))
(define (leaf? object) (eq? (car object) 'leaf))
(define (symbol-leaf x) (cadr x))
(define (weight-leaf x) (caddr x))

; Code trees.
(define (make-code-tree left right)
  (list left
        right
        (append (symbols left) (symbols right))
        (+ (weight left) (weight right))))

(define (left-branch tree) (car tree))
(define (right-branch tree) (cadr tree))
(define (symbols tree)
  (if (leaf? tree)
      (list (symbol-leaf tree))
      (caddr tree)))
(define (weight tree)
  (if (leaf? tree)
      (weight-leaf tree)
      (cadddr tree)))

; Decode.
(define (decode bits tree)
  (define (decode-1 bits current-branch)
    (if (null? bits)
        '()
        (let ((next-branch
               (choose-branch (car bits) current-branch)))
          (if (leaf? next-branch)
              (cons (symbol-leaf next-branch)
                    (decode-1 (cdr bits) tree))
              (decode-1 (cdr bits) next-branch)))))
  (decode-1 bits tree))

(define (choose-branch bit branch)
  (cond ((= bit 0) (left-branch branch))
        ((= bit 1) (right-branch branch))
        (else (error "bad bit: CHOOSE-BRANCH" bit))))

; Given tree and message.
(define sample-tree
  (make-code-tree (make-leaf 'A 4)
                  (make-code-tree
                   (make-leaf 'B 2)
                   (make-code-tree
                    (make-leaf 'D 1)
                    (make-leaf 'C 1)))))
(define sample-message '(0 1 1 0 0 1 0 1 0 1 1 1 0))

; Test.
(define input (decode sample-message sample-tree))
(encode input sample-tree)
