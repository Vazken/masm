.model small
.stack 100h
.data
string1 db '!gnirts a si siht$'  
.code
main PROC
	mov ax,@data
	mov ds,ax
start:      
	lea bx, string1
	mov si, bx

next_byte:  
	cmp [si], '$'
	je found_the_end
	inc si
	jmp next_byte

found_the_end:  dec si

; now bx points to beginning,
; and si points to the end of string.


; do the swapping:

do_reverse: 
	cmp bx, si
	jae done
				
	mov al, [bx]
	mov ah, [si]
				
	mov [si], al
	mov [bx], ah
				
	inc bx
	dec si
jmp do_reverse



; reverse complete, print out:
done:      
	lea dx, string1
	mov ah, 09h
	int 21h

; wait for any key press....
	mov ah, 0
	int 16h

	mov ah,04ch
	int 21h
main ENDP
END main