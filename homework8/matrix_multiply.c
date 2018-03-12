// Copyright (c) 2015 MIT License by 6.172 Staff

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "./fasttime.h"

typedef int data_t;

// The dimensions of the matrices are powers of 2.
#define DIMENSION (1 << 8)

// The size of the matrix, in memory.
#define MATRIX_DATA_SIZE (DIMENSION * DIMENSION * sizeof(data_t))

// For generating random matricies.
#define LIMIT 100
unsigned int random_seed = 0;

// The base case of the cache-oblivious algorithm.
#ifndef BASE_CASE
  #define BASE_CASE 8
#endif

data_t matrix_a[DIMENSION * DIMENSION];
data_t matrix_b[DIMENSION * DIMENSION];
data_t matrix_c_nested_loops[DIMENSION * DIMENSION];
data_t matrix_c_cache_oblivious[DIMENSION * DIMENSION];

// Given a row and column, generates the index into the matrix for the
// appropriate element.
inline size_t index(size_t row, size_t column) {
  return row * DIMENSION + column;
}

// A helper function for printing matrices, for debugging.
void print_matrix(data_t* matrix) {
  for (size_t row = 0; row < DIMENSION; row++) {
    printf("%d", matrix[index(row, 0)]);
    for (size_t column = 1; column < DIMENSION; column++) {
      printf(" %d", matrix[index(row, column)]);
    }
    printf("\n");
  }
}

// Does (length x length) matrix multiplication, on the submatrices a, b, and c.
void matrix_multiply_nested_loops_internal(data_t* a,
                                           data_t* b,
                                           data_t* c,
                                           size_t length) {
  // Naive matrix multiply.
  for (size_t row = 0; row < length; row++) {
    for (size_t column = 0; column < length; column++) {
      for (size_t i = 0; i < length; i++) {
        c[index(row, column)] += a[index(row, i)] * b[index(i, column)];
      }
    }
  }
}

// Does matrix multiplication, using the nested loops method.
void matrix_multiply_nested_loops(data_t* a, data_t* b, data_t* c) {
  // Clear all the entries of c to zero.
  memset(c, 0, MATRIX_DATA_SIZE);

  matrix_multiply_nested_loops_internal(a, b, c, DIMENSION);
}

// Does (length x length) matrix multiplication, on the submatrices a, b, and c.
void matrix_multiply_cache_oblivious_internal(data_t* a,
                                              data_t* b,
                                              data_t* c,
                                              size_t length) {
  if (length < BASE_CASE) {
    for (int row = 0; row < length; row++) {
      for (int column = 0; column < length; column++) {
        for (int i = 0; i < length; i++) {
          c[index(row, column)] += a[index(row, i)] * b[index(i, column)];
        }
      }
    }
    return;
  }

  size_t d11 = 0;
  size_t d12 = length / 2;
  size_t d21 = (length / 2) * DIMENSION;
  size_t d22 = (length / 2) * (DIMENSION + 1);

  matrix_multiply_cache_oblivious_internal(a + d11, b + d11, c + d11, length / 2);
  matrix_multiply_cache_oblivious_internal(a + d12, b + d21, c + d11, length / 2);
  matrix_multiply_cache_oblivious_internal(a + d11, b + d12, c + d12, length / 2);
  matrix_multiply_cache_oblivious_internal(a + d12, b + d22, c + d12, length / 2);
  matrix_multiply_cache_oblivious_internal(a + d21, b + d11, c + d21, length / 2);
  matrix_multiply_cache_oblivious_internal(a + d22, b + d21, c + d21, length / 2);
  matrix_multiply_cache_oblivious_internal(a + d21, b + d12, c + d22, length / 2);
  matrix_multiply_cache_oblivious_internal(a + d22, b + d22, c + d22, length / 2);
}

// Does matrix multiplication, using a cache-oblivious algorithm.
void matrix_multiply_cache_oblivious(data_t* a, data_t* b, data_t* c) {
  memset(c, 0, MATRIX_DATA_SIZE);

  matrix_multiply_cache_oblivious_internal(a, b, c, DIMENSION);
}

int main() {
  // Initialize matrices with random data.
  for (size_t row = 0; row < DIMENSION; row++) {
    for (size_t column = 0; column < DIMENSION; column++) {
      matrix_a[index(row, column)] = rand_r(&random_seed) % LIMIT;
      matrix_b[index(row, column)] = rand_r(&random_seed) % LIMIT;
    }
  }

  // Variables for timing measurements.
  fasttime_t start_time, end_time;
  float elapsed;

#if defined TEST || defined SIMPLE
  // Measure the time for nested_loops matrix multiply.
  start_time = gettime();
  matrix_multiply_nested_loops(matrix_a, matrix_b, matrix_c_nested_loops);
  end_time = gettime();
  elapsed = tdiff(start_time, end_time);
  printf("Matrix multiply nested_loops: %f seconds.\n", elapsed);
#endif

#if defined TEST || defined CACHE_OBLIVIOUS
  // Measure the time for cache_oblivious matrix multiply.
  start_time = gettime();
  matrix_multiply_cache_oblivious(matrix_a, matrix_b, matrix_c_cache_oblivious);
  end_time = gettime();
  elapsed = tdiff(start_time, end_time);
  printf("Matrix multiply cache_oblivious: %f seconds.\n", elapsed);
#endif

#if defined TEST
  printf("Testing for correctness of cache_oblivious: ...\n");

  // Checking for correctness of the cache-oblivious algorithm.
  if (memcmp(matrix_c_nested_loops, matrix_c_cache_oblivious, MATRIX_DATA_SIZE) == 0) {
    printf("\033[1;32mPASS\033[m\n");
  } else {
    printf("\033[1;31mFAIL\033[m\n");
  }
#endif

  return 0;
}
