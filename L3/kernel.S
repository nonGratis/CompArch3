    .syntax unified
    .cpu cortex-m4
    .thumb
    .global __kernel_reset__
__kernel_reset__:
    ldr r1, =data          @ адресу рядка "kernel started!" у r1
    bl dbgput_line         @ виклик процедури друку рядка
    bl lab1                @ Викликати функцію lab1
    mov r1, r0             @ r0 в r1
    bl dbgput_num          @ принт числа
    b .                    @ Нескінченний цикл (зупинка виконання)

    .global lab1
    .type lab1, %function
lab1:
    push {lr}
    mov  r1, #10      @ a=10
    add  r1, r1, #6   @ b=6
    lsr  r1, r1, #1
    mov  r2, #1       @ факторіал
    mov  r3, #5
floop:
    mul  r2, r2, r3
    subs r3, r3, #1
    bne  floop
    add  r0, r1, r2   @ результат
    pop  {pc}

.section .rodata
data:
    .asciz "kernel started!\n"