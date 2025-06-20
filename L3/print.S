    .syntax unified
    .cpu cortex-m4
    .thumb

    .global dbgput_line
dbgput_line:
    mov   r0, #4            @ semihosting SYS_WRITE0
    mov   r1, r0
    bkpt  #0xAB             @ виклик виведення рядка по r1
    bx    lr

    .global dbgput_num
dbgput_num:
    mov   r0, #0x03         @ SYS_WRITENUM semihosting
    bkpt  #0xAB
    bx    lr