    .syntax unified
    .cpu cortex-m4
    .thumb

    #define a  10
    #define b  6
    #define c  5

    .global lab1
    .type lab1, %function
lab1:
    push    {lr}
    mov     r1, #a
    add     r1, r1, #b
    lsr     r1, r1, #1
    mov     r2, #1
    mov     r3, #c
fact_loop:
    mul     r2, r2, r3
    subs    r3, r3, #1
    bne     fact_loop
    add     r0, r1, r2
    pop     {pc}
    .size lab1, .-lab1
