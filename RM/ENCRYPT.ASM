m_endl MACRO
	mov ah,09
	mov dx,offset endl
	int 21h
ENDM
.model small
.stack 100h
.data
	endl db 10,13,'$'
	usr db 101,102 DUP (' ')
	enc db 100 DUP ('$')
	decr db 100 DUP ('$')
	msg db "1.Encrypt",10,13,"2.Decrypt",10,13,'$'
	msg2 db "Enter a string",10,13,'$'
	err db "Wrong value inserted",10,13,'$'
.code
main PROC
	mov ax,@data
	mov ds,ax
	
	mov ah,09
	lea dx,msg2
	int 21h
	
	m_endl
	
	mov ah,10
	lea dx,usr
	int 21h
	
	m_endl
	
	mov ah,09
	mov dx,offset msg
	int 21h
	
	m_endl
	
	mov ah,01
	int 21h
	
	m_endl
	
	cmp al,'1'
	JZ encryptlbl
	
	cmp al,'2'
	JZ decryptlbl
	
	mov ah,09
	lea dx,err
	int 21h
	m_endl
	jmp exit
	
	

encryptlbl:
		xor cx,cx
		mov cl,usr+1
		mov si,2
		xor dx,dx
		m_endl
L1:
		mov dl,usr[si]
		mov enc[si],dl
		add enc[si],0Ah
		
		mov ah,02
		mov dl,enc[si]
		int 21h
		inc si
loop L1
	jmp exit
decryptlbl:
		xor cx,cx
		mov cl,usr+1
		mov si,2
		xor dx,dx
		m_endl
L2:
		mov dl,usr[si]
		mov decr[si],dl
		sub decr[si],0Ah
		
		mov ah,02
		mov dl,decr[si]
		int 21h
		inc si
loop L2
	exit:
		mov ah,04ch
		int 21h
main ENDP
END main
	
	
	
