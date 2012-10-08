# makefile

# 3a08p1.exe: 3a08p1.obj libreria.lib 
#	TLINK /V  3a08p1.obj libreria.lib
all: 1b08p2.obj graficos.lib sonido.lib teclado.lib driver.obj
	TLINK /V  1b08p2.obj graficos.lib sonido.lib teclado.lib
	TLINK /t /V driver.obj
	
driver.com: driver.obj 
	TLINK /t /V  driver.obj 

prueba: prueba.obj
	TLINK /V prueba.obj
	
.asm.obj: 
	TASM /ZI $<

.obj.lib:
	TLIB $&.lib -+$<

clean:
	del *.obj
	del *.map
	del *.exe
	del *.lib
	del *.bak