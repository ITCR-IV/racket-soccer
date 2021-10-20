#lang racket

(provide init-players check-kick-ball all-leq5?)


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
  ;(printf "specs: ~v\n" specs)

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


;;;;; misc
(define (all-leq5? lst)
  (if (null? lst) #t
    (if (<= (car lst) 5) (all-leq5? (cdr lst))
      #f)
    )
  )
