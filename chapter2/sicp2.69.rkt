#lang sicp

(define (generate-huffman-tree pairs)
  (successive-merge (make-leaf-set pairs)))

(define (successive-merge nodes)
  (let ((count (length nodes)))
    (cond ((= count 0) '())
          ((= count 1) (car nodes)) ; return the final result node
          ((> count 1)
           (let ((first (car nodes))
                 (second (cadr nodes))
                 (rest (cddr nodes)))
             (successive-merge
              (adjoin-set (make-code-tree first second)
                          rest)))))))

; Helpers
(define (make-leaf-set pairs)
  (if (null? pairs)
      '()
      (let ((pair (car pairs)))
        (adjoin-set (make-leaf (car pair)   ; symbol
                               (cadr pair)) ; frequency
                    (make-leaf-set (cdr pairs))))))

(define (adjoin-set x set)
  (cond ((null? set) (list x))
        ((< (weight x) (weight (car set))) (cons x set))
        (else (cons (car set)
                    (adjoin-set x (cdr set))))))

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

; Encode.
(define (encode message tree)
  (if (null? message)
      '()
      (append (encode-symbol (car message) tree)
              (encode (cdr message) tree))))

(define (encode-symbol symbol tree)
  (if (not (is-in-tree symbol tree))
      (error "Symbol not in tree: ENCODE-SYMBOL" symbol tree)
      (let ((next-bit
             (choose-bit symbol tree)))
        (let ((next-branch
               (if (= next-bit 0) (left-branch tree) (right-branch tree))))
          (if (leaf? next-branch)
              (list next-bit)
              (cons next-bit (encode-symbol symbol next-branch)))))))

(define (choose-bit symbol tree)
  (cond ((is-in-tree symbol (left-branch tree)) 0)
        ((is-in-tree symbol (right-branch tree)) 1)
        (else
         (error "Symbol not in either branch: CHOOSE-BIT" symbol tree))))

(define (is-in-tree symbol tree)
  (define (contains element list)
    (if (null? list)
        false
        (or (eq? element (car list))
            (contains element (cdr list)))))
  (contains symbol (symbols tree)))

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

; Test
(define test-pairs '((A 4) (B 2) (D 1) (C 1)))
(define result-tree (generate-huffman-tree test-pairs))