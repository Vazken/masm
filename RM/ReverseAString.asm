TITLE Reverse a string
.model small
.stack 100h
.data
    msg db "Enter a string: $"
	pkey db "Press any key to continue . . .$"
    usr db 101,102 dup ('$')
    endl db 10,13,'$'
.code
main PROC
    mov ax,@data
    mov ds,ax
    
    mov ah,09
    lea dx,msg
    int 21h
    
    mov ah,10
    lea dx,usr
    int 21h
    
    mov ah,09
    lea dx,endl
    int 21h
    
    mov cl,usr+1
    xor ch,ch
    
    mov si,cx
    
    inc si
    
L1:
    mov ah,02
    mov dl,usr[si]
    int 21h
    dec si
loop L1
	mov ah,09
	mov dx,offset endl
	int 21h
	
	mov ah,09
	mov dx,offset pkey
	int 21h
	
	mov ah,01
	int 21h
	
	mov ah,04ch
	mov al,0
    int 21h
main ENDP
end main