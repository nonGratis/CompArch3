    .syntax unified 
    .cpu cortex-m4 
    //.fpu softvfp 
    .thumb 

    // Глобальні символи
    .global vtable 
    .global __hard_reset__ 

    /* 
     * Таблиця векторів
     */ 
    .type vtable, %object 
    .type __hard_reset__, %function 
vtable:
    .word __stack_start           // Початковий SP
    .word __hard_reset__+1        // Адреса обробника скидання (+1 для Thumb)
    .size vtable, .-vtable 

__hard_reset__:
    // Ініціалізація стеку (якщо потрібно)
    bl  bootloader                // виклик завантажувача
_loop:
    b   _loop
    .size __hard_reset__, .-__hard_reset__
