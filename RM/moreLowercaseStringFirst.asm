;insert two strings, get their combination and print, in combination the first string must be the string that has
;more lowercases, do the input, m_OUTPUT and newline procedures using macros.
m_INPUT MACRO x
	push ax 
	push dx
	mov ah,10
	lea dx,x
	int 21h
	pop dx 
	pop ax
ENDM
m_OUTPUT MACRO x
	push ax 
	push dx
	mov ah,09
	lea dx,x
	int 21h
	pop dx 
	pop ax
ENDM
NEWLINE MACRO
	push ax 
	push dx
	mov ah,09
	mov dx,offset endl
	int 21h
	pop dx 
	pop ax
ENDM
concate MACRO x,y,z
	;z= x+y
	push si 
	push di 
	push cx 
	push es 
	push ds
	pop es
	cld
	lea di,z
	lea si,x[2]
	xor cx,cx
	mov cl,[si-1]
	rep movsb
	
	lea si,y[2]
	mov cl,[si-1]
	rep movsb
	
	pop es 
	pop cx 
	pop di 
	pop si
ENDM
count MACRO x,y
	local L1
	local no
	push si 
	push cx
	lea si,x[2]
	xor cx,cx
	mov cl,[si-1]
	xor y,y
L1:
	cmp byte ptr [si],'a'
	JB no
	cmp byte ptr [si],'z'
	JA no
	inc y
no:
	inc si
loop L1
	pop cx 
	pop si
ENDM
.model small
.stack 100h
.data
	a db 10,11 DUP (?)
	b db 10,11 DUP (?)
	c1 db 19 DUP('$')
	endl db 10,13,'$'
.code
main PROC
	mov ax,@data
	mov ds,ax
	
	m_INPUT a
	
	newline
	
	m_INPUT b
	
	newline
	
	count a,dl
	
	count b,bl
	
	cmp dl,bl
	JB ba
	concate a,b,c1
	
	jmp fin
ba:
	concate b,a,c1
fin:
	m_OUTPUT c1
	
	mov ah,04ch
	int 21h
main ENDP
END main