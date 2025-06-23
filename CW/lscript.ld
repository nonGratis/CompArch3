/*
 * Курсова робота: Скрипт компонувальника для STM32F407VG (Cortex-M4)
 * Обчислення формули F = (((X₁ | (X₂ >> 1)) >> 3) - 2 × (X₃ ⊕ 1))
 */

/* Точка входу програми */
ENTRY(reset_handler)

/* Визначення областей пам'яті для STM32F407VG */
MEMORY
{
    /* Flash пам'ять: 1MB, доступна тільки для читання та виконання */
    FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 1024K
    
    /* RAM пам'ять: 128KB, доступна для читання/запису */
    RAM (rwx) : ORIGIN = 0x20000000, LENGTH = 128K
    
    /* CCM RAM: 64KB, додаткова швидка RAM */
    CCMRAM (rwx) : ORIGIN = 0x10000000, LENGTH = 64K
}

/* Адреса початку стеку (вершина RAM) */
__stack_start = ORIGIN(RAM) + LENGTH(RAM);
__stack_size = 2K;
__stack_end = __stack_start - __stack_size;

/* Секції програми */
SECTIONS
{
    /* Таблиця векторів переривань */
    .isr_vector :
    {
        . = ALIGN(4);
        KEEP(*(.isr_vector))
        . = ALIGN(4);
    } >FLASH

    /* Код програми */
    .text :
    {
        . = ALIGN(4);
        *(.text)
        *(.text*)
        *(.rodata)
        *(.rodata*)
        . = ALIGN(4);
        
        /* Таблиця конструкторів */
        __preinit_array_start = .;
        KEEP (*(.preinit_array*))
        __preinit_array_end = .;
        
        __init_array_start = .;
        KEEP (*(SORT(.init_array.*)))
        KEEP (*(.init_array*))
        __init_array_end = .;
        
        __fini_array_start = .;
        KEEP (*(.fini_array*))
        KEEP (*(SORT(.fini_array.*)))
        __fini_array_end = .;
        
        . = ALIGN(4);
    } >FLASH
    
    /* Дані для ініціалізації змінних */
    .data : 
    {
        . = ALIGN(4);
        __data_start__ = .;
        *(.data)
        *(.data*)
        . = ALIGN(4);
        __data_end__ = .;
    } >RAM AT>FLASH
    
    __data_load_addr__ = LOADADDR(.data);
    __data_size__ = SIZEOF(.data);
    
    /* Неініціалізовані дані */
    .bss :
    {
        . = ALIGN(4);
        __bss_start__ = .;
        *(.bss)
        *(.bss*)
        *(COMMON)
        . = ALIGN(4);
        __bss_end__ = .;
    } >RAM
    
    __bss_size__ = SIZEOF(.bss);
    
    /* Куча */
    .heap :
    {
        . = ALIGN(4);
        __heap_start__ = .;
        . = . + 1K;
        __heap_end__ = .;
    } >RAM
    
    /* Перевірка на переповнення пам'яті */
    .stack_check :
    {
        . = ALIGN(4);
        . = . + __stack_size;
        . = ALIGN(4);
    } >RAM
}

/* Експорт символів для використання в коді */
PROVIDE(__stack_start = __stack_start);
PROVIDE(__data_start = __data_start__);
PROVIDE(__data_end = __data_end__);
PROVIDE(__bss_start = __bss_start__);
PROVIDE(__bss_end = __bss_end__);