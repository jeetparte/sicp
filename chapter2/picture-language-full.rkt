#lang racket/gui

; -------------------------------------------------------------------
; BEGIN: Picture Language Library
; -------------------------------------------------------------------

; Graphics setup (provides the drawing capabilities)
(require graphics/graphics)
(open-graphics)
(define viewport-width 500)
(define viewport-height 500)
(define vp (open-viewport "Picture Language Canvas" viewport-width viewport-height))

(define draw (draw-viewport vp))
(define (clear) ((clear-viewport vp)))
(define line (draw-line vp))

; In the graphics library, the viewport's origin (0, 0) is at the upper-left corner,
; and positions increase to the right and down.
; This function converts regular y-coordinates to match the graphic library's semantics,
; allowing us to use standard semantics in our code.
(define (normalize y-coord)
  (- viewport-height y-coord))

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

; a useful vector
(define origin-vector (make-vect 0 0))

; Frames
(define (make-frame origin edge1 edge2) (list origin edge1 edge2))
(define (origin-frame frame) (car frame))
(define (edge1-frame frame) (cadr frame))
(define (edge2-frame frame) (caddr frame))

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

(define right-diagonal-painter
  (segments->painter
   (list (make-segment (make-vect 0 0)
                       (make-vect 1 1)))))

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

; these constants define the height:width ratio of the original wave image - 
(define wave-image-width 346)
(define wave-image-height 416)
; a helper
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

; Painter transformations
(define (transform-painter painter origin corner1 corner2)
  (lambda (frame)
    (let ((m (frame-coord-map frame)))
      (let ((new-origin (m origin)))
        (painter (make-frame
                  new-origin
                  (sub-vect (m corner1) new-origin)
                  (sub-vect (m corner2) new-origin)))))))

(define (flip-vert painter)
  (transform-painter painter
                     (make-vect 0.0 1.0)
                     (make-vect 1.0 1.0)
                     (make-vect 0.0 0.0)))

(define (squash-inwards painter)
  (transform-painter painter
                     (make-vect 0.0 0.0)
                     (make-vect 0.65 0.35)
                     (make-vect 0.35 0.65)))

(define (flip-horiz painter)
  (transform-painter painter
                     (make-vect 1.0 0.0)
                     (make-vect 0.0 0.0)
                     (make-vect 1.0 1.0)))

(define (rotate90 painter)
  (transform-painter painter
                     (make-vect 1.0 0.0)
                     (make-vect 1.0 1.0)
                     (make-vect 0.0 0.0)))

(define (rotate180 painter)
  (transform-painter painter
                     (make-vect 1.0 1.0)
                     (make-vect 0.0 1.0)
                     (make-vect 1.0 0.0)))

(define (rotate270 painter)
  (transform-painter painter
                     (make-vect 0.0 1.0)
                     (make-vect 0.0 0.0)
                     (make-vect 1.0 1.0)))

(define (beside painter1 painter2)
  (let ((split-point (make-vect 0.5 0.0)))
    (let ((paint-left
           (transform-painter
            painter1
            (make-vect 0.0 0.0)
            split-point
            (make-vect 0.0 1.0)))
          (paint-right (transform-painter
                        painter2
                        split-point
                        (make-vect 1.0 0.0)
                        (make-vect 0.5 1.0))))
      (lambda (frame)
        (paint-left frame)
        (paint-right frame)))))

(define (below0 painter1 painter2)
  (let ((split-point (make-vect 0.0 0.5)))
    (let ((paint-up
           (transform-painter
            painter2
            split-point
            (make-vect 1.0 0.5)
            (make-vect 0.0 1.0)))
          (paint-down
           (transform-painter
            painter1
            (make-vect 0.0 0.0)
            (make-vect 1.0 0.0)
            split-point)))
      (lambda (frame)
        (paint-up frame)
        (paint-down frame)))))

; Alternately, in terms of `beside` and rotations that cancel out:
(define (below painter1 painter2)
  (rotate90 (beside (rotate270 painter1) (rotate270 painter2))))

; Recursive painter operations
(define (right-split painter n)
  (if (= n 0)
      painter
      (let ((smaller (right-split painter (- n 1))))
        (beside painter
                (below smaller smaller)))))
(define (up-split painter n)
  (if (= n 0)
      painter
      (let ((smaller (up-split painter (- n 1))))
        (below painter
               (beside smaller smaller)))))

(define (corner-split painter n)
  (if (= n 0)
      painter
      (let ((up (up-split painter (- n 1)))
            (right (right-split painter (- n 1))))
        (let ((top-left (beside up up))
              (bottom-right (below right right))
              (corner (corner-split painter (- n 1))))
          (below (beside painter bottom-right)
                 (beside top-left corner))))))

(define (square-limit painter n)
  (let ((quarter (corner-split painter n)))
    (let ((half (beside (flip-horiz quarter) quarter)))
      (below (flip-vert half) half))))

; Higher-order operations
(define (square-of-four tl tr bl br)
  (lambda (painter)
    (let ((top (beside (tl painter) (tr painter)))
          (bottom (beside (bl painter) (br painter))))
      (below bottom top))))

; square-limit in terms of 'square-of-four':
(define (square-limit-h painter n)
  (define (identity painter) painter)
  (let ((combine4 (square-of-four flip-horiz identity rotate180 flip-vert)))
    (combine4 (corner-split painter n))))

; -------------------------------------------------------------------
; END: Picture Language Library
; -------------------------------------------------------------------

; -------------------------------------------------------------------
; BEGIN: Picture Language Library Extensions
; -------------------------------------------------------------------

; Some additional frame operations
(define (make-quick-frame width height tilt)
  (make-frame origin-vector
              (make-vect width tilt)
              (make-vect tilt height)))

(define (tilt-frame frame tilt)
  (make-frame (origin-frame frame)
              (add-vect (edge1-frame frame) (make-vect 0 tilt))
              (add-vect (edge2-frame frame) (make-vect tilt 0))))

; to center a frame w.r.t another, we calculate it's origin vector based on the relation
; that when the centers of the frame and reference-frame align,
; vector(reference-frame's center) = vector(origin) + relative_vector(frame's center)
(define (centered frame reference-frame)
  (define (relative-center frame)
    (add-vect (scale-vect 0.5 (edge1-frame frame))
              (scale-vect 0.5 (edge2-frame frame))))
  (let ((actual-center (add-vect (origin-frame reference-frame)
                                 (relative-center reference-frame)))
        (relative-center (relative-center frame)))
    (make-frame (sub-vect actual-center relative-center)
                (edge1-frame frame)
                (edge2-frame frame))))

; returns a tilted frame which is centered w.r.t. the original frame
(define (tilt-and-center-frame frame tilt)
  (centered (tilt-frame frame tilt) frame))

; Useful frames

; Define the drawing area as a frame centered in the viewport
(define viewport-frame
  (make-frame origin-vector
              (make-vect viewport-width 0)
              (make-vect 0 viewport-height)))
(define drawing-area-frame
  (let ((width 400) (height 400) (tilt 0))
    (let ((frame (make-quick-frame width height tilt)))
      (centered frame viewport-frame))))

; a frame that has the correct proportions for the wave painting
(define wave-painter-frame
  (make-quick-frame (* 0.5 wave-image-width)
                    (* 0.5 wave-image-height)
                    0))

; -------------------------------------------------------------------
; END: Picture Language Library Extensions
; -------------------------------------------------------------------

; -------------------------------------------------------------------
; BEGIN: Code snippet for the Picture Language Exhibition
; -------------------------------------------------------------------

; Primitives
(define outline-pattern (square-limit outline-painter 3))
(define x-pattern (square-limit x-painter 3))
(define diamond-pattern (square-limit diamond-painter 3))
(define left-diagonal-pattern (square-limit
                               (flip-horiz right-diagonal-painter) ; left-diagonal-painter
                               3))
(define right-diagonal-pattern (square-limit right-diagonal-painter 3))

; Exhibit 1
(define solo-picture-1 outline-pattern)
(define solo-picture-2 x-pattern)
(define solo-picture-3 diamond-pattern)
(define solo-picture-4 left-diagonal-pattern)
(define solo-picture-5 right-diagonal-pattern)

; Exhibit 2
(define combination-1-a
  (lambda (frame)
    (outline-pattern frame)
    (right-diagonal-pattern frame)))

(define combination-1-b
  (lambda (frame)
    (outline-pattern frame)
    (left-diagonal-pattern frame)))

(define combination-2
  (lambda (frame)
    (outline-pattern frame)
    (x-pattern frame)))

(define combination-3
  (lambda (frame)
    (outline-pattern frame)
    (diamond-pattern frame)))

(define combination-4
  (lambda (frame)
    (diamond-pattern frame)
    (x-pattern frame)))

(define combination-5
  (lambda (frame)
    (outline-pattern frame)
    (diamond-pattern frame)
    (x-pattern frame)))
    
; Exhibit 3
; Note: The centerpiece picture makes extensive use of the 'Picture Language Library Extensions' defined above.

(define centerpiece
  (lambda ()
    (let ((square-frame drawing-area-frame))
      (let ((inner-frame (centered wave-painter-frame square-frame)))
        (outline-painter square-frame)
        (outline-painter (tilt-and-center-frame square-frame 50))
        (outline-painter (tilt-and-center-frame square-frame -50))
        ((square-limit wave-painter 3) (tilt-and-center-frame inner-frame 70))
        ((square-limit wave-painter 3) (tilt-and-center-frame inner-frame -70))))))

; Example usages:
;(solo-picture-1 drawing-area-frame)
;(combination-4 drawing-area-frame)
(centerpiece)

; -------------------------------------------------------------------
; END: Code snippet for the Picture Language Exhibition
; -------------------------------------------------------------------