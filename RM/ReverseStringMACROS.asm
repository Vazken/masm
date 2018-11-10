mWriteString MACRO str
    mov ah,09
    mov dx,offset str
    int 21h
ENDM
mReadString MACRO str
    mov ah,10
    mov dx,offset str
    int 21h
ENDM
mReverse MACRO usr
    xor cx,cx
    mov cl,usr+1
    mov si,cx
    inc si
l1:    
    mov dl,usr[si]
    mov ah,02
    int 21h
    dec si
loop l1
ENDM    
.model small
.stack 100h
.data
    msg db "Enter a string: "
    usr db 11,12 DUP('$')
    endl db 10,13,'$'
.code
main PROC
    mov ax,@data
    mov ds,ax
    
    mWriteString msg
    
    mReadString usr
    
    mov ah,09
    mov dx,offset endl
    int 21h
    
    mReverse usr
    
    mov ah,04ch
    int 21h
main ENDP
END main
