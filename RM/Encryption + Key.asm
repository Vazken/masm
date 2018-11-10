m_Encrypt MACRO
;CSE
push cx
push ax
push si
xor cx,cx
mov cl,usrMsg+1			;number of characters user entered
mov si,2
mov ah,02
L1:
	mov dl,usrMsg[si]
	add dl,key
	int 21h
	inc si
loop L1
pop si
pop ax
pop cx
ENDM
m_Decrypt MACRO
;CSE
push cx
push ax
push si
xor cx,cx
mov cl,usrMsg+1			;number of characters user entered
mov si,2
mov ah,02
L2:
	mov dl,usrMsg[si]
	sub dl,key
	int 21h
	inc si
loop L2
pop si
pop ax
pop cx
ENDM
m_enterMsg MACRO
	mov ah,09
	mov dx,offset msg3
	int 21h
	
	mov ah,10
	mov dx,offset usrMsg
	int 21h
	m_endl
ENDM
m_endl MACRO
mov ah,02
mov dl,10
int 21h
mov dl,13
int 21h
ENDM
.model small
.stack 100h
.data
key db 0
msg0 db "IF YOU WANT TO ENCRYPT, TYPE E.",10,13,"IF YOU WANT TO DECRYPT, TYPE D."
	 db 10,13,'$'
msg1 db "THAT IS AN ILLEGAL CHARACTER, PLEASE TRY AGAIN.$"
msg2 db "ENTER THE ENCRYPTION KEY (A SINGLE DIGIT FROM 1 TO 9): $";
msg3 db "INPUT A MESSAGE OF NO MORE THAN 20 CHARACTERS.",10,13
	 db "WHEN DONE, PRESS <ENTER>.",10,13,'$'
msg4 db "Enter encryption key: (1-9)$"
usrMsg db 21,22 DUP (?)  ;max of 20 characters + null
.code
main PROC
	mov ax,@data
	mov ds,ax
start:
	;add cls here
	mov ax,0
	int 10h
	m_enterMsg
	
	mov ah,09
	mov dx,offset msg0		;encrypt or decrypt message
	int 21h
	
	mov ah,09
	mov dx,offset msg4
	int 21h
	
	mov ah,01
	int 21h
	mov key,al
	sub key,'0'
	
	m_endl
	
	mov ah,01
	int 21h					;e or d input
	
	cmp al,'e'
	JZ encryptLbl
	cmp al,'E'
	JZ encryptLbl
	
	cmp al,'d'
	JZ decryptLbl
	cmp al,'D'
	JZ decryptLbl
	
	
	mov ah,09
	mov dx,offset msg1
	int 21h
	
	m_endl
	
	jmp start
encryptLbl:
	m_endl
	m_Encrypt 
	jmp exit
decryptLbl:
	m_endl
	m_Decrypt
	jmp exit
exit:
	mov ah,04ch
	mov al,0
	int 21h
main ENDP
END main
	
	