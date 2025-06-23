/*
 * Курсова робота: Стартовий файл для STM32F407VG (Cortex-M4)
 * Таблиця векторів переривань та точка входу
 */

.syntax unified 
.cpu cortex-m4 
.thumb 

/* Глобальні символи */
.global reset_handler
.global main_program

/* 
 * Таблиця векторів переривань для Cortex-M4
 * Розміщується у секції .isr_vector
 */
.section .isr_vector, "a", %progbits
.type vtable, %object 
vtable: 
    .word __stack_start       /* Початкове значення SP */
    .word reset_handler+1     /* Вектор скидання (Reset) */
    .word nmi_handler+1       /* Non-Maskable Interrupt */
    .word hardfault_handler+1 /* Hard Fault */
    .word memmanage_handler+1 /* Memory Management Fault */
    .word busfault_handler+1  /* Bus Fault */
    .word usagefault_handler+1/* Usage Fault */
    .word 0                   /* Зарезервовано */
    .word 0                   /* Зарезервовано */
    .word 0                   /* Зарезервовано */
    .word 0                   /* Зарезервовано */
    .word svc_handler+1       /* Supervisor Call */
    .word debugmon_handler+1  /* Debug Monitor */
    .word 0                   /* Зарезервовано */
    .word pendsv_handler+1    /* PendSV */
    .word systick_handler+1   /* SysTick */
    .size vtable, .-vtable 

/* Перехід до секції коду */
.section .text

/*
 * Обробник скидання - головна точка входу програми
 */
.type reset_handler, %function 
reset_handler: 
    /* Ініціалізація стеку */
    ldr     sp, =__stack_start
    
    /* Виклик головної програми обчислення */
    bl      main_program
    
    /* Нескінченний цикл після завершення */
infinite_loop: 
    b       infinite_loop 
    .size reset_handler, .-reset_handler 

/*
 * Базові обробники переривань
 * Усі просто зациклюються для відлагодження
 */
.type nmi_handler, %function
nmi_handler:
    b       nmi_handler
    .size nmi_handler, .-nmi_handler

.type hardfault_handler, %function
hardfault_handler:
    b       hardfault_handler
    .size hardfault_handler, .-hardfault_handler

.type memmanage_handler, %function
memmanage_handler:
    b       memmanage_handler
    .size memmanage_handler, .-memmanage_handler

.type busfault_handler, %function
busfault_handler:
    b       busfault_handler
    .size busfault_handler, .-busfault_handler

.type usagefault_handler, %function
usagefault_handler:
    b       usagefault_handler
    .size usagefault_handler, .-usagefault_handler

.type svc_handler, %function
svc_handler:
    b       svc_handler
    .size svc_handler, .-svc_handler

.type debugmon_handler, %function
debugmon_handler:
    b       debugmon_handler
    .size debugmon_handler, .-debugmon_handler

.type pendsv_handler, %function
pendsv_handler:
    b       pendsv_handler
    .size pendsv_handler, .-pendsv_handler

.type systick_handler, %function
systick_handler:
    b       systick_handler
    .size systick_handler, .-systick_handler 
