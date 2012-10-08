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
; segmento de pila
pila segment stack "stack"
	db 400h dup (0)
pila ends

;_________________________________________________________________
;definicion del segmento de codigo
graficos segment BYTE PUBLIC 'CODE'
	assume cs:graficos, ds:datos, ss:pila


;==================================
;=     libreria de graficos 	 =
;==================================

;_________________________________________________________________

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
	push ax
	mov ax,datos
	mov dx,ax
	
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
	
	pop ax
	ret

endp pintar
;_________________________________________________________________
; funciones que activan y deactivan modo Video
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




graficos ends
		public modoTexto
		public modoVideo
		public pintar
		public restaura_teclado_n
		public restaura_teclado
		public actualiza_teclado_peque
		public pintar_tecla_mini_borde
		public pintar_tecla_mini
		end