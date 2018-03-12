#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>

// Simple base-case method that computes the nth Fibonacci number
// iteratively.
__attribute__((always_inline))
int fib_base(int n) {
  if (n < 2) return n;
  int x0 = 0, x1 = 1;
  for (int i = 2; i < n; ++i) {
    int tmp = x0;
    x0 = x1;
    x1 += tmp;
  }
  return x0 + x1;
}

// Exponential-time recursive function to compute the nth Fibonacci
// number.  This function switches to fib_base when n becomes smaller
// than the base-case size, which is assumed to be at least 2.
int fib(int n, int base) {
  if (n < base) return fib_base(n);
  int x, y;
  x = fib(n - 1, base);
  y = fib(n - 2, base);
  return (x + y);
}

int main(int argc, char *argv[]) {
  int n = 38;
  int base = 37;

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
