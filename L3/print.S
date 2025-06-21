    .syntax unified
    .cpu cortex-m4
    .thumb

    .global dbgput_line
dbgput_line:
    push {r0, r2, r3, lr}         @ зберігаємо регістри, які будемо використовувати
    mov r0, #4                    @ код оперціі SYS_WRITE0 (вивести рядок)
    @ r1 вже містить адресу рядка (заповнено викликом цієї функції)
    bkpt #0xAB                    @ semihosting (зупинка для GDB/QEMU)
    pop {r0, r2, r3, pc}

    .global dbgput_num
dbgput_num:
    push {r0, r2, r3, r4, lr}     

    ldr r2, =num_buffer           @ завантажуємо адресу буфера
    mov r3, r1                    @ копіюємо число в r3
    mov r4, #0                    @ лічильник цифр
    
    @ Перевіряємо чи число = 0
    cmp r3, #0
    bne convert_loop
    mov r0, #48                   @ ASCII '0'
    strb r0, [r2]
    mov r4, #1
    b add_newline

convert_loop:
    cmp r3, #0                    @ перевіряємо чи залишилися цифри
    beq reverse_digits
    
    @ Отримуємо останню цифру (r3 % 10)
    mov r0, #10
    udiv r1, r3, r0               @ r1 = r3 / 10
    mul r0, r1, r0                @ r0 = (r3 / 10) * 10
    sub r0, r3, r0                @ r0 = r3 - ((r3 / 10) * 10) = r3 % 10
    
    add r0, r0, #48               @ перетворюємо в ASCII
    strb r0, [r2, r4]             @ зберігаємо цифру
    add r4, r4, #1                @ збільшуємо лічильник
    
    mov r3, r1                    @ r3 = r3 / 10
    b convert_loop

reverse_digits:
    @ Обертаємо цифри (вони зберігаються у зворотному порядку)
    mov r0, #0                    @ початковий індекс
    sub r1, r4, #1                @ кінцевий індекс
reverse_loop:
    cmp r0, r1
    bge add_newline
    
    ldrb r3, [r2, r0]             @ завантажуємо початковий символ
    ldrb r12, [r2, r1]            @ завантажуємо кінцевий символ
    strb r12, [r2, r0]            @ зберігаємо кінцевий на початок
    strb r3, [r2, r1]             @ зберігаємо початковий в кінець
    
    add r0, r0, #1
    sub r1, r1, #1
    b reverse_loop

add_newline:
    mov r0, #10                   @ символ нового рядка '\n'
    strb r0, [r2, r4]             @ записуємо його
    add r4, r4, #1
    
    mov r0, #0                    @ null термінатор '\0'
    strb r0, [r2, r4]             @ записуємо кінець рядка

    mov r0, #4                    @ код SYS_WRITE0 для виводу рядка
    ldr r1, =num_buffer           @ вказівник на наш текстовий буфер
    bkpt #0xAB                    @ викликаємо semihosting для виводу
    pop {r0, r2, r3, r4, pc}

.section .data
num_buffer:
    .space 16                     @ Резервуємо 16 байтів для числа