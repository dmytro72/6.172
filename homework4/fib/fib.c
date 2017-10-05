// Copyright (c) 2015 MIT License by 6.172 Staff

#include <stdio.h>
#include <stdlib.h>

#include <cilk/cilk.h>
#include "../cilktool/cilktool.h"

int fib(int n) {
  if (n < 2) {
    return n;
  }

  if (n < 10) {
    return fib(n-1) + fib(n-2);  
  }

  int x, y;
  x = cilk_spawn fib(n-1);
  y = fib(n-2);
  cilk_sync;
  return x + y;
}

int main(int argc, char* argv[]) {
  int n = 10;

  if (argc > 1) {
    n = atoi(argv[1]);
  }

  int result = fib(n);
  printf("fib(%d)=%d\n", n, result);

  #ifdef CILKSCALE
    print_total();
  #endif
  return 0;
}
