TITLE Count number of certain letters inserted by user
Numb=100
.model small
.stack 100h
.data
    usr db Numb,Numb+1 dup('$')
    endl db 10,13,'$'
    msg db "Enter a string to check how many ('A' 'B' 'C')s are there: $"
    sum dw Numb,Numb+1 dup('$')
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
    mov cl,usr+1
    xor ch,ch
    mov si,2
    mov dx,0000h
L1:
    cmp usr[si],'A'
    JE yes
    
    cmp usr[si],'B'
    JE yes
    
    cmp usr[si],'C'
    JNE no
    
    yes:
    inc dl
    
    no:
    inc si
loop L1
    mov ax,dx
    AAA
    mov dx,ax
    or dx,3030h
    xchg dl,dh
    mov sum,dx
    
    mov ah,09
    mov dx,offset sum
    int 21h
    
    mov ah,04ch
    int 21h
    
main ENDP
end main