.model small
.stack 100h
.data 
    string db 20, 22 dup('?')
    new_line db 10,13, '$'
.code
main PROC
     mov ax,@data
     mov ds,ax 
     
     
    lea dx, string
    mov ah, 10
    int 21h
    
    mov bx, dx
    mov ah, 0
    mov al, [bx+1]
    add bx, ax ; point to end of string.

    mov byte ptr [bx+2], '$' ; put dollar to the end.

    lea dx, new_line
    mov ah, 09h
    int 21h


    lea bx, string
    
    mov ch, 0
    mov cl, [bx+1] ; get string size.
    
    jcxz null ; is string is empty?
    
    add bx, 2 ; skip control chars.

upper_case:

; check if it's a lower case letter:
    cmp byte ptr [bx], 'a'
    jb ok
    cmp byte ptr [bx], 'z'
    ja ok

    and byte ptr [bx], 11011111b
    
    ok:
    inc bx ; next char.
    loop upper_case


; int 21h / ah=09h - output of a string at ds:dx.
; string must be terminated by '$' sign.
    lea dx, string+2
    mov ah, 09h
    int 21h
	
; wait for any key press....
    mov ah, 0
    int 16h 
null:
       mov ah,04ch
       int 21h
main ENDP
END main