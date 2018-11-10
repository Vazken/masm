Microsoft (R) Macro Assembler Version 6.14.8444		    08/23/17 13:52:07
Encryption.asm						     Page 1 - 1


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
 0000				.data
 = 0003				key=3			;key of encryption/decryption
 0000 49 46 20 59 4F 55		msg0 db "IF YOU WANT TO ENCRYPT, TYPE E.",10,13,"IF YOU WANT TO DECRYPT, TYPE D."
       20 57 41 4E 54 20
       54 4F 20 45 4E 43
       52 59 50 54 2C 20
       54 59 50 45 20 45
       2E 0A 0D 49 46 20
       59 4F 55 20 57 41
       4E 54 20 54 4F 20
       44 45 43 52 59 50
       54 2C 20 54 59 50
       45 20 44 2E
 0040  0A 0D 24				 db 10,13,'$'
 0043 54 48 41 54 20 49		msg1 db "THAT IS AN ILLEGAL CHARACTER, PLEASE TRY AGAIN.$"
       53 20 41 4E 20 49
       4C 4C 45 47 41 4C
       20 43 48 41 52 41
       43 54 45 52 2C 20
       50 4C 45 41 53 45
       20 54 52 59 20 41
       47 41 49 4E 2E 24
 0073 45 4E 54 45 52 20		msg2 db "ENTER THE ENCRYPTION KEY (A SINGLE DIGIT FROM 1 TO 9): $";
       54 48 45 20 45 4E
       43 52 59 50 54 49
       4F 4E 20 4B 45 59
       20 28 41 20 53 49
       4E 47 4C 45 20 44
       49 47 49 54 20 46
       52 4F 4D 20 31 20
       54 4F 20 39 29 3A
       20 24
 00AB 49 4E 50 55 54 20		msg3 db "INPUT A MESSAGE OF NO MORE THAN 20 CHARACTERS.",10,13
       41 20 4D 45 53 53
       41 47 45 20 4F 46
       20 4E 4F 20 4D 4F
       52 45 20 54 48 41
       4E 20 32 30 20 43
       48 41 52 41 43 54
       45 52 53 2E 0A 0D
 00DB  57 48 45 4E 20 44		 db "WHEN DONE, PRESS <ENTER>.",10,13,'$'
       4F 4E 45 2C 20 50
       52 45 53 53 20 3C
       45 4E 54 45 52 3E
       2E 0A 0D 24
 00F7 15			usrMsg db 21,22 DUP (?)  ;max of 20 characters + null
       0016 [
        00
       ]
 0000				.code
 0000				main PROC
 0000  B8 ---- R			mov ax,@data
 0003  8E D8				mov ds,ax
 0005				start:
					;add cls here
 0005  B8 0000				mov ax,0
 0008  CD 10				int 10h
					m_enterMsg
 000A  B4 09		     1		mov ah,09
 000C  BA 00AB R	     1		mov dx,offset msg3
 000F  CD 21		     1		int 21h
 0011  B4 0A		     1		mov ah,10
 0013  BA 00F7 R	     1		mov dx,offset usrMsg
 0016  CD 21		     1		int 21h
 0018  B4 02		     2	mov ah,02
 001A  B2 0A		     2	mov dl,10
 001C  CD 21		     2	int 21h
 001E  B2 0D		     2	mov dl,13
 0020  CD 21		     2	int 21h
					
 0022  B4 09				mov ah,09
 0024  BA 0000 R			mov dx,offset msg0		;encrypt of decrypt message
 0027  CD 21				int 21h
					
					m_endl
 0029  B4 02		     1	mov ah,02
 002B  B2 0A		     1	mov dl,10
 002D  CD 21		     1	int 21h
 002F  B2 0D		     1	mov dl,13
 0031  CD 21		     1	int 21h
					
 0033  B4 01				mov ah,01
 0035  CD 21				int 21h					;e or d input
					
 0037  3C 65				cmp al,'e'
 0039  74 1F				JZ encryptLbl
 003B  3C 45				cmp al,'E'
 003D  74 1B				JZ encryptLbl
					
 003F  3C 64				cmp al,'d'
 0041  74 40				JZ decryptLbl
 0043  3C 44				cmp al,'D'
 0045  74 3C				JZ decryptLbl
					
					
 0047  B4 09				mov ah,09
 0049  BA 0043 R			mov dx,offset msg1
 004C  CD 21				int 21h
					
					m_endl
 004E  B4 02		     1	mov ah,02
 0050  B2 0A		     1	mov dl,10
 0052  CD 21		     1	int 21h
 0054  B2 0D		     1	mov dl,13
 0056  CD 21		     1	int 21h
					
 0058  EB AB				jmp start
 005A				encryptLbl:
					m_endl
 005A  B4 02		     1	mov ah,02
 005C  B2 0A		     1	mov dl,10
 005E  CD 21		     1	int 21h
 0060  B2 0D		     1	mov dl,13
 0062  CD 21		     1	int 21h
					m_Encrypt 
 0064  51		     1	push cx
 0065  50		     1	push ax
 0066  56		     1	push si
 0067  33 C9		     1	xor cx,cx
 0069  8A 0E 00F8 R	     1	mov cl,usrMsg+1			;number of characters user entered
 006D  BE 0002		     1	mov si,2
 0070  B4 02		     1	mov ah,02
 0072			     1	L1:
 0072  8A 94 00F7 R	     1		mov dl,usrMsg[si]
 0076  80 C2 03		     1		add dl,key
 0079  CD 21		     1		int 21h
 007B  46		     1		inc si
 007C  E2 F4		     1	loop L1
 007E  5E		     1	pop si
 007F  58		     1	pop ax
 0080  59		     1	pop cx
 0081  EB 29				jmp exit
 0083				decryptLbl:
					m_endl
 0083  B4 02		     1	mov ah,02
 0085  B2 0A		     1	mov dl,10
 0087  CD 21		     1	int 21h
 0089  B2 0D		     1	mov dl,13
 008B  CD 21		     1	int 21h
					m_Decrypt
 008D  51		     1	push cx
 008E  50		     1	push ax
 008F  56		     1	push si
 0090  33 C9		     1	xor cx,cx
 0092  8A 0E 00F8 R	     1	mov cl,usrMsg+1			;number of characters user entered
 0096  BE 0002		     1	mov si,2
 0099  B4 02		     1	mov ah,02
 009B			     1	L2:
 009B  8A 94 00F7 R	     1		mov dl,usrMsg[si]
 009F  80 EA 03		     1		sub dl,key
 00A2  CD 21		     1		int 21h
 00A4  46		     1		inc si
 00A5  E2 F4		     1	loop L2
 00A7  5E		     1	pop si
 00A8  58		     1	pop ax
 00A9  59		     1	pop cx
 00AA  EB 00				jmp exit
 00AC				exit:
 00AC  B4 4C				mov ah,04ch
 00AE  B0 00				mov al,0
 00B0  CD 21				int 21h
 00B2				main ENDP
				END main
					
	
Microsoft (R) Macro Assembler Version 6.14.8444		    08/23/17 13:52:07
Encryption.asm						     Symbols 2 - 1




Macros:

                N a m e                 Type

m_Decrypt  . . . . . . . . . . .	Proc
m_Encrypt  . . . . . . . . . . .	Proc
m_endl . . . . . . . . . . . . .	Proc
m_enterMsg . . . . . . . . . . .	Proc


Segments and Groups:

                N a m e                 Size     Length   Align   Combine Class

DGROUP . . . . . . . . . . . . .	GROUP
_DATA  . . . . . . . . . . . . .	16 Bit	 010E	  Word	  Public  'DATA'	
STACK  . . . . . . . . . . . . .	16 Bit	 0100	  Para	  Stack	  'STACK'	 
_TEXT  . . . . . . . . . . . . .	16 Bit	 00B2	  Word	  Public  'CODE'	


Procedures,  parameters and locals:

                N a m e                 Type     Value    Attr

main . . . . . . . . . . . . . .	P Near	 0000	  _TEXT	Length= 00B2 Private


Symbols:

                N a m e                 Type     Value    Attr

@CodeSize  . . . . . . . . . . .	Number	 0000h	 
@DataSize  . . . . . . . . . . .	Number	 0000h	 
@Interface . . . . . . . . . . .	Number	 0000h	 
@Model . . . . . . . . . . . . .	Number	 0002h	 
@code  . . . . . . . . . . . . .	Text   	 _TEXT
@data  . . . . . . . . . . . . .	Text   	 DGROUP
@fardata?  . . . . . . . . . . .	Text   	 FAR_BSS
@fardata . . . . . . . . . . . .	Text   	 FAR_DATA
@stack . . . . . . . . . . . . .	Text   	 DGROUP
L1 . . . . . . . . . . . . . . .	L Near	 0072	  _TEXT	
L2 . . . . . . . . . . . . . . .	L Near	 009B	  _TEXT	
decryptLbl . . . . . . . . . . .	L Near	 0083	  _TEXT	
encryptLbl . . . . . . . . . . .	L Near	 005A	  _TEXT	
exit . . . . . . . . . . . . . .	L Near	 00AC	  _TEXT	
key  . . . . . . . . . . . . . .	Number	 0003h	 
msg0 . . . . . . . . . . . . . .	Byte	 0000	  _DATA	
msg1 . . . . . . . . . . . . . .	Byte	 0043	  _DATA	
msg2 . . . . . . . . . . . . . .	Byte	 0073	  _DATA	
msg3 . . . . . . . . . . . . . .	Byte	 00AB	  _DATA	
start  . . . . . . . . . . . . .	L Near	 0005	  _TEXT	
usrMsg . . . . . . . . . . . . .	Byte	 00F7	  _DATA	

	   0 Warnings
	   0 Errors
