#lang racket

(provide init-players check-kick-ball)

(define (init-players specs) 
  (init-players-aux specs '() #f)
  )

(define (create-player type team minx maxx miny maxy)
  (list type team (list (random minx maxx) (random miny maxy)) (list (random 10) (random 10) (random 10)))
  )

(define (sub1-from lst n)
  (call-with-values (lambda () (split-at lst n)) (lambda (a b) (append a (cons (sub1 (car b)) (cdr b))) ))
  )

(define (init-players-aux specs players portero2)
  ; specs es lista de 6 elementos con tipos de jugador de cada equipo (no se incluyen porteros)
  ; esta función va restando de specs cada jugador que ingresa a la lista final hasta que obtiene a todos los jugadores
  ;(printf "specs: ~v\n" specs)

  (cond 
    [(null? players) (init-players-aux specs (list (create-player 0 0 0 55 235 418)) portero2)] ; crear primer portero
    [(and (all-zero? specs) portero2) players] ; terminar

    [(and (all-zero? (take specs 5)) portero2) (init-players-aux (sub1-from specs 5) (append players (list (create-player 3 1 0 333 0 650))) portero2)] ; delanteros segundo equipo
    [(and (all-zero? (take specs 4)) portero2) (init-players-aux (sub1-from specs 4) (append players (list (create-player 2 1 333 666 0 650))) portero2)] ; medios segundo equipo
    [(and (all-zero? (take specs 3)) portero2) (init-players-aux (sub1-from specs 3) (append players (list (create-player 1 1 666 1000 0 650))) portero2)] ; defensas segundo equipo

    [(all-zero? (take specs 3))  (init-players-aux specs (append players (list (create-player 0 1 945 1000 235 418))) #t)] ; agregar segundo portero
    [(all-zero? (take specs 2)) (init-players-aux (sub1-from specs 2) (append players (list (create-player 3 0 666 1000 0 650))) portero2)] ; delanteros primer equipo
    [(all-zero? (take specs 1)) (init-players-aux (sub1-from specs 1) (append players (list (create-player 2 0 333 666 0 650))) portero2)]  ; medios primer equipo
    [else (init-players-aux (sub1-from specs 0) ( append players (list (create-player 1 0 0 333 0 650))) portero2)] ; agregar defensas 0
    )
  )

(define (check-kick-ball players) (list 1 2) )

(define (all-zero? lst)
  (if (null? lst) #t
    (if (zero? (car lst)) (all-zero? (cdr lst))
      #f)
    )
  )

