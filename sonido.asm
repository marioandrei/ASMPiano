;==================================
;=     libreria del sonido        =
;==================================


extrn restaura_teclado_n:far
extrn restaura_teclado:far
extrn actualiza_teclado_peque:far
extrn pintar_tecla_mini_borde:far
extrn pintar_tecla_mini:far

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
;___________________________________________________
;definicion del segmento de codigo
sonidolib segment byte public 'CODE'
	assume cs:sonidolib, ds:datos
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
	mov al,4
	jmp cambiar

poner_2:
	call actualiza_teclado_peque
	mov al,2
	jmp cambiar

poner_3:
	call actualiza_teclado_peque
	mov al,1
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
	push bx cx
	push ax 
	call restaura_teclado
	call restaura_teclado_n
	pop ax


comparar:	
	mov bx,0 ;inicializo
	mov cl,letras[bx]
	cmp al,cl ;comparo al con letras indice
	je pintarnota
	inc bx
	
	cmp bx,13
	jne comparar
	
	
	call ponerescala
	call ponerritmo
	pop bx
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
	pop cx bx
	ret


endp playnota2
;_________________________________________________________________
; funcion playnota
;funcion que comparar lo que hay en al(capturado en obtener tecla)
;para que suene
playnota proc far
	
	push ax
	call restaura_teclado
	call restaura_teclado_n
	pop ax
	

	
	
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


	


sonidolib ends
		public	CompruebaDriver
		public	playnota
		public	playnota2
		public	ponerescala
		public	ponerritmo
		END

