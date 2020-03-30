include macro.asm

.model small
.stack 100h
.data

inicio db 0ah,0dh,'UNIVERSIDAD DE SAN CARLOS DE GUATEMALA',0ah,0dh,'FACULTAD DE INGENIERIA',0ah,0dh,'ESCUELA CIENCIAS Y SISTEMAS',0ah,0dh,'ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1 A',0ah,0dh,'PRIMER SEMESTRE 2020',0ah,0dh,'PABLO ANDR',90h,'S ROCA DOMINGUEZ',0ah,0dh,'CARNET: 201700584',0ah,0dh,'QUINTA PRACTICA',0ah,0dh,'$' ;caracter "$" para finalizar cadenas;
menuTexto db 0ah,0dh,'1) Ingresar funcion f(x)',0ah,0dh,'2) Funcion en memoria',0ah,0dh,'3) Derivada f',27h,'(x)',0ah,0dh,'4) Integral F(x)',0ah,0dh,'5) Graficar funciones',0ah,0dh,'6) Reporte',0ah,0dh,'7) Modo calculadora',0ah,0dh,'8) Salir',0ah,0dh,'opcion: ', '$'
;=============INGRESAR FUNCION============
msgCoeficiente db 0ah,0dh,'Coeficiente de x',0,': ','$'
minus db '-','$'
max db '+','$'
numSig db 1
numTemp db 0
;============Mostrar funciones=====
msgFun db 0ah,0dh,'f(x) = ','$'
;=============ARREGLOS============
;Funcion normal
fun db 0,0,0,0,0,'$'
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
printNum fun[3]
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
;=================================FINAL==============================
;====================================================================
end
