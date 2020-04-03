print macro p1
pushear
mov ah,09h          ;Function(print string)
mov dx,offset p1         ;DX = String terminated by "$"
int 21h
popear           ;Interruptions DOS Functions
endm

multiplicar macro p1,p2
xor ax,ax
mov al,p1
mov bl,p2
imul bl
endm

dividir macro p1,p2
xor ax,ax
mov al,p1
mov bl,p2
idiv bl
endm

pixel macro x,y,color
push ax
push cx
push dx

mov ah,0ch
mov al,color
mov bh,0h
mov dx,y
mov cx,x
int 10h

pop dx
pop cx
pop ax
endm

getNumber macro buffer
LOCAL INICIO, FIN
xor si,si
INICIO:
call getchar
cmp al,0dh
je FIN
mov buffer[si],al
inc si
jmp INICIO
FIN:
mov buffer[si],00h
endm

pintarLineaHaciaAbajo macro x,y,tamanio
mov ax,tamanio
mov numero_a_imprimir,al
call printNum
endm

crearArchivo macro p1 ;macro para la creacion de archivo
pushear
mov ah,3ch
mov cx,0
mov dx,offset p1
int 21h
jc salir ;en case de un error
salir:
popear
endm

escribirEnArchivo macro p1,p2 ;macro para la creacion de archivo
pushear
;Escritura de archivo
mov cx,p2 ;num de caracteres a grabar
mov dx,offset p1
mov ah,40h
int 21h
popear
endm

convertirString macro buffer
LOCAL Dividir,Dividir2,FinCr3,NEGATIVO,FIN2,FIN
xor si,si
xor cx,cx
xor bx,bx
xor dx,dx
mov dl,0ah
test ax,1000000000000000
jnz NEGATIVO
jmp Dividir2

NEGATIVO:
neg ax
mov buffer[si],45
inc si
jmp Dividir2

Dividir:
xor ah,ah
Dividir2:
div dl
inc cx
push ax
cmp al,00h
je FinCr3
jmp Dividir

FinCr3:
pop ax
add ah,30h
mov buffer[si],ah
inc si
Loop FinCr3
mov ah,24h
mov buffer[si],ah
inc si
FIN:
endm

convertirAscii macro numero
LOCAL INICIO,FIN
push cx
push si

xor ax,ax
xor bx,bx
xor cx,cx
mov bx,10
xor si,si
INICIO:
mov cl,numero[si]
cmp cl,48
jl FIN
cmp cl,57
jg FIN
inc si
sub cl,48
mul bx
add ax,cx
jmp INICIO
FIN:
pop si
pop cx
endm

leerArchivo macro p1
LOCAL fin,leer
pushear
xor si,si

mov ah,3dh
mov al,0 ;indicar que se abre archivo en lectura
mov dx,offset p1
int 21h
mov handler,ax
jc error1

leer:
mov ah,3fh
mov bx,handler
mov cx,1
lea dx,textoInicial[si]
int 21h
cmp textoInicial[si],59
je fin
inc si
jmp leer

error1:
print errorNoAbre
mov ah,3eh
mov bx,handler
int 21h
jmp final_final

fin:
  mov ah,3eh
  mov bx,handler
  int 21h
  ejecutarDivision textoInicial

final_final:
popear
endm

ejecutarDivision macro operacion
LOCAL vino_fin,vino_esp,ultima_cmp,escribirResultado,segundo_dig_primer_num_esp,primer_dig_primer_num,segundo_dig_primer_num,fin,espacio_blanco,primer_dig_segundo_num,segundo_dig_segundo_num,operador_num,espacio_blanco_2,espacio_o_fin
;pushear
xor si,si;limpiamos el indice
xor ax,ax
xor cx,cx

primer_dig_primer_num:

mov al,operacion[si]
cmp al,30h
je segundo_dig_primer_num
cmp al,31h
je segundo_dig_primer_num
cmp al,32h
je segundo_dig_primer_num
cmp al,33h
je segundo_dig_primer_num
cmp al,34h
je segundo_dig_primer_num
cmp al,35h
je segundo_dig_primer_num
cmp al,36h
je segundo_dig_primer_num
cmp al,37h
je segundo_dig_primer_num
cmp al,38h
je segundo_dig_primer_num
cmp al,39h
je segundo_dig_primer_num
cmp al,00h
je segundo_dig_primer_num_esp
mov caracInv[21],al
print caracInv
jmp fin

segundo_dig_primer_num_esp:
mov al,30h

segundo_dig_primer_num:
inc si
mov al,operacion[si]
cmp al,30h
je espacio_blanco
cmp al,31h
je espacio_blanco
cmp al,32h
je espacio_blanco
cmp al,33h
je espacio_blanco
cmp al,34h
je espacio_blanco
cmp al,35h
je espacio_blanco
cmp al,36h
je espacio_blanco
cmp al,37h
je espacio_blanco
cmp al,38h
je espacio_blanco
cmp al,39h
je espacio_blanco

mov caracInv[21],al
print caracInv
jmp fin

espacio_blanco:

inc si
mov al,operacion[si]
cmp al,32
je operador_num
mov caracInv[21],al
print caracInv
jmp fin

operador_num:
inc si
mov al,operacion[si]
cmp al,43
je espacio_blanco_2
cmp al,45
je espacio_blanco_2
cmp al,42
je espacio_blanco_2
cmp al,47
je espacio_blanco_2
mov caracInv[21],al
print caracInv
jmp fin

espacio_blanco_2:
mov operadorAct,al

inc si
mov al,operacion[si]
cmp al,20h
je primer_dig_segundo_num
mov caracInv[21],al
print caracInv
jmp fin

primer_dig_segundo_num:
inc si
mov al,operacion[si]
cmp al,30h
je segundo_dig_segundo_num
cmp al,31h
je segundo_dig_segundo_num
cmp al,32h
je segundo_dig_segundo_num
cmp al,33h
je segundo_dig_segundo_num
cmp al,34h
je segundo_dig_segundo_num
cmp al,35h
je segundo_dig_segundo_num
cmp al,36h
je segundo_dig_segundo_num
cmp al,37h
je segundo_dig_segundo_num
cmp al,38h
je segundo_dig_segundo_num
cmp al,39h
je segundo_dig_segundo_num
mov caracInv[21],al
print caracInv
jmp fin

segundo_dig_segundo_num:

inc si
mov al,operacion[si]
cmp al,30h
je espacio_o_fin
cmp al,31h
je espacio_o_fin
cmp al,32h
je espacio_o_fin
cmp al,33h
je espacio_o_fin
cmp al,34h
je espacio_o_fin
cmp al,35h
je espacio_o_fin
cmp al,36h
je espacio_o_fin
cmp al,37h
je espacio_o_fin
cmp al,38h
je espacio_o_fin
cmp al,39h
je espacio_o_fin
mov caracInv[21],al
print caracInv
jmp fin

espacio_o_fin:

ultima_cmp:

inc si
mov bl,operacion[si]
cmp bl,20h
je vino_esp
cmp bl,59
je vino_fin
print faltFin
jmp fin

vino_esp:

dec si
dec si
jmp primer_dig_primer_num

vino_fin:
inc bx
mov al,numeroSec[0]
mov textoFinal[bx],al
inc bx
mov al,numeroSec[1]
mov textoFinal[bx],al
inc bx
mov al,59
mov textoFinal[bx],al

fin:

;popear
endm

pushear macro
  push ax
  push bx
  push cx
  push dx
  push si
  push di
endm

popear macro
  pop di
  pop si
  pop dx
  pop cx
  pop bx
  pop ax
endm
