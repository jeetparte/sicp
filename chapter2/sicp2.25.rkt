#lang sicp

(cadr (caddr '(1 3 (5 7) 9)))
(caar '((7)))
(cadadr (cadadr (cadadr '(1 (2 (3 (4 (5 (6 7)))))))))

; P.S. Quoting (') has not been introduced at this point in the text and I don't know exactly how it works but
; I saw it in someone else's solution and am using it here for conciseness.

