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
#define malloc(...) (USE_FIXED_MALLOC)
#define free(...) (USE_FIXED_FREE)
#define realloc(...) (USE_FIXED_REALLOC)

typedef struct free_list_t {
   struct free_list_t* next;
} free_list_t;

free_list_t *free_list;

int fixed_init() {
  // reset free list
  free_list = NULL;

  /* YOUR CODE HERE */
  // Align the cache line
  void *heap_address = (uint64_t)mem_heap_hi() + 1;
  mem_sbrk(CACHE_ALIGNMENT - (uint64_t)heap_address%CACHE_ALIGNMENT);

  return 0;
}

// fixed_check - No checker.
int fixed_check() {
  return 1;
}

// fixed_malloc - check free list, or allocate a cache-aligned fixed block
void * fixed_malloc(size_t size) {
  void * p = NULL;
  assert(size <= FIXED_SIZE);

  /* YOUR CODE HERE */
  if (free_list != NULL) {
    void* x = free_list;
    free_list = free_list->next;
    return x;
  }

  p = mem_sbrk(FIXED_SIZE);

  if (p == (void *) -1) {
    // The heap is probably full, so return NULL.
    return NULL;
  } else {
    return p;
  }
}

void fixed_free(void* p) {
  /* YOUR CODE HERE */
  ((free_list_t*)p)->next = free_list;
  free_list = (free_list_t*) p;
}

void * fixed_realloc(void *ptr, size_t size) {
  /* no-op if same size! */
  return ptr;
}

// call mem_reset_brk.
void fixed_reset_brk() {
  mem_reset_brk();
}

// call mem_heap_lo
void * fixed_heap_lo() {
  return mem_heap_lo();
}

// call mem_heap_hi
void * fixed_heap_hi() {
  return mem_heap_hi();
}
