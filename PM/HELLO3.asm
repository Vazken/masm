.386p
data segment 'data' use16
	Bg=10000010b			;blinking green
	msg db 'H',Bg,'E',Bg,'L',Bg,'L',Bg,'O',Bg
	msg_l=$-msg
	rest_scr=25*80
	
	GDT	label byte
			   db 8 DUP(0)
	GDT_flatCS db 0FFh,0FFh,0,0,0,10011010b,11001111b,0
	GDT_flatDS db 0FFh,0FFh,0,0,0,10010010b,11001111b,0
	
	GDT_16bitCS db 0FFh,0FFh,0,0,0,10011010b,0,0
	GDT_16bitDS db 0FFh,0FFh,0,0,0,10010010b,0,0
	
	GDT_l=$-GDT
	
	GDTR dw GDT_l-1
		 dd ?
data ENDS
RM_seg	segment para public 'code' use16
	assume cs:RM_seg,DS:data
start:
	mov ax,data
	mov ds,ax
	
	in al,92h
	or al,2							;Enable gate A20
	out 92h,al
	
	xor eax,eax
	mov ax,PM_seg
	shl eax,4
	add eax,offset PM_entry
	mov dword ptr cs:pm_entry_off,eax
	
	xor eax,eax
	mov ax,ds
	shl eax,4
	push eax
	mov word ptr GDT_16bitDS+2,ax
	shr eax,16
	mov byte ptr GDT_16bitDS+4,al
	
	xor eax,eax
	mov ax,cs
	shl eax,4
	mov word ptr GDT_16bitCS+2,ax
	shr eax,16
	mov byte ptr GDT_16bitCS+4,al
	
	pop eax
	add eax,offset GDT
	mov dword ptr GDTR+2,eax
	LGDT fword ptr GDTR
	
	cli
	
	in al,70h
	or al,80h
	out 70h,al
	
	mov eax,cr0
	or al,1					;enable PM
	mov cr0,eax
	db 66h
	db 0EAh
	pm_entry_off dd ?
	dw SEL_flatCS
	
RM_return:
	mov eax,cr0
	and al,0FEh				;disable PM
	mov cr0,eax
	
	db 0EAh
	dw $+4
	dw RM_seg
	
	in al,70h
	and al,07Fh
	out 70h,al
	
	sti
	
	mov ah,0			;read key
	int 16h				;key pressed in AL
	
	mov ah,04ch
	int 21h
	
	SEL_flatCS equ 00001000b
	SEL_flatDS equ 00010000b
	SEL_16bitCS equ 00011000b
	SEL_16BitDS equ 00100000b
RM_seg ENDS

PM_seg segment public 'code' use32
	assume CS:PM_seg
PM_entry:
	mov ax,SEL_16BitDS
	mov ds,ax
	mov ax,SEL_flatDS
	mov es,ax
	
	cld
	
	mov edi,0B8000h
	mov ecx,rest_scr	
	mov al,' '
	mov ah,0010b
	rep stosw
	
	mov esi,offset msg
	mov edi,0B8000h		;start of screen, first line
	add edi,160			;Each line = 160bytes	, 2nd line
	add edi,160			;3rd line
	mov ecx,msg_l
	rep movsb
	
		db 0EAh				;far jump
		dd offset RM_return
		dw SEL_16bitCS
PM_seg ENDS

END start