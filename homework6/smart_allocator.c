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
#define malloc(...) (USE_SMART_MALLOC)
#define free(...) (USE_SMART_FREE)
#define realloc(...) (USE_SMART_REALLOC)

typedef struct free_list_t {
  struct free_list_t* next;
} free_list_t;

relocate_callback_t relocate_callback = NULL;
void* relocate_state = NULL;
void smart_register_relocate_callback(relocate_callback_t f, void* state)
{
  relocate_callback = f;
  relocate_state = state;
}

free_list_t* free32;
free_list_t* free64;

int smart_init() {
  void *brk = mem_heap_hi() + 1;
  int req_size = CACHE_ALIGN(brk) - (uint64_t)brk;
  mem_sbrk(req_size);
  /* align brk just once */

  free32 = NULL;
  free64 = NULL;

  relocate_callback = NULL;

  return 0;
}

void * alloc_aligned(size_t size) {
  if (size > SMALL_SIZE) {
    assert(size <= LARGE_SIZE);
    /* may need to alloc straight to free32 */
    void *brk = mem_heap_hi() + 1;
    if (!ALIGNED(brk, LARGE_SIZE)) {
       /* YOUR CODE HERE */
      void *small = mem_sbrk(CACHE_ALIGN(brk) - (uint64_t)brk);
      free_list_t** head = &free32;
      free_list_t* fn = (free_list_t*)small;
      fn->next = *head;
      *head = fn;
    }
    size = LARGE_SIZE;
  } else {
    size = SMALL_SIZE;
  }

  void *p = mem_sbrk(size);
  assert(ALIGNED(p, size));

  if (p == (void *)-1) {
    return NULL;
  }
  return p;
}

int smart_check() {
  return 1;
}

void* smart_malloc(size_t size) {
  void* p = NULL;
  /* YOUR CODE HERE */
  if (size > SMALL_SIZE) {
    if (free64 != NULL) {
      void* x = free64;
      free64 = free64->next;
      return x;
    }
  } else {
    if (free32 != NULL) {
      void* x = free32;
      free32 = free32->next;
      return x;
    }
  }

  p = alloc_aligned(size);

  if (p == (void *)-1) {
    // Whoops, an error of some sort occurred.  We return NULL to let
    // the client code know that we weren't able to allocate memory.
    return NULL;
  }

  // Don't forget to mark p's size?
  return p;
}

void smart_free(void* p) {
  /* add to free list with different size now! */
  free_list_t** head;
  if (IS_SMALL(p)) {
    head = &free32;
  } else {
    head = &free64;
  }

  free_list_t* fn = SMART_PTR(p);
  fn->next = *head;
  *head = fn;
}

// realloc - Implemented simply in terms of malloc and free
void * smart_realloc(void *ptr, size_t size) {
  // not used in this assignment
  return NULL;
}

// call mem_reset_brk.
void smart_reset_brk() {
  mem_reset_brk();
}

// call mem_heap_lo
void * smart_heap_lo() {
  return mem_heap_lo();
}

// call mem_heap_hi
void * smart_heap_hi() {
  return mem_heap_hi();
}
