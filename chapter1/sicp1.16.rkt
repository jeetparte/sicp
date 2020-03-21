#lang sicp

; helper
(define (even? n)
  (= (remainder n 2) 0))

; caller
(define (expt b n mode)
  (cond ((= mode 1) (asis b n 1))
        ((= mode 2) (fei b n 1))
        ((= mode 3) (ebs b n 1))))

; iterative exponentiation using logarithmic number of steps:

; simplest and best - uses `a' only when necessary. I think this is the optimal one.
(define (asis b n a)
  (cond ((= n 0) a)
        ((even? n) (asis (* b b) (/ n 2) a))
        (else (asis b (- n 1) (* a b)))))

; (fei = fast exponentiation iterative), original solution - tries to grow `a' into `b ^ n` and reduces a few steps but involves ~twice the multiplications
(define (fei b n a)
  (cond ((= n 0) a)
        ((even? n) (fei (* b b) (- (/ n 2) 1) (* a b b)))
        (else (fei b (- n 1) (* a b)))))

; another implementation - else case forces skipping next step but uses one more multiplication than asis
(define (ebs b n a)
  (cond ((= n 0) a)
        ((even? n) (ebs (* b b) (/ n 2) a))
        (else (ebs (* b b) (/ (- n 1) 2) (* a b)))))


; analysis
; modified to count no. of steps / multiplication

; asis
(define (casis b n a count)
  (cond ((= n 0) count)
        ((even? n) (casis (* b b) (/ n 2) a (+ count 1)))
        (else (casis b (- n 1) (* a b) (+ count 1)))))

; fei
(define (cfei b n a count)
  (cond ((= n 0) count)
        ((even? n) (cfei (* b b) (- (/ n 2) 1) (* a b b) (+ count 1)))
        (else (cfei b (- n 1) (* a b) (+ count 1)))))

; ebs
(define (cebs b n a count)
  (cond ((= n 0) count)
        ((even? n) (cebs (* b b) (/ n 2) a (+ count 1)))
        (else (cebs (* b b) (/ (- n 1) 2) (* a b) (+ count 1)))))


; callers
(define (cexp b n variant)
  (cond ((= variant 1) (casis b n 1 0))
        ((= variant 2) (cfei b n 1 0))
        ((= variant 3) (cebs b n 1 0))))