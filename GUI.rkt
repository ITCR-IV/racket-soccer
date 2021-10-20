#lang racket/gui

(require racket/date)
(require "auxiliary.rkt")

; la bola
(define ball '()) 

; el jugador
(define players '())

; font
(define font (make-object font% 16 'default))

(define (move-ball move-x move-y) 
  (set! ball (list (+ (car ball) move-x) (+ (cadr ball) move-y) (caddr ball)))
  )

(define (draw-ball dc)
  (send dc set-pen "black" 2 'solid)
  (send dc set-brush "white" 'solid)
  (send dc draw-ellipse ( - (car ball)  (caddr ball)) ( - (cadr ball) (caddr ball) )
	(* 2 (caddr ball)) (* 2 (caddr ball)))
  )

(define (kick-ball-animation canvas finalx finaly)
  (define x-interval ( / (- finalx (car ball)) 15))
  (define y-interval ( / (- finaly (cadr ball)) 15))
  (define timer-counter 0)
  (define timer
    (new timer%
	 (notify-callback
	   (lambda ()
	     (cond [(< timer-counter 15) ;; va a durar 1.5 segundos en llegar
		    (set! timer-counter (add1 timer-counter))
		    (move-ball x-interval y-interval)
		    (send canvas refresh)]
		   [else
		     (send timer stop)])))))
  (send timer start 100) ; update cada 100ms
  )

; dibuja la cancha base
(define (draw-field dc)
  (send dc set-pen "white" 7 'solid)
  (send dc set-brush "white" 'transparent)

  ; borde de la cancha
  (send dc draw-rectangle 0 0 1000 650)
  ; rectangulos canchas
  (send dc draw-rectangle 0 125 165 400)
  (send dc draw-rectangle 835 125 165 400)
  (send dc draw-rectangle 0 235 55 183)
  (send dc draw-rectangle 945 235 55 183)

  ; linea del centro
  (send dc draw-line 500 0 500 650)

  ; circulitos de esquinas
  (send dc set-pen "white" 5 'solid)
  (send dc draw-ellipse -25 -25 50 50)
  (send dc draw-ellipse -25 625 50 50)
  (send dc draw-ellipse 975 -25 50 50)
  (send dc draw-ellipse 975 625 50 50)

  ; circulo del centro
  (send dc draw-ellipse 409 234 182 182)

  ; punto pequeño del centro
  (send dc set-brush "white" 'solid)
  (send dc draw-ellipse 495 320 10 10)
  )

(define (draw-player dc player n)
  (send dc set-pen (if (zero? (cadr player)) "blue" "red") 4 'solid)
  (send dc set-brush (case (car player) 
		       [(0) "deep sky blue"]
		       [(1) "forest green"]
		       [(2) "orange red"]
		       [(3) "dark red"]) 'solid)

  ;(printf "val: ~v\n"  (* (if (>= n 10) 1 2) (send dc get-char-width)))
  (send dc draw-ellipse ( - (caaddr player)  (* (if (>= n 10) 1 2) (send dc get-char-width))) ( - (car (cdaddr player)) 16)
	(* 2 16) (* 2 16))

  ;el número
  ;(send dc set-pen "white" 3 'solid)
  (send dc draw-text (number->string n) (- (caaddr player) 15) ( - (car (cdaddr player)) 15) )

  )

(define (draw-players dc lst n)
  (if (null? lst) (void)
    (begin (draw-player dc (car lst) n) (draw-players dc (cdr lst) (add1 n)))
    )
  )


; dibuja la siguiente iteración generativa
(define (draw-time canvas dc)
  ;(printf "\n\n")
  (send dc set-font font)
  (draw-field dc)
  (draw-ball dc)
  (draw-players dc players 0)
  (send dc draw-text (date->string (current-date) #t) 50 50)
  )

(define (fix-until-ok)
  (let ([test-fix (fix-collisions players)])
    (if test-fix (begin 
		     (set! players test-fix)
		     (fix-until-ok)
		     )
      (void))
    )
  )

; frame
(define frame (new frame%
		   [label "CCEQ"]
		   [width 1000]
		   [height 650]))

; definir un canvas que dibuja cuando se estripa la barra espaciadora
(define generative-canvas%
  (class canvas%
    (inherit refresh)
    (define/override (on-char key)
		     (if (equal? (send key get-key-code) #\space)
		       (begin 
			 ;(print-cake (random 10))
			 ;(kick-ball-animation canvas (+ (car ball) 100) (+ (cadr ball) 100) )
			 (printf "fix: ~v\n" (fix-until-ok))
			 (refresh) ) (void))
		     )
    (super-new [parent frame] [paint-callback draw-time])
    )
  )

(define (CCEQ equipo1 equipo2 gens)
  (if (not (all-leq5? (append equipo1 equipo2))) (error "En el método CCEQ se permite un máximo de 5 de cualquier tipo de jugador para cada equipo.") (void))

  ; globals
  (set! players (init-players (append equipo1 equipo2)))
  (set! ball (list 500 325 12)) ;empieza en el centro y tiene radio de 5

  ; new-canvas
  (define canvas (new generative-canvas%))

  ; config
  (send canvas set-canvas-background (make-color 42 100 55 1))
  (send (send canvas get-dc) set-text-foreground "white")
  (send frame show #t)
  )

(CCEQ '(4 4 2) '(5 3 2) 20)
