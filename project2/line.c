#include "./line.h"

#include <stdlib.h>

LineList LineList_make() {
  LineList lineList;
  lineList.head = NULL;
  lineList.tail = NULL;
  lineList.size = 0;
  return lineList;
}

void LineList_appendNode(LineList *list, Line *l) {
  LineNode *node = malloc(sizeof(LineNode));
  if (node == NULL)
    return;
  node->line = l;
  node->next = NULL;

  if (list->head == NULL) {
    list->head = node;
  } else {
    list->tail->next = node;
  }
  list->tail = node;
  list->size++;
}

void LineList_deleteNodes(LineList *list) {
  LineNode *curNode = list->head;
  LineNode *nextNode = NULL;
  while (curNode != NULL) {
    nextNode = curNode->next;
    free(curNode);
    curNode = nextNode;
  }
  list->head = NULL;
  list->tail = NULL;
  list->size = 0;
}  
