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

  Una vez se logró que la pelota limitara su movimiento al recuadro que aparece en pantalla, se siguió con la construcción de lo que sería la base para el puntaje: que se detectara en qué momento la pelota debería seguir con su movimiento a través de la pantalla debido a que rebotó con las raquetas; y en qué momento debía volver al centro de la pantalla ya que uno de los jugadores habría anotado un punto.

5. Delay pelota

  Así, cuando la pelota no chocaba con las raquetas (cuando se anota un punto) la pelota iría de nuevo a su posición inicial, no obstante, lo que ocurría era que la pelota iniciaba de manera inmediata su movimiento, lo que trababa la jugabilidad, ya que hacía imposible que los jugadores reaccionaran en el tiempo correcto para seguir jugando, por lo que se decidió insertar un tiempo de espera después de cada punto. De este modo ahora, tras cada punto, los jugadores serán capaces de procesar el movimiento de la pelota y mejorar así la jugabilidad.

6. Puntaje

  Luego, de hacer el proyecto estable y jugable, se procedió a iniciar con el puntaje, hecho con contadores que se refelejan en pantalla con barras que se hacen más grandes dependiendo de la cantidad de puntos que realicen los jugadores. Los puntajes se establecieron hasta 7.

7. Reset

Por último se le agrego un segundo botón de reset el cual:
- Pone ambos score en el valor 0
- Coloca la pelota en los valores x y y centrales
- Reinicia la posición de ambas barritas ubicandolas en la posición central del eje x




### Cómo funciona el código (Análisis, explicación del código)

- Control de pantalla VGA
Tiene dos partes fundamentales, la sincronizanción con la pantalla y el manejo de colores a travez de información en la RAM. Esta Última se procesa por medio del módulo VGA_driver.v.

Es necesario sincronizar tanto en el eje x como  en el y.

```verilog
localparam SCREEN_X = 640; 	// tamaño de la pantalla visible en horizontal 
localparam FRONT_PORCH_X =16;  
localparam SYNC_PULSE_X = 96;
localparam BACK_PORCH_X = 48;
localparam TOTAL_SCREEN_X = SCREEN_X+FRONT_PORCH_X+SYNC_PULSE_X+BACK_PORCH_X; 	// total pixel pantalla en horizontal 


localparam SCREEN_Y = 480; 	// tamaño de la pantalla visible en Vertical 
localparam FRONT_PORCH_Y =10;  
localparam SYNC_PULSE_Y = 2;
localparam BACK_PORCH_Y = 33;
localparam TOTAL_SCREEN_Y = SCREEN_Y+FRONT_PORCH_Y+SYNC_PULSE_Y+BACK_PORCH_Y; 	// total pixel pantalla en Vertical 

```


Dependiendo de la resolución de la pantalla todos los parametros anteriores variarán.

```verilog
assign posX    = countX;
assign posY    = countY;

assign pixelOut = (countX<SCREEN_X) ? (pixelIn ) : (12'b000000000000) ;

assign Hsync_n = ~((countX>=SCREEN_X+FRONT_PORCH_X) && (countX<SCREEN_X+SYNC_PULSE_X+FRONT_PORCH_X)); 
assign Vsync_n = ~((countY>=SCREEN_Y+FRONT_PORCH_Y) && (countY<SCREEN_Y+FRONT_PORCH_Y+SYNC_PULSE_Y));
```
Luego Se verifica si se está adentro de la pantalla de visualización y se calcúla el tiempo de los pulsos de sincronización.

Para manejar los colores se uso un archivo de texto que contiene los colores del juego y este archivo se precargó en la RAM a travez del módulo buffer_ram_dp.v

- Movimiento de la bola (rebote, puntos o no)

Se dibuja un cuadrado que hace de pelota y cuya posición depende de dos contadores (contx, conty).
```verilog
    always @ (VGA_posX, VGA_posY) begin
  // Dibujo de la pelota en base a los contadores en x y y.
		if ((VGA_posX>contx) && (VGA_posX<contx+BALL_X) && (VGA_posY>conty) &&(VGA_posY<conty+BALL_Y) )
			DP_RAM_addr_out=2;

```

Estos contadores aumentan o disminuyen dependiendo de unas banderas (banx,bany) que indican con que borde de la pantalla la pelota esta "chocando"
```verilog
always @ ( posedge enable) begin
//banx, bany controlan la dirección de la pelota
	if (banx) contx = contx + 1; else contx= contx - 1;
	if (bany) conty = conty + 1; else conty= conty - 1;
	// Cambiar bandera si detecta que esta en el borde
	if (contx==1) banx=1;
	if (contx==639) banx=0;
```
- Movimiento de las raquetas (límites)

Se dibujan las raquetas en una posición especifica de y y la posición x depende de un contador
```verilog
always @ (VGA_posX, VGA_posY) begin
		//Raqueta verde
		if ((VGA_posX>cont) && (VGA_posX<cont+CAM_SCREEN_X) && (VGA_posY>25) &&(VGA_posY<40) )
			DP_RAM_addr_out=1;
		//Raqueta roja
		if ((VGA_posX>cont2) && (VGA_posX<cont2+CAM_SCREEN_X) && (VGA_posY>410) &&(VGA_posY<425) )
			DP_RAM_addr_out=2;
		else
			DP_RAM_addr_out=0;

```

Luego los contadores aumentan o disminuyen dependiendo de si se estan oprimiendo unos pulsadores externos los cuales se ejecutan dentro de un proceso que tiene como reloj la señal enable que tiene una frecuencia mas baja para que la raqueta tenga una velocidad moderada.

```verilog
always @ ( posedge enable) begin
// Movimiento Raqueta verde
	if (~bntl1)  cont=cont-1;
	if (~bntr1) cont=cont+1;
	// Movimiento Raqueta roja
	if (~bntl2)  cont2=cont2-1;
	if (~bntr2) cont2=cont2+1;

```
Con la finalidad de que las raquetas no se salgan del borde de la pantalla, los contadores tienen dos valores limites.

```verilog
always @ ( posedge enable) begin
// Limites de raquetas (para que no se salgan de la pantalla)
	if (cont<=2) cont=2;	//R verde
	if (cont>480) cont=480;
	if (cont2<=2) cont2=2;	//R roja
	if (cont2>480) cont2=480;

```

- Marcadores
Son dos barritas visuales que aumentan de tamaño a medida que aumenta el score teniendo como límite 7 ptos, al llegar a este ambos puntajes se reinician en el valor 0.

- Reset

### Video de funcionamiento final

### Conclusiones

- La FPGA es una herramienta muy poderosa que, aún con nuestro breve conociemiento sobre ella, se logró de manera satisfactoria cumplir el objetivo inicial: recrear el primer juego que tuvo éxito entre la gente.

### Referencias

<a id="1">[1]</a> Wikipedia Contributors. (2022, July 1). Pong. Wikipedia; Wikimedia Foundation. https://en.wikipedia.org/wiki/Pong

‌
