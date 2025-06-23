##
## Курсова робота: Makefile для STM32F407VG (Cortex-M4) на QEMU
## Обчислення формули F = (((X₁ | (X₂ >> 1)) >> 3) - 2 × (X₃ ⊕ 1))
##

# Налаштування інструментів
SDK_PREFIX ?= arm-none-eabi-
CC = $(SDK_PREFIX)gcc
AS = $(SDK_PREFIX)as
LD = $(SDK_PREFIX)ld
SIZE = $(SDK_PREFIX)size
OBJCOPY = $(SDK_PREFIX)objcopy
OBJDUMP = $(SDK_PREFIX)objdump
GDB = gdb-multiarch

# Налаштування QEMU
QEMU = qemu-system-gnuarmeclipse
BOARD ?= STM32F4-Discovery
MCU = STM32F407VG
TARGET = firmware
CPU_CC = cortex-m4
TCP_ADDR = 1234

# Прапори компіляції
ASFLAGS = -mcpu=$(CPU_CC) -mthumb -g3
CFLAGS = -mcpu=$(CPU_CC) -mthumb -O0 -g3 -Wall
LDFLAGS = -mcpu=$(CPU_CC) -mthumb --specs=nosys.specs -nostdlib -lgcc -T./lscript.ld

# Файли проекту
SOURCES = start.S CW.S
OBJECTS = start.o CW.o

# Основні цілі
.PHONY: all clean qemu debug disasm help verify

all: $(TARGET).bin $(TARGET).elf

# Компіляція об'єктних файлів
%.o: %.S
	$(CC) -x assembler-with-cpp -c $(ASFLAGS) $< -o $@

# Компонування
$(TARGET).elf: $(OBJECTS) lscript.ld
	$(CC) $(OBJECTS) $(LDFLAGS) -o $@
	$(SIZE) $@

# Створення бінарного файлу
$(TARGET).bin: $(TARGET).elf
	$(OBJCOPY) -O binary $< $@

# Дизасемблювання для аналізу
disasm: $(TARGET).elf
	$(OBJDUMP) -d -S $< > $(TARGET)_disasm.txt
	@echo "Дизасемблер збережено у $(TARGET)_disasm.txt"

# Запуск QEMU
qemu: $(TARGET).bin
	$(QEMU) --verbose --verbose \
		--board $(BOARD) \
		--mcu $(MCU) \
		-d unimp,guest_errors \
		--image $(TARGET).bin \
		--semihosting-config enable=on,target=native \
		-gdb tcp::$(TCP_ADDR) \
		-S

# Відлагодження з GDB
debug: $(TARGET).elf
	@echo "Запустіть QEMU в іншому терміналі: make qemu"
	@echo "Потім підключіться через GDB:"
	$(GDB) $(TARGET).elf -x debug_script.gdb

# Інтерактивне відлагодження
debug-interactive: $(TARGET).elf
	@echo "Запустіть QEMU в іншому терміналі: make qemu"
	@echo "Потім підключіться через GDB:"
	$(GDB) $(TARGET).elf \
		-ex "target remote localhost:$(TCP_ADDR)" \
		-ex "load" \
		-ex "break main_program" \
		-ex "continue"

# Очищення
clean:
	-rm -f *.o
	-rm -f *.elf
	-rm -f *.bin
	-rm -f *_disasm.txt

# Допоміжні цілі
help:
	@echo "Доступні команди:"
	@echo "  make all               - збірка проекту"
	@echo "  make qemu              - запуск QEMU"
	@echo "  make debug             - відлагодження з GDB (автоматичний скрипт)"
	@echo "  make debug-interactive - інтерактивне відлагодження з GDB"
	@echo "  make disasm            - дизасемблювання"
	@echo "  make clean             - очищення файлів"
	@echo "  make verify            - перевірка збірки"

# Перевірка збірки
verify: $(TARGET).elf
	@echo "=== Перевірка збірки ==="
	@$(SIZE) $(TARGET).elf
	@echo "Файл $(TARGET).bin створено успішно"
	@ls -la $(TARGET).*

# Залежності
start.o: start.S lscript.ld
CW.o: CW.S
