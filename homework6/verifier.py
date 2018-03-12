#!/usr/bin/python
from __future__ import with_statement
import subprocess, os, sys, re

def exitWithError(error):
    print(error)
    sys.exit(1)

def runAndReadOutput(args):
    if args is str:
        args = [args]
    try:
        return subprocess.check_output(args)
    except subprocess.CalledProcessError as e:
        exitWithError("ERROR: runtime error with %s" % str(args))

def run(path): runAndReadOutput(path)

def runAndCheckTrace(tracefile):
    args = ["./mdriver", "-g", "-v", "-B", "-f", tracefile]
    output = runAndReadOutput(args)

    scores = re.findall(r"perfidx:\s*([0-9\.]+)", output)

    if len(scores) == 0:
        exitWithError('ERROR: could not find prefidx in output of %s:\n%s' % (' '.join(args), output))

    score = float(scores[0])

    if score < 99:
        exitWithError('ERROR: actual perfidx %f not greater than 99 on command %s' % (score, ' '.join(args)))
    elif score > 100:
        exitWithError('ERROR: actual perfidx %f greater than 100 on command %s\nSUGGESTION: Did you forget to pop blocks off the free list before returning them?' % (score, ' '.join(args)))

def build(make_arg, filename, *args):
    print("\nRunning make %s ... " % make_arg)
    run(["make", "clean", filename, "DEBUG=0"] + list(args))
    print("Ok!")

    print("\nChecking that %s was built ... " % filename)
    if not os.path.isfile(filename):
        exitWithError("ERROR: %s binary missing, did you rename it?" % filename)
    print("Ok!")

def buildAndCheckTrace(make_arg, make_args, size):
    print("\nRunning make %s ... " % make_arg)
    args = ["make"] + list(make_args)
    output = runAndReadOutput(args)

    scores = re.findall(r"perfidx:\s*([0-9\.]+)", output)

    if len(scores) == 0:
        exitWithError('ERROR: could not find prefidx in output of %s:\n%s' % (' '.join(args), output))

    score = float(scores[0])

    if score < 99:
        exitWithError('ERROR: actual perfidx %f not greater than 99 on command %s' % (score, ' '.join(args)))
    elif score > 100:
        exitWithError('ERROR: actual perfidx %f greater than 100 on command %s\nSUGGESTION: Did you forget to pop blocks off the free list before returning them?' % (score, ' '.join(args)))

    sizes = re.findall(r"BLOCK_SIZE\s*=\s*([0-9\.]+)", output)

    if len(sizes) == 0:
        exitWithError('ERROR: could not find BLOCK_SIZE in output of %s:\n%s' % (' '.join(args), output))

    if size != sizes[0]:
        exitWithError('ERROR: actual BLOCK_SIZE "%s" not equal to expected BLOCK_SIZE "%s"' % (sizes[0], size))
    

print("Running verifying script ... ")

print("\nChecking that the Makefile exists ... ")
if not os.path.isfile('Makefile'):
    exitWithError('ERROR: Makefile does not exist.')
print("Good!")

build("mdriver", "mdriver")
print("Checking output of mdriver on rec_traces/trace_c0_v0 ... ")
runAndCheckTrace("rec_traces/trace_c0_v0")
print("Ok!")

build("mdriver (4096)", "mdriver", 'PARAMS="-D BLOCK_SIZE=4096"')
print("Checking output of mdriver on rec_traces/trace_c1_v0 ... ")
runAndCheckTrace("rec_traces/trace_c1_v0")
print("Ok!")

buildAndCheckTrace("autotune TRACE_FILE=rec_traces/trace_c0_v0", ["autotune", 'TRACE_FILE=rec_traces/trace_c0_v0'], "1024")
print("Ok!")

buildAndCheckTrace("autotune TRACE_FILE=rec_traces/trace_c1_v0", ["autotune", 'TRACE_FILE=rec_traces/trace_c1_v0'], "4096")
print("Ok!")

print("")

print("LGTM")

print("")

print("Question to answer for the TA:")
print("How did OpenTuner know that BLOCK_SIZE should be 1024 and 4096, respectively?  (Hint: Look at opentuner_run.py, and explain how it determines the performance of a given BLOCK_SIZE.)")
# print("2. Show the TA your changes to allocator.c (with `git diff allocator.c`), demonstrating in particular that you pop blocks off the free list before returning them.")
