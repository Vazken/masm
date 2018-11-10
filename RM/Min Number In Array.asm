.model small
.stack 100h
.data
	i db ?
	x db 0,5,-1,4,2
	min db 0
	msg db "The min number is: $"
.code
main PROC
	mov ax,@data
	mov ds,ax
	
	xor cx,cx
	mov cl,5
	
	mov si,0
L1:
	mov dl,x[si]
	cmp min,dl
	JNB no
	mov min,dl
no:
	inc si
loop L1
	add min,30h
	
	mov ah,09
	mov dx,offset msg
	int 21h
	
	mov ah,02
	mov dl,min
	int 21h
	
	mov ah,04ch
	int 21h
main ENDP
END main