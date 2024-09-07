[ORG 0x7C00]
[BITS 16]

;<---------------variables--------------->

maxstring db 8
minstring db 0
string db ' '
position db 1
key db ' '

;<---------------bucle_pricipal--------------->

jmp start ;salto al bucle principal

;<---------------funciones--------------->


backspace:

mov al, [minstring]

cmp byte [position], al
jle backspace_end


mov al, [position]
mov bl, [key]
mov cl, [string]

sub al, 1
mov bl, ' '
mov cl, ' '

mov [position], al
mov [key], bl
mov [string], cl


backspace_delete:

call deleteleter


backspace_end:

jmp main


enter:

call check

mov al, [position]
mov bl, [key]
mov cl, [string]

mov al, [minstring]
mov bl, ' '
mov cl, ' '

mov [position], al
mov [key], bl
mov [string], cl


enter_end:

jmp main


store_char:

mov al, [position]
mov bl, [key]
mov cl, [string]

add al, 1
mov bl, bl
mov cl, bl

mov [position], al
mov [key], bl
mov [string], cl


store_char_end:

ret




;<---------------lista_de_comandos--------------->


commands:

; Imprimir el contenido del buffer de momento
call print_string

mov al, [position]
add al, 48
mov ah, 0x0e
int 0x10

ret




;<---------------sub_funciones--------------->


get_key:

mov al, 0
mov ah, 0
int 0x16
mov [key], al

ret



deleteleter:

mov al, 0x08
mov ah, 0x0e
int 0x10

mov al, ' '
mov ah, 0x0e
int 0x10

mov al, 0x08
mov ah, 0x0e
int 0x10

ret



check:

call new_line
call new_line

call commands

call new_line
call new_line

ret



new_line:

mov al, 0x0a
mov ah, 0x0e
int 0x10

mov al, 0x0d
mov ah, 0x0e
int 0x10

ret



print_string:

mov al, [string]
mov ah, 0x0e
int 0x10

ret



print_key:

mov al, [key]
mov ah, 0x0e
int 0x10

ret




;<---------------bucle_principal--------------->


start:



main:


call get_key


cmp byte [key], 0x08
je backspace

cmp byte [key], 0x0d
je enter


mov al, [maxstring]

cmp byte [position], al
jge main

call store_char
call print_key


jmp main

;<---------------no_tocar--------------->

times 510-($-$$) db 0

dw 0xAA55
