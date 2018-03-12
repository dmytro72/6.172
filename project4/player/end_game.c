// Copyright (c) 2017 MIT License by 6.172 Staff

#include "./end_game.h"

// check the victim pieces returned by the move to determine if it's a
// game-over situation.  If so, also calculate the score depending on
// the pov (which player's point of view)
static bool is_game_over(victims_t victims, int pov, int ply) {
  if (victims.zapped_count > 0 &&
      ptype_of(victims.zapped[victims.zapped_count - 1]) == KING) {
    return true;
  }
  return false;
}

static score_t get_game_over_score(victims_t victims, int pov, int ply) {
  score_t score;
  if (color_of(victims.zapped[victims.zapped_count - 1]) == WHITE) {
    score = -WIN * pov;
  } else {
    score = WIN * pov;
  }
  if (score < 0) {
    score += ply;
  } else {
    score -= ply;
  }
  return score;
}


// Here's a great spot to add in a closing book/end game table if you choose to implement one.

// In this function, determine if the position is in the end game table or not.
bool is_end_game_position(position_t* p, int pov, int ply) {
  // Note: pov and ply are for the move that *generated* this position, not the position itself.
  //       This means you might have an off-by-one error when reading from your closing book.
  return is_game_over(p->victims, pov, ply);
}

// In this function, read the end game table and return the score of this position,
// accounting for who wins and how many moves away this end game position is.
//
// The score of an end-game position is dependent on:
//   - Whose point of view the search is occurring from
//   - How many layers deep this position occurs in the search
//   - How many more moves it will take the game to end once it reaches this position.
score_t get_end_game_score(position_t* p, int pov, int ply) {
  // Note: pov and ply are for the move that *generated* this position, not the position itself.
  //       This means you might have an off-by-one error when reading from your closing book.
    return get_game_over_score(p->victims, pov, ply);
}
