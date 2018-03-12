#include "./quadtree.h"

#include <assert.h>
#include <stdlib.h>
#include <cilk/cilk.h>

bool is_leaf(QuadTreeNode *node) {
  return node->top_left == NULL
         && node->top_right == NULL
         && node->bottom_left == NULL
         && node->bottom_right == NULL;
}

void QuadTreeNode_free(QuadTreeNode *root) {
  if (root == NULL) {
    return;
  }

  // Destroy the line lists
  if (root->num_all_lines > 0) {
    free(root->all_lines_on_level);
  }
  if (root->num_giant_lines > 0) {
    free(root->giant_lines);
  }

  QuadTreeNode_free(root->top_left);
  QuadTreeNode_free(root->top_right);
  QuadTreeNode_free(root->bottom_left);
  QuadTreeNode_free(root->bottom_right);
  
  free(root);
}

QuadTreeNode* QuadTreeNode_make(unsigned int numLines) {
  QuadTreeNode *node = malloc(sizeof(QuadTreeNode));
 
  // Allocate largest amount of space to hold the lines
  // since we don't know the worst case
  node->all_lines_on_level = malloc(numLines * sizeof(Line *));
  node->giant_lines = malloc(numLines * sizeof(Line *));

  // Keeps track of the actual number of lines in each quadrant
  node->num_all_lines = 0; 
  node->num_giant_lines = 0; 

  node->top_left = NULL;
  node->top_right = NULL;
  node->bottom_left = NULL;
  node->bottom_right = NULL;

  return node;
}

QuadTreeNode* createRoot(Line **all_lines, unsigned int numLines, double time) { 
  QuadTreeNode *root = QuadTreeNode_make(numLines);

  root->top_left_point = Vec_make(0, 0);
  root->top_right_point = Vec_make(WINDOW_WIDTH, 0);
  root->bottom_left_point = Vec_make(0, WINDOW_HEIGHT);
  root->bottom_right_point = Vec_make(WINDOW_WIDTH, WINDOW_HEIGHT);

  // Populate the root's lines
  for (unsigned int i = 0; i < numLines; i++) {
    root->all_lines_on_level[i] = all_lines[i];
  }
  root->num_all_lines = numLines;

  // Keep partitioning until each quadrant has <= MAX_LINES lines
  unsigned int depth = 0;
  QuadTree_partition(root, &depth, numLines, time);
  return root; 
}

// Partition the lines that exist within root quad into the four subquadrants
// Effectively, buckets the lines that fit in a certain subquadrant and leaves
// the lines that don't fit in the bucket as giant lines in root
// Clears the root's list of lines to avoid duplicate storage of lines 
static void QuadTree_partition(struct QuadTreeNode *root, unsigned int *depth, unsigned int numLines, double time) {
  // Leaf node
  if (*depth == MAX_DEPTH) {
      return;
  }
  (*depth)++;

  if (root->num_all_lines <= MAX_LINES) {
      return;
  }
  
  // Allocates space for the new QuadTreeNode and sets the dimensions for each quad
  QuadTree_partition_helper(root, numLines);  

  // Partition root's lines into the respective quadrants
  for (int i = 0; i < root->num_all_lines; i++) {
    Line *line = root->all_lines_on_level[i];

    window_dimension x1_out_static;
    window_dimension y1_out_static;
    window_dimension x2_out_static;
    window_dimension y2_out_static;

    boxToWindow(&x1_out_static, &y1_out_static, line->p1.x, line->p1.y);
    boxToWindow(&x2_out_static, &y2_out_static, line->p2.x, line->p2.y);

    Vec p1;
    Vec p2;
    p1 = Vec_add(line->p1, Vec_multiply(line->velocity, time));
    p2 = Vec_add(line->p2, Vec_multiply(line->velocity, time));

    window_dimension x1_out;
    window_dimension y1_out;
    window_dimension x2_out;
    window_dimension y2_out;

    boxToWindow(&x1_out, &y1_out, p1.x, p1.y);
    boxToWindow(&x2_out, &y2_out, p2.x, p2.y);

    // Check each subquadrant to find which one fits the line
    if (does_line_fit(x1_out_static, y1_out_static, x2_out_static, y2_out_static, x1_out, y1_out, x2_out, y2_out, root->top_left)) {
      root->top_left->all_lines_on_level[root->top_left->num_all_lines] = line;
      root->top_left->num_all_lines++;
    } else if (does_line_fit(x1_out_static, y1_out_static, x2_out_static, y2_out_static, x1_out, y1_out, x2_out, y2_out, root->top_right)) {
      root->top_right->all_lines_on_level[root->top_right->num_all_lines] = line;
      root->top_right->num_all_lines++;
    } else if (does_line_fit(x1_out_static, y1_out_static, x2_out_static, y2_out_static, x1_out, y1_out, x2_out, y2_out, root->bottom_left)) {
      root->bottom_left->all_lines_on_level[root->bottom_left->num_all_lines] = line;
      root->bottom_left->num_all_lines++;
    } else if (does_line_fit(x1_out_static, y1_out_static, x2_out_static, y2_out_static, x1_out, y1_out, x2_out, y2_out, root->bottom_right)) {
      root->bottom_right->all_lines_on_level[root->bottom_right->num_all_lines] = line;
      root->bottom_right->num_all_lines++;
    } else {
      root->giant_lines[root->num_giant_lines] = line;
      root->num_giant_lines++;
    }
  }

  // Recursively partitions
  cilk_spawn QuadTree_partition(root->top_left, depth, numLines, time);
  cilk_spawn QuadTree_partition(root->top_right, depth, numLines, time);
  cilk_spawn QuadTree_partition(root->bottom_left, depth, numLines, time);
  QuadTree_partition(root->bottom_right, depth, numLines, time);

  cilk_sync;
}

static void QuadTree_partition_helper(struct QuadTreeNode *root, unsigned int numLines) {
  QuadTreeNode *newNode_tl = QuadTreeNode_make(numLines);
  QuadTreeNode *newNode_tr = QuadTreeNode_make(numLines);
  QuadTreeNode *newNode_bl = QuadTreeNode_make(numLines);
  QuadTreeNode *newNode_br = QuadTreeNode_make(numLines);
  if (newNode_tl == NULL || newNode_tr == NULL || newNode_bl == NULL || newNode_br == NULL   ) {
    return;
  }

  vec_dimension left_x = root->top_left_point.x; 
  vec_dimension right_x = root->top_right_point.x; 
  vec_dimension mid_x = (left_x + right_x) / 2; 
  vec_dimension top_y = root->top_left_point.y; 
  vec_dimension bottom_y = root->bottom_left_point.y; 
  vec_dimension mid_y = (top_y + bottom_y) / 2; 

  newNode_tl->top_left_point = Vec_make(left_x, top_y);
  newNode_tl->top_right_point = Vec_make(mid_x, top_y);
  newNode_tl->bottom_left_point = Vec_make(left_x, mid_y); 
  newNode_tl->bottom_right_point = Vec_make(mid_x, mid_y); 
  root->top_left = newNode_tl;
  
  newNode_tr->top_left_point = Vec_make(mid_x, top_y);
  newNode_tr->top_right_point = Vec_make(right_x, top_y);
  newNode_tr->bottom_right_point = Vec_make(right_x, mid_y);
  newNode_tr->bottom_left_point = Vec_make(mid_x, mid_y);
  root->top_right = newNode_tr;
  
  newNode_bl->top_left_point = Vec_make(left_x, mid_y);
  newNode_bl->top_right_point = Vec_make(mid_x, mid_y);
  newNode_bl->bottom_right_point = Vec_make(mid_x, bottom_y);
  newNode_bl->bottom_left_point = Vec_make(left_x, bottom_y);
  root->bottom_left = newNode_bl;
  
  newNode_br->top_left_point = Vec_make(mid_x, mid_y);
  newNode_br->top_right_point = Vec_make(right_x, mid_y);
  newNode_br->bottom_right_point = Vec_make(right_x, bottom_y);
  newNode_br->bottom_left_point = Vec_make(mid_x, bottom_y);
  root->bottom_right = newNode_br;
}

// Checks if the line's two endpoints x and y coordinates fit within the node 
// Check if the parallelogram swept by the line in this time fits in node
static inline bool does_line_fit(window_dimension x1_static, window_dimension y1_static,window_dimension x2_static, window_dimension y2_static, window_dimension x1_moving, window_dimension y1_moving, window_dimension x2_moving, window_dimension y2_moving, QuadTreeNode *node) {
  // (0,0) is top left corner, axes positive going to the right and down
  bool already_in = node->bottom_left_point.x <= x1_static 
          && x1_static < node->bottom_right_point.x
          && node->bottom_left_point.x <= x2_static
          && x2_static < node->bottom_right_point.x 
          && node->top_left_point.y <= y1_static
          && y1_static < node->bottom_left_point.y 
          && node->top_left_point.y <= y2_static
          && y2_static < node->bottom_left_point.y;

  bool moved_in = node->bottom_left_point.x <= x1_moving 
          && x1_moving < node->bottom_right_point.x
          && node->bottom_left_point.x <= x2_moving
          && x2_moving < node->bottom_right_point.x 
          && node->top_left_point.y <= y1_moving
          && y1_moving < node->bottom_left_point.y 
          && node->top_left_point.y <= y2_moving
          && y2_moving < node->bottom_left_point.y;

  return already_in && moved_in;
}

#ifdef DEBUG
static void printSpaces(int numSpaces) {
  for (int i = 0; i < numSpaces; i++) {
    printf(" ");
  }
}

static void printLineIds(Line **ll, unsigned int numLines) {
  for (int i = 0; i < numLines; i++) {
    Line *cur = ll[i];
    window_dimension x1_out;
    window_dimension y1_out;
    window_dimension x2_out;
    window_dimension y2_out;

    boxToWindow(&x1_out, &y1_out, cur->p1.x, cur->p1.y);
    boxToWindow(&x2_out, &y2_out, cur->p2.x, cur->p2.y);
    printf("id: %d p1: (%f, %f) p2: (%f, %f), ", 
            cur->id, 
            x1_out, y1_out,
            x2_out, y2_out);
  }
}

void QuadTree_print(struct QuadTreeNode *root, int *depth) {
  if (is_leaf(root)) {
    printSpaces(*depth);
    printf("TL: (%f, %f), TR: (%f, %f), BL: (%f, %f), BR: (%f, %f)\n", 
           root->top_left_point.x, root->top_left_point.y,
           root->top_right_point.x, root->top_right_point.y,
           root->bottom_left_point.x, root->bottom_left_point.y,
           root->bottom_right_point.x, root->bottom_right_point.y);
    printSpaces(*depth);
    printf("all_lines_on_level: ");
    printLineIds(root->all_lines_on_level, root->num_all_lines);
    printf("\n");
    printSpaces(*depth);
    printf("giant_lines: ");
    printLineIds(root->giant_lines, root->num_giant_lines);
    printf("\n");
    return;
  }

  printSpaces(*depth);
  printf("TL: (%f, %f), TR: (%f, %f), BL: (%f, %f), BR: (%f, %f)\n", 
         root->top_left_point.x, root->top_left_point.y,
         root->top_right_point.x, root->top_right_point.y,
         root->bottom_left_point.x, root->bottom_left_point.y,
         root->bottom_right_point.x, root->bottom_right_point.y);
  printSpaces(*depth);
  printf("all_lines_on_level: ");
  printLineIds(root->all_lines_on_level, root->num_all_lines);
  printf("\n");
  printSpaces(*depth);
  printf("giant_lines: ");
  printLineIds(root->giant_lines, root->num_giant_lines);
  printf("\n");

  (*depth)++;
  QuadTree_print(root->top_left, depth);
  QuadTree_print(root->top_right, depth);
  QuadTree_print(root->bottom_left, depth);
  QuadTree_print(root->bottom_right, depth);
}
#endif
