#!/bin/bash

make clean
make PPROF=1
./leiserchess input.txt
google-pprof --svg leiserchess /tmp/output.pprof > out.svg
cp out.svg ../../../www/
