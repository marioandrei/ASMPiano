;/---------------------------------------------/
;/ practicas de etc-ii                    uam  /
;/ ignacio sainz-trapaga	mario pantoja	  /
;/ etc-ii                                      /
;/ practica 1   : libreria de funciones        /
;/---------------------------------------------/

;___________________________________________________
; definicion del segmento de datos 
datos segment
texto1  db "driver no encontrado",0ah,"$" 
texto2	db "driver incorrecto",0ah,"$"
x1		dw 0
y1		dw 0
x2		dw 0
y2		dw 10
escala	db "n",0ah,"$"
ritmo		db "c",0ah,"$"
modo    db	0,0,' ','$'
ritmot  db "             RITMO    ESCALA",0ah,"$" 
letras1  db "W  E      T  Y  U",0ah,"$" 
letras2  db "A  S  D  F   G  H  J  K",0ah,"$" 
mas_menos  db "+      -",0ah,"$" 
letras3  db "Salir: Z     X C V    B N M ","$" 

letras	db 'a','w','s','e','d','f','t','g','y','h','u','j','i','k'
notas 	db	1,2,3,4,5,6,7,8,9,10,11,12,13
notas1	db	60,79,86,105,112,138,157,164,183,190,209,216,242
notas2	db	110,68,110,68,110,110,68,110,68,110,68,110,110
colors	db	31,21,31,21,31,31,21,31,21,31,21,31,31

; Declaracion de constantes
   X0TECLADO   EQU 60



datos ends ;fin del segmento de datos

;_________________________________________________________________
;definicion del segmento de codigo
libreria SEGMENT PUBLIC
 ASSUME CS:libreria , ds:datos

;==================================
;=     libreria de graficos 	 =
;==================================

;_________________________________________________________________
;funcion que pinta el texto
pinta_letras proc far
	
	mov al,00H
	mov cx,00FFH
	mov ah,0EH
	mov al,10
	mov bl,31	;color
	
	;int 10H	;salto de linea
	int 10H
	int 10H
	int 10H
	mov al,9
	int 10h
	mov al,0
	int 10h
	int 10h
	mov dx,offset letras1	;texto a imprimir
	mov ah, 9              	;
	int 21h               
	mov ah,0EH

	mov al,10 
	int 10h
	int 10h
	int 10h
	int 10h
	int 10h
	int 10h
	int 10h
	int 10h
	int 10h
	int 10h
	int 10h
	int 10h
	mov al,9
	int 10h
	mov al,0
	int 10h

	mov dx,offset letras2	;texto a imprimir
	mov ah, 9              	;
	int 21h               
	mov ah,0EH

	

	mov al,10
	int 10h
	mov dx,offset ritmot	;texto a imprimir
	mov ah, 9              	;
	int 21h 
	mov ah,0EH
	mov al,9
	int 10h
	mov al,10
	int 10h
	int 10h
	int 10h
	int 10h
	mov al,8
	int 10h
	int 10h
	int 10h
	int 10h
	int 10h
	int 10h
	int 10h
	int 10h
	mov dx,offset letras3	;texto a imprimir
	mov ah, 9              	;
	int 21h               
	              

	ret
endp pinta_letras

;_________________________________________________________________
;funcion que imprimer una tecla de tamaño 20x100
pintar_tecla_mini_borde proc far
	;cx=x,dx,y
	;20px largo 100 alto
	
	mov bx,0a000h	;zona que vamos a pintar
	mov es,bx 
	mov bx,0000h ;inicializar

	add bx,cx
b1:
	cmp dx,0
	je p1
	add bx,320
	dec dx
	jmp b1

p1:
	mov cx, 25 ;anchura
	mov dx, 13 ;altura
b3:
	mov es:[bx],al
	inc bx
	dec cx
	jne b3
	
	add bx,320
	mov cx,25
	sub bx,cx
	dec dx
	jne b3
	ret

endp pintar_tecla_mini_borde
	
;_________________________________________________________________
pintar_tecla_mini proc far
		;cx=x,dx,y
		;20px largo 100 alto


		mov bx,0a000h	;zona que vamos a pintar
		mov es,bx 
		mov bx,0000h ;inicializar

		add bx,cx
	b_ucl:
		cmp dx,0
		je p_in_t
		add bx,320
		dec dx
		jmp b_ucl

	p_in_t:
		mov cx, 13 ;anchura
		mov dx, 8 ;altura
	b_ucl2:
		mov es:[bx],al
		inc bx
		dec cx
		jne b_ucl2

		add bx,320
		mov cx,13
		sub bx,cx
		dec dx
		jne b_ucl2
		ret
		endp pintar_tecla_mini
	


;_________________________________________________________________
pintar_tecla_grande proc far
	;cx=x,dx,y
	;20px largo 100 alto
	
	
	mov bx,0a000h	;zona que vamos a pintar
	mov es,bx 
	mov bx,0000h ;inicializar

	add bx,cx
bucl:
	cmp dx,0
	je pin_t
	add bx,320
	dec dx
	jmp bucl

pin_t:
	mov cx, 25 ;anchura
	mov dx, 80 ;altura
bucl2:
	mov es:[bx],al
	inc bx
	dec cx
	jne bucl2
	
	add bx,320
	mov cx,25
	sub bx,cx
	dec dx
	jne bucl2
	ret
	endp pintar_tecla_grande
	
	
;_________________________________________________________________
pintar_tecla_peque proc far	
		;cx=x,dx,y
		;20px largo 100 alto


		mov bx,0a000h	;zona que vamos a pintar
		mov es,bx 
		mov bx,0000h ;inicializar

		add bx,cx
	bucl_:
		cmp dx,0
		je pin_t_
		add bx,320
		dec dx
		jmp bucl_

	pin_t_:
		mov cx, 13 ;anchura
		mov dx, 36 ;altura
	bucl_2:
		mov es:[bx],al
		inc bx
		dec cx
		jne bucl_2

		add bx,320
		mov cx,13
		sub bx,cx
		dec dx
		jne bucl_2
		ret
		endp pintar_tecla_peque

;_________________________________________________________________

pintar_tecla_peque2 proc far	
		;cx=x,dx,y
		;20px largo 100 alto


		mov bx,0a000h	;zona que vamos a pintar
		mov es,bx 
		mov bx,0000h ;inicializar

		add bx,cx
	bucl_b:
		cmp dx,0
		je pin_t_2
		add bx,320
		dec dx
		jmp bucl_b

	pin_t_2:
		mov cx, 13 ;anchura
		mov dx, 11 ;altura
	bucl_22:
		mov es:[bx],al
		inc bx
		dec cx
		jne bucl_22

		add bx,320
		mov cx,13
		sub bx,cx
		dec dx
		jne bucl_22
		ret
		endp pintar_tecla_peque2

		
;_________________________________________________________________
;funcion que imprime una tecla blanca y su sombra

tecla_blanca proc far		;pinta una tecla blanca
	mov al,31 ;color 
	call pintar_tecla_grande

	mov dx,y1
	mov cx,x1
	add dx,80
	;inc cx
	mov al,29 ;color
	call pintar_tecla_mini_borde
	
	ret
	
endp tecla_blanca

;_________________________________________________________________
;funcion que imprime una tecla negra, con su sombra

tecla_negra proc far		;pinta una tecla negra
	mov al,21 ;color 
	mov x1,cx
	mov y1,dx
	call pintar_tecla_peque

	mov dx,y1
	mov cx,x1
	add dx,36
	mov al,0 ;color
	call pintar_tecla_mini
	
	ret
endp tecla_negra

;_________________________________________________________________
;funcion que imprime una tecla negra, con su sombra

tecla_pequena proc far		;pinta una tecla negra
	mov al,102;color 
	mov x1,cx
	mov y1,dx
	call pintar_tecla_peque2

	mov dx,y1
	mov cx,x1
	add dx,11
	mov al,78 ;color
	call pintar_tecla_mini
	
	ret
endp tecla_pequena



mod_tecla_pequena proc far		;pinta una tecla negra
	mov al,0 ;color 
	mov x1,cx
	mov y1,dx
	call pintar_tecla_peque2

	mov dx,y1
	mov cx,x1
	add dx,11
	mov al,102 ;color
	call pintar_tecla_peque2
	
	ret
endp mod_tecla_pequena


teclado_blanco proc far		;pinta el teclado negro
	
	mov cx,x1	; guardamos primra posoici
	mov dx,y1	;
	
	call tecla_blanca
	mov cx,x1
	mov dx,y1
	add cx, 26
	mov x1, cx
	
	
	mov ax,x2
	add ax, 1
	mov x2,ax
	
	cmp ax,8
	jne teclado_blanco 
	ret
endp teclado_blanco
;_________________________________________________________________
;funcion auxiliar con la que probamos y visualizamos todo el espectro de colores

colores proc far		;pinta en la primera linea de la pantalla todos los colores
	mov bx,0a000h	;zona que vamos a pintar
	mov es,bx 
	mov bx,0000h ;inicializar
	mov al,0
pint:
	mov es:[bx],al
	inc al
	inc bx
	cmp al,250
	jne pint
	ret
endp colores

teclado_negro proc far		;pinta el teclado negro
	
	mov cx,79	; guardamos primra posoici
	mov dx,34	;
	call tecla_negra
	mov cx,105	
	mov dx,34	
	call tecla_negra
	mov cx,157	
	mov dx,34	
	call tecla_negra
	mov cx,183	
	mov dx,34	
	call tecla_negra
	mov cx,209	
	mov dx,34	
	call tecla_negra
	ret
	
	
	
endp teclado_negro



teclado_pequeno proc far		;pinta el subteclado inferior
	
	mov cx,106	; guardamos primra posoici
	mov dx,159	;
	call tecla_pequena
	mov cx,120	
	mov dx,159	
	call tecla_pequena
	mov cx,134	
	mov dx,159	
	call tecla_pequena

	ret
	
	
	
endp teclado_pequeno


teclado_pequeno1 proc far		;pinta el subteclado inferior
	
	mov cx,176	
	mov dx,159	
	call tecla_pequena
	mov cx,190	
	mov dx,159	
	call tecla_pequena
	mov cx,204	
	mov dx,159	
	call tecla_pequena

	ret
	
	
	
endp teclado_pequeno1


;funcion actualiza el estado de cada tecla de ritmo y escala
actualiza_teclado_peque proc far
	cmp escala,'n'
	je pon_n
	cmp escala,'b'
	je pon_b
	cmp escala,'m'
	je pon_m
p_ritmo:
	cmp ritmo,'x'
	je pon_x
	cmp ritmo,'c'
	je pon_c
	cmp ritmo,'v'
	je pon_v
	
	ret
pon_n:
	call teclado_pequeno1
	mov cx,190
	mov dx,152
	call mod_tecla_pequena
	jmp p_ritmo
pon_b:
	call teclado_pequeno1
	mov cx,176
	mov dx,152
	call mod_tecla_pequena
	jmp p_ritmo
pon_m:
	call teclado_pequeno1
	mov cx,204
	mov dx,152
	call mod_tecla_pequena
	jmp p_ritmo
pon_x:
	call teclado_pequeno
	mov cx,106
	mov dx,152
	call mod_tecla_pequena
	ret
pon_c:
	call teclado_pequeno
	mov cx,120
	mov dx,152
	call mod_tecla_pequena
	ret
pon_v:
	call teclado_pequeno
	mov cx,134
	mov dx,152
	call mod_tecla_pequena
	ret

endp actualiza_teclado_peque



restaura_teclado proc far		;restaura al estado original el teclado blanco

	mov cx,60	
	mov dx,114
	mov al,29
	call pintar_tecla_mini_borde
	mov cx,86	
	mov dx,114
	call pintar_tecla_mini_borde
	mov cx,112	
	mov dx,114
	call pintar_tecla_mini_borde
	mov cx,138	
	mov dx,114
	call pintar_tecla_mini_borde
	mov cx,164	
	mov dx,114
	call pintar_tecla_mini_borde
	mov cx,190	
	mov dx,114
	call pintar_tecla_mini_borde
	mov cx,216	
	mov dx,114
	call pintar_tecla_mini_borde
	mov cx,242	
	mov dx,114
	call pintar_tecla_mini_borde
	ret

endp restaura_teclado


restaura_teclado_n proc far		;restaura al estado original el teclado negro

	mov cx,79	
	mov dx,70
	mov al,0
	call pintar_tecla_mini
	mov cx,157	
	mov dx,70
	call pintar_tecla_mini
	mov cx,183	
	mov dx,70
	call pintar_tecla_mini
	mov cx,209	
	mov dx,70
	call pintar_tecla_mini
	mov cx,105	
	mov dx,70
	call pintar_tecla_mini
	ret

endp restaura_teclado_n




;_________________________________________________________________
;_________________________________________________________________
; funcion pintar 
;
pintar proc far		;pinta el teclado blanco y luego el teclado negro
	mov cx,X0TECLADO
	mov x1,cx
	mov dx,34
	mov y1,dx
	mov ax,0
	mov x2,ax
	call teclado_blanco
	call teclado_negro
	call teclado_pequeno 
	mov ritmo,'c'
	mov escala,'n'
	call actualiza_teclado_peque
	call pinta_letras 
	
	;call colores ;muestra en la primera linea todos los colores
	
	
	ret

endp pintar
;_________________________________________________________________
; funcion activar modo Texto y modo Video
;AH = 0Fh      | Get Video Mode  | Devuelve en AL el modo de video     |
;|  Devuelve:    |                 | actual.                             |
;| AL = Modo
modoVideo proc far

	mov ah, 0fh
	int 10H
	mov modo[0], al
	
	mov ah, 0		;AH=0 init videoMOde
	mov al, 13h		;320x200
	int 10h			;
	ret
endp modoVideo


modoTexto proc far
	mov al,modo[0];restaura modo anterior

	mov ah, 0		;
	;mov al, 03h		;modo texto 
	int 10h			;
	ret
endp modoTexto


;==================================
;=     libreria del teclado		  =
;==================================
;_________________________________________________________________
; funcion que mira si hay tecla pulsada
; AL=0 si no hay tecla, 1 si hay tecla
HayTecla proc far
	mov  ah,0bh
	mov  al,0h
	int  21h
	ret
HayTecla endp

;_________________________________________________________________
; funcion que devuelve la tecla pulsada en al
; accede al buffer del teclado y devuelve la tecla pulsada
; si se pulsa una tecla extendida se devuelve 0x00, y luego 
; habra que volver a llamara la funcion para saber cual ha 
; sido la tecla pulsada
LeeTecla proc far
	;push dx
	mov  ah,06h
	mov  dl,0ffh
	int  21h
	;pop  dx
	ret
LeeTecla endp

;_________________________________________________________________
; funcion que espera a que se pulse una tecla
; momento en la que la devuelve en al
ObtenerTecla proc far
	mov ah,7	;comprueba si esta sonando algo, si nio esta sonando restaura el teclado a su estado inicial
	int 61h
	cmp  al,0 
	jne seguir   
	call restaura_teclado
	call restaura_teclado_n

seguir:
	call HayTecla
	cmp  al,0 
	je   obtenertecla; mientras no se presiones, 

	call leetecla
	ret
ObtenerTecla endp





;==================================
;=     libreria del sonido		  =
;==================================
;_________________________________________________________________
; funcion que comprueba si el driver esta ejecutandose y si es correcto

compruebadriver proc far
	
	
	mov ax, 0			;inicializamos ax
	mov es, ax			;le pasamos el valor 0
	mov bx, es:[184h]	;offset
	mov ax, es:[186h] 	;segmento
	add ax, bx 			;sumamos (los dos 0)
	cmp ax, 0 			;comprobamos que la suma es 0
	je  nodriver		;saltamos a no driver

	; paso 2
	mov ax, es:[186h] 	;recargamos segmento
	mov es, ax
	mov cx, es:[bx +3]	;sumamos 3
	cmp cx, 0cafeh		;comprobamos cafeh
	jne nodriver

	;paso 3
	mov ah,0
	int 61h
	cmp ax,0ee01h
	jne nodriver

	ret
	
nodriver: 

	mov dx, offset texto1	;texto a imprimir
	mov ah, 9              	;
	int 21h               	;llamada a la interrupcion del dos 21h

	;fin del programa y vuelta al dos
	
	mov ax,4c00h 
	int 21h
	
compruebadriver endp


;______________

ponerescala proc far
	
	
	cmp escala,al
	je no_modificar
	
	
	mov dl,al
	mov escala,al	; guardar escala actua
	
	cmp al,'b' 
	je poner_1
	
	cmp al,'n' 
	je poner_2
	
	cmp al,'m' 
	je poner_3
	
	jmp no_modificar		;para que no entre si quiere cambiar el ritmo
poner_1:
	call actualiza_teclado_peque
	mov al,1
	jmp cambiar

poner_2:
	call actualiza_teclado_peque
	mov al,2
	jmp cambiar

poner_3:
	call actualiza_teclado_peque
	mov al,3
	jmp cambiar
	
cambiar:
	mov ah,6	;cambiar escala
	int 61h ;
	mov al,dl
	
no_modificar:
	ret
	
endp ponerescala
;______________

ponerritmo proc far
	

	cmp ritmo,al
	je no_modificarr
	
	
	mov dl,al
	mov ritmo,al	; guardar ritmo actua
	
	cmp al,'x' 
	je ponerr_1
	
	cmp al,'c' 
	je ponerr_2
	
	cmp al,'v' 
	je ponerr_3

	jmp no_modificar		;para que no entre si quiere cambiar la escala

	
ponerr_1:
	call actualiza_teclado_peque
	mov al,1
	jmp cambiarr

ponerr_2:
	call actualiza_teclado_peque
	mov al,2
	jmp cambiarr

ponerr_3:
	call actualiza_teclado_peque
	mov al,3
	jmp cambiarr
	
cambiarr:
	
	mov ah,5	;cambiar ritmo
	int 61h ;
	mov al,dl
	
no_modificarr:
	ret
	
endp ponerritmo
;------------------------------------------

playnota2 proc far
	mov y2,ax
	call restaura_teclado
	call restaura_teclado_n
	mov ax,y2


comparar:	
	mov bx,0 ;inicializo
	cmp al,letras[bx] ;comparo al con letras indice
	je pintarnota
	inc bx
	
	cmp bx,13
	jne comparar
	
	
	call ponerescala
	call ponerritmo
	ret
	


pintarnota:
	mov cl,notas1[bx]	
	mov dl,notas2[bx]
	mov ch,0
	mov	dh,0
	mov al,colors[bx]
	
	cmp bx,2
	je pintar_sos
	cmp bx,4
	je pintar_sos
	cmp bx,7
	je pintar_sos
	cmp bx,9
	je pintar_sos
	cmp bx,11
	je pintar_sos
	
	jmp pintar_normal
	
	
	
pintar_sos:
	call pintar_tecla_mini
	mov al,notas[bx]
	jmp tocar
	
pintar_normal:	
	call pintar_tecla_mini_borde
	inc bx
	mov ax,bx
tocar:
	mov ah,2
	int 61h;
	ret


endp playnota2
;_________________________________________________________________
; funcion playnota
playnota proc far

	mov y2,ax
	call restaura_teclado
	call restaura_teclado_n
	mov ax,y2
	

	
	
	cmp al,'a' 
	je poner_do

	cmp al,'w' 
	je poner_do_sos
	
	cmp al,'s' 
	je poner_re
	
	cmp al,'e' 
	je poner_re_sos

	cmp al,'d' 
	je poner_mi
	
	cmp al,'f' 
	je poner_fa

	cmp al,'t' 
	je poner_fa_sos
	
	cmp al,'g' 
	je poner_sol
	
	cmp al,'y' 
	je poner_sol_sos
	cmp al,'h' 
	je poner_la
	
	cmp al,'u' 
	je poner_la_sos
	cmp al,'j' 
	je poner_si
	cmp al,'k' 
	je poner_do_1
	jmp noesnota
	
poner_do:
	mov cx,X0TECLADO	
	mov dx,110
	mov al,31
	call pintar_tecla_mini_borde
	mov al,1
	jmp play
poner_do_sos: 
	mov al,21 ;color
	mov cx,79	
	mov dx,68
	call pintar_tecla_mini
	mov al,2
	jmp play
poner_re:
	mov cx,X0TECLADO+26	
	mov dx,110
	mov al,31
	call pintar_tecla_mini_borde
	mov al,3
	jmp play
poner_re_sos: 
	mov al,21 ;color
	mov cx,105	
	mov dx,68
	call pintar_tecla_mini
	mov al,4
	jmp play
poner_mi:
	jmp poner_mi2
poner_fa:
	jmp poner_fa2
poner_fa_sos:
	mov al,21 ;color
	mov cx,157	
	mov dx,68
	call pintar_tecla_mini
	jmp poner_fa_sos2
poner_sol:
	jmp poner_sol2
poner_sol_sos:
	jmp poner_sol_sos2
poner_la:
	jmp poner_la2
poner_la_sos:
	jmp poner_la_sos2
poner_si:
	jmp poner_si2
poner_do_1:
	jmp poner_do_12
poner_mi2:
	mov cx,X0TECLADO+52	
	mov dx,110
	mov al,31
	call pintar_tecla_mini_borde
	mov al,5
	jmp play
poner_fa2:
	mov cx,X0TECLADO+78	
	mov dx,110
	mov al,31
	call pintar_tecla_mini_borde
	mov al,6
	jmp play
poner_fa_sos2:
	mov al,7
	jmp play
poner_sol2: 
	mov cx,X0TECLADO+104	
	mov dx,110
	mov al,31
	call pintar_tecla_mini_borde
	mov al,8
	jmp play
poner_sol_sos2: 
	mov al,21 ;color
	mov cx,183	
	mov dx,68
	call pintar_tecla_mini

	mov al,9
	jmp play	
poner_la2:
	mov cx,190	
	mov dx,110
	mov al,31
	call pintar_tecla_mini_borde
	mov al,10
	jmp play
poner_la_sos2:
	mov al,21 ;color
	mov cx,209	
	mov dx,68
	call pintar_tecla_mini
	mov al,11
	jmp play
poner_si2:
	mov cx,216	
	mov dx,110
	mov al,31
	call pintar_tecla_mini_borde
	mov al,12
	jmp play
poner_do_12:
	mov cx,242	
	mov dx,110
	mov al,31
	call pintar_tecla_mini_borde
	mov al,13
	jmp play
	
play:
	mov ah,2
	int 61h;
	ret
noesnota:
	call ponerescala
	call ponerritmo
	ret
	
	
endp playnota


	

libreria ends
		public actualiza_teclado_peque
		public	restaura_teclado_n
		public	restaura_teclado
		public	HayTecla
		public	ObtenerTecla
		public	CompruebaDriver
		public 	Pintar
		public	playnota
		public 	modotexto
		public	modovideo
		end
