#include <stdio.h>

#include "./allocator_interface.h"
#include "./fasttime.h"
#include "./memlib.h"

#define NUM_ALLOCS 17
#define NUM_ITERATIONS 1 << 17

const malloc_impl_t* mem_impl;
int verbose = 0;

int main() {
  mem_init();

  mem_impl = &my_impl;
  mem_impl->init();

  void* allocs[NUM_ALLOCS];

  fasttime_t begin = gettime();
  for (int iter = 0; iter < NUM_ITERATIONS; iter++) {
    for (int i = 0; i < NUM_ALLOCS; i++) {
      allocs[i] = mem_impl->malloc(1 << i);
    }
    for (int i = 0; i < NUM_ALLOCS; i++) {
      mem_impl->free(allocs[i]);
    }
  }
  fasttime_t end = gettime();

  mem_deinit();

  printf("total runtime: %fs\n", tdiff(begin, end));
  printf("total mem usage: %d bytes\n", (int)mem_heapsize());
}
