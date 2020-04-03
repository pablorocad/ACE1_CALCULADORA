include macro.asm

.model small
.stack 100h
.data

inicio db 0ah,0dh,'UNIVERSIDAD DE SAN CARLOS DE GUATEMALA',0ah,0dh,'FACULTAD DE INGENIERIA',0ah,0dh,'ESCUELA CIENCIAS Y SISTEMAS',0ah,0dh,'ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1 A',0ah,0dh,'PRIMER SEMESTRE 2020',0ah,0dh,'PABLO ANDRES ROCA DOMINGUEZ',0ah,0dh,'CARNET: 201700584',0ah,0dh,'QUINTA PRACTICA',0ah,0dh,'$' ;caracter "$" para finalizar cadenas;
menuTexto db 0ah,0dh,'1) Ingresar funcion f(x)',0ah,0dh,'2) Funcion en memoria',0ah,0dh,'3) Derivada f',27h,'(x)',0ah,0dh,'4) Integral F(x)',0ah,0dh,'5) Graficar funciones',0ah,0dh,'6) Reporte',0ah,0dh,'7) Modo calculadora',0ah,0dh,'8) Salir',0ah,0dh,'opcion: ', '$'
pathArchivoSalida db 'pra5.txt',0
pathArchivoEntrada db 'op.arq',0
;==================REPORTE================
masgReporte db 'REPORTE PRACTICA No. 5',0ah,0dh
fechaHora db 'Fecha:00/00/2000',0ah,0dh,'Hora: 00:00:00',0ah,0dh
msgOriginal db 'Funcion Original',0ah,0dh
msgDerivada db 'Funcion Derivada',0ah,0dh
msgIntegral db 'Funcion Integral',0ah,0dh
;=============INGRESAR FUNCION============
msgCoeficiente db 0ah,0dh,'Coeficiente de x',0,': ','$'
minus db ' - ','$'
max db ' + ','$'
numSig db 1
numTemp db 0
;============Mostrar funciones=====
msgFx db 0ah,0dh,'f(x) = ','$'
msgFderx db 0ah,0dh,'f',27h,'(x) = ','$'
msgFintx db 0ah,0dh,'F(x) = ','$'
val5 db '*x5','$'
val4 db '*x4','$'
val3 db '*x3','$'
val2 db '*x2','$'
val1 db '*x','$'
signoDiv db '/','$'
masC db ' + c','$'
cinco db '5','$'
cuatro db '4','$'
tres db '3','$'
dos db '2','$'

msgFxTxt db 'f(x) = '
msgFderxTxt db 'f',27h,'(x) = '
msgFintxTxt db 'F(x) = '
val5Txt db '*x5'
val4Txt db '*x4'
val3Txt db '*x3'
val2Txt db '*x2'
val1Txt db '*x'
signoDivTxt db '/'
masCTxt db ' + c'
cincoTxt db '5'
cuatroTxt db '4'
tresTxt db '3'
dosTxt db '2'
minusTxt db ' - '
maxTxt db ' + '
salto db 0ah,0dh

signo_a_escribir db 0
numero_a_escribir db 0
numero_a_imprimir db 0
;=============GRAFICAR============
menuGraficar db 0ah,0dh,'1) Graficar original f(x)',0ah,0dh,'2) Graficar derivada f',27h,'(x)',0ah,0dh,'3) Graficar integral F(x)',0ah,0dh,'4) Regresar',0ah,0dh,'opcion: ', '$'
valorInicial db 0ah,0dh,'Ingrese valor inicial del intervalo: ','$'
valorFinal db 0ah,0dh,'Ingrese valor final del intervalo: ','$'
valorFx dw 0
valorX dw 0
_minimo dw 0
_maximo dw 0
_pot dw 1
base dw 0
exp db 0
valorAnteriorFx dw 0
FxActual dw 0
;=============ARREGLOS============
;Funcion normal
fun db 0,0,0,0,0
;Funcion derivada
fun_der db 0,0,0,0
;Funcion integrada
fun_int db 0,0,0,0,0

;=============CALCULADORA=========
textoInicial db 100 dup('$'),'$'
textoFinal db 100 dup('$'),'$'

numeroPri db 2 dup('$'),'$'
numeroSec db 2 dup('$'),'$'
operadorAct db 0
handler dw ?

caracInv db 0ah,0dh,'Caracter invalido: ',0,'$'
faltFin db 0ah,0dh,'Falto caracter de finalizacion (;)','$'
buffer db 0
numAux db 100 dup('$'),'$'
ingRuta db 0ah,0dh,'Ingrese ruta del archivo: ','$'
rutaMat db 50 dup('$'),'$'
rutaMatTemp db 50 dup('$'),'$'
errorNoAbre db 0ah,0dh,'La ruta no existe',0ah,0dh,'$'
errorExt db 0ah,0dh,'La extension de archivo es incorrecta','$'
errorSigno db 0ah,0dh,'Hace falta el signo # en la ruta',0ah,0dh,'$'

.code
;====================================================================
;=================================INICIO=============================
;====================================================================
main  proc
mov ax,@data
mov ds, ax;LIMPIAMOS
print inicio

menuPrincipal:
print menuTexto
call getchar

cmp al,31h
  je ingresarFuncion
cmp al,32h
  je funcionEnMemoria
cmp al,33h
  je mostrarDerivada
cmp al,34h
  je mostrarIntegral
cmp al,35h
  je graficar
cmp al,36h
  je reporte
cmp al,37h
  je modoCalculadora
cmp al,38h
  je salir

jmp menuPrincipal

  ;====================================================================
  ;=========================INGRESAR FUNCION===========================
  ;====================================================================
ingresarFuncion:
pushear

xor bx,bx;limpiamos bx
mov cx,5
mov bx,4
bucle_ingresarFunc:

push bx
add bl,30h
mov msgCoeficiente[18],bl
print msgCoeficiente
pop bx

call getchar

;==========VEMOS SI HAY SIGNO Y CUAL==========
_neg:
cmp al,2dh;'-'
jne _pos
mov numSig,-1
jmp _coeficiente

_pos:
cmp al,2bh;'+'
jne _entero
mov numSig,1
jmp _coeficiente

_entero:;====SI SOLO VIENE NUMERO====
sub al,30h
mov fun[bx],al
;printNum fun[bx]
jmp _fin_bucle_ingresarFunc

_coeficiente:;====AQUI PREGUNTA EL COEFICIENTE====
call getchar
push bx
mov bl,numSig
sub al,30h
imul bl
pop bx
mov fun[bx],al

_fin_bucle_ingresarFunc:
dec bx
dec cx
cmp cx,0
jne bucle_ingresarFunc

call derivarFuncion
call integrarFuncion

popear
jmp menuPrincipal

;====================================================================
;=========================MOSTRAR =FUNCION===========================
;====================================================================
funcionEnMemoria:
call mostrar_funcionEnMemoria
;call mostrar_funcionEnMemoriaTxt
jmp menuPrincipal

;====================================================================
;=========================MOSTRAR DERIVADA===========================
;====================================================================
mostrarDerivada:
call mostrar_funcionDerivada
jmp menuPrincipal

;====================================================================
;=========================MOSTRAR INTEGRAL===========================
;====================================================================
mostrarIntegral:
call mostrar_funcionIntegrada
jmp menuPrincipal

;====================================================================
;============================GRAFICAR================================
;====================================================================
graficar:
print menuGraficar
call getchar
cmp al,31h
  je graficarFuncionNormal
cmp al,32h
  je graficarFuncionDerivada
cmp al,33h
  je graficarFuncionIntegrada
cmp al,34h
  je menuPrincipal

jmp graficar
;====================================================================
;======================GRAFICA NORMAL================================
;====================================================================
graficarFuncionNormal:
call intervalos
mov ax,0013h
int 10h

call graficarEjes
call _graficarFuncionNormal
;pixel 134,80,31h

;Presione una tecla para salir
mov ah,10h
int 16h

;Regresar al modo texto
mov ax,0003h
int 10h
jmp graficar

graficarFuncionDerivada:
call intervalos
mov ax,0013h
int 10h

call graficarEjes
call _graficarFuncionDerivada

;Presione una tecla para salir
mov ah,10h
int 16h

;Regresar al modo texto
mov ax,0003h
int 10h
jmp graficar

graficarFuncionIntegrada:
call intervalos
mov ax,0013h
int 10h

call graficarEjes
call _graficarFuncionIntegrada

;Presione una tecla para salir
mov ah,10h
int 16h

;Regresar al modo texto
mov ax,0003h
int 10h
jmp graficar

jmp menuPrincipal

;====================================================================
;=============================REPORTE================================
;====================================================================
reporte:
lea bx,fechaHora
call GetDate
call GetTime
call reporteFinal
jmp menuPrincipal

;====================================================================
;============================CALCULADORA=============================
;====================================================================
modoCalculadora:
print ingRuta
getNumber rutaMatTemp

xor si,si
xor bx,bx
mov bx,-1
mov si,-1

inc si
mov al,rutaMatTemp[si]
cmp al,35
jne error3

inc si
mov al,rutaMatTemp[si]
cmp al,35
jne error3

bucle_leer_path:
inc si
inc bx
mov al,rutaMatTemp[si]
mov rutaMat[bx],al
cmp al,46
jne bucle_leer_path
a:
inc si
inc bx
mov al,rutaMatTemp[si]
mov rutaMat[bx],al
cmp al,97
je r
jne error2

r:
inc si
inc bx
mov al,rutaMatTemp[si]
mov rutaMat[bx],al
cmp al,114
je q
jne error2

q:
inc si
inc bx
mov al,rutaMatTemp[si]
mov rutaMat[bx],al
cmp al,113
jne error2
inc bx
mov rutaMat[bx],00h
inc bx
mov rutaMat[bx],36

inc si
mov al,rutaMatTemp[si]
cmp al,35
jne error3

inc si
mov al,rutaMatTemp[si]
cmp al,35
jne error3

;print rutaMat
leerArchivo rutaMat
;ejecutarDivision textoInicial

jmp salir_calcu

error2:
print errorExt
jmp modoCalculadora

error3:
print errorSigno
jmp modoCalculadora

salir_calcu:
jmp menuPrincipal

  salir:
    mov ah,4ch       ;Function (Quit with exit code (EXIT))
    xor al,al
    int 21h

main endp


getchar proc near
mov ah,01h
int 21h
ret
getchar endp


intervalos proc near
pushear
print valorInicial
call getchar

;==========VEMOS SI HAY SIGNO Y CUAL==========
_neg:
cmp al,2dh;'-'
jne _pos
mov numSig,-1
jmp _primerNum

_pos:
cmp al,2bh;'+'
jne _entero
mov numSig,1
jmp _primerNum

_entero:
push bx
mov bl,numSig
sub al,30h
imul bl
pop bx
mov _minimo,ax
jmp _val_final

_primerNum:;====SI SOLO VIENE NUMERO====
call getchar
push bx
mov bl,numSig
sub al,30h
imul bl
pop bx
mov _minimo,ax
;jmp _fin_bucle_ingresarInicial

print valorFinal
call getchar

cmp al,2dh;'-'
jne _pos_f
mov numSig,-1
jmp _segundoNum

_pos_f:
cmp al,2bh;'+'
jne _entero_s
mov numSig,1
jmp _segundoNum

_entero_s:
push bx
mov bl,numSig
sub al,30h
imul bl
pop bx
mov _maximo,ax
jmp _val_final

_segundoNum:;====AQUI PREGUNTA EL COEFICIENTE====
call getchar
push bx
mov bl,numSig
sub al,30h
imul bl
pop bx
mov _maximo,ax

_val_final:
popear
ret
intervalos endp

;====================================================================
;=========================DERIVAR FUNCION============================
;====================================================================
derivarFuncion proc near
pushear

push ax
multiplicar fun[4],4
mov fun_der[3],al

multiplicar fun[3],3
mov fun_der[2],al

multiplicar fun[2],2
mov fun_der[1],al

multiplicar fun[1],1
mov fun_der[0],al
pop ax

popear
ret
derivarFuncion endp

;====================================================================
;=========================INTEGRAR FUNCION===========================
;====================================================================
integrarFuncion proc near
pushear

mov al,fun[4]
cmp al,0
je pos3

dividir fun[4],5
cmp al,0
jne pos3
mov al,1
pos3:
mov fun_int[4],al

mov al,fun[3]
cmp al,0
je pos2

dividir fun[3],4
cmp al,0
jne pos2
mov al,1
pos2:
mov fun_int[3],al

mov al,fun[2]
cmp al,0
je pos1

dividir fun[2],3
cmp al,0
jne pos1
mov al,1
pos1:
mov fun_int[2],al

mov al,fun[1]
cmp al,0
je pos0

dividir fun[1],2
cmp al,0
jne pos0
mov al,1
pos0:
mov fun_int[1],al

mov al,fun[0]
mov fun_int[0],al

popear
ret
integrarFuncion endp

;====================================================================
;=========================MOSTRAR FUNCION============================
;====================================================================
mostrar_funcionEnMemoria proc near
crearArchivo pathArchivoSalida
pushear

;abrir el archivo
mov ah,3dh
mov al,1h ;Abrimos el archivo en solo escritura.
mov dx,offset pathArchivoSalida
int 21h
;jc salir ;Si hubo error
mov bx,ax ; mover hadfile

escribirEnArchivo msgFxTxt,SIZEOF msgFxTxt
print msgFx

mov ah,fun[4]
cmp ah,0
je v3
mov numero_a_imprimir,ah
call printNum
print val4
escribirEnArchivo signo_a_escribir,SIZEOF signo_a_escribir
escribirEnArchivo numero_a_escribir,SIZEOF numero_a_escribir
escribirEnArchivo val4Txt,SIZEOF val4Txt

v3:
mov ah,fun[3]
cmp ah,0
je v2
mov numero_a_imprimir,ah
call printNum
print val3
escribirEnArchivo signo_a_escribir,SIZEOF signo_a_escribir
escribirEnArchivo numero_a_escribir,SIZEOF numero_a_escribir
escribirEnArchivo val3Txt,SIZEOF val3Txt

v2:
mov ah,fun[2]
cmp ah,0
je v1
mov numero_a_imprimir,ah
call printNum
print val2
escribirEnArchivo signo_a_escribir,SIZEOF signo_a_escribir
escribirEnArchivo numero_a_escribir,SIZEOF numero_a_escribir
escribirEnArchivo val2Txt,SIZEOF val2Txt

v1:
mov ah,fun[1]
cmp ah,0
je v0
mov numero_a_imprimir,ah
call printNum
print val1
escribirEnArchivo signo_a_escribir,SIZEOF signo_a_escribir
escribirEnArchivo numero_a_escribir,SIZEOF numero_a_escribir
escribirEnArchivo val1Txt,SIZEOF val1Txt

v0:
mov ah,fun[0]
cmp ah,0
je fin_proceso
mov numero_a_imprimir,ah
call printNum
escribirEnArchivo signo_a_escribir,SIZEOF signo_a_escribir
escribirEnArchivo numero_a_escribir,SIZEOF numero_a_escribir

fin_proceso:
mov ah,3eh  ;Cierre de archivo
int 21h

popear
ret
mostrar_funcionEnMemoria endp

;====================================================================
;=========================MOSTRAR DERIVADA============================
;====================================================================
mostrar_funcionDerivada proc near
crearArchivo pathArchivoSalida
pushear

;abrir el archivo
mov ah,3dh
mov al,1h ;Abrimos el archivo en solo escritura.
mov dx,offset pathArchivoSalida
int 21h
;jc salir ;Si hubo error
mov bx,ax ; mover hadfile

escribirEnArchivo msgFderxTxt,SIZEOF msgFderxTxt
print msgFderx

v3:
mov ah,fun_der[3]
cmp ah,0
je v2
mov numero_a_imprimir,ah
call printNum
print val3
escribirEnArchivo signo_a_escribir,SIZEOF signo_a_escribir
escribirEnArchivo numero_a_escribir,SIZEOF numero_a_escribir
escribirEnArchivo val3Txt,SIZEOF val3Txt

v2:
mov ah,fun_der[2]
cmp ah,0
je v1
mov numero_a_imprimir,ah
call printNum
print val2
escribirEnArchivo signo_a_escribir,SIZEOF signo_a_escribir
escribirEnArchivo numero_a_escribir,SIZEOF numero_a_escribir
escribirEnArchivo val2Txt,SIZEOF val2Txt

v1:
mov ah,fun_der[1]
cmp ah,0
je v0
mov numero_a_imprimir,ah
call printNum
print val1
escribirEnArchivo signo_a_escribir,SIZEOF signo_a_escribir
escribirEnArchivo numero_a_escribir,SIZEOF numero_a_escribir
escribirEnArchivo val1Txt,SIZEOF val1Txt

v0:
mov ah,fun_der[0]
cmp ah,0
je fin_proceso
mov numero_a_imprimir,ah
call printNum
escribirEnArchivo signo_a_escribir,SIZEOF signo_a_escribir
escribirEnArchivo numero_a_escribir,SIZEOF numero_a_escribir

fin_proceso:
mov ah,3eh  ;Cierre de archivo
int 21h
popear
ret
mostrar_funcionDerivada endp

;====================================================================
;=========================MOSTRAR INTEGRAL===========================
;====================================================================
mostrar_funcionIntegrada proc near
crearArchivo pathArchivoSalida
pushear

;abrir el archivo
mov ah,3dh
mov al,1h ;Abrimos el archivo en solo escritura.
mov dx,offset pathArchivoSalida
int 21h
;jc salir ;Si hubo error
mov bx,ax ; mover hadfile

escribirEnArchivo msgFintxTxt,SIZEOF msgFintxTxt
print msgFintx

mov ah,fun[4]
cmp ah,0
je v3
mov numero_a_imprimir,ah
call printNum
print signoDiv
print cinco
print val5
escribirEnArchivo signo_a_escribir,SIZEOF signo_a_escribir
escribirEnArchivo numero_a_escribir,SIZEOF numero_a_escribir
escribirEnArchivo signoDivTxt,SIZEOF signoDivTxt
escribirEnArchivo cincoTxt,SIZEOF cincoTxt
escribirEnArchivo val5Txt,SIZEOF val5Txt

v3:
mov ah,fun[3]
cmp ah,0
je v2
mov numero_a_imprimir,ah
call printNum
print signoDiv
print cuatro
print val4
escribirEnArchivo signo_a_escribir,SIZEOF signo_a_escribir
escribirEnArchivo numero_a_escribir,SIZEOF numero_a_escribir
escribirEnArchivo signoDivTxt,SIZEOF signoDivTxt
escribirEnArchivo cuatroTxt,SIZEOF cuatroTxt
escribirEnArchivo val4Txt,SIZEOF val4Txt

v2:
mov ah,fun[2]
cmp ah,0
je v1
mov numero_a_imprimir,ah
call printNum
print signoDiv
print tres
print val3
escribirEnArchivo signo_a_escribir,SIZEOF signo_a_escribir
escribirEnArchivo numero_a_escribir,SIZEOF numero_a_escribir
escribirEnArchivo signoDivTxt,SIZEOF signoDivTxt
escribirEnArchivo tresTxt,SIZEOF tresTxt
escribirEnArchivo val3Txt,SIZEOF val3Txt

v1:
mov ah,fun[1]
cmp ah,0
je v0
mov numero_a_imprimir,ah
call printNum
print signoDiv
print dos
print val2
escribirEnArchivo signo_a_escribir,SIZEOF signo_a_escribir
escribirEnArchivo numero_a_escribir,SIZEOF numero_a_escribir
escribirEnArchivo signoDivTxt,SIZEOF signoDivTxt
escribirEnArchivo dosTxt,SIZEOF dosTxt
escribirEnArchivo val2Txt,SIZEOF val2Txt

v0:
mov ah,fun[0]
cmp ah,0
je fin_proceso
mov numero_a_imprimir,ah
call printNum
print val1
escribirEnArchivo signo_a_escribir,SIZEOF signo_a_escribir
escribirEnArchivo numero_a_escribir,SIZEOF numero_a_escribir
escribirEnArchivo val1Txt,SIZEOF val1Txt

fin_proceso:
print masC
escribirEnArchivo masCTxt,SIZEOF masCTxt
mov ah,3eh  ;Cierre de archivo
int 21h
popear
ret
mostrar_funcionIntegrada endp

;====================================================================
;===========================REPORTE==================================
;====================================================================
reporteFinal proc near
crearArchivo pathArchivoSalida
pushear

;abrir el archivo
mov ah,3dh
mov al,1h ;Abrimos el archivo en solo escritura.
mov dx,offset pathArchivoSalida
int 21h
;jc salir ;Si hubo error
mov bx,ax ; mover hadfile

escribirEnArchivo inicio,SIZEOF inicio
escribirEnArchivo masgReporte,SIZEOF masgReporte
escribirEnArchivo fechaHora,SIZEOF fechaHora

escribirEnArchivo msgOriginal,SIZEOF msgOriginal

escribirEnArchivo msgFxTxt,SIZEOF msgFxTxt
print msgFx

mov ah,fun[4]
cmp ah,0
je v3_o
mov numero_a_imprimir,ah
call printNum
print val4
escribirEnArchivo signo_a_escribir,SIZEOF signo_a_escribir
escribirEnArchivo numero_a_escribir,SIZEOF numero_a_escribir
escribirEnArchivo val4Txt,SIZEOF val4Txt

v3_o:
mov ah,fun[3]
cmp ah,0
je v2_o
mov numero_a_imprimir,ah
call printNum
print val3
escribirEnArchivo signo_a_escribir,SIZEOF signo_a_escribir
escribirEnArchivo numero_a_escribir,SIZEOF numero_a_escribir
escribirEnArchivo val3Txt,SIZEOF val3Txt

v2_o:
mov ah,fun[2]
cmp ah,0
je v1_o
mov numero_a_imprimir,ah
call printNum
print val2
escribirEnArchivo signo_a_escribir,SIZEOF signo_a_escribir
escribirEnArchivo numero_a_escribir,SIZEOF numero_a_escribir
escribirEnArchivo val2Txt,SIZEOF val2Txt

v1_o:
mov ah,fun[1]
cmp ah,0
je v0_o
mov numero_a_imprimir,ah
call printNum
print val1
escribirEnArchivo signo_a_escribir,SIZEOF signo_a_escribir
escribirEnArchivo numero_a_escribir,SIZEOF numero_a_escribir
escribirEnArchivo val1Txt,SIZEOF val1Txt

v0_o:
mov ah,fun[0]
cmp ah,0
je fin_proceso_fx
mov numero_a_imprimir,ah
call printNum
escribirEnArchivo signo_a_escribir,SIZEOF signo_a_escribir
escribirEnArchivo numero_a_escribir,SIZEOF numero_a_escribir

escribirEnArchivo salto,SIZEOF salto
escribirEnArchivo salto,SIZEOF salto

fin_proceso_fx:
escribirEnArchivo msgDerivada,SIZEOF msgDerivada
escribirEnArchivo msgFderxTxt,SIZEOF msgFderxTxt
print msgFderx

v3_d:
mov ah,fun_der[3]
cmp ah,0
je v2_d
mov numero_a_imprimir,ah
call printNum
print val3
escribirEnArchivo signo_a_escribir,SIZEOF signo_a_escribir
escribirEnArchivo numero_a_escribir,SIZEOF numero_a_escribir
escribirEnArchivo val3Txt,SIZEOF val3Txt

v2_d:
mov ah,fun_der[2]
cmp ah,0
je v1_d
mov numero_a_imprimir,ah
call printNum
print val2
escribirEnArchivo signo_a_escribir,SIZEOF signo_a_escribir
escribirEnArchivo numero_a_escribir,SIZEOF numero_a_escribir
escribirEnArchivo val2Txt,SIZEOF val2Txt

v1_d:
mov ah,fun_der[1]
cmp ah,0
je v0_d
mov numero_a_imprimir,ah
call printNum
print val1
escribirEnArchivo signo_a_escribir,SIZEOF signo_a_escribir
escribirEnArchivo numero_a_escribir,SIZEOF numero_a_escribir
escribirEnArchivo val1Txt,SIZEOF val1Txt

v0_d:
mov ah,fun_der[0]
cmp ah,0
je fin_proceso_fpx
mov numero_a_imprimir,ah
call printNum
escribirEnArchivo signo_a_escribir,SIZEOF signo_a_escribir
escribirEnArchivo numero_a_escribir,SIZEOF numero_a_escribir

escribirEnArchivo salto,SIZEOF salto
escribirEnArchivo salto,SIZEOF salto
fin_proceso_fpx:

escribirEnArchivo msgIntegral,SIZEOF msgIntegral
escribirEnArchivo msgFintxTxt,SIZEOF msgFintxTxt
print msgFintx

mov ah,fun[4]
cmp ah,0
je v3
mov numero_a_imprimir,ah
call printNum
print signoDiv
print cinco
print val5
escribirEnArchivo signo_a_escribir,SIZEOF signo_a_escribir
escribirEnArchivo numero_a_escribir,SIZEOF numero_a_escribir
escribirEnArchivo signoDivTxt,SIZEOF signoDivTxt
escribirEnArchivo cincoTxt,SIZEOF cincoTxt
escribirEnArchivo val5Txt,SIZEOF val5Txt

v3:
mov ah,fun[3]
cmp ah,0
je v2
mov numero_a_imprimir,ah
call printNum
print signoDiv
print cuatro
print val4
escribirEnArchivo signo_a_escribir,SIZEOF signo_a_escribir
escribirEnArchivo numero_a_escribir,SIZEOF numero_a_escribir
escribirEnArchivo signoDivTxt,SIZEOF signoDivTxt
escribirEnArchivo cuatroTxt,SIZEOF cuatroTxt
escribirEnArchivo val4Txt,SIZEOF val4Txt

v2:
mov ah,fun[2]
cmp ah,0
je v1
mov numero_a_imprimir,ah
call printNum
print signoDiv
print tres
print val3
escribirEnArchivo signo_a_escribir,SIZEOF signo_a_escribir
escribirEnArchivo numero_a_escribir,SIZEOF numero_a_escribir
escribirEnArchivo signoDivTxt,SIZEOF signoDivTxt
escribirEnArchivo tresTxt,SIZEOF tresTxt
escribirEnArchivo val3Txt,SIZEOF val3Txt

v1:
mov ah,fun[1]
cmp ah,0
je v0
mov numero_a_imprimir,ah
call printNum
print signoDiv
print dos
print val2
escribirEnArchivo signo_a_escribir,SIZEOF signo_a_escribir
escribirEnArchivo numero_a_escribir,SIZEOF numero_a_escribir
escribirEnArchivo signoDivTxt,SIZEOF signoDivTxt
escribirEnArchivo dosTxt,SIZEOF dosTxt
escribirEnArchivo val2Txt,SIZEOF val2Txt

v0:
mov ah,fun[0]
cmp ah,0
je fin_proceso
mov numero_a_imprimir,ah
call printNum
print val1
escribirEnArchivo signo_a_escribir,SIZEOF signo_a_escribir
escribirEnArchivo numero_a_escribir,SIZEOF numero_a_escribir
escribirEnArchivo val1Txt,SIZEOF val1Txt

fin_proceso:
print masC
escribirEnArchivo masCTxt,SIZEOF masCTxt
mov ah,3eh  ;Cierre de archivo
int 21h
popear
ret
reporteFinal endp

;====================================================================
;===========================GRAFICAR==================================
;====================================================================
printNum proc near
pushear

mov al,numero_a_imprimir

;=============Comparamos si es negativa o positiva================
mov bl,-1
cmp al,1
jg _imprimir_pos;=====Si es positiva no hacemos ningun cambio========
je _imprimir_pos
imul bl;=Si es negativa convertimos a positiva e imprimimos signo======
print minus
mov signo_a_escribir,45
jmp _imprimir_num

_imprimir_pos:
print max
mov signo_a_escribir,43

_imprimir_num:
xor bx,bx

;mov al,p1
aam
mov bx,ax

;===========decenas
cmp bh,0
je unidades

decenas:
mov ah,02h
mov dl,bh
add dl,30h
int 21h

;==========unidades
unidades:
cmp bl,0
je fin

mov ah,02h
mov dl,bl
add dl,30h
int 21h
mov numero_a_escribir,dl

fin:
popear
ret
printNum endp

potencia proc near
push cx
push bx
mov _pot,1

xor cx,cx
xor bx,bx
xor ax,ax

mov cl,exp
pot:
mov ax,base
mov bx,_pot
  imul bx
xor ah,ah
mov _pot,ax
Loop pot

pop bx
pop cx
ret
potencia endp

;====================================================================
;=============================GRAFICAR EJES==========================
;====================================================================
graficarEjes proc near
mov cx,13eh;dibujar eje x 318
eje_x:
pixel cx,05fh,01
Loop eje_x

;dibujar eje de las y 198
mov cx,0c8h
eje_y:
pixel 09fh,cx,01
Loop eje_y
ret
graficarEjes endp

;====================================================================
;=============================GRAFICAR fx============================
;====================================================================
_graficarFuncionNormal proc near
mov ax,_maximo
inc ax
mov _maximo,ax

mov cx,_minimo
grafo:
push cx

;==========X4=========
;mov valorX,cx
mov base,cx
mov exp,4
call potencia
mov bl,fun[4]
imul bl
mov valorFx,ax

;==========X3=========
;mov valorX,cx
mov base,cx
mov exp,3
call potencia
mov bl,fun[3]
imul bl
add ax,valorFx
mov valorFx,ax

;==========X2=========
;mov valorX,cx
mov base,cx
mov exp,2
call potencia
mov bl,fun[2]
imul bl
add ax,valorFx
mov valorFx,ax

;==========X1=========
mov ax,cx
mov bl,fun[1]
imul bl
add ax,valorFx
mov valorFx,ax

;==========X0=========
mov ax,1
mov bl,fun[0]
imul bl
add ax,valorFx
;mov valorFx,ax

;==========PUNTO=============
mov dx,cx;guardamos el valor actual de cx
add cx,09fh;valor en x
mov valorX,cx

mov bl,-1;valor en y
imul bl
add ax,05fh
mov valorFx,ax
pixel valorX,valorFx,10

;==========Pintar vacios=============
pushear

cmp dx,_minimo
je final_bucle
xor cx,cx
mov cx,valorAnteriorFx
sub cx,ax
;mov numero_a_imprimir,cl
;call printNum

mov ax,valorFx
pintar_vacio:
mov FxActual,ax
pixel valorX,FxActual,10

mov bx,valorAnteriorFx
cmp bx,ax
ja ant_es_mayor
jb ant_es_menor

ant_es_menor:
mov ax,FxActual
sub ax,1
jmp fin_loop_vacio

ant_es_mayor:
mov ax,FxActual
add ax,1

fin_loop_vacio:
Loop pintar_vacio

final_bucle:
popear
;====================================

;pintarLineaHaciaAbajo valorX,valorFx,dh
mov valorAnteriorFx,ax
pop cx
inc cx
cmp cx,_maximo
jne grafo

mov ax,_maximo
dec ax
mov _maximo,ax

ret
_graficarFuncionNormal endp

;====================================================================
;=============================GRAFICAR f'x===========================
;====================================================================
_graficarFuncionDerivada proc near
mov ax,_maximo
inc ax
mov _maximo,ax

mov cx,_minimo
grafo:
push cx

;==========X3=========
;mov valorX,cx
mov base,cx
mov exp,3
call potencia
mov bl,fun_der[3]
imul bl
mov valorFx,ax

;==========X2=========
;mov valorX,cx
mov base,cx
mov exp,2
call potencia
mov bl,fun_der[2]
imul bl
add ax,valorFx
mov valorFx,ax

;==========X1=========
mov ax,cx
mov bl,fun_der[1]
imul bl
add ax,valorFx
mov valorFx,ax

;==========X0=========
mov ax,1
mov bl,fun_der[0]
imul bl
add ax,valorFx
;mov valorFx,ax

mov dx,cx;guardamos el valor actual de cx
add cx,09fh;valor en x
mov valorX,cx

mov bl,-1;valor en y
imul bl
add ax,05fh
mov valorFx,ax
pixel valorX,valorFx,10

;==========Pintar vacios=============
pushear

cmp dx,_minimo
je final_bucle
xor cx,cx
mov cx,valorAnteriorFx
sub cx,ax
;mov numero_a_imprimir,cl
;call printNum

mov ax,valorFx
pintar_vacio:
mov FxActual,ax
pixel valorX,FxActual,10

mov bx,valorAnteriorFx
cmp bx,ax
ja ant_es_mayor
jb ant_es_menor

ant_es_menor:
mov ax,FxActual
sub ax,1
jmp fin_loop_vacio

ant_es_mayor:
mov ax,FxActual
add ax,1

fin_loop_vacio:
Loop pintar_vacio

final_bucle:
popear
;====================================

;pintarLineaHaciaAbajo valorX,valorFx,dh
mov valorAnteriorFx,ax
pop cx
inc cx
cmp cx,_maximo
jne grafo

mov ax,_maximo
dec ax
mov _maximo,ax

ret
_graficarFuncionDerivada endp

;====================================================================
;=============================GRAFICAR Fx============================
;====================================================================
_graficarFuncionIntegrada proc near
mov ax,_maximo
inc ax
mov _maximo,ax

mov cx,_minimo
grafo:
push cx

;==========X5=========
;mov valorX,cx
mov base,cx
mov exp,5
call potencia
mov bl,fun_int[4]
imul bl
mov valorFx,ax

;==========X4=========
;mov valorX,cx
mov base,cx
mov exp,4
call potencia
mov bl,fun_int[3]
imul bl
add ax,valorFx
mov valorFx,ax

;==========X3=========
;mov valorX,cx
mov base,cx
mov exp,3
call potencia
mov bl,fun_int[2]
imul bl
add ax,valorFx
mov valorFx,ax

;==========X2=========
;mov valorX,cx
mov base,cx
mov exp,2
call potencia
mov bl,fun_int[1]
imul bl
add ax,valorFx
mov valorFx,ax

;==========X1=========
mov ax,cx
mov bl,fun_int[0]
imul bl
add ax,valorFx
mov valorFx,ax

mov dx,cx;guardamos el valor actual de cx
add cx,09fh;valor en x
mov valorX,cx

mov bl,-1;valor en y
imul bl
add ax,05fh
mov valorFx,ax
pixel valorX,valorFx,10

;==========Pintar vacios=============
pushear

cmp dx,_minimo
je final_bucle
xor cx,cx
mov cx,valorAnteriorFx
sub cx,ax
;mov numero_a_imprimir,cl
;call printNum

mov ax,valorFx
pintar_vacio:
mov FxActual,ax
pixel valorX,FxActual,10

mov bx,valorAnteriorFx
cmp bx,ax
ja ant_es_mayor
jb ant_es_menor

ant_es_menor:
mov ax,FxActual
sub ax,1
jmp fin_loop_vacio

ant_es_mayor:
mov ax,FxActual
add ax,1

fin_loop_vacio:
Loop pintar_vacio

final_bucle:
popear
;====================================

;pintarLineaHaciaAbajo valorX,valorFx,dh
mov valorAnteriorFx,ax
pop cx
inc cx
cmp cx,_maximo
jne grafo

mov ax,_maximo
dec ax
mov _maximo,ax

ret
_graficarFuncionIntegrada endp
;====================================================================
;===========================FECHA Y HORA=============================
;====================================================================
GetDate proc near
    mov ah,2ah
    int 21h

    mov al,dl
    call convert
    mov [bx + 6],ax

    mov al,dh
    call convert
    mov [bx + 9],ax

    mov ah,2ah
    int 21h
    add cx,0F830H
    mov ax,cx
    aam
    mov cx,ax

    call Disp
    ret
GetDate endp

GetTime proc near
    mov ah,2ch
    int 21h

    mov al,ch
    call Convert
    mov [bx + 24],ax

    mov al,cl
    call convert
    mov [bx+27],ax

    mov al,dh
    call convert
    mov [bx+30],ax

    ret
GetTime endp

Convert proc near
    mov ah,0
    mov dl,10
    div dl
    or ax,3030h
    ret
Convert endp

disp proc near
    MOV dl,ch      ; Since the values are in BX, BH Part
    ADD dl,30h    ; ASCII Adjustment
    mov [bx+14],dl

    MOV dl,cl      ; BL Part
    ADD dl,30h     ; ASCII Adjustment
    mov [bx+15],dl
    RET
disp endp      ; End Disp Procedure

;====================================================================
;=================================FINAL==============================
;====================================================================
end
