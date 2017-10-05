CC := clang

CFLAGS := -std=gnu99 -ftapir -Wall

ifeq ($(DEBUG),1)
	CFLAGS += -O0 -g -gdwarf-3
else
	CFLAGS += -O3 -g -DNDEBUG
endif

LDFLAGS := -lrt -lm -lcilkrts

include ../cilktool/cilkutils.mk

all: queens

board.o: board.c 
	$(CC) $(CFLAGS) -c board.c 

queens.o: queens.c
	$(CC) $(CFLAGS) -c queens.c 

queens: board.o queens.o
	$(CC) -o queens board.o queens.o $(LDFLAGS)

clean:
	rm -f queens *.o
