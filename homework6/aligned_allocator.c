/**
 * Copyright (c) 2012 MIT License by 6.172 Staff
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to
 * deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
 * sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 **/

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>

#include "./allocator_interface.h"
#include "./memlib.h"

// Don't call libc malloc!
#define malloc(...) (USE_ALIGNED_MALLOC)
#define free(...) (USE_ALIGNED_FREE)
#define realloc(...) (USE_ALIGNED_REALLOC)

typedef struct used_header_t {
   size_t size;
} used_header_t;
#define HEADER_T_SIZE (ALLOC_ALIGN(sizeof(used_header_t)))

// aligned_init - Does nothing.
int aligned_init() {
  return 0;
}

// aligned_check - No checker.
int aligned_check() {
  return 1;
}

// aligned_malloc - Allocate a block by incrementing the brk pointer.
void * aligned_malloc(size_t size) {
  int aligned_size = ALLOC_ALIGN(size + HEADER_T_SIZE); // Uncomment this when ready
  unsigned int offset = CACHE_ALIGNMENT - ((uint64_t)mem_heap_hi() + 1)%64;
  void *p1 = mem_sbrk(aligned_size + offset);
  void *p = CACHE_ALIGN(p1 + HEADER_T_SIZE);
  used_header_t *hdr = p - HEADER_T_SIZE;
  if (p) 
    hdr->size = size;
  return p;
}

void
aligned_free(void* p) {
   /* no-op */
}

void * aligned_realloc(void *ptr, size_t size) {
  /* no-op if same size! */
  return ptr;
}

// call mem_reset_brk.
void aligned_reset_brk() {
  mem_reset_brk();
}

// call mem_heap_lo
void * aligned_heap_lo() {
  return mem_heap_lo();
}

// call mem_heap_hi
void * aligned_heap_hi() {
  return mem_heap_hi();
}
