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
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include "./allocator_interface.h"
#include "./memlib.h"

// Don't call libc malloc!
#define malloc(...) (USE_WRAPPED_MALLOC)
#define free(...) (USE_WRAPPED_FREE)
#define realloc(...) (USE_WRAPPED_REALLOC)

typedef struct used_header_t {
   size_t size;
} used_header_t;
#define HEADER_T_SIZE (ALLOC_ALIGN(sizeof(used_header_t)))

int wrapped_check() {
   /* unused */
  return 1;
}

// init - Initialize the malloc package.  Called once before any other
// calls are made.  Since this is a very simple implementation, we just
// return success.
int wrapped_init() {
  return 0;
}

void * unaligned_malloc(size_t size) {
  int aligned_size = ALLOC_ALIGN(size + HEADER_T_SIZE);

  // Expands the heap by the given number of bytes and returns a pointer to
  // the newly-allocated area.  This is a slow call, so you will want to
  // make sure you don't wind up calling it on every malloc.
  void *p = mem_sbrk(aligned_size);

  if (p == (void *)-1) {
    // Whoops, an error of some sort occurred.  We return NULL to let
    // the client code know that we weren't able to allocate memory.
    return NULL;
  } else {
    // We store the size of the block we've allocated in the first
    // HEADER_T_SIZE bytes.
    ((used_header_t*)p)->size = size;

    // Then, we return a pointer to the rest of the block of memory,
    // which is at least size bytes long.  We have to cast to uint8_t
    // before we try any pointer arithmetic because voids have no size
    // and so the compiler doesn't know how far to move the pointer.
    // Since a uint8_t is always one byte, adding HEADER_T_SIZE after
    // casting advances the pointer by HEADER_T_SIZE bytes.
    return (void *)((char *)p + HEADER_T_SIZE);
  }
}

//  malloc - Allocate a block by incrementing the brk pointer.
//  Always allocate a block whose size is a multiple of the alignment.
void * wrapped_malloc(size_t size) {
  void *p = unaligned_malloc(size + CACHE_ALIGNMENT);
  p = CACHE_ALIGN(p);
  
  if (p) {
    ((used_header_t*)p)->size = size;
  }
  /* YOUR CODE HERE */
  /*
  * Don't worry about not being able to free() this object properly!
  */
  return p;
}

// free - Freeing a block does nothing.
void wrapped_free(void *ptr) {
}

// realloc - Implemented simply in terms of malloc and free
void * wrapped_realloc(void *ptr, size_t size) {
  // not used in this assignment
  return NULL;
}

// call mem_reset_brk.
void wrapped_reset_brk() {
  mem_reset_brk();
}

// call mem_heap_lo
void * wrapped_heap_lo() {
  return mem_heap_lo();
}

// call mem_heap_hi
void * wrapped_heap_hi() {
  return mem_heap_hi();
}
