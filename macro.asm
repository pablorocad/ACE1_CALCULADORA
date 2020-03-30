print macro p1
pushear
mov ax,@data
mov ds, ax
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
