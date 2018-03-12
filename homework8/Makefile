# Copyright (c) 2013 MIT License by 6.172 Staff
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.

CC := gcc
CFLAGS := -Wall -std=c99 -gdwarf-3 -D_POSIX_C_SOURCE=200809L
LDFLAGS := -lrt

TARGETS = matrix_multiply_nested_loops matrix_multiply_test matrix_multiply_cache_oblivious

ifeq ($(DEBUG),1)
	CFLAGS += -O1 # -O0 segfaults in rand_r?!
else
	CFLAGS += -O3 -DNDEBUG
endif

CFLAGS += $(OTHER_CFLAGS)
LDFLAGS := -lrt

all: $(TARGETS)

matrix_multiply_nested_loops: matrix_multiply.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DSIMPLE -o $@ $<

matrix_multiply_cache_oblivious: matrix_multiply.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DCACHE_OBLIVIOUS -o $@ $<

matrix_multiply_test: matrix_multiply.c
	$(CC) $(CFLAGS) $(LDFLAGS) -DTEST -o $@ $<

clean:
	rm -f $(TARGETS)
