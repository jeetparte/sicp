#lang racket/gui

; Graphics (provides the drawing capabilities)
(require graphics/graphics)
(open-graphics)
(define width 500)
(define height 500)
(define vp (open-viewport "Picture Language Canvas" width height))

(define draw (draw-viewport vp))
(define (clear) ((clear-viewport vp)))
(define line (draw-line vp))

; In the graphics library, the viewport's origin (0, 0) is at the upper-left corner,
; and positions increase to the right and down.
; This function converts regular y-coordinates to match the graphic library's semantics,
; allowing us to use standard semantics in our code.
(define (normalize y-coord)
  (- height y-coord))

; Vectors
(define (make-vect x y) (cons x y))
(define (xcor-vect v) (car v))
(define (ycor-vect v) (cdr v))

(define (add-vect v1 v2)
  (make-vect (+ (xcor-vect v1)
                (xcor-vect v2))
             (+ (ycor-vect v1)
                (ycor-vect v2))))
(define (sub-vect v1 v2)
  (make-vect (- (xcor-vect v1)
                (xcor-vect v2))
             (- (ycor-vect v1)
                (ycor-vect v2))))
(define (scale-vect s v)
  (make-vect (* s (xcor-vect v))
             (* s (ycor-vect v))))

; Frames
(define (make-frame origin edge1 edge2) (list origin edge1 edge2))
(define (origin-frame frame) (car frame))
(define (edge1-frame frame) (cadr frame))
(define (edge2-frame frame) (caddr frame))

; an additional helper
(define (make-relative-frame reference-frame)
  (lambda (origin edge1 edge2)
    (make-frame (add-vect origin (origin-frame reference-frame))
                edge1
                edge2)))

(define (frame-coord-map frame)
  (lambda (v)
    (add-vect
     (origin-frame frame)
     (add-vect (scale-vect (xcor-vect v) (edge1-frame frame))
               (scale-vect (ycor-vect v) (edge2-frame frame))))))

; Segments
(define (make-segment start-vector end-vector)
  (cons start-vector end-vector))
(define (start-segment segment) (car segment))
(define (end-segment segment) (cdr segment))

; Painters
(define (segments->painter segment-list)
  (lambda (frame)
    (for-each
     (lambda (segment)
       (let ((start-coord ((frame-coord-map frame) (start-segment segment)))
             (end-coord ((frame-coord-map frame) (end-segment segment))))
         (line
          (make-posn (xcor-vect start-coord) (normalize (ycor-vect start-coord)))
          (make-posn (xcor-vect end-coord) (normalize (ycor-vect end-coord))))))
     segment-list)))

(define outline-painter
  (segments->painter
   (list (make-segment (make-vect 0 0)
                       (make-vect 0 1))
         (make-segment (make-vect 0 1)
                       (make-vect 1 1))
         (make-segment (make-vect 1 1)
                       (make-vect 1 0))
         (make-segment (make-vect 1 0)
                       (make-vect 0 0)))))

(define x-painter
  (segments->painter
   (list (make-segment (make-vect 0 0)
                       (make-vect 1 1))
         (make-segment (make-vect 0 1)
                       (make-vect 1 0)))))

(define diamond-painter
  (let ((mid-left (make-vect 0.0 0.5))
        (mid-top (make-vect 0.5 1.0))
        (mid-right (make-vect 1.0 0.5))
        (mid-bottom (make-vect 0.5 0.0)))
    (segments->painter
     (list (make-segment mid-left mid-top)
           (make-segment mid-top mid-right)
           (make-segment mid-right mid-bottom)
           (make-segment mid-bottom mid-left)))))

(define wave-image-width 346)
(define wave-image-height 416)
; another helper
(define (point x y)
      (make-vect (/ x wave-image-width) (/ y wave-image-height)))

(define wave-painter
    (let (; points for the various parts of our stick figure:
          ; head
          (left-temple (point 150 wave-image-height))
          (right-temple (point 194 wave-image-height))
          (left-ear (point 120 346))
          (right-ear (point 220 346))
          (left-neck (point 147 277))
          (right-neck (point 205 277))
          ; torso
          (left-shoulder (point 121 285))
          (right-shoulder (point 240 284))
          (left-armpit (point 130 234))
          (right-armpit (point 225 234))
          (left-waist (point 128 148))
          (right-waist (point 222 148))
          (leg-join (point 178 131))
          ; arms
          (left-inner-elbow (point 68 246))
          (left-outer-elbow (point 60 197))
          (left-radial-wrist (point 0 311))
          (left-ulnar-wrist (point 0 267))
          (right-inner-elbow (point 295 187))
          (right-outer-elbow (point 305 217))
          (right-radial-wrist (point wave-image-width 118))
          (right-ulnar-wrist (point wave-image-width 160))
          ; legs
          (left-outer-ankle (point 89 0))
          (left-inner-ankle (point 137 0))
          (right-outer-ankle (point 273 0))
          (right-inner-ankle (point 222 0)))
      (segments->painter
       (list
        ; left side
        (make-segment left-temple left-ear)
        (make-segment left-ear left-neck)
        (make-segment left-neck left-shoulder)
        (make-segment left-shoulder left-inner-elbow)
        (make-segment left-inner-elbow left-radial-wrist)
        (make-segment left-ulnar-wrist left-outer-elbow)
        (make-segment left-outer-elbow left-armpit)
        (make-segment left-armpit left-waist)
        (make-segment left-waist left-outer-ankle)
        ; middle
        (make-segment left-inner-ankle leg-join)
        (make-segment leg-join right-inner-ankle)
        ; right side
        (make-segment right-outer-ankle right-waist)
        (make-segment right-waist right-armpit)
        (make-segment right-armpit right-inner-elbow)
        (make-segment right-inner-elbow right-radial-wrist)
        (make-segment right-ulnar-wrist right-outer-elbow)
        (make-segment right-outer-elbow right-shoulder)
        (make-segment right-shoulder right-neck)
        (make-segment right-neck right-ear)
        (make-segment right-ear right-temple)))))

(define tattoo-painter
  (lambda (frame)
    (x-painter frame)
    (diamond-painter frame)))

; Drawing with painters (the fun part!)
(define wave-painter-frame
  (make-frame (make-vect 50 50)
              (make-vect wave-image-width 0)
              (make-vect 0 wave-image-height)))
(wave-painter wave-painter-frame)

; for fun, draw a tattoo on the wave painter figure's arm
(define tattoo-frame
  ((make-relative-frame wave-painter-frame) (make-vect 94.5 226)
              (make-vect -10.0 17.32)
              (make-vect 34.64 20)))
(tattoo-painter tattoo-frame)