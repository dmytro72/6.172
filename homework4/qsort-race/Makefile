#
# Makefile for the qsort-race example.
#

CC = clang
CFLAGS = -Wall -std=gnu99 -O1 -g -ftapir
LDFLAGS = -ldl -lcilkrts

TARGET = qsort-race
SRC = qsort-race.c

include ../cilktool/cilkutils.mk

.PHONY: all clean
  
all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) -o $@ $(CFLAGS) $^ $(LDFLAGS)

clean::
	rm -f $(TARGET)
