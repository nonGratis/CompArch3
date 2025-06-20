SDK_PREFIX?=arm-none-eabi-
CC = $(SDK_PREFIX)gcc
OBJCOPY = $(SDK_PREFIX)objcopy
QEMU = qemu-system-gnuarmeclipse
BOARD ?= STM32F4-Discovery
MCU=STM32F407VG
TARGET=firmware
CPU_CC=cortex-m4
TCP_ADDR=1234

all: build

build:
	$(CC) -x assembler-with-cpp -c -O0 -g3 -mcpu=$(CPU_CC) start.S -o start.o
	$(CC) -x assembler-with-cpp -c -O0 -g3 -mcpu=$(CPU_CC) print.S -o print.o
	$(CC) -x assembler-with-cpp -c -O0 -g3 -mcpu=$(CPU_CC) kernel.S -o kernel.o
	$(CC) -x assembler-with-cpp -c -O0 -g3 -mcpu=$(CPU_CC) bootloader.S -o bootloader.o
	$(CC) start.o print.o kernel.o bootloader.o \
		-mcpu=$(CPU_CC) --specs=nosys.specs -nostdlib -lgcc \
		-T lscript.ld -o $(TARGET).elf
	$(OBJCOPY) -O binary -F elf32-littlearm $(TARGET).elf $(TARGET).bin

qemu:
	$(QEMU) --board $(BOARD) --mcu $(MCU) \
		--image $(TARGET).bin --semihosting-config enable=on,target=native \
		-gdb tcp::$(TCP_ADDR) -S

clean:
	-rm *.o
	-rm *.elf
	-rm *.bin
