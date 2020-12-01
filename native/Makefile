# force it to x86
CC = gcc
AS = as
CFLAGS = -Wall -Og -g

# make 1000% sure our CC is not an ARM compiler
%.o: %.c
	@$(CC) -dumpmachine | grep -q x86_64
	$(CC) $(CFLAGS) -c -o $@ $<

test-x86: driver.o testfn.o	
	@$(CC) -dumpmachine | grep -q x86_64
	$(CC) -lbsd -o test-x86 $^

run: test-x86
	./test-x86 testdata

clean:
	rm *.o test-x86

.PHONY: clean run
