// Copyright (c) 2012 MIT License by 6.172 Staff

#include "./allocator_interface.h"

/* Libc needs no initialization. */
int libc_init() {
  return 0;
}

/* Libc has no heap checker, so we just return true. */
int libc_check() {
  return 0;
}

/* Libc can't be reset. */
void libc_reset_brk() {
}

/* Return NULL for the minimum pointer value.*/
void * libc_heap_lo() {
  return NULL;
}

/* Return NULL.
   This probably isn't portable. */
void * libc_heap_hi() {
  return NULL;
}

/*call default malloc */
void * libc_malloc(size_t size) {
  return malloc(size);
}

/*call default realloc */
void * libc_realloc(void *ptr, size_t size) {
  return realloc(ptr, size);
}

/*call default realloc */
void libc_free(void *ptr) {
  free(ptr);
}
