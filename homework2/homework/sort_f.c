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


#include "./util.h"

// Function prototypes
static inline void merge_f(data_t *A, int p, int q, int r, data_t * right);
static void copy_f(data_t * source, data_t * dest, int n);
static void isort(data_t *begin, data_t *end);
void sort_f_wrapper(data_t *A, int p, int r, data_t * right);

void sort_f(data_t *A, int p, int r) {
  data_t * right = 0;
  int q = (p + r) / 2;
  mem_alloc(&right, q + 1);

  sort_f_wrapper(A, p, r, right);

  mem_free(&right);
}

void sort_f_wrapper(data_t *A, int p, int r, data_t * right) {
  assert(A);
  if (p < r) {
    int q = (p + r) / 2;
    // Use insertion sort if subarray size <= 40
    if (q <= 40) {
      isort(A + p, A + q);  
    } else {
      sort_f_wrapper(A, p, q, right);
    }
    if (r - q - 1 <= 40) {
      isort(A + q + 1, A + r);
    } else {
      sort_f_wrapper(A, q + 1, r, right);
    }
    merge_f(A, p, q, r, right);
  }
}

// A merge routine. Merges the sub-arrays A [p..q] and A [q + 1..r].
// Uses two arrays 'left' and 'right' in the merge operation.
static inline void merge_f(data_t *A, int p, int q, int r, data_t * right) {
  assert(A);
  assert(p <= q);
  assert((q + 1) <= r);
  int n2 = r - q;

  // if (right == NULL) {
    // mem_free(&right);
    // return;
  // }

  copy_f((A + q + 1), right, n2);
  *(right + n2) = UINT_MAX;

  data_t * left = A + p;
  data_t * right_pointer = right;

  for (int k = p; k <= r; k++) {
    if (*(left) <= *(right_pointer)) { 
      *(A + k) = *(left);
      left++;
    } else {
      // Swap val into temp
      data_t temp = *(A + k);
      *(A + k) = *(right_pointer);
      *(right_pointer) = temp;
      // right_pointer++;
    }
  }
}

static void copy_f(data_t * source, data_t * dest, int n) {
  assert(dest);
  assert(source);

  for (int i = 0 ; i < n ; i++) {
    *(dest + i) = *(source + i);
  }
}

// Insertion sort between begin and end inclusive
static void isort(data_t *begin, data_t *end) {
  data_t *cur = begin + 1;
  while (cur <= end) {
    data_t val = *cur;
    data_t *index = cur - 1;

    while (index >= begin && *index > val) {
      *(index + 1) = *index;
      index--;
    }

    *(index + 1) = val;
    cur++;
  }
}

