.syntax unified
    .cpu cortex-m4
    .thumb

    .global bootloader
    .type bootloader, %function
bootloader:
    ldr r1, =str_boot_start    @ вантажимо адрсу рядка "bootloader started"
    bl dbgput_line
    
    ldr   r0, =kernel_image      @ адреса вбудованого образу
    ldr   r1, =_ram_start        @ початок RAM
    ldr   r5, =kernel_size       @ завантажуємо розмір kernel в регістр
    mov   r2, #0                 @ індекс (offset)
    mov   r4, #1                 @ той байт що вимагає варіант
1:  ldrb r3, [r0, r2, LSL #0]          @ зчитуємо байт з образу
    strb r3, [r1, r2, LSL #0]          @ записуємо в RAM
    add r2, r2, r4              @ інкремент адреси
    cmp   r2, r5                @ порівнюємо з розміром kernel (тепер в регістрі)
    bne   1b
    
    ldr r1, =str_boot_end      @ Load "bootloader end" string
    bl dbgput_line             @ Print it
    
    ldr r3, =_ram_start+1      @ Thumb+1
    bx r3                      @ Transfer control to kernel

    .section .rodata
kernel_image:
    .incbin "kernel.bin"
kernel_size = . - kernel_image

str_boot_start:
    .asciz "bootloader started\n"
str_boot_end:
    .asciz "bootloader end\n"

    .section .bss
    .equ  _ram_start, 0x20000000