#ifndef QUADTREE_H_
#define QUADTREE_H_

#include "./line.h"
#include "./vec.h"

// Macros 
#define MAX_LINES 400
#define MAX_DEPTH 300

// Quadtree
typedef struct QuadTreeNode {
  // Lines that fit in this quadrant
  Line** all_lines_on_level;
  unsigned int num_all_lines;
  
  // Lines that only fit in current quadrant
  Line** giant_lines;
  unsigned int num_giant_lines;

  struct QuadTreeNode *top_left;
  struct QuadTreeNode *top_right;
  struct QuadTreeNode *bottom_left;
  struct QuadTreeNode *bottom_right;

  // coordinates of the box
  Vec top_left_point;
  Vec top_right_point;
  Vec bottom_left_point;
  Vec bottom_right_point;
} QuadTreeNode;

typedef struct QuadTreeRoot {
  QuadTreeNode *root;
} QuadTreeRoot;

// Free QuadTree
void QuadTreeNode_free(QuadTreeNode *root);

// Returns pointer to a new QuadTreeNode
QuadTreeNode *QuadTreeNode_make(unsigned int numLines);

// Returns the root of QuadTree of given lines
QuadTreeNode *createRoot(Line **all_lines, unsigned int numLines, double time);

// Given a QuadTreeNode, partition into four quads and bucket lines accordingly
static void QuadTree_partition(struct QuadTreeNode *root, unsigned int *depth, unsigned int numLines, double time);

static void QuadTree_partition_helper(struct QuadTreeNode *root, unsigned int numLines);

// Returns true if line fits entirely in the given node
static bool does_line_fit(window_dimension x1_static, window_dimension y1_static,window_dimension x2_static, window_dimension y2_static, window_dimension x1_moving, window_dimension y1_moving, window_dimension x2_moving, window_dimension y2_moving, QuadTreeNode *node); 

#ifdef DEBUG
// Print out the quadtree info
void QuadTree_print(struct QuadTreeNode *root, int *depth);
#endif

#endif  // QUADTREE_H_
