    .syntax unified
    .cpu cortex-m4
    .thumb

    .global bootloader
    .type bootloader, %function
bootloader:
    ldr   r0, =kernel_image      @ адреса вбудованого образу
    ldr   r1, =_ram_start        @ початок RAM
    mov   r2, #0                 @ індекс (offset)
1:  ldrb  r3, [r0, r2]           @ зчитуємо байт з образу
    strb  r3, [r1, r2]           @ записуємо в RAM
    add   r2, r2, #1             @ інкремент адреси
    cmp   r2, #kernel_size       @ перевірка кінця образу
    bne   1b
    ldr   r3, =_ram_start+1      @ Thumb+1
    bx    r3                     @ передаємо управління kernel

    .section .rodata
kernel_image:
    .incbin "kernel.bin"
kernel_size = . - kernel_image

    .section .bss
    .equ  _ram_start, 0x20000000