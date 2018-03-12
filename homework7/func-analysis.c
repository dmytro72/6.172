#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <csi.h>
#include <math.h>

// This tool reports the number of times each function in the program
// was executed.

csi_id_t num_functions = 0;
long *func_executed = NULL;
struct timespec *start_times = NULL;
double *times = NULL;
long *recursive_calls = NULL;

void report() {
  csi_id_t num_func_executed = 0;
  fprintf(stderr, "CSI-function-cov report:\n");
  for (csi_id_t i = 0; i < num_functions; i++) {
    if (func_executed[i] > 0)
      num_func_executed++;
    const source_loc_t *source_loc = __csi_get_func_source_loc(i);
    if (NULL != source_loc) {
      fprintf(stderr, "%s:%d executed %d times\n",
              source_loc->filename, source_loc->line_number,
              func_executed[i]);
      /*
      fprintf(stderr, "%s:%d spent %d seconds\n",
              source_loc->filename, source_loc->line_number,
              times[i]);
      */
    }
  }
  fprintf(stderr, "Total: %ld of %ld functions executed\n",
          num_func_executed, num_functions);
  free(recursive_calls);
  free(func_executed);
}

void __csi_init() {
  atexit(report);
}

void __csi_unit_init(const char * const file_name,
                     const instrumentation_counts_t counts) {
  // Expand any data structures to accommodate the additional functions
  // in this compilation unit.
  func_executed = (long *)realloc(func_executed,
                                  (num_functions + counts.num_func) * sizeof(long));
  recursive_calls = (long *)realloc(recursive_calls,
                                  (num_functions + counts.num_func) * sizeof(long));
  /*
  start_times = (struct timespec *)realloc(start_times, 
                                  (num_functions + counts.num_func) * sizeof(struct timespec));
  times = (double *)realloc(func_executed,
                                  (num_functions + counts.num_func) * sizeof(double));
  */
  memset(func_executed + num_functions, 0, counts.num_func * sizeof(long));
  memset(recursive_calls + num_functions, 0, counts.num_func * sizeof(long));
  /*
  memset(start_times + num_functions, 0, counts.num_func * sizeof(struct timespec));
  memset(times + num_functions, 0, counts.num_func * sizeof(double));
  */
  num_functions += counts.num_func;
}

void __csi_func_entry(const csi_id_t func_id, const func_prop_t prop) {
  // Increment counter for number of times func_id is executed
  func_executed[func_id]++;
  // Check if function call is root function call
  /*
  if (recursive_calls[func_id] == 0) {
    clock_gettime(CLOCK_MONOTONIC, &start_times[func_id]);
  }
  */
  recursive_calls[func_id]++;
}

void __csi_func_exit(const csi_id_t func_exit_id, const csi_id_t func_id, const func_exit_prop_t prop) {
  recursive_calls[func_id]--;
  /*
  if (recursive_calls[func_id] == 0) {
    struct timespec end;
    clock_gettime(CLOCK_MONOTONIC, &end);
    struct timespec start = start_times[func_id];
    // Subtract start time from end time
    times[func_id] = (end.tv_sec - start.tv_sec) + pow(10,-9)*(end.tv_nsec - start.tv_nsec);
  }
  */
}
