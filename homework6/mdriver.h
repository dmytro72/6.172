#ifndef MM_MDRIVER_H
#define MM_MDRIVER_H

#include <assert.h>
#include <dirent.h>
#include <errno.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>

#include "config.h"
#include "fsecs.h"
#include "memlib.h"
#include "allocator_interface.h"

/**********************
 * Constants and macros
 **********************/

/* Misc */
#define MAXLINE     1024 /* max string size */
#define HDRLINES       4 /* number of header lines in a trace file */
#define LINENUM(i) (i+5) /* cnvt trace request nums to linenums (origin 1) */

typedef enum {ALLOC, FREE, REALLOC, WRITE} traceop_type; /* type of request */
/******************************
 * The key compound data types
 *****************************/

/* Characterizes a single trace operation (allocator request) */
typedef struct {
  traceop_type  type; /* type of request */
  int index;                        /* index for free() to use later */
  int size;                         /* byte size of alloc/realloc request */
} traceop_t;

/* Holds the information for one trace file*/
typedef struct {
  int sugg_heapsize;   /* suggested heap size (unused) */
  int num_ids;         /* number of alloc/realloc ids */
  int num_ops;         /* number of distinct requests */
  int weight;          /* weight for this trace (unused) */
  traceop_t *ops;      /* array of requests */
  char **blocks;       /* array of ptrs returned by malloc/realloc... */
  size_t *block_sizes; /* ... and a corresponding array of payload sizes */
} trace_t;

/*********************
 * Function prototypes
 *********************/

void malloc_error(int tracenum, int opnum, char *msg);
void unix_error(char *msg);
void app_error(char *msg);

#endif /* MM_MDRIVER_H */
