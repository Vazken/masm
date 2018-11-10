stek segment stack 'stack'
	db 512 dup(?)
stek ends
data segment
	yes db 'yes','$'
	no db 'no$'
data ends
;al=01100111 -> 11100110
;al=11000011 -> 11000011
; 123 ->((0*10+3)*10+2)*10+1
cod segment
assume cs:cod, ds:data, ss:stek
main proc far
	push ds
	xor ax,ax
	push ax
	mov ax,data
	mov ds,ax
	mov ah,1
	int 21h
	mov cx,8
x:	ror al,1 ; cf
	rcl bl,1
	loop x	
mov ah,9
	cmp al,bl
	jne no1
	
	lea dx,yes
	int 21h
	jmp fin
no1: 	lea dx,no
	int 21h
fin:	ret

main endp
cod ends
	end main