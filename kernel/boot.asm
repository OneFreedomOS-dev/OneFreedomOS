; boot.asm
bits 32
global _start
extern _kernel_main

section .text
_start:
    cli
	call _kernel_main
	hlt
	
times 510 - ($ - $$) db 0
dw 0xAA55	