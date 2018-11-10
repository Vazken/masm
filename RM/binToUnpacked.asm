;binary to unpacked
.386
.model small
.stack 100h
.data
.code
main PROC
	mov eax,@data
	mov ds,eax
	
	xor si,si
	xor eax,eax
	xor ebx,ebx
	xor ecx,ecx
	
	mov ax,2345h
	mov bl,10
x:
	div bl
	push ax
	xor ah,ah
	inc cx
	cmp al,0
	jne x
	
	xor edi,edi
	xor eax,eax
	shl eax,8
y:
	pop bx
	mov al,bh
	loop y
	
	mov ah,04ch
	int 21h
main ENDP
END main