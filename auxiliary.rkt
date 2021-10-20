#lang racket

(provide init-players check-kick-ball all-leq5? fix-collisions)


;;;;;; player initialization
(define (init-players specs) 
  (init-players-aux specs '() #f)
  )

(define (create-player type team minx maxx miny maxy)
  (list type team (list (random minx maxx) (random miny maxy)) (list (random 10) (random 10) (random 10)))
  )


(define (init-players-aux specs players portero2)
  ; specs es lista de 6 elementos con tipos de jugador de cada equipo (no se incluyen porteros)
  ; esta función va restando de specs cada jugador que ingresa a la lista final hasta que obtiene a todos los jugadores
  ;(printf "specs: ~v\n" specs))

  (cond 
    ; crear primer portero
    [(null? players) (init-players-aux specs (list (create-player 0 0 0 55 235 418)) portero2)]
    ; terminar
    [(and (all-zero? specs) portero2) players]

    ; delanteros segundo equipo
    [(and (all-zero? (take specs 5)) portero2) (init-players-aux (list-update specs 5 sub1) (append players (list (create-player 3 1 0 333 0 650))) portero2)]
    ; medios segundo equipo
    [(and (all-zero? (take specs 4)) portero2) (init-players-aux (list-update specs 4 sub1) (append players (list (create-player 2 1 333 666 0 650))) portero2)]
    ; defensas segundo equipo
    [(and (all-zero? (take specs 3)) portero2) (init-players-aux (list-update specs 3 sub1) (append players (list (create-player 1 1 666 1000 0 650))) portero2)]

    ; agregar segundo portero
    [(all-zero? (take specs 3))  (init-players-aux specs (append players (list (create-player 0 1 945 1000 235 418))) #t)]

    ; delanteros primer equipo
    [(all-zero? (take specs 2)) (init-players-aux (list-update specs 2 sub1) (append players (list (create-player 3 0 666 1000 0 650))) portero2)]
    ; medios primer equipo
    [(all-zero? (take specs 1)) (init-players-aux (list-update specs 1 sub1) (append players (list (create-player 2 0 333 666 0 650))) portero2)]  ; medios primer equipo
    ; agregar defensas 0
    [else (init-players-aux (list-update specs 0 sub1) ( append players (list (create-player 1 0 0 333 0 650))) portero2)]
    )
  )

; Comprueba que todos los elementos de la lista sean 0
(define (all-zero? lst)
  (if (null? lst) #t
    (if (zero? (car lst)) (all-zero? (cdr lst))
      #f)
    )
  )


;;;;; Patear la bola
(define (check-kick-ball players) (list 1 2) )

;;;;; colisiones entre jugadores
(define (fix-collisions players)
  (fix-collisions-aux players players)
  )

(define (move-player player )
  (list (car player) (cadr player) (list (+ (caaddr player) 10) (car (cdaddr player))) (last player))
  )

(define (fix-collisions-aux playerslist playersiter)
  (if (null? playersiter) #f
    (if (check-collisions playerslist (car playersiter) 0)
      (append (take  playerslist (check-collisions playerslist (car playersiter) 0)) (cons (move-player (list-ref playerslist (check-collisions playerslist (car playersiter) 0))) (cdr (list-tail playerslist (check-collisions playerslist (car playersiter) 0)))) )
      (begin
	(fix-collisions-aux playerslist (cdr playersiter))
	)
      )
    )
  )

; Revisa la colisión de un jugador con el resto de los jugadores, retorna el índice del jugador con el que choca.
(define (check-collisions players check-player i)
  ;(printf "players left: ~v\n" players)
  ;(printf "null? players: ~v\n" (null? players))
  ;(printf "check-player: ~v \n" check-player)
  (if (null? players) #f
    (if (equal? check-player (car players) ) (check-collisions (cdr players) check-player (add1 i))
      (if (check-circles-collision (caaddr check-player) (car (cdaddr check-player)) 16 
				   (caaddr (car players)) (car (cdaddr (car players))) 16) i 
	(check-collisions (cdr players) check-player (add1 i)))
      )
    )
  )

(define (check-circles-collision point1x point1y radi1 point2x point2y radi2)
  (< (sqrt ( + (expt (- point2x point1x) 2) (expt (- point2y point1y) 2))) (+ radi1 radi2))
  )

;;;;; misc
(define (all-leq5? lst)
  (if (null? lst) #t
    (if (<= (car lst) 5) (all-leq5? (cdr lst))
      #f)
    )
  )
