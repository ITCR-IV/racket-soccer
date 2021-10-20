#lang racket/gui

(require racket/date)

; draws the current time on the canvas
(define (draw-time canvas dc)
  (send dc draw-text (date->string (current-date) #t) 50 50)
  )

; new frame
(define frame (new frame%
		   [label "Example"]
		   [width 1000]
		   [height 500]))

; define a canvas that acts on spacebar keypress
(define generative-canvas%
  (class canvas%
    (inherit refresh)
    (define/override (on-char key)
		     (if (equal? (send key get-key-code) #\space)
		       (refresh) (void))
		     )
    (super-new [parent frame] [paint-callback draw-time])
    )
  )

; new-canvas
(define canvas (new generative-canvas%))

; config
(send canvas set-canvas-background (make-color 42 100 55 1))
(send (send canvas get-dc) set-text-foreground "white")
(send frame show #t)
