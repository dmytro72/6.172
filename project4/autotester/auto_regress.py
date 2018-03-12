import os
import re
import sys

def get_txt(executable, book='../tests/book.dta', rounds=2, depth=3):
    return '''cpus = 2
book = %s
game_rounds = %d
title = basic
adjudicate = 400

# now we have the player definitions
# --

player = player1
invoke = %s
depth = %d

player = player2
invoke = %s
depth = %d
''' % (book, rounds, executable, depth, executable, depth)

def text_to_file(filename, text):
    with open(filename, 'w') as text_file:
        text_file.write(text)

def get_move_list(filename):
    lines = ''.join([line.rstrip('\n') for line in open(filename)])
    return [lines[m.start(): m.end()] for m in re.finditer('[a-h][0-7]([a-h][0-7]|R|L|U)', lines)]

def run_test(executable_path, suffix):
    txt = get_txt('../player/leiserchess')
    txt_file = '../tests/regression_' + suffix + '.txt'
    pgn_file = '../tests/regression_' + suffix + '.pgn'

    text_to_file(txt_file, txt)

    os.system('rm ' + pgn_file);
    os.system('java -jar lauto.jar ' + txt_file)
    os.system('../tests/pgnrate.tcl '+ pgn_file)

    return get_move_list(pgn_file)

reference_exe = sys.argv[1]
modified_exe  = sys.argv[2]

ref = run_test(reference_exe, 'reference')
mod = run_test(modified_exe, 'modified')

if ref == mod:
    print "SUCCESS"
else:
    print "FAIL"
