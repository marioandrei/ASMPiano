;/---------------------------------------------/
;/ practicas de etc-ii                    uam  /
;/ ignacio sainz-trapaga	mario pantoja	  /
;/ etc-ii                                      /
;/ practica 2                                  /
;/---------------------------------------------/
extrn actualiza_teclado_peque
extrn CompruebaDriver:far
extrn ObtenerTecla:far
extrn Pintar:far
extrn modoTexto:far
extrn modoVideo:far
extrn playnota:far
extrn playnota2:far
extrn HayTecla:far
extrn restaura_teclado:far
extrn restaura_teclado_n:far
 ;_______________________________________________________________
; definicion del segmento de datos 

datos segment

datos ends ;fin del segmento de datos
;_______________________________________________________________
; segmento de pila
pila segment stack "stack"
	db 400h dup (0)
pila ends
;_______________________________________________________________
; definicion del segmento de codigo
code segment 
assume cs:code;,ds:datos
;_______________________________________________________________
;comienzo del procedimiento principal (start)
start proc far

;_______________________________________________________________
;inicializacion de los registros de segmento
mov ax,datos 
mov ds,ax

;_______________________________________________________________
;______ comprobacion driver_________________________________

	call compruebadriver
	
	call modoVideo
	
	call pintar
bucle:
	;call actualiza_teclado_peque
	call ObtenerTecla ;en Al esta tecla presionada
	
	;segun lo que se capturo en obtenertecla en AL se toca esa nota o se sale si es x
	call playnota
	
	cmp al,'z'	; si es z salimos
	je fin  
	
	jmp bucle

;_______________________________________________________________
;	fin de programa
fin:
	;volver al modo texto, pero recuperando el valor anterior guardado en mem
	call modotexto
	
	;desactivar driver
	mov ah, 1
	int 61h

	;fin del programa y vuelta al dos
	mov ax,4c00h
	int 21h

start endp ;fin del procedimiento start

code ends  ;fin del segmento de codigo

end start  ;fin del programa

