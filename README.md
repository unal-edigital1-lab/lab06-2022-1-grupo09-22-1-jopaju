# WP01

# Elecrtónica Digital I
## Proyecto final: Nacho Pong

### Integrantes

- Pablo García - correo
- Juan Ochoa - correo
- Juan Rodríguez - juarodriguezr@unal.edu.co

### Objetivos

- Recrear el videojuego PONG usando una tarjeta FPGA
- Usar el conector VGA para visualizar imágenes en pantalla
- 

### Introducción (Descripción del juego)

El videojuego PONG, lanzado al público por primera vez en 1972, busca simular el tenis de mesa, por lo que los jugadores que controlan las raquetas buscarán hacer que su oponente no pueda devolver la pelota. Este videojuego fue el primero en tener éxito comercial que ayudó a sentar las bases de lo que es hoy día la industria de los videojuegos [1].

Por lo tanto, el objetivo del grupo fue recrear este famoso juego, haciendo uso de los conociemientos adquiridos a través de las diferentes prácticas de laboratorio para la asignatura de Electrónica Digital I, y de las valiosas herramientas que allí tuvimos a disposición de las cuales la que más resalta es sin duda la tarjeta FPGA. Entre las nuevas habilidades aprehendidas resaltan para la culminación de este proyecto final el uso y configuración de pantallas VGA a través de sus señales de sincronización, además del aprendizaje general del lenguaje de descripción de hardware Verilog, y el software de diseño Quartus.

El control del videojuego se lleva a cabo en la FPGA, mientras que el video se enseña en una pantalla con entrada VGA, además se construyeron también un par de mandos, de modo tal que los jugadores pudieran llevar a cabo el movimiento de las raquetas. Es también de resaltar elementos propios de la correcta jugabilidad tal como lo son el *delay* que se presenta cada vez que algún jugador anota un punto, además de un botón de *reset* que pone en ceros el marcador, pone la bola en el centro y las raquetas en su posición inicial.

### Materiales (Implementos)

- Controles
- Pantalla
- FPGA
- Quartus

### Proceso (Cronológico, cómo se desarrolló, primeros avances)

- 

### Cómo funciona el código (Análisis, explicación del código)

- Movimiento de la bola (rebote, puntos o no)
- Movimiento de las raquetas (límites)
- Marcadores
- Reset

### Video de funcionamiento final

### Conclusiones

- La FPGA es una herramienta muy poderosa que, aún con nuestro breve conociemiento sobre ella, se logró de manera satisfactoria cumplir el objetivo inicial: recrear el primer juego que tuvo éxito entre la gente.

### Referencias

1. Wikipedia Contributors. (2022, July 1). Pong. Wikipedia; Wikimedia Foundation. https://en.wikipedia.org/wiki/Pong

‌
