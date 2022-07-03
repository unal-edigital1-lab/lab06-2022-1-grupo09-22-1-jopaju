# WP01

# Elecrtónica Digital I
## Proyecto final: Nacho Pong

### Integrantes

- Pablo García - pgarcias@unal.edu.co
- Juan Ochoa - juochoac@unal.edu.co
- Juan Rodríguez - juarodriguezr@unal.edu.co

### Objetivos

- Sintetizar los conocimientos adquiridos en los laboratorios en un proyecto
- Recrear el videojuego PONG usando una tarjeta FPGA
- Usar el conector VGA para visualizar imágenes en pantalla

### Introducción (Descripción del juego)

El videojuego PONG, lanzado al público por primera vez en 1972, busca simular el tenis de mesa, por lo que los jugadores que controlan las raquetas buscarán hacer que su oponente no pueda devolver la pelota. Este videojuego fue el primero en tener éxito comercial que ayudó a sentar las bases de lo que es hoy día la industria de los videojuegos [[1]](#1).

Por lo tanto, el objetivo del grupo fue recrear este famoso juego, haciendo uso de los conociemientos adquiridos a través de las diferentes prácticas de laboratorio para la asignatura de Electrónica Digital I, y de las valiosas herramientas que allí tuvimos a disposición de las cuales la que más resalta es sin duda la tarjeta FPGA. Entre las nuevas habilidades aprehendidas resaltan para la culminación de este proyecto final el uso y configuración de pantallas VGA a través de sus señales de sincronización, además del aprendizaje general del lenguaje de descripción de hardware Verilog, y el software de diseño Quartus.

El control del videojuego se lleva a cabo en la FPGA, mientras que el video se enseña en una pantalla con entrada VGA, además se construyeron también un par de mandos, de modo tal que los jugadores pudieran llevar a cabo el movimiento de las raquetas. Es también de resaltar elementos propios de la correcta jugabilidad tal como lo son el *delay* que se presenta cada vez que algún jugador anota un punto, además de un botón de *reset* que pone en ceros el marcador, pone la bola en el centro y las raquetas en su posición inicial.

### Materiales (Implementos)

- Controles
- Pantalla
- FPGA
- Quartus

### Proceso (Cronológico, cómo se desarrolló, primeros avances)

1. El primer reto fue controlar la pantalla VGA por medio de la FPGA, para esto se interpretó y adató el código a nuestro modelo de tarjeta (xdxd Poner modelo aqui xdxd) pues esta solo permite usar RGB111 (un bit por cada color), mientras que el código dado por el profe estaba hecho para usar RGB444. Al intentar solucionar esto realizamos una mala lectura del archivo image.men obteniendo nuestro primer error.


<p align="center">
  <img src="code\hdl\proyecto\Documentacion_fotografica\controlVGAerrorColor.jpg" width="300">
</p>

Para solucionar esto se usó unicamente el último bit de cada color, es decir:
| Linea de archivo image.men | "tradución" a binario | Último bit de cada color|
| ------------- | ------------- |------------- |
| F00  | 1111 0000 0000 |100|
| 0FF  | 0000 1111 1111  |011|
| 010  | 0000 0001 0000  |010|
| 1F0  | 0001 1111 0000  |110|

Aunque esta propuesta es ineficiente en cuanto a memoria, pues en el archivo se almacenan bits innecesarios, fue la manera mas sencilla de corregir este error obteniendo el funcionamiento esperado
<p align="center">
  <img src="code\hdl\proyecto\Documentacion_fotografica\solucionColor.jpg" width="300">
</p>

video

.

.

.

.

.

video



2. Luego conociendo ya como controlar la pantalla se decidio implementar las barritas (raquetas), primero dibujandola en la pantalla y luego programando su movimiento condicionadolo a un par de botones.

video

.

.

.

.

.

video

Para despues duplicar este código y crear la barrita del segundo jugador.

video

.

.

.

.

.

video

3. Desarrollo de la "pelota"
    - Se inició pintando un cuadrado que representa la pelota y programandole movimiento en el eje x y ene eje y
    - vvvvv

4. Detectar anotación de punto

  Una vez se logró que la pelota limitara su movimiento al recuadro que aparece en pantalla, se siguió con la construcción de lo que sería la base para el puntaje: que se detectara en qué momento la pelota debería seguir con su movimiento a través de la pantalla debido a que rebotó con las raquetas; y en qué momento debía volver al centro de la pantalla ya que uno de los jugadores habría anotado un punto.

5. Delay pelota

  Así, cuando la pelota no chocaba con las raquetas (cuando se anota un punto) la pelota iría de nuevo a su posición inicial, no obstante, lo que ocurría era que la pelota iniciaba de manera inmediata su movimiento, lo que trababa la jugabilidad, ya que hacía imposible que los jugadores reaccionaran en el tiempo correcto para seguir jugando, por lo que se decidió insertar un tiempo de espera después de cada punto. De este modo ahora, tras cada punto, los jugadores serán capaces de procesar el movimiento de la pelota y mejorar así la jugabilidad.

6. Puntaje

  Luego, de hacer el proyecto estable y jugable, se procedió a iniciar con el puntaje, hecho con contadores que se refelejan en pantalla con barras que se hacen más grandes dependiendo de la cantidad de puntos que realicen los jugadores. Los puntajes se establecieron hasta 7.

7. Reset



### Cómo funciona el código (Análisis, explicación del código)

- Control de pantalla VGA
- Movimiento de la bola (rebote, puntos o no)
- Movimiento de las raquetas (límites)
- Marcadores
- Reset

### Video de funcionamiento final

### Conclusiones

- La FPGA es una herramienta muy poderosa que, aún con nuestro breve conociemiento sobre ella, se logró de manera satisfactoria cumplir el objetivo inicial: recrear el primer juego que tuvo éxito entre la gente.

### Referencias

<a id="1">[1]</a> Wikipedia Contributors. (2022, July 1). Pong. Wikipedia; Wikimedia Foundation. https://en.wikipedia.org/wiki/Pong

‌
