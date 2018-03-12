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
#define _GNU_SOURCE
#include <assert.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <sys/types.h>

#include "./bitarray.h"
#include "./ktiming.h"
#include "./tests.h"


// ******************************* Prototypes *******************************

// Creates a new bit array in test_bitarray by parsing a string of 0s
// and 1s.  For instance, "0101011011" is a suitable argument.
void testutil_frmstr(const char* const bitstring);

// Rotates test_bitarray in place.
// Requires that test_bitarray is not NULL.
void testutil_rotate(const size_t bit_offset,
                     const size_t bit_length,
                     const ssize_t bit_right_shift_amount);


// Checks that the rotation is valid given the size of test_bitarray.
// Causes a test suite failure if the input is invalid.
void testutil_require_valid_input(const size_t bit_offset,
                                  const size_t bit_length,
                                  const ssize_t bit_right_shift_amount,
                                  const char* const func_name,
                                  const int line);

// Creates a new bit array in test_bitarray of the specified size and
// fills it with random data based on the seed given.  For a given seed number,
// the pseudorandom data will be the same (at least on the same glibc
// implementation).
static void testutil_newrand(const size_t bit_sz, const unsigned int seed);

// Prints a string representation of a bit array.
static void bitarray_fprint(FILE* const stream,
                            const bitarray_t* const bitarray);

// Verifies that test_bitarray has the expected content.
// Outputs FAIL or PASS as appropriate.
// Note: You can call this function directly, but it's much cleaner to use the
// testutil_expect macro instead.
// Requires that test_bitarray is not NULL.
static void testutil_expect_internal(const char* const bitstring,
                                     const char* const func_name,
                                     const int line);

// Returns a single random bit.
static bool randbit();

// Converts a character into a boolean.  The character '1' converts to true;
// the character '0' converts to false.
static bool boolfromchar(const char c);

// Retrieves a char* argument from a buffer in strtok.
char* next_arg_char();


// ******************************** Globals *********************************
// Some global variables make it easier to run individual tests.

// The bit array currently under test.
static bitarray_t* test_bitarray = NULL;

// Whether or not tests should be verbose.
static bool test_verbose = false;


// ********************************* Macros *********************************

// Marks a test as successful, outputting its name and line.
#define TEST_PASS() TEST_PASS_WITH_NAME(__func__, __LINE__)

// Marks a test as successful, outputting the specified name and line.
#define TEST_PASS_WITH_NAME(name, line)          \
  fprintf(stderr, " --> %s at line %d: PASS\n", (name), (line))

// Marks a test as unsuccessful, outputting its name, line, and the specified
// failure message.
//
// Use this macro just like you would call printf.
#define TEST_FAIL(failure_msg, args...)          \
  TEST_FAIL_WITH_NAME(__func__, __LINE__, failure_msg, ##args)

// Marks a test as unsuccessful, outputting the specified name, line, and the
// failure message.
//
// Use this macro just like you would call printf.
#define TEST_FAIL_WITH_NAME(name, line, failure_msg, args...)    \
  do {                \
    fprintf(stderr, " --> %s at line %d: FAIL\n    Reason:", \
      (name), (line));        \
    fprintf(stderr, (failure_msg), ##args);      \
    fprintf(stderr, "\n");          \
  } while (0)

// Calls testutil_expect_internal with the current function and line
// number.
// Requires that test_bitarray is not NULL.
#define testutil_expect(bitstring)        \
  testutil_expect_internal((bitstring), __func__, __LINE__)

// Retrieves an integer from the strtok buffer.
#define NEXT_ARG_LONG() atol(strtok(NULL, " "))

// ******************************* Functions ********************************

static void testutil_newrand(const size_t bit_sz, const unsigned int seed) {
  // If we somehow managed to avoid freeing test_bitarray after a previous
  // test, go free it now.
  if (test_bitarray != NULL) {
    bitarray_free(test_bitarray);
  }

  test_bitarray = bitarray_new(bit_sz);
  assert(test_bitarray != NULL);

  // Reseed the RNG with whatever we were passed; this ensures that we can
  // repeat the test deterministically by specifying the same seed.
  srand(seed);

  for (size_t i = 0; i < bit_sz; i++) {
    bitarray_set(test_bitarray, i, randbit());
  }

  // If we were asked to be verbose, go ahead and show the bit array and
  // the random seed.
  if (test_verbose) {
    bitarray_fprint(stdout, test_bitarray);
    fprintf(stdout, " newrand sz=%zu, seed=%u\n",
            bit_sz, seed);
  }
}

void testutil_frmstr(const char* const bitstring) {
  const size_t bitstring_length = strlen(bitstring);

  // If we somehow managed to avoid freeing test_bitarray after a previous
  // test, go free it now.
  if (test_bitarray != NULL) {
    bitarray_free(test_bitarray);
  }

  test_bitarray = bitarray_new(bitstring_length);
  assert(test_bitarray != NULL);

  bool current_bit;
  for (size_t i = 0; i < bitstring_length; i++) {
    current_bit = boolfromchar(bitstring[i]);
    bitarray_set(test_bitarray, i, current_bit);
  }
  bitarray_fprint(stdout, test_bitarray);
  if (test_verbose) {
    fprintf(stdout, " newstr lit=%s\n", bitstring);
    testutil_expect(bitstring);
  }
}

static void bitarray_fprint(FILE* const stream,
                            const bitarray_t* const bitarray) {
  for (size_t i = 0; i < bitarray_get_bit_sz(bitarray); i++) {
    fprintf(stream, "%d", bitarray_get(bitarray, i) ? 1 : 0);
  }
}

static void testutil_expect_internal(const char* bitstring,
                                     const char* const func_name,
                                     const int line) {
  // The reason why the test fails.  If the test passes, this will stay
  // NULL.
  const char* bad = NULL;

  assert(test_bitarray != NULL);

  // Check the length of the bit array under test.
  const size_t bitstring_length = strlen(bitstring);
  if (bitstring_length != bitarray_get_bit_sz(test_bitarray)) {
    bad = "bitarray size";
  }

  // Check the content.
  for (size_t i = 0; i < bitstring_length; i++) {
    if (bitarray_get(test_bitarray, i) != boolfromchar(bitstring[i])) {
      bad = "bitarray content";
    }
  }

  // Obtain a string for the actual bitstring.
  const size_t actual_bitstring_length = bitarray_get_bit_sz(test_bitarray);
  char* actual_bitstring = calloc(sizeof(char), bitstring_length + 1);
  for (size_t i = 0; i < actual_bitstring_length; i++) {
    if (bitarray_get(test_bitarray, i)) {
      actual_bitstring[i] = '1';
    } else {
      actual_bitstring[i] = '0';
    }
  }

  if (bad != NULL) {
    bitarray_fprint(stdout, test_bitarray);
    fprintf(stdout, " expect bits=%s \n", bitstring);
    TEST_FAIL_WITH_NAME(func_name, line, " Incorrect %s.\n    Expected: %s\n    Actual:   %s",
                        bad, bitstring, actual_bitstring);
  } else {
    TEST_PASS_WITH_NAME(func_name, line);
  }
  free(actual_bitstring);
}

void testutil_rotate(const size_t bit_offset,
                     const size_t bit_length,
                     const ssize_t bit_right_shift_amount) {
  assert(test_bitarray != NULL);
  bitarray_rotate(test_bitarray, bit_offset, bit_length, bit_right_shift_amount);
  if (test_verbose) {
    bitarray_fprint(stdout, test_bitarray);
    fprintf(stdout, " rotate off=%zu, len=%zu, amnt=%zd\n",
            bit_offset, bit_length, bit_right_shift_amount);
  }
}

void testutil_require_valid_input(const size_t bit_offset,
                                  const size_t bit_length,
                                  const ssize_t bit_right_shift_amount,
                                  const char* const func_name,
                                  const int line) {
  size_t bitarray_length = bitarray_get_bit_sz(test_bitarray);
  if (bit_offset >= bitarray_length || bit_length > bitarray_length ||
      bit_offset + bit_length > bitarray_length) {
    // invalid input
    TEST_FAIL_WITH_NAME(func_name, line, " TEST SUITE ERROR - " \
                        "bit_offset + bit_length > bitarray_length");
  }
}

double medrunning_rotation() {
  // We're going to be doing a bunch of rotations; we probably shouldn't
  // let the user see all the verbose output.
  test_verbose = false;

  // A third of the length of the long-running test.
  const size_t bit_sz = 4 * 1024 * 8 + 471;
  testutil_newrand(bit_sz, 0);

  const clockmark_t start_time = ktiming_getmark();
  testutil_rotate(0, bit_sz, -((ssize_t) bit_sz) / 4);
  testutil_rotate(0, bit_sz, bit_sz / 4);
  testutil_rotate(0, bit_sz, bit_sz / 2);
  const clockmark_t end_time = ktiming_getmark();

  // Arguably, we should set test_verbose back to whatever it was before
  // we started.  However, since we're never going to be running more than
  // one performance test at a time (or performance tests at the same time
  // as functional tests), we can just let it be.

  return ktiming_diff_usec(&start_time, &end_time) / 1000000000.0;
}


double longrunning_rotation() {
  // We're going to be doing a bunch of rotations; we probably shouldn't
  // let the user see all the verbose output.
  test_verbose = false;

  // There's probably some great reason why this exact size was chosen for
  // the test bit array; however, if there is, it's been lost to
  // history.
  const size_t bit_sz = 12 * 1024 * 8 + 471;
  testutil_newrand(bit_sz, 0);

  const clockmark_t start_time = ktiming_getmark();
  testutil_rotate(0, bit_sz, -bit_sz / 4);
  testutil_rotate(0, bit_sz, bit_sz / 4);
  testutil_rotate(0, bit_sz, bit_sz / 2);
  const clockmark_t end_time = ktiming_getmark();

  // Arguably, we should set test_verbose back to whatever it was before
  // we started.  However, since we're never going to be running more than
  // one performance test at a time (or performance tests at the same time
  // as functional tests), we can just let it be.

  return ktiming_diff_usec(&start_time, &end_time) / 1000000000.0;
}

static bool randbit() {
  return ((rand() % 2) == 0) ? false : true;
}

static bool boolfromchar(const char c) {
  assert(c == '0' || c == '1');
  return c == '1';
}

char* next_arg_char() {
  char* buf = strtok(NULL, " ");
  char* eol = NULL;
  if ((eol = strchr(buf, '\n')) != NULL) {
    *eol = '\0';
  }
  return buf;
}

void parse_and_run_tests(const char* filename, int selected_test) {
  test_verbose = false;
  fprintf(stderr, "Testing file %s.\n", filename);
  FILE* f = fopen(filename, "r");

  char* buf = NULL;
  size_t bufsize = 0;
  int test = -1;
  int line = 0;
  bool ready_to_run = false;
  if (f == NULL) {
    fprintf(stderr, "Error opening file.\n");
    return;
  }
  while (getline(&buf, &bufsize, f) != -1) {
    line++;
    char* token = strtok(buf, " ");
    switch (token[0]) {
    case '\n':
    case '#':
      continue;
    case 't':
      test = (int) NEXT_ARG_LONG();
      ready_to_run = (test == selected_test || selected_test == -1);
      if (!ready_to_run) {
        continue;
      }

      fprintf(stderr, "\nRunning test #%d...\n", test);
      break;
    case 'n':
      if (!ready_to_run) {
        continue;
      }
      testutil_frmstr(next_arg_char());
      break;
    case 'e':
      if (!ready_to_run) {
        continue;
      }
      {
        char* expected = next_arg_char();
        testutil_expect_internal(expected, filename, line);
      }
      break;
    case 'r':
      if (!ready_to_run) {
        continue;
      }
      {
        size_t offset = (size_t) NEXT_ARG_LONG();
        size_t length = (size_t) NEXT_ARG_LONG();
        ssize_t amount = (ssize_t) NEXT_ARG_LONG();
        testutil_require_valid_input(offset, length, amount, filename, line);
        testutil_rotate(offset, length, amount);
      }
      break;
    default:
      fprintf(stderr, "Unknown command %s", buf);
    }
  }
  free(buf);

  fprintf(stderr, "Done testing file %s.\n", filename);
}

// Local Variables:
// mode: C
// fill-column: 100
// c-file-style: "k&r"
// c-basic-offset: 2
// indent-tabs-mode: nil
// tab-width: 2
// End:
