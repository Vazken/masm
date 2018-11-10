TITLE Hello World PM
.model small
.stack 100h
.data
	Bg=10000010b
	Br=10000100b
	
	msg db 'H',Bg,'E',Br,'L',Bg,'L',Br,'O',Bg
	msg1=$-msg				;sizeof msg
	msg2=80*25-msg1/2		
.code
main PROC
	mov ax,@data
	mov ds,ax
	
	.386p					
	cld					;DF=0, direction= forward
	
	mov ax,0B800h
	mov es,ax
	
	cli					;lP=0
	
	in al,70h			
	or al,80h
	out 70h,al
	
	mov eax,cr0
	or al,1
	mov cr0,eax
	
	xor di,di
	mov si,offset msg
	mov cx,msg1
	
	rep movsb
	
	mov ax,720h
	mov cx,msg2
	rep stosw
	
	mov eax,cr0
	and al,0FEh
	
	mov cr0,eax
	
	in al,70h
	and al,7Fh
	
	out 70h,al
	
	sti					;IP=1
	
	 mov ah,0			;00 (AWAIT_Char), Reads a character from the keyboard
	 int 16h				;works with the ah,0 above
	; mov ah,01
	; int 21h
	
	
	mov ah,04ch
	mov al,0
	int 21h
main ENDP
END main