# %.o: %.s
# 	$(AS) -c -target arm-unknown-linux-gnueabi $^
ASFLAGS = --gstabs

test-arm: main.o q1.o
	$(CC) -o test-arm $^

run-gdb: test-arm
	qemu-arm -g 12345 test-arm

gdb:
	arm-unknown-linux-gnueabi-gdb

run: test-arm
	qemu-arm test-arm

clean:
	rm *.o test-arm

.PHONY: clean run run-gdb gdb
