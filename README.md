# racket-soccer


## Notas de diseño

- Posición depende de velocidad, se escoge un ángulo al azar y se mueve en un radio de tamaño de la velocidad

- Son 11 jugadores: 1 portero, 4 defensas, 4 medios, 2 delanteros vs 5 defensas, medios, 2 delanteros

- GUI va a ser un rectángulo y jugadores van a ser puntos de colores, los equipos van a ser rojo vs azul y los diferentes tipos de jugadores diferentes tonos
(por ej: portero rosado, defensas rojo oscuro, ...)
- y la bola va a ser un punto blanco

- La información de los jugadores es manejada por el GUI, y llama al algoritmo genético para generar generaciones nuevas y dibujarlas en un loop.

- La información de jugadores viene en una lista de 22 individuos y cada individuo está representado por una lista de la siguiente manera
Individuo = [x, y, equipo (0 o 1), tipo de jugador (0..3),  stats]
stats = [Velocidad, fuerza, posición,  habilidad]
- El GUI es el papá del algoritmo genético, encargado de manejar toda la info de los jugadores y nada más se la pasa al genético para generar generaciones nuevas, como el siguiente pseudocódigo:
```
generacion = init_gen()

for 0..max_generaciones:
	generacion = generar_nueva_generacion()

	// hacer cosas como patear bola, arreglar colisiones, dibujar varas
end
```
	

- El GUI es el encargado de saber dónde está la bola y de que los jugadores la pateen en cada generación si están cerca

