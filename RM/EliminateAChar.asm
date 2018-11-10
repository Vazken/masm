TITLE Print a string without the stars in it
.model small
.stack 100h
.data
    msg db "Enter a string: $"
    endl db 10,13,'$'
    usr db 11,12 dup('$')
.code
main PROC
    mov ax,@data
    mov ds,ax
    
    mov ah,09
    mov dx,offset msg
    int 21h
    
    mov ah,10
    mov dx,offset usr
    int 21h
    
    mov ah,09
    mov dx,offset endl
    int 21h
    
    mov si,2
    mov cl,usr+1
    xor ch,ch
L1:
    cmp usr[si],'*'
    jz skip
    mov ah,02
    mov dl,usr[si]
    int 21h
    
    skip:
    inc si
loop L1
    
    mov ah,04ch
    mov al,0
    int 21h
main ENDP
end main