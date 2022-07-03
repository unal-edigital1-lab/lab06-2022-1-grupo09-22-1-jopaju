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
    - Se inició pintando un cuadrado que representa la pelota y programandole movimiento en el eje x y en el eje y
    - Luego se verfica si la pelota esta en algun borde de la pantalla 1px - 480px para el eje x, y 1px - 640px  para en eje y. En caso de que este en aguna de estas posiciones la pelota cambia de dirección 

    video

    .

    .

    .

    .

    .

    video

4. Detectar anotación de punto

5. Delay pelota

6. Puntaje

7. Reset

Por último se le agrego un botón de reset el cual:
- Pone ambos score en el valor 0
- Coloca la pelota en los valores x y y centrales
- Reinicia la posición de ambas barritas ubicandolas en la posición central del eje x




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
