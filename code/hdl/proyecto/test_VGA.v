`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineers:  	Pablo Garcia 		pgarcias@unal.edu.co
//		Juan Ochoa		juochoac@unal.edu.co
//		Guillermo Rodríguez	juarodriguezr@unal.edu.co			
// 
// Create Date:    July 3 of 2022
// Design Name: 
// Module Name:    test_VGA  // ESte archivo es el top
// Project Name: 	 Nacho_pong
// Target Devices: FPGA CICLONE IV
// Tool versions:  QUARTUS PRIME 20.1
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module test_VGA(
    input wire clk,          
    input wire rst,         	// reset button
	 input wire rst1,
	// VGA input/output  
    output wire VGA_Hsync_n,  // horizontal sync output
    output wire VGA_Vsync_n,  // vertical sync output
    output wire VGA_R,	// 4-bit VGA red output
    output wire VGA_G,  // 4-bit VGA green output
    output wire VGA_B,  // 4-bit VGA blue output
    output wire clkout,  
 	
	// input/output
	
	
	input wire bntr1,//botones de control del juego, para el test no hacen nada
	input wire bntl1,
	input wire bntr2,
	input wire bntl2 
		
);

// TAMAÑO DE LAS RAQUETAS
parameter CAM_SCREEN_X = 150;
parameter CAM_SCREEN_Y = 12;

// PARAMETROS X Y Y DE LA BOLITA 
parameter BALL_X =12;
parameter BALL_Y=12;






//reloj botones


reg [30:0] cfreq=0;
wire enable;

// Divisor de frecuecia, se usará enable como reloj para la velocidad de la barra y 
// la bolita

assign enable = cfreq[16];
always @(posedge clk) begin
  if(rst==0) begin
		cfreq <= 0;
		
				
	end else begin
		cfreq <=cfreq+1;
	end
end


localparam AW = 8; // LOG2(CAM_SCREEN_X*CAM_SCREEN_Y)
localparam DW = 12;

// El color es RGB 444
localparam RED_VGA =   12'b111100000000;
localparam GREEN_VGA = 12'b000011110000;
localparam BLUE_VGA =  12'b000000001111;

 reg [9:0] cont;
 initial cont=10'b0101000000;

 reg [9:0] cont2;
 initial cont2=10'b0101000000;
 
 reg [9:0] contx;
 initial contx=10'b0101000000;

 reg [9:0] conty;
 initial conty=10'b0011110000;
 
 reg [13:0] delay;
 initial delay=14'b00000000000000;
 
 
reg [3:0] marcadorverde;
initial marcadorverde=4'b0000;

reg [3:0] marcadorrojo;
initial marcadorrojo=4'b0000;
 
reg [2:0] score_rojo;
initial score_rojo=3'b000; 

reg [2:0] score_verde;
initial score_verde=3'b000;
 
 //banderas para que la bola se mueva arriba o abajo o izquierda o derecha
 reg banx;
 initial banx=0;
 reg bany;
 initial bany=0;
 
 reg ban_marcador;
 initial ban_marcador=0;

// Clk 
wire clk12M;
reg clk25M;

// Conexión dual por ram

wire  [AW-1: 0] DP_RAM_addr_in;  
wire  [DW-1: 0] DP_RAM_data_in;
wire DP_RAM_regW;

reg  [AW-1: 0] DP_RAM_addr_out;  








	
// Conexión VGA Driver
wire [DW-1:0]data_mem;	   // Salida de dp_ram al driver VGA
wire [DW-1:0]data_RGB444;  // salida del driver VGA al puerto
wire [9:0]VGA_posX;		   // Determinar la pos de memoria que viene del VGA
wire [8:0]VGA_posY;		   // Determinar la pos de memoria que viene del VGA


/* ****************************************************************************
Ya que la FPGA solo puede usar RGB111 solo se toma El último bit de los grupos de cuatro bits que
representan cada uno de los colores 
**************************************************************************** */
	assign VGA_R = data_RGB444[8];
	assign VGA_G = data_RGB444[4];
	assign VGA_B = data_RGB444[0];





/* ****************************************************************************
  Este bloque se debe modificar según sea le caso. El ejemplo esta dado para
  fpga Spartan6 lx9 a 32MHz.
  usar "tools -> IP Generator ..."  y general el ip con Clocking Wizard
  el bloque genera un reloj de 25Mhz usado para el VGA , a partir de una frecuencia de 12 Mhz
**************************************************************************** */
assign clk12M =clk; //No se usó

/*
cl_25_24_quartus clk25(
	.areset(rst),
	.inclk0(clk12M),
	.c0(clk25M)
	
);
*/


//assign clk25M=clk;
assign clkout=clk25M; // tampoco se uso :v

/* ****************************************************************************
buffer_ram_dp buffer memoria dual port y reloj de lectura y escritura separados
Se debe configurar AW  según los calculos realizados en el Wp01
se recomiendia dejar DW a 8, con el fin de optimizar recursos  y hacer RGB 332
**************************************************************************** */
buffer_ram_dp #( AW,DW,"C:/Users/HP/Documents/GitHub/lab06-2022-1-grupo09-22-1-jopaju/hdl/proyecto/image.men")
	DP_RAM(  
	.clk_w(clk25M), 
	.addr_in(DP_RAM_addr_in), 
	.data_in(DP_RAM_data_in),
	.regwrite(DP_RAM_regW), 
	
	.clk_r(clk25M), 
	.addr_out(DP_RAM_addr_out),
	.data_out(data_mem)
	);
	

/* ****************************************************************************
VGA_Driver640x480
**************************************************************************** */
VGA_Driver640x480 VGA640x480
(
	.rst(~rst),
	.clk(clk25M), 				// 25MHz  para 60 hz de 640x480
	.pixelIn(data_mem), 		// entrada del valor de color  pixel RGB 444 
//	.pixelIn(RED_VGA), 		// entrada del valor de color  pixel RGB 444 
	.pixelOut(data_RGB444), // salida del valor pixel a la VGA 
	.Hsync_n(VGA_Hsync_n),	// señal de sincronizaciÓn en horizontal negada
	.Vsync_n(VGA_Vsync_n),	// señal de sincronizaciÓn en vertical negada 
	.posX(VGA_posX), 			// posición en horizontal del pixel siguiente
	.posY(VGA_posY) 			// posición en vertical  del pixel siguiente

);

 
/* ****************************************************************************
LÓgica para actualizar el pixel acorde con la buffer de memoria y el pixel de 
VGA si la imagen de la camara es menor que el display  VGA, los pixeles 
adicionales seran iguales al color del último pixel de memoria 
**************************************************************************** */

//En este proceso se maneja la visualización de raquetas, pelota y marcador

always @ (VGA_posX, VGA_posY) begin
		//Raqueta verde
		if ((VGA_posX>cont) && (VGA_posX<cont+CAM_SCREEN_X) && (VGA_posY>25) &&(VGA_posY<40) )
			DP_RAM_addr_out=1;
		//Raqueta roja
		if ((VGA_posX>cont2) && (VGA_posX<cont2+CAM_SCREEN_X) && (VGA_posY>410) &&(VGA_posY<425) )
			DP_RAM_addr_out=2;
		else
			DP_RAM_addr_out=0;
		

		// Dibujo de la pelota en base a los contadores en x y y.
		if ((VGA_posX>contx) && (VGA_posX<contx+BALL_X) && (VGA_posY>conty) &&(VGA_posY<conty+BALL_Y) )
			DP_RAM_addr_out=2;

		// Dibujo de los marcadores.
		if ((VGA_posX>=1) && (VGA_posX<=(marcadorverde*15)) && (VGA_posY>=5) && (VGA_posY<=17))
			DP_RAM_addr_out=1;
		if ((VGA_posX>=1) && (VGA_posX<=(marcadorrojo*15)) && (VGA_posY>=450) && (VGA_posY<=467))
			DP_RAM_addr_out=2;	
	
	   
		
		
end

//se utiliza un segundo reset ya que el primero desabilita el enable

//En este proceso se analizan los botones, luego de presionar un boton debe haber un 
//tiempo de espera
//luego de lograr un punto se programa un tiempo de espera a traves 
//de la variable delay
always @ ( posedge enable) begin
	
	// Reset de juego 
	if (~rst1) begin
		//Reinicio Score
		marcadorrojo=0;
		marcadorverde=0;

		//Centrar pelota
		contx=10'b0101000000; 
		conty=10'b0011110000;

		// Centrar raquetas
		cont=10'b0101000000;
		cont2=10'b0101000000;
		
		end

	// Movimiento Raqueta verde
	if (~bntl1)  cont=cont-1;
	if (~bntr1) cont=cont+1;
	// Movimiento Raqueta roja
	if (~bntl2)  cont2=cont2-1;
	if (~bntr2) cont2=cont2+1;

	// Limites de raquetas (para que no se salgan de la pantalla)
	if (cont<=2) cont=2;	//R verde
	if (cont>480) cont=480;
	if (cont2<=2) cont2=2;	//R roja
	if (cont2>480) cont2=480;
	

	// Delay de pelota luego de anotar un punto
	if (ban_marcador) begin
		contx=10'b0101000000; 
		conty=10'b0011110000;
		delay=delay + 1;
		end
	if (delay>=500) ban_marcador=0;
	

	//banx, bany controlan la dirección de la pelota
	if (banx) contx = contx + 1; else contx= contx - 1;
	if (bany) conty = conty + 1; else conty= conty - 1;
	// Cambiar bandera si detecta que esta en el borde
	if (contx==1) banx=1;
	if (contx==639) banx=0;
	
	if (conty<=40) // En 40 esta el borde interno de la raqueta verde
		begin
		bany=1;
		
		//analisis para aumentar los marcadores o score
		
		if ((contx>=cont) && contx<=cont+CAM_SCREEN_X+5) // pelota esta chocando con barrita verde?
			begin 
			marcadorrojo=marcadorrojo;
		
			end else begin // Punto para el rival rojo
			marcadorrojo=marcadorrojo+1;
			ban_marcador=1;
			// Úbicación de la pelota en el centro
			contx=10'b0101000000;
			conty=10'b0011110000;
			// Comenzar delay
			delay=0;
			
				// Jugador rojo llego a 7 puntos(gano) entonces se reinician los puntajes
				if (marcadorrojo == 3'b111) begin
				marcadorrojo = 0;
				marcadorverde =0;
				
				end
			end
		
		end
		
	if (conty>=410) // En 40 esta el borde interno de la raqueta roja
		begin
		
		bany=0;
	

		if (contx>=cont2 && contx<=cont2+CAM_SCREEN_X+5) marcadorverde=marcadorverde; // pelota esta chocando con barrita Roja?
				else // Punto para el rival verde
				begin
					marcadorverde=marcadorverde+1;
					ban_marcador=1;
					// Úbicación de la pelota en el centro
					contx=10'b0101000000;
					conty=10'b0011110000;
					// Comenzar delay
					delay=0;
					
					// Jugador verde llego a 7 puntos(gano) entonces se reinician los puntajes
					if (marcadorverde == 3'b111) begin
						marcadorrojo = 0;
						marcadorverde =0;
						end
				end
			end
		
	
end



//asignacion reloj de 25 Mhz

always @ (posedge clk) begin //Divisor de frecuencia facil 
 clk25M = ~clk25M;
 end
 



endmodule


