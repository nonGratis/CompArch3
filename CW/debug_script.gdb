# GDB script для відлагодження курсової роботи
# Використання: gdb-multiarch firmware.elf -x debug_script.gdb

# Підключення до QEMU
target remote localhost:1234

# Завантаження програми
load

# Встановлення точок зупинки
break reset_handler
break main_program
break compute_formula
break verify_result

# Встановлення точки зупинки на кожний крок алгоритму
break *0x08000062  # MOV r4, #18
break *0x08000066  # MOV r5, #-9  
break *0x0800006a  # MOV r6, #23
break *0x0800006e  # ASR r5, #1
break *0x08000072  # ORR r4, r5
break *0x08000076  # MOV r7, #3
break *0x0800007a  # shift_loop
break *0x08000082  # EOR r6, #1
break *0x08000086  # LSL r6, #1
break *0x0800008a  # SUB r4, r6
break *0x0800008e  # MOV r0, r4

# Функції для зручного відлагодження
define show_registers
    printf "=== Стан регістрів ===\n"
    printf "r4 (Rx): 0x%08x (%d)\n", $r4, $r4
    printf "r5 (Ry): 0x%08x (%d)\n", $r5, $r5  
    printf "r6 (R3): 0x%08x (%d)\n", $r6, $r6
    printf "r7 (CT): 0x%08x (%d)\n", $r7, $r7
    printf "r0 (Result): 0x%08x (%d)\n", $r0, $r0
    printf "=====================\n"
end

define show_flags
    printf "=== Прапорці процесора ===\n"
    printf "N (Negative): %d\n", ($cpsr >> 31) & 1
    printf "Z (Zero):     %d\n", ($cpsr >> 30) & 1  
    printf "C (Carry):    %d\n", ($cpsr >> 29) & 1
    printf "V (Overflow): %d\n", ($cpsr >> 28) & 1
    printf "========================\n"
end

define step_analysis
    printf "\n=== Аналіз кроку ===\n"
    x/i $pc
    show_registers
    show_flags
    printf "==================\n"
end

# Налаштування відображення
set confirm off
set pagination off

# Початок виконання
continue

printf "\n=== Курсова робота: STM32F407VG Formula Computation ===\n"
printf "Формула: F = (((X₁ | (X₂ >> 1)) >> 3) - 2 × (X₃ ⊕ 1))\n"
printf "X₁ = 18, X₂ = -9, X₃ = 23\n"
printf "Очікуваний результат: F = -45\n"
printf "=====================================================\n"
