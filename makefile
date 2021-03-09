BUILD_DIR = ./build
AS = nasm
CC = gcc
LD = gcc
LIB = -I include/
ASFLAGS = -f elf64
CFLAGS = -c -g $(LIB)

OBJS = $(BUILD_DIR)/main.o $(BUILD_DIR)/assert.o $(BUILD_DIR)/task.o $(BUILD_DIR)/list.o \
		$(BUILD_DIR)/analog_interrupt.o $(BUILD_DIR)/timer.o $(BUILD_DIR)/died_context_swap.o \
		$(BUILD_DIR)/bitmap.o $(BUILD_DIR)/context_swap.o $(BUILD_DIR)/debug.o $(BUILD_DIR)/sync.o \
		$(BUILD_DIR)/console.o

###### 编译 ######
$(BUILD_DIR)/main.o: main.c include/task.h
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/list.o: lib/list.c include/list.h
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/assert.o: lib/assert.c include/assert.h
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/task.o: task/task.c include/task.h \
					include/list.h include/assert.h include/bitmap.h include/debug.h
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/analog_interrupt.o: interrupt/analog_interrupt.c include/analog_interrupt.h \
					include/set_ticker.h include/stdint.h include/assert.h
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/timer.o: interrupt/timer.c include/timer.h \
					include/stdint.h include/task.h include/assert.h
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/bitmap.o: lib/bitmap.c include/bitmap.h \
					include/stdint.h include/assert.h
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/debug.o: task/debug.c include/debug.h \
					include/analog_interrupt.h
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/sync.o: task/sync.c include/sync.h \
					include/stdint.h include/list.h include/analog_interrupt.h \
					include/debug.h include/assert.h include/task.h
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/console.o: device/console.c include/console.h \
					include/sync.h include/task.h
	$(CC) $(CFLAGS) $< -o $@

###### 汇编文件 ######
$(BUILD_DIR)/died_context_swap.o: task/died_context_swap.asm
	$(AS) $(ASFLAGS) $< -o $@

$(BUILD_DIR)/context_swap.o: task/context_swap.asm
	$(AS) $(ASFLAGS) $< -o $@

###### 链接 ######
main: $(OBJS)
	$(LD) $(^) -o $@

.PHONY: mk_dir clean all

mk_dir:
	if [ ! -d $(BUILD_DIR) ]; then mkdir $(BUILD_DIR);fi

clean:
	cd $(BUILD_DIR) && rm -f ./*

build: main

all:mk_dir build
