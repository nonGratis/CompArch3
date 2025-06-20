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
    push {r0, r1, r2, r3, lr}     

    ldr r2, =num_buffer           @ завантажуємо адресу буфера для текстового представлення числа
    add r1, #48                   @ перетворюємо цифру (0–9) у символ ASCII ('0'–'9')
    strb r1, [r2]                 @ записуємо символ цифри в буфер

    mov r1, #10                   @ символ нового рядка '\n' (ASCII 10)
    strb r1, [r2, #1]             @ записуємо його другим байтом

    mov r1, #0                    @ null термінатор '\0'
    strb r1, [r2, #2]             @ pаписуємо третім байтом (кінець рядка)

    mov r0, #4                    @ код SYS_WRITE0 для виводу рядка
    ldr r1, =num_buffer           @ вказівник на наш текстовий буфер
    bkpt #0xAB                    @ викликаємо semihosting для виводу
    pop {r0, r1, r2, r3, pc}

.section .data
num_buffer:
    .space 3                      @ Резервуємо 3 байти: символ цифри, '\n', '\0'
