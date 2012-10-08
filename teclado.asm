;==================================
;=     libreria del teclado      =
;==================================
extrn restaura_teclado:far
extrn restaura_teclado_n:far
;_________________________________________________________________
;definicion del segmento de codigo
tecladolib segment BYTE PUBLIC 'CODE'
	assume cs:tecladolib

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

;_________________________________________________________________
tecladolib ends
		public  ObtenerTecla
		end
