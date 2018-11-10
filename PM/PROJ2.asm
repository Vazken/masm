; enter str => PM => print str on screen's 5,10 position with chaning colors
.386p
.model small
.stack 100h
data segment 'data' use16
	mes db 20,21 dup(?)
	rest_scr=25*80
GDT label byte
	db 8 dup(0)
	gdt_flatcs db 0ffh,0ffh,0,0,0, 10011010b,11001111b,0
	gdt_flatds db 0ffh,0ffh,0,0,0, 10010010b,11001111b,0
	gdt_16bitcs db 0ffh,0ffh,0,0,0,10011010b,0,0
	gdt_16bitds db 0ffh,0ffh,0,0,0,10010010b,0,0
	gdt_l=$-GDT
gdtr dw gdt_l-1
	dd ?
data ends
RM_seg segment para public 'code' use16
	assume cs:RM_seg, ds:data
start:	mov ax,data
	mov ds,ax
; -----------------
	mov ah,10
	lea dx,mes
	int 21h
;--------------------------------------
	in al,92h
	or al,2
	out 92h,al
	xor eax,eax
	mov ax,pm_seg
	shl eax,4
	add eax,offset pm_entry
	mov  dword ptr cs:pm_entry_off, eax
	xor eax,eax
	mov ax,ds
	shl eax,4
	push eax
	mov word ptr gdt_16bitds+2,ax
	shr eax,16
	mov byte ptr gdt_16bitds+4,al
	xor eax,eax
	mov ax,cs
	shl eax,4
	mov word ptr gdt_16bitcs+2,ax
	shr eax,16
	mov byte ptr gdt_16bitcs+4,al
	pop eax
	add eax,offset GDT
	mov dword ptr gdtr+2,eax
	lgdt fword ptr gdtr
	cli
	in al,70h
	or al,80h
	out 70h,al
	mov eax,cr0
	or al,1
	mov cr0,eax
	db 66h
	db 0eah
	pm_entry_off dd ?
	dw sel_flatcs
rm_return:
	mov eax,cr0
	and al,0feh
	mov cr0,eax
	db 0eah
	dw $+4
	dw rm_seg
	in al,70h
	and al,07fh
	out 70h,al
	sti
	mov ah,0
	int 16h
	mov ah,4ch
	int 21h
	sel_flatcs equ 00001000b
	sel_flatds equ 00010000b
	sel_16bitcs equ 00011000b
	sel_16bitds equ 00100000b
rm_seg ends

pm_seg segment para public 'code' use32
	assume cs:pm_seg
pm_entry:
	mov ax,sel_16bitds
	mov ds,ax
	mov ax,sel_flatds
	mov es,ax
	mov edi, 0b8000h
	mov ecx,rest_scr
	mov ax,0720h
	rep stosw
	mov esi,offset mes
	xor ecx,ecx
	mov cl,[esi+1]
	mov edi, 0b8000h
	add edi,820 ; (5,10)=5*80*2+10*2=820
	add esi,2
	cld
	mov ah,5Ch
aa:	mov al,[esi]
	stosw
	inc esi
	add ah,11h
	loop aa
	db 0eah
	dd offset rm_return
	dw sel_16bitcs
pm_seg ENDS
END start