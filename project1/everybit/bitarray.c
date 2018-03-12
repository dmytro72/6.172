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

// Implements the ADT specified in bitarray.h as a packed array of bits; a bit
// array containing bit_sz bits will consume roughly bit_sz/8 bytes of
// memory.

#include "./bitarray.h"

#include <assert.h>
#include <stdbool.h>
#include <stdlib.h>
#include <stdint.h>

#include <sys/types.h>
#include <stdio.h>

// ********************************* Types **********************************

// Concrete data type representing an array of bits.
struct bitarray {
  // The number of bits represented by this bit array.
  // Need not be divisible by 64.
  size_t bit_sz;

  // The underlying memory buffer that stores the bits in
  // packed form (8 per byte).
  uint64_t* buf;
};

static const unsigned char ReverseByteLookupTable[] = {
  0x00, 0x80, 0x40, 0xC0, 0x20, 0xA0, 0x60, 0xE0, 0x10, 0x90, 0x50, 0xD0, 0x30, 0xB0, 0x70, 0xF0,
  0x08, 0x88, 0x48, 0xC8, 0x28, 0xA8, 0x68, 0xE8, 0x18, 0x98, 0x58, 0xD8, 0x38, 0xB8, 0x78, 0xF8,
  0x04, 0x84, 0x44, 0xC4, 0x24, 0xA4, 0x64, 0xE4, 0x14, 0x94, 0x54, 0xD4, 0x34, 0xB4, 0x74, 0xF4,
  0x0C, 0x8C, 0x4C, 0xCC, 0x2C, 0xAC, 0x6C, 0xEC, 0x1C, 0x9C, 0x5C, 0xDC, 0x3C, 0xBC, 0x7C, 0xFC,
  0x02, 0x82, 0x42, 0xC2, 0x22, 0xA2, 0x62, 0xE2, 0x12, 0x92, 0x52, 0xD2, 0x32, 0xB2, 0x72, 0xF2,
  0x0A, 0x8A, 0x4A, 0xCA, 0x2A, 0xAA, 0x6A, 0xEA, 0x1A, 0x9A, 0x5A, 0xDA, 0x3A, 0xBA, 0x7A, 0xFA,
  0x06, 0x86, 0x46, 0xC6, 0x26, 0xA6, 0x66, 0xE6, 0x16, 0x96, 0x56, 0xD6, 0x36, 0xB6, 0x76, 0xF6,
  0x0E, 0x8E, 0x4E, 0xCE, 0x2E, 0xAE, 0x6E, 0xEE, 0x1E, 0x9E, 0x5E, 0xDE, 0x3E, 0xBE, 0x7E, 0xFE,
  0x01, 0x81, 0x41, 0xC1, 0x21, 0xA1, 0x61, 0xE1, 0x11, 0x91, 0x51, 0xD1, 0x31, 0xB1, 0x71, 0xF1,
  0x09, 0x89, 0x49, 0xC9, 0x29, 0xA9, 0x69, 0xE9, 0x19, 0x99, 0x59, 0xD9, 0x39, 0xB9, 0x79, 0xF9,
  0x05, 0x85, 0x45, 0xC5, 0x25, 0xA5, 0x65, 0xE5, 0x15, 0x95, 0x55, 0xD5, 0x35, 0xB5, 0x75, 0xF5,
  0x0D, 0x8D, 0x4D, 0xCD, 0x2D, 0xAD, 0x6D, 0xED, 0x1D, 0x9D, 0x5D, 0xDD, 0x3D, 0xBD, 0x7D, 0xFD,
  0x03, 0x83, 0x43, 0xC3, 0x23, 0xA3, 0x63, 0xE3, 0x13, 0x93, 0x53, 0xD3, 0x33, 0xB3, 0x73, 0xF3,
  0x0B, 0x8B, 0x4B, 0xCB, 0x2B, 0xAB, 0x6B, 0xEB, 0x1B, 0x9B, 0x5B, 0xDB, 0x3B, 0xBB, 0x7B, 0xFB,
  0x07, 0x87, 0x47, 0xC7, 0x27, 0xA7, 0x67, 0xE7, 0x17, 0x97, 0x57, 0xD7, 0x37, 0xB7, 0x77, 0xF7,
  0x0F, 0x8F, 0x4F, 0xCF, 0x2F, 0xAF, 0x6F, 0xEF, 0x1F, 0x9F, 0x5F, 0xDF, 0x3F, 0xBF, 0x7F, 0xFF
};

static const uint64_t Mask1LookupTable[] = {
  0x0, 0xfffffffffffffffe, 0xfffffffffffffffc, 0xfffffffffffffff8, 0xfffffffffffffff0, 0xffffffffffffffe0,
  0xffffffffffffffc0, 0xffffffffffffff80, 0xffffffffffffff00, 0xfffffffffffffe00, 0xfffffffffffffc00,
  0xfffffffffffff800, 0xfffffffffffff000, 0xffffffffffffe000, 0xffffffffffffc000, 0xffffffffffff8000,
  0xffffffffffff0000, 0xfffffffffffe0000, 0xfffffffffffc0000, 0xfffffffffff80000, 0xfffffffffff00000,
  0xffffffffffe00000, 0xffffffffffc00000, 0xffffffffff800000, 0xffffffffff000000, 0xfffffffffe000000,
  0xfffffffffc000000, 0xfffffffff8000000, 0xfffffffff0000000, 0xffffffffe0000000, 0xffffffffc0000000,
  0xffffffff80000000, 0xffffffff00000000, 0xfffffffe00000000, 0xfffffffc00000000, 0xfffffff800000000,
  0xfffffff000000000, 0xffffffe000000000, 0xffffffc000000000, 0xffffff8000000000, 0xffffff0000000000,
  0xfffffe0000000000, 0xfffffc0000000000, 0xfffff80000000000, 0xfffff00000000000, 0xffffe00000000000,
  0xffffc00000000000, 0xffff800000000000, 0xffff000000000000, 0xfffe000000000000, 0xfffc000000000000,
  0xfff8000000000000, 0xfff0000000000000, 0xffe0000000000000, 0xffc0000000000000, 0xff80000000000000,
  0xff00000000000000, 0xfe00000000000000, 0xfc00000000000000, 0xf800000000000000, 0xf000000000000000,
  0xe000000000000000, 0xc000000000000000, 0x8000000000000000
};

static const uint64_t Mask2LookupTable[] = {
  0x0, 0x8000000000000000, 0xc000000000000000, 0xe000000000000000, 0xf000000000000000, 0xf800000000000000,
  0xfc00000000000000, 0xfe00000000000000, 0xff00000000000000, 0xff80000000000000, 0xffc0000000000000,
  0xffe0000000000000, 0xfff0000000000000, 0xfff8000000000000, 0xfffc000000000000, 0xfffe000000000000,
  0xffff000000000000, 0xffff800000000000, 0xffffc00000000000, 0xffffe00000000000, 0xfffff00000000000,
  0xfffff80000000000, 0xfffffc0000000000, 0xfffffe0000000000, 0xffffff0000000000, 0xffffff8000000000,
  0xffffffc000000000, 0xffffffe000000000, 0xfffffff000000000, 0xfffffff800000000, 0xfffffffc00000000,
  0xfffffffe00000000, 0xffffffff00000000, 0xffffffff80000000, 0xffffffffc0000000, 0xffffffffe0000000,
  0xfffffffff0000000, 0xfffffffff8000000, 0xfffffffffc000000, 0xfffffffffe000000, 0xffffffffff000000,
  0xffffffffff800000, 0xffffffffffc00000, 0xffffffffffe00000, 0xfffffffffff00000, 0xfffffffffff80000,
  0xfffffffffffc0000, 0xfffffffffffe0000, 0xffffffffffff0000, 0xffffffffffff8000, 0xffffffffffffc000,
  0xffffffffffffe000, 0xfffffffffffff000, 0xfffffffffffff800, 0xfffffffffffffc00, 0xfffffffffffffe00,
  0xffffffffffffff00, 0xffffffffffffff80, 0xffffffffffffffc0, 0xffffffffffffffe0, 0xfffffffffffffff0,
  0xfffffffffffffff8, 0xfffffffffffffffc, 0xfffffffffffffffe
};

// ******************** Prototypes for static functions *********************

// Portable modulo operation that supports negative dividends.
//
// Many programming languages define modulo in a manner incompatible with its
// widely-accepted mathematical definition.
// http://stackoverflow.com/questions/1907565/c-python-different-behaviour-of-the-modulo-operation
// provides details; in particular, C's modulo
// operator (which the standard calls a "remainder" operator) yields a result
// signed identically to the dividend e.g., -1 % 10 yields -1.
// This is obviously unacceptable for a function which returns size_t, so we
// define our own.
//
// n is the dividend and m is the divisor
//
// Returns a positive integer r = n (mod m), in the range
// 0 <= r < m.
static size_t modulo(const ssize_t n, const size_t m);

static inline void reverse(bitarray_t* const bitarray, const size_t bit_offset,
                           const size_t bit_length);

static inline void reverse_64bit(bitarray_t* const bitarray, const size_t bit_offset,
                                 const size_t bit_length);

static inline void bitarray_set_64bit(bitarray_t* const bitarray,
                                      const size_t bit_index,
                                      const uint64_t value);

static inline uint64_t bitarray_get_64bit(const bitarray_t* const bitarray, const size_t bit_index);

static inline uint64_t reverse_bitstring(uint64_t b);

static void print(uint64_t n);


// ******************************* Functions ********************************

bitarray_t* bitarray_new(const size_t bit_sz) {
  // Allocate an underlying buffer of ceil(bit_sz/64) bytes.
  uint64_t* const buf = calloc(8, (bit_sz >> 6) + (((bit_sz & 63) == 0) ? 0 : 1));
  if (buf == NULL) {
    return NULL;
  }

  // Allocate space for the struct.
  bitarray_t* const bitarray = malloc(sizeof(struct bitarray));
  if (bitarray == NULL) {
    free(buf);
    return NULL;
  }

  bitarray->buf = buf;
  bitarray->bit_sz = bit_sz;
  return bitarray;
}

void inline bitarray_free(bitarray_t* const bitarray) {
  if (bitarray == NULL) {
    return;
  }
  free(bitarray->buf);
  bitarray->buf = NULL;
  free(bitarray);
}

size_t inline bitarray_get_bit_sz(const bitarray_t* const bitarray) {
  return bitarray->bit_sz;
}

bool bitarray_get(const bitarray_t* const bitarray, const size_t bit_index) {
  assert(bit_index < bitarray->bit_sz);

  // We're storing bits in packed form, 64 per byte.  So to get the nth
  // bit, we want to look at the (n mod 64)th bit of the (floor(n/64)th)
  // byte.
  //
  // In C, integer division is floored explicitly, so we can just do it to
  // get the byte; we then bitwise-and the byte with an appropriate mask
  // to produce either a zero byte (if the bit was 0) or a nonzero byte
  // (if it wasn't).  Finally, we convert that to a boolean.
  return ((bitarray->buf[bit_index >> 6]) & (1ULL << (bit_index & 63))) ?
         true : false;
}

static inline uint64_t bitarray_get_64bit(const bitarray_t* const bitarray,
                                          const size_t bit_index) {
  assert(bit_index + 63 < bitarray->bit_sz);
  int mod = bit_index & 63;
  if (mod == 0) {
    return bitarray->buf[bit_index >> 6];
  }
  uint64_t mask1 = Mask1LookupTable[mod];
  uint64_t mask2 = Mask2LookupTable[mod];

  uint64_t first = (((bitarray->buf[bit_index >> 6] & mask1) >> mod)) & ~mask2;
  uint64_t second = ((bitarray->buf[(bit_index >> 6) + 1]) & ~mask1) << (64 - mod);

  return first | second;
}

void bitarray_set(bitarray_t* const bitarray,
                  const size_t bit_index,
                  const bool value) {
  assert(bit_index < bitarray->bit_sz);

  // We're storing bits in packed form, 64 per byte.  So to set the nth
  // bit, we want to set the (n mod 64)th bit of the (floor(n/64)th) byte.
  //
  // In C, integer division is floored explicitly, so we can just do it to
  // get the byte; we then bitwise-and the byte with an appropriate mask
  // to clear out the bit we're about to set.  We bitwise-or the result
  // with a byte that has either a 1 or a 0 in the correct place.
  uint64_t mask = 1ULL << (bit_index & 63);
  bitarray->buf[bit_index >> 6] =
    (bitarray->buf[bit_index >> 6] & ~mask) |
    (value ? mask : 0);
}

static inline void bitarray_set_64bit(bitarray_t* const bitarray,
                                      const size_t bit_index,
                                      const uint64_t value) {
  assert(bit_index + 63 < bitarray->bit_sz);

  int mod = bit_index & 63;

  if (mod == 0) {
    bitarray->buf[bit_index >> 6] = value;
  } else {
    uint64_t mask1 = Mask1LookupTable[mod];
    uint64_t mask2 = Mask2LookupTable[mod];

    bitarray->buf[bit_index >> 6] =
      (bitarray->buf[bit_index >> 6] & ~mask1) | ((value & ~mask2) << mod);

    bitarray->buf[(bit_index >> 6) + 1ULL] =
      (bitarray->buf[(bit_index >> 6) + 1ULL] & mask1) | (value >> (64 - mod) & ~mask1);
  }

}

void bitarray_rotate(bitarray_t* const bitarray,
                     const size_t bit_offset,
                     const size_t bit_length,
                     const ssize_t bit_right_amount) {
  assert(bit_offset + bit_length <= bitarray->bit_sz);

  if (bit_length == 0) {
    return;
  }

  size_t xbit_right_amount = modulo(bit_right_amount, bit_length);
  //  printf("\nmod: %zu \n", xbit_right_amount);

  reverse_64bit(bitarray, bit_offset, bit_length - xbit_right_amount);
  reverse_64bit(bitarray, bit_offset + bit_length - xbit_right_amount, xbit_right_amount);
  reverse_64bit(bitarray, bit_offset, bit_length);
}

static inline void reverse(bitarray_t* const bitarray, const size_t bit_offset,
                           const size_t bit_length) {
  size_t first = bit_offset;
  size_t last = bit_offset + bit_length - 1;
  while (last > first) {
    const bool temp = bitarray_get(bitarray, first);
    bitarray_set(bitarray, first, bitarray_get(bitarray, last));
    bitarray_set(bitarray, last, temp);
    last--;
    first++;
  }
}

static inline void reverse_64bit(bitarray_t* const bitarray, const size_t bit_offset,
                                 const size_t bit_length) {

  if (bit_length <= 64) {
    reverse(bitarray, bit_offset, bit_length);
    return;
  }
  int first = bit_offset;
  int last = bit_offset + bit_length - 64;
  assert(last + 63 < bitarray->bit_sz);
  while (last > first) {
    uint64_t temp = bitarray_get_64bit(bitarray, first);
    bitarray_set_64bit(bitarray, first, reverse_bitstring(bitarray_get_64bit(bitarray, last)));
    bitarray_set_64bit(bitarray, last, reverse_bitstring(temp));
    last -= 64;
    first += 64;
  }
  last += 63;
  while (last > first) {
    const bool temp = bitarray_get(bitarray, first);
    bitarray_set(bitarray, first, bitarray_get(bitarray, last));
    bitarray_set(bitarray, last, temp);
    last--;
    first++;
  }
}

static inline uint64_t reverse_bitstring(uint64_t x) {
  uint64_t y;
  uint8_t* x_array = (uint8_t*)
                     &x;   // https://stackoverflow.com/questions/35153015/convert-uint64-t-to-uint8-t8
  uint8_t* y_array = (uint8_t*) &y;
  y_array[0] = ReverseByteLookupTable[x_array[7]];
  y_array[1] = ReverseByteLookupTable[x_array[6]];
  y_array[2] = ReverseByteLookupTable[x_array[5]];
  y_array[3] = ReverseByteLookupTable[x_array[4]];
  y_array[4] = ReverseByteLookupTable[x_array[3]];
  y_array[5] = ReverseByteLookupTable[x_array[2]];
  y_array[6] = ReverseByteLookupTable[x_array[1]];
  y_array[7] = ReverseByteLookupTable[x_array[0]];

  return y;
}

static inline size_t modulo(const ssize_t n, const size_t m) {
  const ssize_t signed_m = (ssize_t)m;
  assert(signed_m > 0);
  const ssize_t result = ((n % signed_m) + signed_m) % signed_m;
  assert(result >= 0);
  return (size_t)result;
}


static void print(uint64_t n) {
  while (n) {
    if (n & 1) {
      printf("1");
    } else {
      printf("0");
    }

    n >>= 1;
  }
  printf("\n");
}
