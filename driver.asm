serv  	equ 0ee01h  ; codigo que indentifica al driver
errn  	equ 0ffh
video 	equ 0b800h   ; posicion de memoria donde empieza el modo 80x25
ok 		equ 00h

;notas, ritmo y escalas
ndo 		equ		0a1h
ndo2 		equ		23h
ndos		equ		0a1h
ndo2s		equ		21h
nre			equ		0beh
nre2		equ		1fh
nres		equ		0f6h
nre2s		equ		1dh
nmi			equ		047h
nmi2		equ		1ch
nfa			equ		0b1h
nfa2		equ		1ah
nfas		equ		031h
nfa2s		equ		19h
nsol		equ		0c7h
nsol2		equ		17h
nsols		equ		072h
nsol2s		equ		16h
nla			equ		02fh
nla2		equ		15h
nlas		equ		0ffh
nla2s		equ		13h
nsi			equ		0dfh
nsi2		equ		12h

ritmo1		equ 	000ffh
ritmo2		equ		00fffh
ritmo3		equ		0ffffh

escala3     equ		1h
escala4     equ     2h
escala5		equ		4h

;------------------------------------------------------------------------
code segment
assume ss:code, es:code, cs:code, ds:code

	; El ORG 100H es necesario para generar programas .COM ya que
	; la zona de memoria anterior es ocupada por el PSP
	org	100h

start:
	jmp instalar
	
;------------------------------------------------------------------------
; Funciones RTC
;------------------------------------------------------------------------

; Funcion que configura el periodo del RTC
config_rtc proc far
        push ax
        cli

        ; configuro pic
        in    al,021h
        and   al, 0fbh
        out   021h, al   ; pongo a 0 bit 2 puerto 21h
        in    al,0a1h
        and   al, 0feh
        out   0a1h, al   ; pongo a 0 bit 0 puerto a1h

        ; configuro la frecuencia
        mov   al, 0ah
        out   070h,al
        mov   al,02fh   ; 0010-xxxx
        out   071h,al

        sti
        pop ax
        ret
config_rtc endp

; Activa las interrupciones del RTC
start_rtc proc far
        push ax
        cli

        ; activo interrupcion pie
        mov   al, 0bh
        out   070h,al
        in    al,071h
        or    al,040h
        and   al,047h
        mov   ah,al
        mov   al,0bh
        out   070h,al
        mov   al,ah
        out   071h,al
        mov   al, 0ch   ; necesario para activar las interrupciones
        out   070h,al
        in    al,071h

        sti
        pop   ax
        ret
start_rtc endp


; desactiva las interrupciones del rtc
stop_rtc proc far
        push ax
        cli

        ; desactivo interrupcion pie
        mov   al, 0bh
        out   070h,al
        in    al,071h
        and   al,0bfh
        mov   ah,al
        mov   al,0bh
        out   070h,al
        mov   al, ah
        out   071h,al
        mov   al, 0ch
        out   070h,al
        in    al,071h

        sti
        pop   ax
        ret

stop_rtc endp

;------------------------------------------------------------------------
;. Rutina de servicio de la interrupcion 1CH (pos en tabla 70H)
;------------------------------------------------------------------------
serv70_int proc far
	cli
	push ax bx es ds dx

	mov  ax,cs
	mov  ds,ax

	; compruebo que ha sido el pie quien ha interrumpido
	mov  al, 0ch
	out  070h,al
	in   al,071h
	and  al,040h
	jnz  pi_int
	jmp  salir	
	
	;------------------------------------------------------------------------
	;-  codigo de mi rutina de interrupcion:
	;-     rota un caracter en la pantalla
	;------------------------------------------------------------------------
	pi_int:
		add numero,1
	  
		mov  ax,video
		mov  es,ax      ; es apunta a la memoria de video
		mov  bx, cont   ; bx contiene el estado del puntero a la tabla
		inc  bx
		cmp  bx,4     ; ¨hemos superado el final tabla ?
		jne  sigue     ; no -> apunta al carater que corresponda
		mov  bx,0      ; si -> apunta al primer caracter

; pinta el caracter en la esquina superior izquierda
	sigue:
		mov  al, tabla[bx+0]
		mov  byte ptr es:[09eh],al
		; devuelve el control
		mov  word ptr cont,bx
		

	;---------------------------------------------------------
	;- fin de mi codigo de la rutina de interrupcion
	;---------------------------------------------------------

	salir:   ;  necesario para terminar correctamente la interrrupcion
		mov  al, 020h   ; cargo eoi
		out  020h, al   ; mando eoi al pic maestro
		out  0a0h, al   ; mando eoi al pic esclavo

		pop  dx ds es bx ax
		sti
		iret

serv70_int endp
	
;----------------------------
;. SERVICIO AH=0 Comprobación del DRIVER    .
;. E - AH=0 Comprobacion del driver 
;. S - AX=0xEE01H                         
;----------------------------
status proc
	mov  ax, serv
	iret
endp status
	
;----------------------------
;. SERVICIO AH=1 Desinstalar el driver .
;. E - AH=1 Desinstalar .
;. S - AH=OK .
;----------------------------
desinstalar proc
	call stop_rtc

	cli ;inhabilito interrupciones

	
	;restaurar los valores originales

	xor ax,ax
	mov es,ax 	;nos vamos a las interrupciones

	mov ax, cs:mem		;devuelvo el anterior offset guardado
    mov word ptr es:[061h*4], ax  		

	mov ax, cs:mem2		;devuelvo el anterior segmento guardado
    mov word ptr es:[061h*4+2], ax	

	;mov ax, cs:offset_70			;devuelvo el anterior offset guardado
    ;mov word ptr es:[070h*4], ax  		

;	mov ax, cs:segmen_70			;devuelvo el anterior segmento guardado
;    mov word ptr es:[070h*4+2], ax		
	
	;mov ax, cs:offset_1c			;devuelvo el anterior offset guardado
    ;mov word ptr es:[01ch*4], ax  		

	;mov ax, cs:segmen_1c			;devuelvo el anterior segmento guardado
    ;mov word ptr es:[01ch*4+2], ax	
	
	;liberar segmento de entorno y psp (2ch)
	
	;liberar la memoria de segmento de entorno y el driver. acabar devolviendo el control a dos

	mov es, cs:[2ch] 	;segmento de entorno, cs apunta al psp

	mov ah, 49h 		;funcion para liberar de memoria
	int 21h				;en es debe estar el segmento a liberar
			
	mov ax, cs
	mov es, ax

	mov ah, 49h 		;funcion para liberar de memoria
	int 21h
	
	sti			;rehabilito interrupciones

	mov ah,ok	
	iret

endp desinstalar

;----------------------------
;. SERVICIO AH=2 Play Nota .
;. E - AH=2 Play .
;. E - AL=Nota a tocar (Ver tabla) .
;. S - AH=ERRN (fuera tamaño o no disponible).
;. S - AH=OK .
;----------------------------

playnota proc far 
	mov numero, 0
	
	mov bx,ax ;guardo ax temporalmente
		
	in al, 61h ; activa
	or al, 11b
	out 61h, al

	mov al,10110110b   ;configura
	out 43h, al
	
	mov ax,bx ;restauro valor anterior
	
	escala=escala3
	
	call playnot ; hace sonar la frecuencia


	;------------------------------------------------
		mov ax,0h
	bucle1:
		inc ax
		cmp ax, ritmo_a 
		jne bucle1
		;-----------------------
		mov ax,0h
	bucle2:
		inc ax
		cmp ax, ritmo_a 
		jne bucle2
	;-----------------------
		mov ax,0h
	bucle3:
		inc ax
		cmp numero, 128
		jne bucle3

	;
	;
	;
	;

	;desactiva altavoz
	in al, 61h
	and al, 11111100b
	out 61h, al
	call stop_rtc
	
	iret


playnota endp
;------------------------------------------------------------------------
;playnot es un playnota aux
;------------------------------------------------------------------------

playnot proc
		cmp al,1
		je nota_1
		cmp al,2
		je nota_2	
		cmp al,3
		je nota_3
		cmp al,4
		je nota_4
		cmp al,5
		je nota_5
		cmp al,6
		je nota_6
		cmp al,7
		je nota_7
		cmp al,8
		je nota_8
		cmp al,9
		je nota_9
		cmp al,10
		je nota_10
		cmp al,11
		je nota_11
		cmp al,12
		je nota_12
		cmp al,13
		je nota_13
		ret
	nota_1:
		mov al,ndo/escala
		out 42h,al
		mov al,ndo2/escala
		out 42h,al
		ret
	nota_2:
		mov al,ndos/escala 
		out 42h,al
		mov al,ndo2s/escala
		out 42h,al	
		ret	
	nota_3:
		mov al,nre/escala 
		out 42h,al
		mov al,nre2/escala
		out 42h,al
		ret	
	nota_4:
		mov al,nres/escala 
		out 42h,al
		mov al,nre2s/escala
		out 42h,al
		ret	
	nota_5:
		mov al,nmi /escala
		out 42h,al
		mov al,nmi2/escala
		out 42h,al
		ret
	nota_6:
		mov al,nfa /escala
		out 42h,al
		mov al,nfa2s/escala
		out 42h,al
		ret
	nota_7:
		mov al,nfas /escala
		out 42h,al
		mov al,nfa2s/escala
		out 42h,al
		ret
	nota_8:
		mov al,nsol /escala
		out 42h,al
		mov al,nsol2/escala
		out 42h,al
		ret
	nota_9:
		mov al,nsols/escala
		out 42h,al
		mov al,nsol2s/escala
		out 42h,al
		ret
	nota_10:
		mov al,nla/escala
		out 42h,al
		mov al,nla2/escala
		out 42h,al
		ret
	nota_11:
		mov al,nlas/escala
		out 42h,al
		mov al,nla2s/escala
		out 42h,al
		ret
	nota_12:
		mov al,nsi /escala
		out 42h,al
		mov al,nsi2/escala
		out 42h,al
		ret
	nota_13:
		mov al,ndo/escala
		out 42h,al
		mov al,ndo2*2h/escala
		out 42h,al
		ret

playnot endp

;----------------------------
;. SERVICIO AH=3 Play Nota .
;. E - AH=3 Play Frecuencia .
;. E - CX = 1.193.180 / (frec nota Hz) .
;----------------------------

;----------------------------
;. SERVICIO AH=4 Stop .
;. E - AH=4 Stop .
;----------------------------
stop proc far
	in al, 61h
	and al, 11111100b
	out 61h, al
stop endp
;----------------------------
;. SERVICIO AH=5 Ritmo. Tiempo que dura la nota .
;. E - AH=5 Ritmo .
;. E - AL= 1 lento ,2 normal ,3 rápido .
;----------------------------
set_ritmo proc far

	cmp al,1
	jne r1
	mov bx, ritmo1
	mov ritmo_a, bx
	jmp fn
r1:
	cmp al,2
	jne r2
	mov bx, ritmo2
	mov ritmo_a, bx
	jmp fn
r2:
	cmp al,3
	jne fn
	mov bx, ritmo3
	mov ritmo_a, bx
fn:
	iret
set_ritmo endp

;----------------------------
;. SERVICIO AH=6 Escala .
;. E - AH=6 Escala .
;. E - AL= 1 baja, 2 normal, 4 superior .
;----------------------------
set_escala proc far
baja:	
	cmp al,1
	jne normal
	mov escala_a, 1h
	jmp lol
normal:
	cmp al,2
	jne superior
	mov escala_a, 2h
	jmp lol
superior:
	cmp al,3
	jne lol
	mov escala_a, 4h
lol:	
	iret
	
set_escala endp
;----------------------------
;. SERVICIO AH=7 Estado .
;. E - AH=7 Estado .
;. S - AL= 1 sonando, AL=0 parado .
;----------------------------
estado proc far
	mov ah, 0
	cmp ah, numero
	je parado
	mov al,1 ;sonando si hay algo en contarodr
	jmp retorno
parado:
	mov al,0
retorno:
	iret
estado endp

;--------------------------------------------------------
;		Programa Principal del Driver
;--------------------------------------------------------
driver proc far
	jmp next
	; chequeo extra driver
	dw   0cafeh
	;contenido anterior de la tabla de interrupciones
	mem		dw	0 ;offset del driver
	mem2 	dw	0 ;segmento del driver

	frecuencia db 	0fh ;
	
	tabla      db  	02fh, 07ch, 05ch, 02dh;
	cont       dw	0
	
	dir_base    dw 	0
	numero	db	0
	
	ritmo_a 	dw 	0ffffh
	escala_a 	dw 	04h
	
	
next:
	cmp  ah, 0
	jne opc_1
	jmp  status
opc_1:
	cmp  ah, 1
	jne opc_2
	jmp desinstalar
opc_2:
	cmp  ah, 2
	jne opc_3
	jmp playnota
opc_3:
	cmp ah, 5
	jne opc_4
	jmp set_ritmo
opc_4:
	cmp ah, 6
	jne   opc_5
;	call set_escala
opc_5:
	; error en llamada a funcion
	mov  ah, errn
	iret
endp driver
instalar proc
	;---------------------------------------------------------
	; rtc: Instalo El Vector De Interrupcion 70H  (Pos 1C0H)
	;---------------------------------------------------------

	xor ax,ax
	mov es,ax
	
	; configuro el rtc
	call config_rtc
	call start_rtc

	; pongo los nuevos
	; hago que apunte a la subrutina 'serv70_int'
	cli
	
	mov  word ptr es:[01c0h],offset serv70_int
	mov  word ptr es:[01c2h],cs

	sti
	
	;------------------------------------------------------------------
	; Instalacion Del Driver de sonido
	;------------------------------------------------------------------

	cli
	
	xor ax,ax ;inicializamos ax
	mov es,ax

	mov ax, offset driver ;etiqueta desde donde se dejara residente.
	mov bx,cs
	
	; actualizo tabla interrupciones para colocar la 61h
	; guardo los valores iniciales
	mov dx, word ptr es:[061h*4]
	mov mem, dx
	mov dx, word ptr es:[061h*4+2]
	mov mem2, dx
	
	; pongo el nuevo valor apuntando al trozo de programa que queremos que se ejecute al 
	; llamar a la interrupcion (driver)
	mov es:[061h*4], ax
	mov es:[061h*4+2], bx
	

	sti
	
	mov dx,	offset instalar ;deja residente el codigo hasta etiqueta instalar
	int 27h
	

instalar endp

code	ends
		end start
