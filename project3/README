Welcome to Project 3!

You will write a customizable memory allocator. Let's take a look around. Remember to also read
the project handout for a high-level, but detailed, overview.


=== C code ===
The main program, able to run your allocator on one or more traces, is mdriver (memory driver).

Files you should modify:
* allocator.c - your allocator! Its interface is defined in allocator_interface.h.
* validator.h - your heap validator

Files you should look at:
* memlib.c - memory functions you should call
* mdriver.c - mdriver, which
    * calculates throughput
    * calculates utilization
    * calls the heap checker (which you are strongly recommended to write)
    * calls the heap validator (which you will write)
* bad_allocator.c - bad allocator. Your heap validator should show an error.

On each trace, you are scored in [0, 100] with the equation:
  (utilization) ** (UTIL_WEIGHT) * (throughput ratio) ** (1 - UTIL_WEIGHT)
where throughput_ratio is an adjusted ratio between your allocator and libc's.

The utilization is calculated with the equation:
  max(MEM_ALLOWANCE, max total size) / max(MEM_ALLOWANCE, heap size)
For example, if a trace continuously allocates and deallocates a 32-byte block of memory, then its
max total size is 32 bytes. At the end, if your heap uses 128 bytes of memory, then its heap size
is 128 bytes. As defined in memlib.c, your heap can only increase its size, never decrease, so use
the space judiciously.

The throughput ratio is calculated with the equation:
  min(1.0, (your throughput) / min(MAX_BASE_THROUGHPUT, LIBC_MULTIPLIER * libc's throughput))
This generally means that your score improves as your allocator's throughput increases, up to when
(assuming LIBC_MULTIPLIER = 1.10) it becomes 10% better than libc's.

Useful mdriver options:
$ ./mdriver -f traces/trace_c0_v0
      run one trace file
$ ./mdriver -t additional_traces/
      run the trace files in a trace directory
$ ./mdriver -c
      run your heap checker
$ ./mdriver -g
      print the score
$ ./mdriver -v
      print details, like the score breakdown
$ ./mdriver -V
      print more details

=== Traces ===
The traces are simple text files encoding a series of memory allocations, deallocations, and
writes. In particular, they include:
  a {pointer-id} {size}      allocate memory - malloc()
  f {pointer-id}             deallocate memory - free()
  r {pointer-id} {new-size}  reallocate memory - realloc()
  w {pointer-id} {size}      write memory

The traces come from many different places. Some are generated from real programs, others were
generously provided by Snailspeed Ltd. Rumor has it that one was generated straight from a team's
Project 2 implementation!

They have the filename trace_c{class}_v{variant}. One variant from each trace class is in the
traces/ directory. More variants from each trace class are in the additional_traces/ directory.
This allows you to examine multiple variants from each trace class and decide how your allocator
can optimize for them.

When grading, your allocator will see one trace variant from each trace class. It may be one of the
variants given or one freshly generated. Because there are different trace classes and slightly
different variants within each trace class, it's probably a good idea to:
* be general where appropriate
      instead of hardcoding checks like if (size == 47) do_optimization();
* use tuning
      as optimizations that work well on some trace classes may not work well for others

The mdriver.py script can be used to benchmark your implementation. For each
trace class, it compiles your code with the TRACE_CLASS={trace-class} macro,
runs, and records the score, then computes the average score across all trace
classes.

Useful mdriver.py options:
$ ./mdriver.py --trace-file=traces/trace_c0_v0
      run one trace file
$ ./mdriver.py --trace-dir=additional_traces/
      run the trace files in a trace directory

=== OpenTuner ===
OpenTuner is a general autotuning framework. If you choose to use it, then it will help your
allocator customize itself for the given trace files. To install OpenTuner on your local AWS
instances, look at the commands from homework 6.

Files you can modify:
* opentuner_params.py - the parameters of your allocator

Files you can look at:
* opentuner_run.py - run one trace file or all trace files in a directory

Useful OpenTuner options:
$ ./opentuner_run.py -h
      help on how to run on a trace file/directory
$ ./opentuner_run.py --test-limit=300 --no-dups --display-frequency 20
  --trace-file=traces/trace_c0_v0
      example usage: run one trace file, 300 steps for optimization
$ ./opentuner_run.py --test-limit=300 --no-dups --display-frequency 20 --trace-dir=traces
      example usage: run on entire trace directory, 300 steps for optimization
$ ./opentuner_run.py --test-limit=300 --no-dups --display-frequency 20 --trace-dir=traces --awsrun
      by adding '--awsrun', the program will be running on the AWS worker machines, and the timing
      information gathered by opentuner will be the running time on the workers. The program is by
      default running on your local instances.

Here's how to expose parameters to OpenTuner. Define them as macros in your C code, read at compile
time. Say that FOO is a parameter that takes a value from {-1, 0, 1}. Use FOO in your code. Before
usage, give it a default value, in case someone forgets to pass it in.
  #ifndef FOO
  #define FOO 0  // default value
  #endif
Make sure it works before trying OpenTuner.
$ make clean mdriver PARAMS="-D FOO=1"
Then define it for OpenTuner in opentuner_params.py and run.
  mdriver_manipulator.add_parameter(IntegerParameter('FOO', -1, 1))  # {-1, 0, 1}

Good luck, and have fun!
