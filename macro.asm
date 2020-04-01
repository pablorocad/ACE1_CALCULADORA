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

pintarLineaHaciaAbajo macro x,y,tamanio
mov ax,tamanio
mov numero_a_imprimir,al
call printNum
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
