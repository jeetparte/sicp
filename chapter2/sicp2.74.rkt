#lang sicp

; Answer - a.
(define (get-record employee file)
  (let ((division (type-tag file)))
    (let ((proc (get 'get-record division)))
      (if proc
          (proc employee (contents file))
          (error "Could not find procedure for division in dispatch table: GET-RECORD" division)))))

; The individual divisions' files must each be structured at the top-level as a pair of the division name,
; i.e. the type tag unique to each division, and the set of personnel records e.g. (cons division-tag records).
; This can be done with the attach-tag and related helper procedures.

; Answer - b.
(define (get-salary record)
  (let ((division (type-tag record)))
    (let ((proc (get 'get-salary division)))
      (if proc
          (proc (contents record))
          (error "Could not find procedure for division in dispatch table: GET-SALARY" division)))))

; For this to work, each record must be created with the attach-tag procedure as (attach-tag division-tag contents-of-records),
; i.e. each record must contain a division tag that identifies the structure of the record, and the record itself (which could have any representation).
; As long as the record-manipulation procedures are installed in the dispatch table and work correctly with the chosen representation,
; headquarters can use generic procedures like get-salary above with any record obtained from the personnel file of any division.

; Answer - c.
(define (find-employee-record employee files)
  (if (null? files)
      false
      (let ((current-record (get-record employee (car files))))
        (if current-record
            current-record
            (find-employee-record employee (cdr files))))))

; Answer - d.
; When Insatiable takes over a new company, (i.e. when a new division is added,)
; it must create a new division tag and attach it to the personnel file of the new division;
; and an implementation of the generic file operations (e.g. get-record) must be installed into the central system's dispatch table for this file type.
; Similarly, the division tag must be added to every record in the file
; and an implementation of the generic record operations (e.g. get-salary) must be installed into the dispatch table for this record type.

; Install division-specific procedures into dispatch table:
(define (install-division1-interface)
  ; internal procedures
  (define division-tag 'div1)
  (define (get-employee record) (car record))  
  (define (get-salary record) (cadr record))
  (define (get-record employee records)
    (cond ((null? records) false)
          ((equal? employee (get-employee (contents (car records)))) ; strip off the tag on the record before calling get-employee
           (car records))
          (else (get-record employee (cdr records)))))
  ; external interface
  (put 'get-record division-tag get-record)
  (put 'get-salary division-tag get-salary)
  'done)

(define (install-division2-interface)
  ; internal procedures
  (define division-tag 'div2)
  (define (get-employee record) (cadr record))
  (define (get-salary record) (car record))
  (define (get-record employee records)
    (cond ((null? records) false)
          ((equal? employee (get-employee (contents (car records))))
           (car records))
          (else (get-record employee (cdr records)))))
  ; external interface
  (put 'get-record division-tag get-record)
  (put 'get-salary division-tag get-salary)
  'done)

; Tagging procedures
(define (attach-tag type-tag contents)
  (cons type-tag contents))
(define (type-tag datum)
  (if (pair? datum)
      (car datum)
      (error "Bad tagged datum: TYPE-TAG" datum)))
(define (contents datum)
  (if (pair? datum) (cdr datum)
      (error "Bad tagged datum: CONTENTS" datum)))

; get and put definitions - from Chapter 3
(define (make-table)
  (let ((local-table (list '*table*)))
    (define (lookup key-1 key-2)
      (let ((subtable
             (assoc key-1 (cdr local-table))))
        (if subtable
            (let ((record
                   (assoc key-2 (cdr subtable))))
              (if record (cdr record) false)) false)))
    (define (insert! key-1 key-2 value)
      (let ((subtable
             (assoc key-1 (cdr local-table))))
        (if subtable
            (let ((record
                   (assoc key-2 (cdr subtable))))
              (if record
                  (set-cdr! record value)
                  (set-cdr! subtable
                            (cons (cons key-2 value)
                                  (cdr subtable)))))
            (set-cdr! local-table
                      (cons (list key-1 (cons key-2 value))
                            (cdr local-table)))))
      'ok)
    (define (dispatch m)
      (cond ((eq? m 'lookup-proc) lookup)
            ((eq? m 'insert-proc!) insert!)
            (else (error "Unknown operation: TABLE" m))))
    dispatch))

(define operation-table (make-table))
(define get (operation-table 'lookup-proc))
(define put (operation-table 'insert-proc!))

; Tests
; Division 1
(install-division1-interface)
(define (make-division-file records tag-name)
  (define (tag item) (attach-tag tag-name item))
  (let ((tagged-records (map tag records))) ;; tag each record in the list of records    
    (tag tagged-records))) ;; tag the file itself

(define division1-file  
  (let ((records ;; salary records as unordered list
         '((John 110) (Mary 135) (Joseph 220) (Elliot 89))))
    (make-division-file records 'div1)))

; Division 2
(install-division2-interface)
(define division2-file
  (let ((records
         ;; salary records as alphabetically ordered list
         ;; each record lists the employee salary first and name second (in contrast to records from division 1)
         '((89 Alphonso) (95 Gerald)  (99 Lisa) (91 Maggie) (80 Rick))))
    (make-division-file records 'div2)))

(define all-files
  (list division1-file division2-file))
(find-employee-record 'Joseph all-files)
(find-employee-record 'Lisa all-files)