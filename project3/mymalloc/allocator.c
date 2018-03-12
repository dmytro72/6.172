/**
 * Copyright (c) 2015 MIT License by 6.172 Staff
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
#include <math.h>
#include "./allocator_interface.h"
#include "./memlib.h"

// Don't call libc malloc!
#define malloc(...) (USE_MY_MALLOC)
#define free(...) (USE_MY_FREE)
#define realloc(...) (USE_MY_REALLOC)
#define MAX(a,b) (((a)>(b))?(a):(b))

// All blocks must have a specified minimum alignment.
// The alignment requirement (from config.h) is >= 8 bytes.
#ifndef ALIGNMENT
  #define ALIGNMENT 8
#endif

// Rounds up to the nearest multiple of ALIGNMENT.
#define ALIGN(size) (((uint64_t)(size) + (ALIGNMENT-1)) & ~(ALIGNMENT-1))
#define ALIGN_POW(size) (pow(2, ceil(log(size)/log(2))))

// The smallest aligned size that will hold a size_t value.
#define SIZE_T_SIZE (ALIGN(sizeof(size_t)))

// Which power of 2 to start incrementing by powers
#define POW_START 6
#define POW_VALUE 1<<POW_START
#define INDEX_POW_START (int)((POW_VALUE) / 8) - 2
#define NUM_BINS 31 + INDEX_POW_START - POW_START

// check - This checks our invariant that the size_t header before every
// block points to either the beginning of the next block, or the end of the
// heap.
int my_check() {
  char* p;
  char* lo = (char*)mem_heap_lo();
  char* hi = (char*)mem_heap_hi() + 1;
  size_t size = 0;

  p = lo;
  while (lo <= p && p < hi) {
    size = ALIGN(*(size_t*)p + SIZE_T_SIZE);
    p += size;
  }

  if (p != hi) {
    printf("Bad headers did not end at heap_hi!\n");
    printf("heap_lo: %p, heap_hi: %p, size: %lu, p: %p\n", lo, hi, size, p);
    return -1;
  }

  return 0;
}

typedef struct free_list_t free_list_t;
struct free_list_t {
  free_list_t* next;
};

// Initialize binned free list with 31 bins
free_list_t* free_lists[NUM_BINS];

// Checks that every block in the free list does not exceed mem_heap_hi()
/*void check() {
  for (int i = 0; i < NUM_BINS; i++) {
    if (free_lists[i] != NULL) {
      if (i <= POW_START) {
        //int block = (i+2)*8;
        assert((char*)free_lists[i] + (i + 2) * 8 - 1 < mem_heap_hi() + 1);
      } else {
        //int block = pow(2,i);
        assert((char*)free_lists[i] + pow(2, i) - 1 < mem_heap_hi() + 1);
      }
    }
  }
}*/

// Given the size of a bin, determines its index in the free list
static int binned_list_index(size_t size) {
  int index;
  // The first 7 bins of the binned list are multiples of 8 (16 through 64)
  if (size < POW_VALUE) {
    index = (int)(size / 8) - 2;
  } else {
    // The rest of the bins are powers of 2, starting from 64
    index = (int)ceil(log(size) / log(2));
  }
  return index;
}

// init - Initialize the malloc package.  Called once before any other
// calls are made.
int my_init() {

  // Initial align
  void* brk = mem_heap_hi() + 1;
  int req_size = ALIGN(brk) - (uint64_t)brk;
  mem_sbrk(req_size);

  // Initialize array of free lists. Each free list is initialized to null.
  for (int i = 0; i < NUM_BINS; i++) {
    free_lists[i] = NULL;
  }
  return 0;
}

//  malloc - Allocate a block.
//  Always allocate a block whose size is a multiple of the alignment.
void* my_malloc(size_t size) {
  // We allocate a little bit of extra memory so that we can store the
  // size of the block we've allocated.  Take a look at realloc to see
  // one example of a place where this can come in handy.
  int aligned_size = ALIGN(size + SIZE_T_SIZE);

  // Determine what bin size we need to fit the requested size,
  // and find the free list that corresponds to this bin size.
  int index = binned_list_index(aligned_size);
  free_list_t* list = free_lists[index];

  // If that free list has a block in it, remove the first block of the free list
  // and return a pointer to it.
  if (list != NULL) {
    void* x = free_lists[index];
    free_lists[index] = free_lists[index]->next;
    // Store the size of the block in the first size_t bytes of the block.
    *(size_t*)x = size;
    // Return a pointer to the data, which is SIZE_T_SIZE bytes after the beginning of the block
    //printf("header 1 returned ptr: %u\n", x);
    return (void*)((char*)x + SIZE_T_SIZE);
  } else {
    // Otherwise, iterate through the free list until you find the next free list that has
    // an available block. We will then split that block.
    for (int i = index + 1; i < NUM_BINS; i++) {
      if (free_lists[i] != NULL) {
        // Split based on whether i < 6
        // If i > 6, you're breaking up a block that is a power of 2
        if (i > POW_START) {
          free_list_t* ptr = free_lists[i];

          // Remove the first block from the first non-empty free list found.
          free_lists[i] = free_lists[i]->next;

          // If we request a size x and the first block size n found is greater than 64,
          //  1. if x > 64, split n in half until we get the smallest bin large enough to fit x.
          //      e.g. if x = 78 and n = 512, we want to place x in a bin of size 128. We split n
          //      into two blocks of size 256. The first block of size 256 is put in a free list.
          //      The second block is split into two blocks of size 128, the first of which is put
          //      in a free list and the second of which is used to store x.
          //  2. if x > 64, split n in half until we get to a bin of size 64. Then we can split the
          //      block of size 64 into a block that is a multiple of 8 large enough to fit x, and the
          //      leftover block is stored in a free list. e.g. if x = 12 and n = 512, we want to place x
          //      in a bin of size 16. Then we split the block of size 512 as described above but continue
          //      until a block of size 64. Then the block of size 64 is split into a block of size 16,
          //      allocated for x, and the remaining block of size 64-16 = 48 is put in a free list.
          for (int j = i; j >= MAX(index + 1, POW_START + 1); j--) {
            ptr->next = free_lists[j - 1];
            free_lists[j - 1] = ptr;
            ptr = (free_list_t*)((char*)ptr + (int)pow(2, j - 1));

            // This accounts for case 1 above
            if (j == index) {
              // The first 8 bytes (header) store the size of the allocated block
              *(size_t*)ptr = size;
              //printf("header 2 returned size: %u\n", ptr);
              return (void*)((char*)ptr + SIZE_T_SIZE);
            }
          }

          // Otherwise, in case 2, we get to a block of size 64.
          ptr->next = free_lists[POW_START];
          free_lists[POW_START] = ptr;

          i = POW_START;
        }
        // This section of code is entered if
        // 1. The first free list block found was at an index of 6 or less (so a multiple of 8), or
        // 2. We finished the for loop above, which partitioned the larger free list block into powers
        //    of 2, and now have a block of size 64 that we need to split.
        // In either case, we have a block size n of 64 or less, and we want to allocate some size x.
        // Then we can split our block into sizes x and n-x. The block of size n-x is placed in a free list,
        // and the block of size x will be returned as the allocated space.

        // i indicates the index of the binned free list. First determine the block size of that index in the
        // binned free list.
        int block_size = (i + 2) * 8;

        // Remove the first element of the free list
        void* x = free_lists[i];
        free_lists[i] = free_lists[i]->next;

        // If the size to be allocated is 16 bytes or less smaller than the available free list block,
        // we can't split the free list block any farther (since the smallest block size in our binned
        // free list is 16). So we simply allocate that free list block.
        if (block_size - aligned_size < 16) {
          *(size_t*)x = size;
          //printf("header 3 returned ptr: %u\n", x);
          return (void*)((char*)x + SIZE_T_SIZE);
        }

        // Otherwise, split the free list block, add one of the split parts to a free list,
        // and allocate the other part as the returned pointer.
        free_list_t* new_head = (free_list_t*)((char*)x + aligned_size);
        unsigned int new_index = (unsigned int)((block_size - aligned_size) / 8) - 2;
        new_head->next = free_lists[new_index];
        free_lists[new_index] = new_head;
        *(size_t*)x = size;
        //printf("header 4 return ptr: %u\n", x);
        return (void*)((char*)x + SIZE_T_SIZE);
      }
    }
  }

  // Expands the heap by the given number of bytes and returns a pointer to
  // the newly-allocated area.  This is a slow call, so you will want to
  // make sure you don't wind up calling it on every malloc.

  if (aligned_size > POW_VALUE) {
    aligned_size = ALIGN_POW(aligned_size);
  }

  void* p = mem_sbrk(aligned_size);

  if (p == (void*) - 1) {
    // Whoops, an error of some sort occurred.  We return NULL to let
    // the client code know that we weren't able to allocate memory.
    return NULL;
  } else {
    // We store the size of the block we've allocated in the first
    // SIZE_T_SIZE bytes.
    *(size_t*)p = size;
    // Then, we return a pointer to the rest of the block of memory,
    // which is at least size bytes long.  We have to cast to char
    // before we try any pointer arithmetic because voids have no size
    // and so the compiler doesn't know how far to move the pointer.
    // Since a char is always one byte, adding SIZE_T_SIZE after
    // casting advances the pointer by SIZE_T_SIZE bytes.
    //printf("header 5 returned ptr: %u\n", p);
    return (void*)((char*)p + SIZE_T_SIZE);
  }
}

// free
void my_free(void* ptr) {

  // If the input pointer is NULL, do nothing.
  if (ptr == NULL) {
    return;
  }

  // The size of a block is stored in the header, which is the 8 bytes (SIZE_T_SIZE bytes) before the block.
  // Get this size.
  size_t* free_block = (size_t*)((char*)ptr - SIZE_T_SIZE);
  size_t size = *free_block;

  // Find the index of the free list according to the size. Note that we have to add SIZE_T_SIZE
  // because we include the 8 bytes of header in the block stored in a free list.
  int aligned_size = ALIGN(size + SIZE_T_SIZE);
  int index;
  index = binned_list_index(aligned_size);

  // Add the block to the relevant free list.
  free_list_t* block = (free_list_t*)free_block;
  block->next = free_lists[index];
  free_lists[index] = block;

}

// realloc - Implemented in terms of malloc and free, with some edge cases
void* my_realloc(void* ptr, size_t size) {

  // If pointer is NULL, just call malloc.
  if (ptr == NULL) {
    void* new_ptr = my_malloc(size);
    return new_ptr;
  }

  size_t copy_size;

  // Get the size of the old block of memory.  Take a peek at my_malloc(),
  // where we stashed this in the SIZE_T_SIZE bytes directly before the
  // address we returned.  Now we can back up by that many bytes and read
  // the size.
  copy_size = *(size_t*)((char*)ptr - SIZE_T_SIZE);

  // Determine the necessary bin size for the new requested size, and for the old size of the block.
  int new_bin, old_bin;
  size_t new_total_size = size + 8;
  new_bin = binned_list_index(new_total_size);
  old_bin = binned_list_index(copy_size);

  // If the bin sizes are the same, we don't need to malloc and memcpy. This means that the bin size
  // is already large enough, so we just return the same pointer. We make sure to change the header size.
  if (new_bin == old_bin) {
    *(size_t*)((char*)ptr - SIZE_T_SIZE) = size;
    return ptr;
  }

  size_t copy_size_aligned = ALIGN(copy_size + SIZE_T_SIZE);
  if (copy_size_aligned > POW_VALUE) {
    copy_size_aligned = ALIGN_POW(copy_size_aligned);
  }

  // If the ptr requested plus the original block size requested is at the end of the heap,
  // then instead of calling malloc again, we can just mem_sbrk the remaining required space.
//  printf("current ptr plus block size: %u\n", (char*)ptr + copy_size_aligned-8);
//  printf("mem heap hi: %u\n", (char*)mem_heap_hi());
  if (((char*)ptr + copy_size_aligned-8) == (char *)mem_heap_hi()+1) {
//    printf("hello\n");
    size_t aligned_size = ALIGN(size + SIZE_T_SIZE);
    if (aligned_size > 64) {
      aligned_size = ALIGN_POW(aligned_size);
    }
    *(size_t*)((uint8_t*)ptr-SIZE_T_SIZE) = aligned_size;
    mem_sbrk(aligned_size - copy_size_aligned);
    return ptr;
  }

  void* newptr;

  // Allocate a new chunk of memory, and fail if that allocation fails.
  newptr = my_malloc(size);
  if (NULL == newptr) {
    return NULL;
  }

  // If the new block is smaller than the old one, we have to stop copying
  // early so that we don't write off the end of the new block of memory.
  if (size < copy_size) {
    copy_size = size;
  }

  // This is a standard library call that performs a simple memory copy.
  memcpy(newptr, ptr, copy_size);

  // Release the old block.
  my_free(ptr);

  //printf("newptr after realloc: %u\n", newptr);
  // Return a pointer to the new block.
  return newptr;
}

// call mem_reset_brk.
void my_reset_brk() {
  mem_reset_brk();
}

// call mem_heap_lo
void* my_heap_lo() {
  return mem_heap_lo();
}

// call mem_heap_hi
void* my_heap_hi() {
  return mem_heap_hi();
}
