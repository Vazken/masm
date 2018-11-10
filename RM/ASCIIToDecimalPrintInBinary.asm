m_NewLine MACRO
	mov ah,09
	mov dx,offset endl
	int 21h
ENDM
.model small
.stack 100h
.data
		UINT db 7,8 dup(0)
		endl db 10,13,'$'
		temp dw ?
		out_t db 6 dup (' '),'$'
.code
main PROC
			mov ax,@data
			mov ds,ax
			
			mov ah,10
			lea dx,UINT						;get first input
			int 21h
			call input
			mov bx,ax
			m_NewLine
			
			
			
			
L0:
            shl bx,1
            jc  one   
            mov ah,02
            mov dl,'0'
            int 21h
            jmp done
one:        
            mov ah,02
            mov dl,'1'
            int 21h
done:            
            cmp bx,0000h
JNZ L0
			mov ah,02
			mov dl,'0'
			int 21h 
			
	exit:
			mov ah,04ch
			int 21h
main ENDP

input PROC uses dx bx si cx di
			xor ax,ax
			xor si,si
			xor cx,cx
			
			mov di,10
			mov cl,UINT+1 					; cx= lengthof UINT
L1:		
			mul di
			mov bh,UINT[si+2]
			sub bh,30h
			add al,bh
			adc ah,0
			inc si
loop L1
			ret
input ENDP

END main