print MACRO char,count
    xor cx,cx
    mov cl,count
L1:
    mov ah,02
    mov dl,char
    int 21h 
    dec cl 
JNZ L1
    
ENDM 
newLine MACRO
    mov ah,09
    mov dx,offset endl          ;newline
    int 21h
ENDM
.model small
.stack 100h
.data    
    msg1 db "Gimme a decimal value to use as n: $"
    endl db 10,13,'$'
    usrInput db 0
    usrDecimal db 0
.code
main PROC
    mov ax,@data
    mov ds,ax
    
    mov ah,09
    mov dx,offset msg1
    int 21h           
    
    mov ah,01
    int 21h
    
    cmp al,'0'
    JZ exit             ;in case of 0 skip rinning the rest of the code and exit
      
    mov usrInput,al     ;save ascii
    sub al,30h          ;decimal
    mov usrDecimal,al
L2: 
    newLine   
    print usrInput usrDecimal
    
    dec usrInput
    dec usrDecimal
JNZ L2

exit:   
    mov ah,04ch
    int 21h
    
main ENDP
END main