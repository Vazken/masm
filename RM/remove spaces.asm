.model small
.stack 100h
.data
		msg db "Enter a string: $"
        str1 db 126,127 dup ('$')
        len db 0
        cntr dw ?
		endl db 10,13,'$'
.code
        mov ax,@data
        mov ds,ax
		
		mov ah,09
		mov dx,offset msg
		int 21h

        mov ah,0Ah
        LEA DX,str1
        int 21h
		
		xor dx,dx
		mov dl, str1[1]
		mov len,dl

        LEA DI,str1 + 2
        mov BX,0000
        mov SI,0002
        mov cntr,dx
        ;sub cntr,1
        L1:
                mov ah,str1[SI]
                cmp ah,' '
                je remove
                INC SI
                cmp SI,cntr
                jge ext
                jmp L1



                remove:
                        mov BX,SI
                   R1:
                        mov ah,str1[BX+1]
                        mov str1[BX],ah
                        cmp Bl,len
                        jge ChangeLen
                        add BX,1
                        jmp R1

                        ChangeLen:
                                mov str1[BX + 1],'$'
                                sub cntr,1
                                jmp L1
        ext:
				mov ah,09
				mov dx,offset endl
				int 21h
				
                mov ah,09h
                LEA DX,str1[2]
                int 21h

                mov ax,4C00h
                int 21h
end