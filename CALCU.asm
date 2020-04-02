include macro.asm

.model small
.stack 100h
.data

inicio db 0ah,0dh,'UNIVERSIDAD DE SAN CARLOS DE GUATEMALA',0ah,0dh,'FACULTAD DE INGENIERIA',0ah,0dh,'ESCUELA CIENCIAS Y SISTEMAS',0ah,0dh,'ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1 A',0ah,0dh,'PRIMER SEMESTRE 2020',0ah,0dh,'PABLO ANDR',90h,'S ROCA DOMINGUEZ',0ah,0dh,'CARNET: 201700584',0ah,0dh,'QUINTA PRACTICA',0ah,0dh,'$' ;caracter "$" para finalizar cadenas;
menuTexto db 0ah,0dh,'1) Ingresar funcion f(x)',0ah,0dh,'2) Funcion en memoria',0ah,0dh,'3) Derivada f',27h,'(x)',0ah,0dh,'4) Integral F(x)',0ah,0dh,'5) Graficar funciones',0ah,0dh,'6) Reporte',0ah,0dh,'7) Modo calculadora',0ah,0dh,'8) Salir',0ah,0dh,'opcion: ', '$'
pathArchivoSalida db 'pra5.txt',0
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
valorFx dw 0
valorX dw 0
_minimo dw -3
_maximo dw 3
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
call _graficarFuncionNormal
jmp menuPrincipal

;====================================================================
;============================CALCULADORA=============================
;====================================================================
modoCalculadora:
mov al,fun_int[4]
mov numero_a_imprimir,al
call printNum

mov al,fun_int[3]
mov numero_a_imprimir,al
call printNum

mov al,fun_int[2]
mov numero_a_imprimir,al
call printNum

mov al,fun_int[1]
mov numero_a_imprimir,al
call printNum

mov al,fun_int[0]
mov numero_a_imprimir,al
call printNum
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
pixel cx,5fh,7fh
Loop eje_x

;dibujar eje de las y 198
mov cx,0c6h
eje_y:
pixel 9fh,cx,7fh
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
add cx,9fh;valor en x
mov valorX,cx

mov bl,-1;valor en y
imul bl
add ax,5fh
mov valorFx,ax
pixel valorX,valorFx,31h

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
pixel valorX,FxActual,31h

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
add cx,9fh;valor en x
mov valorX,cx

mov bl,-1;valor en y
imul bl
add ax,5fh
mov valorFx,ax
pixel valorX,valorFx,31h

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
pixel valorX,FxActual,31h

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
add cx,9fh;valor en x
mov valorX,cx

mov bl,-1;valor en y
imul bl
add ax,5fh
mov valorFx,ax
pixel valorX,valorFx,31h

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
pixel valorX,FxActual,31h

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
;=================================FINAL==============================
;====================================================================
end
