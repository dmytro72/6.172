// Copyright (c) 2017 MIT License by 6.172 Staff

#ifndef END_GAME_H
#define END_GAME_H

#include <stdbool.h>

#include "./move_gen.h"
#include "./search.h"

bool is_end_game_position(position_t* p, int pov, int ply);

score_t get_end_game_score(position_t* p, int pov, int ply);

#endif  // END_GAME_H
