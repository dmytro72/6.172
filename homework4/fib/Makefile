CC := clang
CFLAGS := -Wall -O3 -g -gdwarf-3 -ftapir
LDFLAGS := -lcilkrts -ldl

TARGET := fib
SRC := fib.c

include ../cilktool/cilkutils.mk

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) -o $@ $(CFLAGS) $^ $(LDFLAGS)



clean::
	rm -f $(TARGET)
