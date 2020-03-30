include macro.asm

.model small
.stack 100h
.data

inicio db 0ah,0dh,'UNIVERSIDAD DE SAN CARLOS DE GUATEMALA',0ah,0dh,'FACULTAD DE INGENIERIA',0ah,0dh,'ESCUELA CIENCIAS Y SISTEMAS',0ah,0dh,'ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1 A',0ah,0dh,'PRIMER SEMESTRE 2020',0ah,0dh,'PABLO ANDR',90h,'S ROCA DOMINGUEZ',0ah,0dh,'CARNET: 201700584',0ah,0dh,'QUINTA PRACTICA',0ah,0dh,'$' ;caracter "$" para finalizar cadenas;
menuTexto db 0ah,0dh,'1) Ingresar funcion f(x)',0ah,0dh,'2) Funcion en memoria',0ah,0dh,'3) Derivada f',27h,'(x)',0ah,0dh,'4) Integral F(x)',0ah,0dh,'5) Graficar funciones',0ah,0dh,'6) Reporte',0ah,0dh,'7) Modo calculadora',0ah,0dh,'8) Salir',0ah,0dh,'opcion: ', '$'
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
val4 db '*x4','$'
val3 db '*x3','$'
val2 db '*x2','$'
val1 db '*x','$'
numero_a_imprimir db 0
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

popear
jmp menuPrincipal

;====================================================================
;=========================MOSTRAR =FUNCION===========================
;====================================================================
funcionEnMemoria:
call mostrar_funcionEnMemoria
jmp menuPrincipal

;====================================================================
;=========================MOSTRAR DERIVADA===========================
;====================================================================
mostrarDerivada:
jmp menuPrincipal

;====================================================================
;=========================MOSTRAR INTEGRAL===========================
;====================================================================
mostrarIntegral:
jmp menuPrincipal

;====================================================================
;============================GRAFICAR================================
;====================================================================
graficar:
jmp menuPrincipal

;====================================================================
;=============================REPORTE================================
;====================================================================
reporte:
jmp menuPrincipal

;====================================================================
;============================CALCULADORA=============================
;====================================================================
modoCalculadora:
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
;=========================MOSTRAR FUNCION============================
;====================================================================
mostrar_funcionEnMemoria proc near
pushear

print msgFx

mov ah,fun[4]
cmp ah,0
je v3
mov numero_a_imprimir,ah
call printNum
print val4

v3:
mov ah,fun[3]
cmp ah,0
je v2
mov numero_a_imprimir,ah
call printNum
print val3

v2:
mov ah,fun[2]
cmp ah,0
je v1
mov numero_a_imprimir,ah
call printNum
print val2

v1:
mov ah,fun[1]
cmp ah,0
je v0
mov numero_a_imprimir,ah
call printNum
print val1

v0:
mov ah,fun[0]
cmp ah,0
je fin_proceso
mov numero_a_imprimir,ah
call printNum

fin_proceso:
popear
ret
mostrar_funcionEnMemoria endp

printNum proc near
pushear

mov ax,@data
mov ds, ax;LIMPIAMOS

mov al,numero_a_imprimir

;=============Comparamos si es negativa o positiva================
mov bl,-1
cmp al,1
jg _imprimir_pos;=====Si es positiva no hacemos ningun cambio========
je _imprimir_pos
imul bl;=Si es negativa convertimos a positiva e imprimimos signo======
print minus
jmp _imprimir_num

_imprimir_pos:
print max

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

fin:
popear
ret
printNum endp
;====================================================================
;=================================FINAL==============================
;====================================================================
end
