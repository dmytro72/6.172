// Copyright (c) 2015 MIT License by 6.172 Staff

#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <time.h>
#include <cilk/cilk.h>
#include "../cilktool/cilktool.h"

double get_time() {
  struct timeval t;
  struct timezone tzp;
  gettimeofday(&t, &tzp);
  return t.tv_sec + t.tv_usec*1e-6;
}

void transpose(double** A, int n) {
  cilk_for (int i = 0; i < n; i++) {
    for (int j = 0; j < i; j++) {
      double temp = A[i][j];
      A[i][j] = A[j][i];
      A[j][i] = temp;
    }
  }
}

void print(double** A, int n) {
  int i, j;
  for (i = 0; i < n; i++) {
    for (j = 0; j < n; j++) {
      printf("%4.0f ", A[i][j]);
    }
    printf("\n");
  }
}

int main(int argc, char* argv[]) {
  int n = 4;
  int printFlag = 1;

  if (argc > 1) {
    n = atoi(argv[1]);
    printFlag = 0;
  }
  if (argc > 2) {
    printFlag = atoi(argv[2]);
  }

  double* A[n];
  int i;
  for (i = 0; i < n; i++) {
    A[i] = (double*)malloc(sizeof(double) * n);
  }

  int j;
  double count = 0.0;
  for (i = 0; i < n; i++) {
    for (j = 0; j < n; j++) {
      A[i][j] = count;
      count += 1.0;
    }
  }


  double start_time, stop_time;
  if (printFlag == 1) {
    printf("Original:\n");
    print(A, n);
  }
  start_time = get_time();
  transpose(A, n);
  stop_time = get_time();
  if (printFlag == 1) {
    printf("Transposed:\n");
    print(A, n);
  }
  printf("Elapsed time: %fs\n", stop_time-start_time);
  #ifdef CILKSCALE
  print_total();
  #endif
  return 0;
}
