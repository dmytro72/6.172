#include <assert.h>
#include <cilk/cilk.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>

// Exponential-time recursive function to compute the nth Fibonacci
// number.  This function spawns recursive calls to fib until n is
// smaller than the specified base-case size, at which point it
// replaces the spawn with a simple recursive call.
int fib(int n, int base) {
  if (n < 2) return n;
  int x, y;
  if (n < base)
    x = fib(n - 1, base);
  else
    x = cilk_spawn fib(n - 1, base);
  y = fib(n - 2, base);
  cilk_sync;
  return (x + y);
}

int main(int argc, char *argv[]) {
  int n = 35;
  int base = 2;

  // Parse the first command-line argument to be the Fibonacci number
  // to compute.
  if (argc > 1)
    n = atoi(argv[1]);
  // Parse the second command-line argument to be the base-case size
  // to use.
  if (argc > 2)
    base = atoi(argv[2]);
  
  struct timespec start;
  clock_gettime(CLOCK_MONOTONIC, &start);
  int r = fib(n, base);
  struct timespec end;
  clock_gettime(CLOCK_MONOTONIC, &end);

  double tdiff = (end.tv_sec - start.tv_sec) + pow(10,-9)*(end.tv_nsec - start.tv_nsec);
 
  printf("time in fib: %f seconds\n", tdiff);
  printf("fib(%d) = %d\n", n, r);
  return 0;
}
