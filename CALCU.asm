include macro.asm

.model small
.stack 100h
.data

inicio db 0ah,0dh,'UNIVERSIDAD DE SAN CARLOS DE GUATEMALA',0ah,0dh,'FACULTAD DE INGENIERIA',0ah,0dh,'ESCUELA CIENCIAS Y SISTEMAS',0ah,0dh,'ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1 A',0ah,0dh,'PRIMER SEMESTRE 2020',0ah,0dh,'PABLO ANDR',90h,'S ROCA DOMINGUEZ',0ah,0dh,'CARNET: 201700584',0ah,0dh,'QUINTA PRACTICA',0ah,0dh,'$' ;caracter "$" para finalizar cadenas;
menuTexto db 0ah,0dh,'1) Ingresar funcion f(x)',0ah,0dh,'2) Funcion en memoria',0ah,0dh,'3) Derivada f',27h,'(x)',0ah,0dh,'4) Integral F(x)',0ah,0dh,'5) Graficar funciones',0ah,0dh,'6) Reporte',0ah,0dh,'7) Modo calculadora',0ah,0dh,'8) Salir',0ah,0dh,'opcion: ', '$'


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

ingresarFuncion:
jmp menuPrincipal

funcionEnMemoria:
jmp menuPrincipal

mostrarDerivada:
jmp menuPrincipal

mostrarIntegral:
jmp menuPrincipal

graficar:
jmp menuPrincipal

reporte:
jmp menuPrincipal

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
