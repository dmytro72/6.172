/** 
 * collision_world.c -- detect and handle line segment intersections
 * Copyright (c) 2012 the Massachusetts Institute of Technology
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE. 
 **/

#include "./collision_world.h"

#include <stdlib.h>
#include <math.h>
#include <assert.h>
#include <stdio.h>
#include <cilk/cilk.h>
#include <cilk/reducer.h>

#include "./intersection_detection.h"
#include "./intersection_event_list.h"
#include "./line.h"
#include "./quadtree.h"

// Reducer Stuff
typedef CILK_C_DECLARE_REDUCER(IntersectionEventList) IntersectionEventListReducer;

void merge_lists(IntersectionEventList* list1, IntersectionEventList* list2) {
  if(list1->head != NULL) {
    if (list2->head != NULL) {
      list1->tail->next = list2->head;
      list1->tail = list2->tail;
    }
  } else {
    list1->head = list2->head;
    list1->tail = list2->tail;
  }
  list2->head = NULL;
  list2->tail = NULL;
}

void intersect_list_reduce(void* key, void* left, void* right) {
  merge_lists((IntersectionEventList*) left, (IntersectionEventList*) right);
}

void intersect_list_identity(void* key, void* value) {
  *(IntersectionEventList*) value = (IntersectionEventList) { .head = NULL, .tail = NULL }; 
}

void intersect_list_destroy(void* key, void* value) {
  value = (IntersectionEventList*) value;
  IntersectionEventList_deleteNodes(value);
}

IntersectionEventListReducer X = CILK_C_INIT_REDUCER(IntersectionEventList,
  intersect_list_reduce, intersect_list_identity, intersect_list_destroy,
  (IntersectionEventList) { .head = NULL, .tail = NULL });

CollisionWorld* CollisionWorld_new(const unsigned int capacity) {
  assert(capacity > 0);

  CollisionWorld* collisionWorld = malloc(sizeof(CollisionWorld));
  if (collisionWorld == NULL) {
    return NULL;
  }

  collisionWorld->numLineWallCollisions = 0;
  collisionWorld->numLineLineCollisions = 0;
  collisionWorld->timeStep = 0.5;
  collisionWorld->lines = malloc(capacity * sizeof(Line*));
  collisionWorld->numOfLines = 0;
  return collisionWorld;
}

void CollisionWorld_delete(CollisionWorld* collisionWorld) {
  for (int i = 0; i < collisionWorld->numOfLines; i++) {
    free(collisionWorld->lines[i]);
  }
  free(collisionWorld->lines);
  free(collisionWorld);
}

unsigned int CollisionWorld_getNumOfLines(CollisionWorld* collisionWorld) {
  return collisionWorld->numOfLines;
}

void CollisionWorld_addLine(CollisionWorld* collisionWorld, Line *line) {
  collisionWorld->lines[collisionWorld->numOfLines] = line;
  collisionWorld->numOfLines++;
}

Line* CollisionWorld_getLine(CollisionWorld* collisionWorld,
                             const unsigned int index) {
  if (index >= collisionWorld->numOfLines) {
    return NULL;
  }
  return collisionWorld->lines[index];
}

void CollisionWorld_updateLines(CollisionWorld* collisionWorld, unsigned int count) {
  CollisionWorld_detectIntersection(collisionWorld, count);
  CollisionWorld_updatePosition(collisionWorld);
  CollisionWorld_lineWallCollision(collisionWorld);
}

void CollisionWorld_updatePosition(CollisionWorld* collisionWorld) {
  double t = collisionWorld->timeStep;
  cilk_for (int i = 0; i < collisionWorld->numOfLines; i++) {
    Line *line = collisionWorld->lines[i];
    line->p1 = Vec_add(line->p1, Vec_multiply(line->velocity, t));
    line->p2 = Vec_add(line->p2, Vec_multiply(line->velocity, t));
  }
}

void CollisionWorld_lineWallCollision(CollisionWorld* collisionWorld) {
  for (int i = 0; i < collisionWorld->numOfLines; i++) {
    Line *line = collisionWorld->lines[i];
    bool collide = false;

    // Right side
    if ((line->p1.x > BOX_XMAX || line->p2.x > BOX_XMAX)
        && (line->velocity.x > 0)) {
      line->velocity.x = -line->velocity.x;
      collide = true;
    }
    // Left side
    if ((line->p1.x < BOX_XMIN || line->p2.x < BOX_XMIN)
        && (line->velocity.x < 0)) {
      line->velocity.x = -line->velocity.x;
      collide = true;
    }
    // Top side
    if ((line->p1.y > BOX_YMAX || line->p2.y > BOX_YMAX)
        && (line->velocity.y > 0)) {
      line->velocity.y = -line->velocity.y;
      collide = true;
    }
    // Bottom side
    if ((line->p1.y < BOX_YMIN || line->p2.y < BOX_YMIN)
        && (line->velocity.y < 0)) {
      line->velocity.y = -line->velocity.y;
      collide = true;
    }
    // Update total number of collisions.
    if (collide == true) {
      collisionWorld->numLineWallCollisions++;
    }
  }
}

// Pairwise line collision detection for Line**
static unsigned int detect_collisions_slow(Line **lines, unsigned int numOfLines, double timeStep, IntersectionEventList *intersectionEventList) {
  unsigned int numLineLineCollisions = 0;
  // Test all line-line pairs to see if they will intersect before the
  // next time step.
  for (int i = 0; i < numOfLines; i++) {
    Line *l1 = lines[i];

    for (int j = i + 1; j < numOfLines; j++) {
      Line *l2 = lines[j];
      // intersect expects compareLines(l1, l2) < 0 to be true.
      // Swap l1 and l2, if necessary.

      // faster check to see if lines actually intersect
      if (l1->min_x > l2->max_x || l1->max_x < l2->min_x || 
          l1->min_y > l2->max_y || l1->max_y < l2->min_y) {
          continue;
      } 
 
      if (compareLines(l1, l2) >= 0) {
        Line *temp = l1;
        l1 = l2;
        l2 = temp;
      }
      
      IntersectionType intersectionType =
          intersect(l1, l2, timeStep);
      if (intersectionType != NO_INTERSECTION) {
        IntersectionEventList_appendNode(intersectionEventList, l1, l2,
                                         intersectionType);
        numLineLineCollisions++;
      }
    }
  }
  return numLineLineCollisions;
} 

static unsigned int detect_collisions_giant(Line **giant_lines, unsigned int num_giant_lines, Line **other_lines, unsigned int num_other_lines, double timeStep, IntersectionEventList *intersectionEventList) {
  unsigned int numLineLineCollisions = 0;

  // Test all line-line pairs to see if they will intersect before the
  // next time step.
  for (int i = 0; i < num_giant_lines; i++) {
    Line *l1 = giant_lines[i];

    for (int j = 0; j < num_other_lines; j++) {
      Line *l2 = other_lines[j];

      // intersect expects compareLines(l1, l2) < 0 to be true.
      // Swap l1 and l2, if necessary.
      assert(l1 != l2);

      // faster check to see if lines actually intersect
      if (l1->min_x > l2->max_x || l1->max_x < l2->min_x || 
          l1->min_y > l2->max_y || l1->max_y < l2->min_y) {
          continue;
      } 

      Line *orig_l1 = l1;
      if (compareLines(l1, l2) >= 0) {
        Line *temp = l1;
        l1 = l2;
        l2 = temp;
      }

      IntersectionType intersectionType =
          intersect(l1, l2, timeStep);
      if (intersectionType != NO_INTERSECTION) {
        IntersectionEventList_appendNode(intersectionEventList, l1, l2,
                                         intersectionType);
        numLineLineCollisions++;
      }
      l1 = orig_l1;
    }
  }
  return numLineLineCollisions;
}

static unsigned int detectCollisionsInQuadTree(QuadTreeNode *root, double timeStep, IntersectionEventList *intersectionEventList) {
  // Iterate through tree and count up number of collisions at each level
  // If level has giant lines, do pairwise collision detection for each giant line
  // and the subquadrant's lines
  // If level has nonempty lines, then do pairwise collision detection on each line

  if (root == NULL) {
    return 0;
  }

  unsigned int numCollisions[9];

  QuadTreeNode* sub_quadrant[4] = {
    (root->top_left),
    (root->top_right),
    (root->bottom_left),
    (root->bottom_right)
  };
  
  if (is_leaf(root)) {
    return detect_collisions_slow(root->all_lines_on_level, root->num_all_lines, timeStep, intersectionEventList);
  }

  IntersectionEventList eventLists[9];  // NOTE: 9 is the number of IntersectionEventLists we need for parallelizing
  for (int i=0; i < 9; i++) {
    eventLists[i] = IntersectionEventList_make();
    numCollisions[i] = 0;
  }

  if (root->num_giant_lines > 0) {
    // Detect collisions between giant lines
    cilk_spawn numCollisions[0] = detect_collisions_slow(root->giant_lines, root->num_giant_lines, timeStep, &eventLists[0]);

    // Detect collisions between giant lines and all lines in subquadrants
    for (int j = 1; j < 5; j++) {
      cilk_spawn numCollisions[j] = detect_collisions_giant(root->giant_lines, root->num_giant_lines, (sub_quadrant[j-1])->all_lines_on_level, (sub_quadrant[j-1])->num_all_lines, timeStep, &eventLists[j]);
    }
  }

  // Count number of collisions in the subquadrants
  for (int i = 5; i < 9; i++) {
    cilk_spawn numCollisions[i] = detectCollisionsInQuadTree(sub_quadrant[i-5], timeStep, &eventLists[i]);
  }

  cilk_sync;

  for (int i = 0; i < 9; i++) {
    merge_lists(intersectionEventList, &eventLists[i]);
  }

  return numCollisions[0] + numCollisions[1] + numCollisions[2] + numCollisions[3] + numCollisions[4]
    + numCollisions[5] + numCollisions[6] + numCollisions[7] + numCollisions[8];
}

void CollisionWorld_detectIntersection(CollisionWorld* collisionWorld, unsigned int count) {
  // Update bounding boxes
  cilk_for (int i = 0; i < collisionWorld->numOfLines; i++) {
    updateBounds(collisionWorld->lines[i], collisionWorld->timeStep);
  }

  IntersectionEventList intersectionEventList = REDUCER_VIEW(X);

  // Perform naive pairwise line if number of lines small enough
  if (collisionWorld->numOfLines <= MAX_LINES) {
    collisionWorld->numLineLineCollisions += detect_collisions_slow(collisionWorld->lines, collisionWorld->numOfLines, collisionWorld->timeStep, &intersectionEventList);
  } else {
    // Create the quadtree 
    QuadTreeNode *root = createRoot(collisionWorld->lines, collisionWorld->numOfLines, collisionWorld->timeStep);
    
    // Count the collisions

    CILK_C_REGISTER_REDUCER(X);
    unsigned int numLL_new = detectCollisionsInQuadTree(root, collisionWorld->timeStep, &intersectionEventList);
    CILK_C_UNREGISTER_REDUCER(X);
    collisionWorld->numLineLineCollisions += numLL_new;
  
    // Delete the quadtree
    QuadTreeNode_free(root);
  }

  // Sort the intersection event list.
  IntersectionEventNode* startNode = intersectionEventList.head;
  while (startNode != NULL) {
    IntersectionEventNode* minNode = startNode;
    IntersectionEventNode* curNode = startNode->next;
    while (curNode != NULL) {
      if (IntersectionEventNode_compareData(curNode, minNode) < 0) {
        minNode = curNode;
      }
      curNode = curNode->next;
    }
    if (minNode != startNode) {
      IntersectionEventNode_swapData(minNode, startNode);
    }
    startNode = startNode->next;
  }

  // Call the collision solver for each intersection event.
  IntersectionEventNode* curNode = intersectionEventList.head;

  while (curNode != NULL) {
    CollisionWorld_collisionSolver(collisionWorld, curNode->l1, curNode->l2,
                                   curNode->intersectionType);
    curNode = curNode->next;
  }

  IntersectionEventList_deleteNodes(&intersectionEventList);
}

unsigned int CollisionWorld_getNumLineWallCollisions(
    CollisionWorld* collisionWorld) {
  return collisionWorld->numLineWallCollisions;
}

unsigned int CollisionWorld_getNumLineLineCollisions(
    CollisionWorld* collisionWorld) {
  return collisionWorld->numLineLineCollisions;
}

void CollisionWorld_collisionSolver(CollisionWorld* collisionWorld,
                                    Line *l1, Line *l2,
                                    IntersectionType intersectionType) {
  assert(compareLines(l1, l2) < 0);
  assert(intersectionType == L1_WITH_L2
         || intersectionType == L2_WITH_L1
         || intersectionType == ALREADY_INTERSECTED);

  // Despite our efforts to determine whether lines will intersect ahead
  // of time (and to modify their velocities appropriately), our
  // simplified model can sometimes cause lines to intersect.  In such a
  // case, we compute velocities so that the two lines can get unstuck in
  // the fastest possible way, while still conserving momentum and kinetic
  // energy.
  if (intersectionType == ALREADY_INTERSECTED) {
    Vec p = getIntersectionPoint(l1->p1, l1->p2, l2->p1, l2->p2);

    if (Vec_length(Vec_subtract(l1->p1, p))
        < Vec_length(Vec_subtract(l1->p2, p))) {
      l1->velocity = Vec_multiply(Vec_normalize(Vec_subtract(l1->p2, p)),
                                  Vec_length(l1->velocity));
    } else {
      l1->velocity = Vec_multiply(Vec_normalize(Vec_subtract(l1->p1, p)),
                                  Vec_length(l1->velocity));
    }
    if (Vec_length(Vec_subtract(l2->p1, p))
        < Vec_length(Vec_subtract(l2->p2, p))) {
      l2->velocity = Vec_multiply(Vec_normalize(Vec_subtract(l2->p2, p)),
                                  Vec_length(l2->velocity));
    } else {
      l2->velocity = Vec_multiply(Vec_normalize(Vec_subtract(l2->p1, p)),
                                  Vec_length(l2->velocity));
    }
    return;
  }

  // Compute the collision face/normal vectors.
  Vec face;
  Vec normal;
  if (intersectionType == L1_WITH_L2) {
    Vec v = Vec_makeFromLine(*l2);
    face = Vec_normalize(v);
  } else {
    Vec v = Vec_makeFromLine(*l1);
    face = Vec_normalize(v);
  }
  normal = Vec_orthogonal(face);

  // Obtain each line's velocity components with respect to the collision
  // face/normal vectors.
  double v1Face = Vec_dotProduct(l1->velocity, face);
  double v2Face = Vec_dotProduct(l2->velocity, face);
  double v1Normal = Vec_dotProduct(l1->velocity, normal);
  double v2Normal = Vec_dotProduct(l2->velocity, normal);

  // Compute the mass of each line (we simply use its length).
  double m1 = Vec_length(Vec_subtract(l1->p1, l1->p2));
  double m2 = Vec_length(Vec_subtract(l2->p1, l2->p2));

  // Perform the collision calculation (computes the new velocities along
  // the direction normal to the collision face such that momentum and
  // kinetic energy are conserved).
  double newV1Normal = ((m1 - m2) / (m1 + m2)) * v1Normal
      + (2 * m2 / (m1 + m2)) * v2Normal;
  double newV2Normal = (2 * m1 / (m1 + m2)) * v1Normal
      + ((m2 - m1) / (m2 + m1)) * v2Normal;

  // Combine the resulting velocities.
  l1->velocity = Vec_add(Vec_multiply(normal, newV1Normal),
                         Vec_multiply(face, v1Face));
  l2->velocity = Vec_add(Vec_multiply(normal, newV2Normal),
                         Vec_multiply(face, v2Face));

  return;
}


