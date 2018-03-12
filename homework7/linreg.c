#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <csi.h>
#include <time.h>
#include <math.h>

csi_id_t num_functions = 0;
csi_id_t num_bb = 0;
int32_t volatile num_instructions = 0;
int32_t volatile num_funcs = 0;
int32_t volatile num_spawns = 0;

long *func_executed = NULL;
int32_t *instruction_executed = NULL;
long *spawns = NULL;

void report() {
  csi_id_t num_func_executed = 0;
  fprintf(stderr, "CSI-lin-reg report:\n");
  for (csi_id_t i=0; i < num_functions; i++) {
    if (func_executed[i] > 0)
      num_func_executed++;
      num_funcs += func_executed[i];
    const source_loc_t *func_source_loc = __csi_get_func_source_loc(i);
    if (NULL != func_source_loc) {
      fprintf(stderr, "%s:%d executed %d times\n",
              func_source_loc->filename, func_source_loc->line_number,
              func_executed[i]);
    }
  }
  for (csi_id_t i=0; i < num_bb; i++) {
    num_instructions += instruction_executed[i];
  }
  for (csi_id_t i=0; i < num_functions; i++) {
    if (spawns[i] > 0)
      num_spawns+= spawns[i];
    const source_loc_t *source = __csi_get_func_source_loc(i);
    fprintf(stderr, "%s:%d spawned %d times\n",
            source->filename, source->line_number,
            spawns[i]);
  }
  fprintf(stderr, "Total: %ld of %ld functions executed\n",
          num_func_executed, num_functions);
  fprintf(stderr, "Total: %ld function calls executed\n",
          num_funcs); 
  fprintf(stderr, "Total: %ld instructions executed\n",
          num_instructions);
  fprintf(stderr, "Total: %ld spawns\n",
          num_spawns);
  
  // Free memory
  free(spawns);
  free(instruction_executed);
  free(func_executed);
}

void __csi_init() {
  atexit(report);
}

void __csi_unit_init(const char * const file_name,
                     const instrumentation_counts_t counts) {
  // TODO: Fill this in.
  func_executed = (long *)realloc(func_executed,
                                  (num_functions + counts.num_func) * sizeof(long));
  memset(func_executed + num_functions, 0, counts.num_func * sizeof(long));
  instruction_executed = (int32_t *)realloc(instruction_executed,
                                  (num_bb + counts.num_bb) * sizeof(int32_t));
  memset(instruction_executed + num_bb, 0, counts.num_bb * sizeof(int32_t));
  spawns = (long *)realloc(spawns,
                                  (num_functions + counts.num_func) * sizeof(long));
  memset(spawns + num_functions, 0, counts.num_func * sizeof(long));
  
  num_functions += counts.num_func;
  num_bb += counts.num_bb;
}

// TODO: Fill in the appropriate hooks (see API reference at the end
// of the handout).
void __csi_func_entry(const csi_id_t func_id, const func_prop_t prop) {
  func_executed[func_id]++;
}

void __csi_func_exit(const csi_id_t func_exit_id, const csi_id_t func_id, const func_exit_prop_t prop) {
  
}

void __csi_bb_entry(const csi_id_t bb_id, const bb_prop_t prop) {
  instruction_executed[bb_id] += __csi_get_bb_sizeinfo(bb_id)->non_empty_size;
}

void __csi_bb_exit(const csi_id_t bb_id, const bb_prop_t prop) {

}

void __csi_detach(const csi_id_t detach_id) {
  spawns[detach_id]++;
}
