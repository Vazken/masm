;unpacked to binary
;unpacked --> binary
;binary --> unpacked
;packed --> binary
;binary --> packed
;packed --> unpacked
;unpacked --> packed
;binary of 2345h is 2345h
;unpacked of 2345 is 02 03 04 05h
;packed of 2345h is 2345h
;.data use16 gets me an error
;.code use16 gets me an error
;how to check in cpp wheather windows is 32 or 64 ?
.386
.model small
.stack 100h
.data
	yes db "Yes!",10,13,'$'
	no db "No!",10,13,'$'
.code
main PROC
	mov eax,@data
	mov ds,eax
	xor eax,eax
	
	mov si,10
	mov edi,02030405h
	mov cl,24			;6*4
	
L1:
	mov ebx,edi
	shr ebx,cl
	and bx,0Fh
	mul si
	add ax,bx
	sub cl,8
	
	jge L1
	cmp ax,2345h
	JNE nope
	
	mov ah,09
	lea edx,yes			;didn't work with offset :((
	int 21h
	jmp exit
nope:
	mov ah,09
	lea edx,no
	int 21h
exit:
	mov ah,04ch
	int 21h
main ENDP
END main