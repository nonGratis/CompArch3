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
    mov   r2, #0                 @ індекс (offset)
1:  ldrb  r3, [r0, r2]           @ зчитуємо байт з образу
    strb  r3, [r1, r2]           @ записуємо в RAM
    add   r2, r2, #1             @ інкремент адреси
    cmp   r2, #kernel_size       @ перевірка кінця образу
    bne   1b
    
    ldr r1, =str_boot_end
    bl dbgput_line             @ виводимо завантажений рядок
    
    ldr r3, =_ram_start+1      @ адреса старту ядра з Thumb-бітом
    bx r3                      @ передеча керування ядра

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