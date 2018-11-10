.model small
.stack 100h
.data
	usr db 128,129 DUP ('$')
.code
main PROC
	mov ax,@data
	mov ds,ax
	mov es,ax
	
	mov ah,10
	lea dx,usr
	int 21h
	
	  mov  ah,13h 				;SERVICE TO DISPLAY STRING WITH COLOR.
	  mov  bp,offset usr[2] 		;STRING TO DISPLAY.
	  mov  bh,0 					;PAGE (ALWAYS ZERO).
	  mov  bl,10000010b			;color
	  xor cx,cx
	  mov  cl,usr+1 				;STRING LENGTH.
	  mov  dl,0 					;X screen position
	  mov  dh,5 					;Y screen position 
	  int  10h 					;BIOS SCREEN SERVICES. 
	
	mov ah,0					;wait for a char
	int 16h						
	
	.exit						;microsoft assembler macro mov ah,04ch int 21h :D
main ENDP
END main