print macro p1
pushear
mov ax,@data
mov ds, ax
mov ah,09h          ;Function(print string)
mov dx,offset p1         ;DX = String terminated by "$"
int 21h
popear           ;Interruptions DOS Functions
endm

printNum macro p1
pushear
xor bx,bx

mov ax,@data
mov ds, ax;LIMPIAMOS

mov al,p1

;=============Comparamos si es negativa o positiva================
mov bl,-1
cmp al,1
jg _imprimir_pos;=====Si es positiva no hacemos ningun cambio========
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
